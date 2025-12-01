local cloneref = cloneref or clonereference or function(instance) 
    return instance 
end

local HttpService = cloneref(game:GetService('HttpService'))

local isfolder, isfile, listfiles = isfolder, isfile, listfiles

local function assert(condition, errorMessage)
    if not condition then
        error(errorMessage or 'Assertion failed', 3)
    end
end

if typeof(copyfunction) == 'function' then
    local isfolder_copy = copyfunction(isfolder)
    local isfile_copy = copyfunction(isfile)
    local listfiles_copy = copyfunction(listfiles)

    local success, result = pcall(function()
        return isfolder_copy('test' .. tostring(math.random(1000000, 9999999)))
    end)

    if not success or typeof(result) ~= 'boolean' then
        isfolder = function(folder)
            local ok, data = pcall(isfolder_copy, folder)
            return ok and data or false
        end

        isfile = function(file)
            local ok, data = pcall(isfile_copy, file)
            return ok and data or false
        end

        listfiles = function(folder)
            local ok, data = pcall(listfiles_copy, folder)
            return ok and data or {}
        end
    end
end


local SaveManager = {}

SaveManager.Folder = 'LinoriaLibSettings'
SaveManager.SubFolder = ''
SaveManager.SaveVersion = 1
SaveManager.Library = nil

SaveManager.Ignore = {}
SaveManager.AutoSaveName = nil
SaveManager.AutoSaveTask = nil
SaveManager.LabelUpdateTask = nil
SaveManager.AutoloadStatusLabel = nil
SaveManager.AutoSaveLabel = nil

SaveManager.AutoSaveConfig = {
    Enabled = false,
    Interval = 60,
    LastSaveTime = 0,
    SavesSinceStart = 0,
    FailedSaves = 0,
    MaxFailures = 3,
}


function SaveManager:SetLibrary(library)
    self.Library = library
end

function SaveManager:IgnoreThemeSettings()
    self:SetIgnoreIndexes({
        'BackgroundColor', 
        'MainColor', 
        'AccentColor', 
        'OutlineColor', 
        'FontColor',
        'ThemeManager_ThemeList', 
        'ThemeManager_CustomThemeList', 
        'ThemeManager_CustomThemeName',
        'VideoLink',
    })
end

function SaveManager:SetIgnoreIndexes(list)
    for _, key in ipairs(list) do
        self.Ignore[key] = true
    end
end


function SaveManager:HasSubFolder()
    return typeof(self.SubFolder) == 'string' and self.SubFolder ~= ''
end

function SaveManager:EnsureSubFolder()
    if not self:HasSubFolder() then 
        return false 
    end
    
    local subPath = self.Folder .. '/settings/' .. self.SubFolder
    if not isfolder(subPath) then
        makefolder(subPath)
    end
    
    return true
end

function SaveManager:GetPaths()
    local paths = {}
    
    local parts = self.Folder:split('/')
    for idx = 1, #parts do
        local path = table.concat(parts, '/', 1, idx)
        if not table.find(paths, path) then
            table.insert(paths, path)
        end
    end
    
    table.insert(paths, self.Folder .. '/themes')
    table.insert(paths, self.Folder .. '/settings')

    if self:HasSubFolder() then
        local subFolder = self.Folder .. '/settings/' .. self.SubFolder
        parts = subFolder:split('/')
        
        for idx = 1, #parts do
            local path = table.concat(parts, '/', 1, idx)
            if not table.find(paths, path) then
                table.insert(paths, path)
            end
        end
    end

    return paths
end

function SaveManager:BuildFolderTree()
    local paths = self:GetPaths()
    
    for _, path in ipairs(paths) do
        if not isfolder(path) then
            makefolder(path)
        end
    end
end

function SaveManager:EnsureFolderTree()
    if not isfolder(self.Folder) then
        self:BuildFolderTree()
        task.wait(0.1)
    end
end

function SaveManager:SetFolder(folder)
    self.Folder = folder
    self:BuildFolderTree()
end

function SaveManager:SetSubFolder(folder)
    self.SubFolder = folder
    self:BuildFolderTree()
end


SaveManager.Parser = {
    Toggle = {
        Save = function(idx, object)
            return { 
                type = 'Toggle', 
                idx = idx, 
                value = object.Value 
            }
        end,
        
        Load = function(idx, data)
            local object = SaveManager.Library.Toggles[idx]
            if object then
                object:SetValue(data.value)
            end
        end,
    },
    
    Slider = {
        Save = function(idx, object)
            return { 
                type = 'Slider', 
                idx = idx, 
                value = object.Value 
            }
        end,
        
        Load = function(idx, data)
            local object = SaveManager.Library.Options[idx]
            if object then
                object:SetValue(data.value)
            end
        end,
    },
    
    Dropdown = {
        Save = function(idx, object)
            return { 
                type = 'Dropdown', 
                idx = idx, 
                value = object.Value, 
                multi = object.Multi 
            }
        end,
        
        Load = function(idx, data)
            local object = SaveManager.Library.Options[idx]
            if object then
                object:SetValue(data.value)
            end
        end,
    },
    
    ColorPicker = {
        Save = function(idx, object)
            return { 
                type = 'ColorPicker', 
                idx = idx, 
                value = object.Value:ToHex(), 
                transparency = object.Transparency 
            }
        end,
        
        Load = function(idx, data)
            local object = SaveManager.Library.Options[idx]
            if object then
                object:SetValueRGB(Color3.fromHex(data.value), data.transparency)
            end
        end,
    },
    
    KeyPicker = {
        Save = function(idx, object)
            return { 
                type = 'KeyPicker', 
                idx = idx, 
                mode = object.Mode, 
                key = object.Value 
            }
        end,
        
        Load = function(idx, data)
            local object = SaveManager.Library.Options[idx]
            if object then
                object:SetValue({ data.key, data.mode })
            end
        end,
    },
    
    Input = {
        Save = function(idx, object)
            return { 
                type = 'Input', 
                idx = idx, 
                text = object.Value 
            }
        end,
        
        Load = function(idx, data)
            local object = SaveManager.Library.Options[idx]
            if object and type(data.text) == 'string' then
                object:SetValue(data.text)
            end
        end,
    },
}


function SaveManager:GetConfigPath(name)
    local basePath = self.Folder .. '/settings/' .. name .. '.json'
    
    if self:HasSubFolder() then
        self:EnsureSubFolder()
        basePath = self.Folder .. '/settings/' .. self.SubFolder .. '/' .. name .. '.json'
    end
    
    return basePath
end

function SaveManager:Save(name)
    if not name or name == '' then
        return false, 'No config name provided'
    end
    
    self:EnsureFolderTree()

    local fullPath = self:GetConfigPath(name)
    local data = {
        version = self.SaveVersion,
        objects = {}
    }

    for idx, toggle in pairs(self.Library.Toggles) do
        if toggle.Type and self.Parser[toggle.Type] and not self.Ignore[idx] then
            table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
        end
    end

    for idx, option in pairs(self.Library.Options) do
        if option.Type and self.Parser[option.Type] and not self.Ignore[idx] then
            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end
    end

    if #data.objects == 0 then
        return false, 'No data to save (empty config)'
    end

    local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if not success then
        return false, 'Failed to encode data: ' .. tostring(encoded)
    end

    writefile(fullPath, encoded)
    return true, 'Config saved successfully'
end

function SaveManager:Load(name)
    if not name or name == '' then
        return false, 'No config name provided'
    end
    
    self:EnsureFolderTree()

    local file = self:GetConfigPath(name)
    if not isfile(file) then
        return false, 'Config file does not exist'
    end

    local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
    if not success then
        return false, 'Failed to decode data: ' .. tostring(decoded)
    end

    if decoded.version ~= self.SaveVersion then
        warn(string.format(
            'Config version mismatch: %s (expected %s)', 
            tostring(decoded.version), 
            self.SaveVersion
        ))
    end

    for _, option in ipairs(decoded.objects or {}) do
        if option.type and self.Parser[option.type] then
            task.spawn(self.Parser[option.type].Load, option.idx, option)
        end
    end

    return true, 'Config loaded successfully'
end

function SaveManager:Delete(name)
    if not name or name == '' then
        return false, 'No config name provided'
    end

    local file = self:GetConfigPath(name)
    if not isfile(file) then
        return false, 'Config file does not exist'
    end

    local success, err = pcall(delfile, file)
    if not success then
        return false, 'Failed to delete file: ' .. tostring(err)
    end

    return true, 'Config deleted successfully'
end

function SaveManager:RefreshConfigList()
    self:EnsureFolderTree()

    local folder = self.Folder .. '/settings'
    if self:HasSubFolder() then
        folder = folder .. '/' .. self.SubFolder
    end

    local success, files = pcall(listfiles, folder)
    if not success then
        local errorMsg = 'Failed to refresh config list: ' .. tostring(files)
        if self.Library then
            self.Library:Notify(errorMsg)
        else
            warn(errorMsg)
        end
        return {}
    end

    local configList = {}
    for _, file in ipairs(files or {}) do
        local name = file:match('([^/\\]+)%.json$')
        if name then
            table.insert(configList, name)
        end
    end

    return configList
end


function SaveManager:GetAutoloadPath()
    local basePath = self.Folder .. '/settings/AutoLoad.txt'
    
    if self:HasSubFolder() then
        self:EnsureSubFolder()
        basePath = self.Folder .. '/settings/' .. self.SubFolder .. '/AutoLoad.txt'
    end
    
    return basePath
end

function SaveManager:GetAutoloadConfig()
    self:EnsureFolderTree()

    local autoLoadPath = self:GetAutoloadPath()
    if not isfile(autoLoadPath) then
        return 'none'
    end

    local success, name = pcall(readfile, autoLoadPath)
    if not success then
        return 'none'
    end

    name = name:match('^%s*(.-)%s*$')
    return name ~= '' and name or 'none'
end

function SaveManager:LoadAutoloadConfig()
    self:EnsureFolderTree()

    local autoLoadPath = self:GetAutoloadPath()
    if not isfile(autoLoadPath) then 
        return 
    end

    local successRead, name = pcall(readfile, autoLoadPath)
    if not successRead then
        if self.Library then 
            self.Library:Notify('Failed to read autoload config: ' .. tostring(name)) 
        end
        return
    end

    local success, err = self:Load(name)
    if not success then
        if self.Library then 
            self.Library:Notify('Failed to load autoload config: ' .. err) 
        end
        return
    end

    if self.Library then
        self.Library:Notify(string.format('Auto loaded config "%s"', name))
    end
end

function SaveManager:SaveAutoloadConfig(name)
    if not name or name == '' then
        return false, 'No config name provided'
    end
    
    self:EnsureFolderTree()

    local autoLoadPath = self:GetAutoloadPath()
    local success, err = pcall(writefile, autoLoadPath, name)
    
    if not success then
        return false, 'Failed to write autoload file: ' .. tostring(err)
    end

    return true, 'Autoload config saved'
end

function SaveManager:DeleteAutoLoadConfig()
    self:EnsureFolderTree()

    local autoLoadPath = self:GetAutoloadPath()
    if not isfile(autoLoadPath) then
        return true, 'No autoload config to delete'
    end

    local success, err = pcall(delfile, autoLoadPath)
    if not success then
        return false, 'Failed to delete autoload file: ' .. tostring(err)
    end

    return true, 'Autoload config deleted'
end


function SaveManager:StopAutoSave()
    if self.AutoSaveTask then
        task.cancel(self.AutoSaveTask)
        self.AutoSaveTask = nil
    end
    
    if self.LabelUpdateTask then
        task.cancel(self.LabelUpdateTask)
        self.LabelUpdateTask = nil
    end
    
    self.AutoSaveConfig.Enabled = false
    self.AutoSaveConfig.SavesSinceStart = 0
    self.AutoSaveConfig.FailedSaves = 0
    
    if self.AutoSaveLabel then
        self.AutoSaveLabel:SetText('Auto save: disabled')
    end
end

function SaveManager:UpdateAutoSaveLabel()
    if not self.AutoSaveLabel then 
        return 
    end
    
    local lastStr = (self.AutoSaveConfig.LastSaveTime > 0) 
        and string.format('%.1f', tick() - self.AutoSaveConfig.LastSaveTime) .. 's ago' 
        or 'never'
    
    self.AutoSaveLabel:SetText(string.format(
        'Auto save: enabled | Saves: %d | Last: %s',
        self.AutoSaveConfig.SavesSinceStart,
        lastStr
    ))
end

function SaveManager:ScheduleAutoSave()
    if not self.AutoSaveConfig.Enabled then 
        return 
    end

    if self.AutoSaveTask then
        task.cancel(self.AutoSaveTask)
    end

    self.AutoSaveTask = task.delay(self.AutoSaveConfig.Interval, function()
        self:PerformAutoSave()
    end)
end

function SaveManager:PerformAutoSave()
    self.AutoSaveTask = nil

    local success, msg = self:Save(self.AutoSaveName)
    
    if not success then
        self.AutoSaveConfig.FailedSaves = self.AutoSaveConfig.FailedSaves + 1
        
        if self.Library then
            self.Library:Notify(
                string.format('Auto save failed (%d): %s', 
                    self.AutoSaveConfig.FailedSaves, 
                    msg
                ), 
                3
            )
        end

        if self.AutoSaveConfig.FailedSaves >= self.AutoSaveConfig.MaxFailures then
            if self.Library then
                self.Library:Notify('Auto save disabled due to repeated failures', 4)
            end
            self:StopAutoSave()
        else
            self:ScheduleAutoSave()
        end
    else
        self.AutoSaveConfig.SavesSinceStart = self.AutoSaveConfig.SavesSinceStart + 1
        self.AutoSaveConfig.FailedSaves = 0
        self.AutoSaveConfig.LastSaveTime = tick()
        self:UpdateAutoSaveLabel()
        self:ScheduleAutoSave()
    end
end

function SaveManager:SetupChangeListeners()
    local function onChange()
        self:ScheduleAutoSave()
    end

    for idx, toggle in pairs(self.Library.Toggles) do
        if not self.Ignore[idx] and toggle.OnChanged then
            toggle:OnChanged(onChange)
        end
    end

    for idx, option in pairs(self.Library.Options) do
        if not self.Ignore[idx] and option.OnChanged then
            option:OnChanged(onChange)
        end
    end
end

function SaveManager:StartAutoSave(configName, interval)
    if self.AutoSaveConfig.Enabled then
        self:StopAutoSave()
    end

    self.AutoSaveName = configName
    self.AutoSaveConfig.Interval = interval
    self.AutoSaveConfig.Enabled = true
    self.AutoSaveConfig.LastSaveTime = 0
    self.AutoSaveConfig.SavesSinceStart = 0
    self.AutoSaveConfig.FailedSaves = 0

    self:SetupChangeListeners()
    self:ScheduleAutoSave()

    self.LabelUpdateTask = task.spawn(function()
        while self.AutoSaveConfig.Enabled do
            self:UpdateAutoSaveLabel()
            task.wait(1)
        end
    end)
end


function SaveManager:BuildConfigSection(tab)
    assert(self.Library, 'SaveManager:BuildConfigSection -> Must set SaveManager.Library')

    local section = tab:AddRightGroupbox('Configuration')

    section:AddInput('SaveManager_ConfigName', { Text = 'Config name' })
    section:AddButton('Create config', function()
        local name = self.Library.Options.SaveManager_ConfigName.Value
        
        if not name or name:gsub(' ', '') == '' then
            return self.Library:Notify('Invalid config name (empty)', 2)
        end

        local success, msg = self:Save(name)
        if not success then
            return self.Library:Notify('Failed to create config: ' .. msg)
        end

        self.Library:Notify(string.format('Created config "%s"', name))
        self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
        self.Library.Options.SaveManager_ConfigList:SetValue(nil)
    end)

    section:AddDivider()

    section:AddDropdown('SaveManager_ConfigList', { 
        Text = 'Config list', 
        Values = self:RefreshConfigList(), 
        AllowNull = true 
    })
    
    section:AddButton('Load config', function()
        local name = self.Library.Options.SaveManager_ConfigList.Value
        if not name then 
            return self.Library:Notify('No config selected') 
        end

        local success, msg = self:Load(name)
        if not success then
            return self.Library:Notify('Failed to load config: ' .. msg)
        end

        self.Library:Notify(string.format('Loaded config "%s"', name))
    end)
    
    section:AddButton('Overwrite config', function()
        local name = self.Library.Options.SaveManager_ConfigList.Value
        if not name then 
            return self.Library:Notify('No config selected') 
        end

        local success, msg = self:Save(name)
        if not success then
            return self.Library:Notify('Failed to overwrite config: ' .. msg)
        end

        self.Library:Notify(string.format('Overwrote config "%s"', name))
    end)

    section:AddButton('Delete config', function()
        local name = self.Library.Options.SaveManager_ConfigList.Value
        if not name then 
            return self.Library:Notify('No config selected') 
        end

        local success, msg = self:Delete(name)
        if not success then
            return self.Library:Notify('Failed to delete config: ' .. msg)
        end

        self.Library:Notify(string.format('Deleted config "%s"', name))
        self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
        self.Library.Options.SaveManager_ConfigList:SetValue(nil)
    end)

    section:AddButton('Refresh list', function()
        self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
        self.Library.Options.SaveManager_ConfigList:SetValue(nil)
    end)

    section:AddButton('Set as autoload', function()
        local name = self.Library.Options.SaveManager_ConfigList.Value
        if not name then 
            return self.Library:Notify('No config selected') 
        end

        local success, msg = self:SaveAutoloadConfig(name)
        if not success then
            return self.Library:Notify('Failed to set autoload: ' .. msg)
        end

        self.AutoloadStatusLabel:SetText('Current autoload config: ' .. name)
        self.Library:Notify(string.format('Set "%s" to auto load', name))
    end)
    
    section:AddButton('Reset autoload', function()
        local success, msg = self:DeleteAutoLoadConfig()
        if not success then
            return self.Library:Notify('Failed to reset autoload: ' .. msg)
        end

        self.Library:Notify('Autoload set to None')
        self.AutoloadStatusLabel:SetText('Autoload configuration: None')
    end)

    self.AutoloadStatusLabel = section:AddLabel(
        'Autoload configuration: ' .. self:GetAutoloadConfig(), 
        true
    )

    section:AddDivider('Auto save')

    section:AddToggle('SaveManager_AutoSaveEnabled', { 
        Text = 'Auto Save', 
        Default = false 
    }):OnChanged(function(value)
        if value then
            local config = self.Library.Options.SaveManager_ConfigList.Value
            if not config then
                self.Library:Notify('No config selected for auto save')
                self.Library.Options.SaveManager_AutoSaveEnabled:SetValue(false)
                return
            end
            
            local interval = self.Library.Options.SaveManager_AutoSaveInterval.Value
            self:StartAutoSave(config, interval)
            self:UpdateAutoSaveLabel()
        else
            self:StopAutoSave()
        end
    end)
    
    local DependencyBox = section:AddDependencyBox()
    DependencyBox:SetupDependencies({ { Toggles.SaveManager_AutoSaveEnabled, true } })

    
    DependencyBox:AddSlider('SaveManager_AutoSaveInterval', { 
        Text = 'Auto Save Interval', 
        Default = 10, 
        Min = 5, 
        Max = 300, 
        Rounding = 0, 
        Suffix = 's' 
    })

    DependencyBox:AddSlider('SaveManager_MaxFailures', { 
        Text = 'Max Auto Save Failures', 
        Default = 3, 
        Min = 1, 
        Max = 10, 
        Rounding = 0 
    }):OnChanged(function(value)
        self.AutoSaveConfig.MaxFailures = value
    end)

    self.AutoSaveLabel = DependencyBox:AddLabel('Auto save: disabled', true)

    self:LoadAutoloadConfig()
    self:SetIgnoreIndexes({ 
        'SaveManager_ConfigList', 
        'SaveManager_ConfigName', 
        'SaveManager_AutoSaveEnabled', 
        'SaveManager_AutoSaveInterval', 
        'SaveManager_MaxFailures' 
    })
end

SaveManager:BuildFolderTree()
return SaveManager
