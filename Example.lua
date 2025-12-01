--[[ Load by file local
local LinoriaLib = 'https://raw.githubusercontent.com/DH-SOARESE/LinoriaLib/main/'
local folderName = 'Linoria Library'
local basePath = folderName
local addonsPath = basePath .. '/addons'

if not isfolder(basePath) then makefolder(basePath) end
if not isfolder(addonsPath) then makefolder(addonsPath) end

local function ensureFile(filePath, url)
    if not isfile(filePath) then
        local ok, result = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and result then
            writefile(filePath, result)
        else
            warn('Error ' .. filePath .. ': ' .. tostring(result))
        end
    end
end

ensureFile(basePath .. '/Library.lua', LinoriaLib .. 'Library.lua')
ensureFile(addonsPath .. '/SaveManager.lua', LinoriaLib .. 'addons/SaveManager.lua')
ensureFile(addonsPath .. '/ThemeManager.lua', LinoriaLib .. 'addons/ThemeManager.lua')

local Library = loadfile(basePath .. '/Library.lua')()
local SaveManager = loadfile(addonsPath .. '/SaveManager.lua')()
local ThemeManager = loadfile(addonsPath .. '/ThemeManager.lua')()

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
]]

local LinoriaLib = 'https://raw.githubusercontent.com/Porxiai/NytrixLib/refs/heads/main/Library.lua'

local function loadLibrary(path)
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(LinoriaLib .. path))()
    end)
    if not ok then
        error('Failed to load ' .. path .. ': ' .. result)
    end
    return result
end

local Library = loadLibrary('Library.lua')
local ThemeManager = loadLibrary('addons/ThemeManager.lua')
local SaveManager = loadLibrary('addons/SaveManager.lua')

local LocalPlayer = game:GetService('Players').LocalPlayer

-- Shortcuts for options and toggles
local Options = Library.Options
local Toggles = Library.Toggles

-- Global Library settings
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

Library.NotifySide = 'Right'
Library.MobileButtonsSide = 'Right'
Library.CursorImage = 12230889708
Library.CursorSize = 15 -- Default '20'

-- Create main window
local Window = Library:CreateWindow({
    Title = 'LinoriaLib',
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    TabPadding = 3,
    MenuFadeTime = 0.2
})

-- Define tabs
local Tabs = {
    Controls = Window:AddTab('Controls', 80485236798991),
    Display = Window:AddTab('Display', 134567380715608),
    Advanced = Window:AddTab('Advanced', 114673753213917),
    System = Window:AddTab('System', 9692125126),
    method = Window:AddTab('Example method', 130521044774541),
    Settings = Window:AddTab('Settings', 119015428034090)
}

-- ==================== CONTROLS TAB ====================

local ToggleGroup = Tabs.Controls:AddLeftGroupbox('Toggle System')

ToggleGroup:AddToggle('BasicToggle', {
    Text = 'Basic toggle',
    Default = false,
    Tooltip = 'Simple on/off control',
    Callback = function(State)
        print('State: ' .. tostring(State))
    end
})

ToggleGroup:AddToggle('DisableToggle', {
    Text = 'Disable Toggle',
    Default = false,
    Tooltip = "Toggle Disabled",    
    Disabled = true, 
    Callback = function(value)
        -- No Callback 
    end
})

ToggleGroup:AddToggle('RiskyToggle', {
    Text = 'Critical Mode',
    Default = false,
    Risky = true,
    Tooltip = 'Requires caution when enabling',
    Callback = function(value)
        if value then
            Library:Notify('Critical mode enabled', 3)
        end
        print('[Toggle] Critical:', value)
    end
})

ToggleGroup:AddToggle('KeybindToggle', {
    Text = 'Keybind Toggle',
    Default = false,
    Tooltip = 'Can be toggled via keyboard',
    Callback = function(value)
        print('[Toggle] Keybind state:', value)
    end
}):AddKeyPicker('KeybindPicker', {
    Mode = 'Toggle',
    Default = 'E',
    Text = 'Hotkey',
    SyncToggleState = true,
    Callback = function(value)
        print('State of Toggle:' .. value)
    end
})

local ColorToggle = ToggleGroup:AddToggle('ColorToggle', {
    Text = 'Color Toggle',
    Default = true,
    Tooltip = 'Toggle with color customization',
    Callback = function(value)
        print('[Toggle] Color enabled:' .. value)
    end
})

ColorToggle:AddColorPicker('PrimaryColor', {
    Title = 'Primary',
    Default = Color3.fromRGB(0, 170, 255),
    Callback = function(color) -- not transparency
        print(
            'Color = (' .. color .. ') \n',
            'Player:' .. LocalPlayer.Name
        )
    end
})

ColorToggle:AddColorPicker('SecondaryColor', {
    Title = 'Secondary',
    Default = Color3.fromRGB(255, 170, 0),
    Transparency = 0.3,
    Callback = function(color, alpha)
        print(
            'Color = (' .. color .. ') \n',
            'Alpha = [' .. alpha .. ']',
            'Player:' .. LocalPlayer.Name
        )
    end
})

local ButtonGroup = Tabs.Controls:AddLeftGroupbox('Button Actions')

ButtonGroup:AddButton({
    Text = 'Quick Action',
    Tooltip = 'Single click execution',
    Func = function() 
        Library:Notify('Action executed', 2)
        print('[Button] Quick action triggered')
    end
})

ButtonGroup:AddButton({
    Text = 'Safe Action',
    DoubleClick = true,
    Tooltip = 'Requires double-click',
    Func = function()
        Library:Notify('Safe action confirmed', 2)
        print('[Button] Safe action executed')
    end
})

ButtonGroup:AddButton({
    Text = 'Chain Action',
    Func = function()
        print('[Button] Chain started')
        Library:Notify('Processing...', 1)
    end
}):AddButton({
    Text = 'Verify',
    DoubleClick = true,
    Func = function()
        print('[Button] Chain verified')
        Library:Notify('Verified successfully', 2)
    end
})

ButtonGroup:AddButton({
    Text = 'Locked Feature',
    Disabled = true,
    DisabledTooltip = 'Feature not available',
    Func = function()
        print('[Button] Should not execute')
    end
})

local SliderGroup = Tabs.Controls:AddRightGroupbox('Slider Controls Example')

SliderGroup:AddSlider('IntegerSlider', {
    Text = 'Integer Value',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Tooltip = 'Select a whole number between 0 and 100',
    Callback = function(value)
        print('Integer Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('SliderDisable', {
    Text = 'Example',
    Default = 30,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Disabled = true,
    Callback = function(value)
        PlaybackVideo:SetVolume(value / 100)
    end
})

SliderGroup:AddSlider('DecimalSlider', {
    Text = 'Decimal Value',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Tooltip = 'Select a precise decimal value (2 decimal places)',
    Callback = function(value)
        print('Decimal Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('CurrencySlider', {
    Text = 'Currency Amount',
    Default = 1000,
    Min = 0,
    Max = 10000,
    Rounding = 0,
    Prefix = '$',
    Suffix = '.00',
    Tooltip = 'Adjust the amount in currency format',
    Callback = function(value)
        print('Currency Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('PercentageSlider', {
    Text = 'Percentage',
    Default = 75,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Tooltip = 'Select a percentage value',
    Callback = function(value)
        print('Percentage Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('ThresholdSlider', {
    Text = 'Threshold Level',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    ValueText = {
        {Value = 0, Text = 'Off'},
        {Value = 25, Text = 'Low'},
        {Value = 50, Text = 'Medium'},
        {Value = 75, Text = 'High'},
        {Value = 100, Text = 'Max'}
    },
    Tooltip = 'Select a named threshold level',
    Callback = function(value)
        print('Threshold Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('CompactSlider', {
    Text = 'Compact Range',
    Default = 256,
    Min = 0,
    Max = 1024,
    Rounding = 0,
    Compact = true,
    Tooltip = 'A slider with compact design for large ranges',
    Callback = function(value)
        print('Compact Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('HideMaxSlider', {
    Text = 'Hidden Max Slider',
    Default = 0,
    Min = -400,
    Max = 400,
    Rounding = 0,
    HideMax = true,
    Tooltip = 'Slider hides maximum value for cleaner display',
    Callback = function(value)
        print('HideMax Slider Value: ' .. value)
    end
})

SliderGroup:AddSlider('NoTitleSlider', {
    Default = math.random(-1000, 1000),
    Min = math.random(-1000, 0),
    Max = math.random(0, 1000),
    Rounding = math.random(0, 5),
    HideMax = true,
    Tooltip = 'Slider without a title label, starts with random decimal and random rounding',
    Callback = function(value)
        print('No Title Slider Value: ' .. value)
    end
})

local InputGroup = Tabs.Controls:AddRightGroupbox('Input Fields')

InputGroup:AddInput('TextInput', {
    Text = 'Text Field',
    Default = '',
    Placeholder = 'Enter text here...',
    Tooltip = 'Standard text input',
    Callback = function(value)
        print('[Input] Text:', value)
    end
})

InputGroup:AddInput('ConfirmInput', {
    Text = 'Confirm Input',
    Default = '',
    Placeholder = 'Press Enter to submit',
    Finished = true,
    Tooltip = 'Triggers on Enter key',
    Callback = function(value)
        if value ~= '' then
            Library:Notify('Input received: ' .. value, 2)
            print('[Input] Confirmed:', value)
        end
    end
})

InputGroup:AddInput('LimitedInput', {
    Text = 'Limited (15 chars)',
    Default = '',
    Placeholder = 'Max 15 characters',
    MaxLength = 15,
    AllowEmpty = false,
    Tooltip = 'Character limit enforced',
    Callback = function(value)
        print('[Input] Limited:', value)
    end
})

InputGroup:AddInput('NumericInput', {
    Text = 'Numeric Only',
    Default = '0',
    Placeholder = 'Numbers only',
    Numeric = true,
    Tooltip = 'Accepts numbers only',
    Callback = function(value)
        local num = tonumber(value)
        if num then
            print('[Input] Number:', num)
        end
    end
})

InputGroup:AddInput('ReadOnly', {
    Text = 'Read Only',
    Default = 'System information',
    Disabled = true,
    Tooltip = 'Cannot be modified'
})

-- ==================== DISPLAY TAB ====================

local DropdownGroup = Tabs.Display:AddLeftGroupbox('Dropdown Menus')

DropdownGroup:AddDropdown('SingleSelect', {
    Text = 'Single Select',
    Values = {'Option A', 'Option B', 'Option C', 'Option D', 'Option E'},
    Default = 1,
    Tooltip = 'Select one option',
    Callback = function(value)
        print('[Dropdown] Selected:', value)
    end
})

DropdownGroup:AddDropdown('Disabled', {
    Text = 'Dropdown Disabled',
    Values = {'Option A', 'Option B', 'Option C', 'Option D', 'Option E'},
    Default = 1,
    Disabled = true,
    Callback = function(value)
        print('[Dropdown] Selected:', value)
    end
})

DropdownGroup:AddDropdown('SearchDrop', {
    Text = 'Searchable List',
    Values = {'Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta'},
    Default = 1,
    Searchable = true,
    Tooltip = 'Type to filter options',
    Callback = function(value)
        print('[Dropdown] Searched:', value)
    end
})

DropdownGroup:AddDropdown('MultiSelect', {
    Text = 'Multi Select',
    Values = {'Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'},
    Default = {['Item 1'] = true},
    Multi = true,
    Tooltip = 'Select multiple items',
    Callback = function(values)
        print('[Dropdown] Multi selection:')
        for item, enabled in pairs(values) do
            if enabled then
                print('  -', item)
            end
        end
    end
})

DropdownGroup:AddDropdown('PlayerSelect', {
    Text = 'Player List',
    SpecialType = 'Player',
    ExcludeLocalPlayer = true,
    Searchable = true,
    Tooltip = 'Select active player',
    Callback = function(player)
        print('[Dropdown] Player:', player)
    end
})

local DisplayGroup = Tabs.Display:AddLeftGroupbox('Visual Elements')

DisplayGroup:AddLabel('Static text label for information')
DisplayGroup:AddLabel('Multi-line label:\n- First point\n- Second point\n- Third point', true)
DisplayGroup:AddDivider()
DisplayGroup:AddLabel('Content after divider')
DisplayGroup:AddDivider('Named Section')
DisplayGroup:AddLabel('Content after named divider')

local MediaGroup = Tabs.Display:AddRightGroupbox('Media Display')

MediaGroup:AddImage('DisplayImage', {
    Image = 'rbxassetid://10511855986',
    Height = 180,
    Color = Color3.fromRGB(255, 255, 255),
    ScaleType = Enum.ScaleType.Fit,
    Transparency = 0,
    Visible = true,
    Tooltip = 'Image from Roblox assets'
})

MediaGroup:AddButton({
    Text = 'Toggle Image',
    Func = function()
        Options.DisplayImage:SetVisible(not Options.DisplayImage.Visible)
    end
})

local VideoGroup = Tabs.Display:AddRightGroupbox('Video Playback')

local PlaybackVideo = VideoGroup:AddVideo('PlaybackVideo', {
    Video = 'rbxassetid://5670824523',
    Height = 180,
    Looped = true,
    Playing = true,
    Volume = 0.3,
    Visible = true
})

VideoGroup:AddSlider('VideoVolume', {
    Text = 'Volume',
    Default = 30,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(value)
        PlaybackVideo:SetVolume(value / 100)
    end
})

VideoGroup:AddButton({
    Text = 'Playing',
    Func = function()
        PlaybackVideo:SetPlaying(true)
    end
})

VideoGroup:AddToggle('VideoLooped', {
    Text = 'Looped',
    Default = true,
    Callback = function(value)
        PlaybackVideo:SetLooped(value)
    end
})

local ViewportGroup = Tabs.Display:AddRightGroupbox('3D Preview')

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

local function WaitForCharacter(player)
    if player.Character and player.Character.Parent then
        return player.Character
    end
    return player.CharacterAdded:Wait()
end

local function CloneCharacter(character)
    local clone = Instance.new('Model')
    clone.Name = character.Name .. '_Clone'

    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA('BasePart') then
            local part = obj:Clone()
            part.Anchored = true
            part.CanCollide = false
            part.Parent = clone
        elseif obj:IsA('Accessory') then
            local handle = obj:FindFirstChild('Handle')
            if handle and handle:IsA('BasePart') then
                local acc = handle:Clone()
                acc.Parent = clone
            end
        end
    end

    clone.PrimaryPart = clone:FindFirstChildWhichIsA('BasePart')
    return clone
end

local Character = WaitForCharacter(LocalPlayer)
local ClonedChar = CloneCharacter(Character)

local Viewport = ViewportGroup:AddViewport('CharPreview', {
    Object = ClonedChar,
    Clone = false,
    Interactive = true,
    AutoFocus = true,
    Height = 220,
    Visible = true
})

LocalPlayer.CharacterAdded:Connect(function()
    local char = WaitForCharacter(LocalPlayer)
    local newClone = CloneCharacter(char)
    Viewport:SetObject(newClone, false)
    Viewport:Focus()
end)

ViewportGroup:AddLabel('Interactive 3D character model')

-- ==================== ADVANCED TAB ====================

local DependencyGroup = Tabs.Advanced:AddLeftGroupbox('Dependencies')

DependencyGroup:AddLabel('Master control enables child elements:')

local MasterToggle = DependencyGroup:AddToggle('MasterControl', {
    Text = 'Enable Features',
    Default = false,
    Tooltip = 'Controls dependent elements',
    Callback = function(value)
        print('[Dependency] Master:', value)
    end
})

local DependentBox = DependencyGroup:AddDependencyBox()
DependentBox:SetupDependencies({{Toggles.MasterControl, true}})

DependentBox:AddToggle('ChildToggle', {
    Text = 'Child Toggle',
    Default = false,
    Tooltip = 'Requires master enabled',
    Callback = function(value)
        print('[Dependency] Child toggle:', value)
    end
})

DependentBox:AddSlider('ChildSlider', {
    Text = 'Child Slider',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Tooltip = 'Requires master enabled',
    Callback = function(value)
        print('[Dependency] Child slider:', value)
    end
})

DependentBox:AddInput('ChildInput', {
    Text = 'Child Input',
    Default = '',
    Placeholder = 'Requires master...',
    Tooltip = 'Requires master enabled',
    Callback = function(value)
        print('[Dependency] Child input:', value)
    end
})

DependentBox:AddDropdown('ChildDropdown', {
    Text = 'Child Dropdown',
    Values = {'Mode 1', 'Mode 2', 'Mode 3'},
    Default = 1,
    Tooltip = 'Requires master enabled',
    Callback = function(value)
        print('[Dependency] Child dropdown:', value)
    end
})

local NestedTabbox = Tabs.Advanced:AddLeftTabbox()
local SubTab1 = NestedTabbox:AddTab('Config')
local SubTab2 = NestedTabbox:AddTab('Data')
local SubTab3 = NestedTabbox:AddTab('Execute')

SubTab1:AddToggle('ConfigToggle', {
    Text = 'Configuration',
    Default = false,
    Callback = function(value)
        print('[Nested] Config toggle:', value)
    end
})

SubTab1:AddSlider('ConfigSlider', {
    Text = 'Config Value',
    Default = 75,
    Min = 0,
    Max = 150,
    Rounding = 0,
    Callback = function(value)
        print('[Nested] Config slider:', value)
    end
})

SubTab2:AddInput('DataInput', {
    Text = 'Data Entry',
    Default = '',
    Placeholder = 'Enter data...',
    Callback = function(value)
        print('[Nested] Data input:', value)
    end
})

SubTab2:AddDropdown('DataDropdown', {
    Text = 'Data Type',
    Values = {'Type A', 'Type B', 'Type C'},
    Default = 1,
    Callback = function(value)
        print('[Nested] Data type:', value)
    end
})

SubTab3:AddButton({
    Text = 'Execute',
    Func = function()
        Library:Notify('Nested action executed', 2)
        print('[Nested] Execute button')
    end
})

SubTab3:AddButton({
    Text = 'Verify',
    DoubleClick = true,
    Func = function()
        Library:Notify('Verification complete', 2)
        print('[Nested] Verify button')
    end
})

local KeybindGroup = Tabs.Advanced:AddRightGroupbox('Keybind System')

-- Toggle Mode
KeybindGroup:AddLabel('Toggle Mode (Press to switch):')
KeybindGroup:AddToggle('ExampleToggle_Toggle', {
    Text = 'Example Toggle',
    Default = false,
    Callback = function(value)
        print('Toggle:', value)
    end
}):AddKeyPicker('ToggleKey', {
    Default = 'F',
    Mode = 'Toggle',
    Text = 'Toggle',
    SyncToggleState = true,
    Callback = function(value)
        print('[Key] Toggle mode:', value)
    end
})

-- Hold Mode
KeybindGroup:AddLabel('Hold Mode (Active while held):')
KeybindGroup:AddToggle('ExampleToggle_Hold', {
    Text = 'Example Toggle',
    Default = false,
    Callback = function(value)
        print('Toggle:', value)
    end
}):AddKeyPicker('HoldKey', {
    Default = 'LeftShift',
    Mode = 'Hold',
    Text = 'Hold',
    Callback = function(value)
        print('[Key] Hold mode:', value)
    end
})

-- Always Mode
KeybindGroup:AddLabel('Always Mode (Permanent):')
KeybindGroup:AddToggle('ExampleToggle_Always', {
    Text = 'Example Toggle',
    Default = false,
    Callback = function(value)
        print('Toggle:', value)
    end
}):AddKeyPicker('AlwaysKey', {
    Default = 'None',
    Mode = 'Always',
    Text = 'Always',
    Callback = function(value)
        print('[Key] Always mode:', value)
    end
})

-- KeyPicker (Independent)
KeybindGroup:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
    Default = 'MB2',
    Mode = 'Toggle',
    Text = 'Auto lockpick safes',
    SyncToggleState = false,
    NoUI = false,
    Callback = function(value)
        print('[cb] Keybind clicked!', value)
    end,
    ChangedCallback = function(newKey, modifiers)
        print('[cb] Keybind changed!', newKey, table.unpack(modifiers or {}))
    end
})

Options.KeyPicker:OnClick(function()
    print('Keybind clicked!', Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
    print('Keybind changed!', Options.KeyPicker.Value, table.unpack(Options.KeyPicker.Modifiers or {}))
end)

task.spawn(function()
    while task.wait(1) do
        if Library.Unloaded then break end
        if Options.KeyPicker:GetState() then
            print('KeyPicker is being held down')
        end
    end
end)

Options.KeyPicker:SetValue({ 'MB2', 'Hold' })

-- Keybind Counter
local KeybindNumber = 0
KeybindGroup:AddLabel('Increase Number'):AddKeyPicker('KeyPicker2', {
    Default = 'X',
    Mode = 'Press',
    WaitForCallback = false,
    Text = 'Increase Number',
    Callback = function()
        KeybindNumber += 1
        Library:Notify('[cb] Keybind clicked! Number increased to: ' .. KeybindNumber)
    end
})

-- ==================== SYSTEM TAB ====================

local StatusGroup = Tabs.System:AddLeftGroupbox('System Status')

StatusGroup:AddLabel('Real-time system information')

local StatusLabel = StatusGroup:AddLabel('Initializing...')

local RunService = game:GetService('RunService')
local Stats = game:GetService('Stats')

local frameCounter = 0
local frameTime = tick()
local currentFPS = 60

RunService.Heartbeat:Connect(function()
    frameCounter = frameCounter + 1
    
    if tick() - frameTime >= 1 then
        currentFPS = frameCounter
        frameTime = tick()
        frameCounter = 0
        
        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
        local memory = Stats:GetTotalMemoryUsageMb()
        
        StatusLabel:SetText(string.format(
            'FPS: %d | Ping: %dms | Memory: %.1fMB',
            math.floor(currentFPS),
            math.floor(ping),
            memory
        ))
    end
end)

local NotifGroup = Tabs.System:AddLeftGroupbox('Notifications')

NotifGroup:AddButton({
    Text = 'Info Notification',
    Func = function()
        Library:Notify('Information message displayed', 3)
    end
})

NotifGroup:AddButton({
    Text = 'Success Notification',
    Func = function()
        Library:Notify('Operation completed successfully', 3)
    end
})

NotifGroup:AddButton({
    Text = 'Warning Notification',
    Func = function()
        Library:Notify('Warning: Check system settings', 4)
    end
})

NotifGroup:AddButton({
    Text = 'Long Notification',
    Func = function()
        Library:Notify('This is a longer notification message that provides more detailed information to the user', 5)
    end
})

local ActionGroup = Tabs.System:AddRightGroupbox('System Actions')

ActionGroup:AddButton({
    Text = 'Reset Configuration',
    DoubleClick = true,
    Tooltip = 'Double-click to reset all settings',
    Func = function()
        Library:Notify('Configuration reset', 2)
        Library:ResetUI()
    end
})

ActionGroup:AddButton({
    Text = 'Unload Interface',
    DoubleClick = true,
    Tooltip = 'Double-click to unload completely',
    Func = function()
        Library:Notify('Unloading system...', 2)
        task.wait(0.5)
        Library:LinoriaUnload()
    end
})

local Example1 = Tabs.method:AddLeftGroupbox('Example One')

local Label1 = Example1:AddLabel("State: False")

Example1:AddToggle('Enabled', {
    Text = 'Enable Feature',
    Default = false,
    Callback = function(Value)
        Label1:SetText('State: ' .. (Value and 'True' or 'False'))
    end
})

Example1:AddButton({
    Text = 'Toggle (toggle)',
    Func = function()
        Toggles.Enabled:SetValue(not Toggles.Enabled.Value)
    end
})

local ByState = false
local MyButton
MyButton = Example1:AddButton({
    Text = 'State: False',
    Func = function()
        ByState = not ByState
        MyButton:SetText('State: ' .. (ByState and 'True' or 'False'))
    end
})

Example1:AddDivider()

Example1:AddSlider('A', {
    Text = 'a',
    Default = math.random(-1000, 10000),
    Min = math.random(-1000, 0),
    Max = math.random(0, 10000),
    Rounding = math.random(0, 5),
    Callback = function(Value)
        Options.B:SetValue(Value)
    end
})

Example1:AddSlider('B', {
    Text = 'b',
    Default = math.random(-1000, 10000),
    Min = math.random(-1000, 0),
    Max = math.random(0, 10000),
    Rounding = math.random(0, 5),
    Callback = function(Value)
        Options.A:SetValue(Value)
    end
})

Example1:AddDivider()

Example1:AddSlider('Gg', {
    Text = 'Example 2',
    Default = 0,
    Min = -9999,
    Max = 9999,
    Rounding = 0
})

Example1:AddInput('Number', {
    Text = 'Slider Control',
    Placeholder = 'Enter',
    Numeric = true,
    Finished = true,
    Callback = function(value)
        Options.Gg:SetValue(value)
    end
})

local Example2 = Tabs.method:AddRightGroupbox('Example Two')

local pool = {'Easy', 'Medium', 'Hard'}

Example2:AddDropdown('Examplep', {
    Text = 'Select toggles',
    Values = pool,
    Default = {},
    Multi = true,
    AllowNull = false,
    Tooltip = 'Choose the difficulty level.',
    Callback = function(selected)
        for _, key in ipairs(pool) do
            Toggles[key]:SetValue(false)
        end
        for _, key in ipairs(selected) do
            Toggles[key]:SetValue(true)
        end
    end
})

Example2:AddDropdown('Examplehj', {
    Text = 'Select the options to disable.',
    Values = pool,
    Default = {},
    Multi = true,
    Callback = function(selected)
        for _, key in ipairs(pool) do
            Toggles[key]:SetDisabled(false)
        end
        for _, key in ipairs(selected) do
            Toggles[key]:SetDisabled(true)
        end
    end
})

for _, key in ipairs(pool) do
    Example2:AddToggle(key, {
        Text = 'Feature',
        Default = false
    })
end

local Button53 
Button53 = Example2:AddButton({
    Text = tostring(math.random(100, 200)),
    Func = function()
        Button53:SetText(tostring(math.random(0, 200)))
    end
})

Example2:AddDivider()

Example2:AddLabel("Example"):AddKeyPicker('ExampleofKey', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'KeyPicker example'
})

Example2:AddInput('UsernameInput', {
    Text = 'Set',
    Default = 'E',
    MaxLength = 1,
    Finished = true,
    Placeholder = 'Enter Value',
    Callback = function(value)
        if #value ~= 1 then return end
        Options.ExampleofKey:SetValue({value:upper(), 'Toggle'})
    end
})

-- ==================== SETTINGS TAB ====================

local UIGroup = Tabs.Settings:AddLeftGroupbox('UI Configuration')

Library.KeybindFrame.Visible = true

UIGroup:AddToggle('ShowKeybinds', {
    Text = 'Show Keybind Frame',
    Default = true,
    Tooltip = 'Display active keybinds panel',
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end
})

UIGroup:AddToggle('ShowToolTip', {
    Text = 'Show Tooltip',
    Default = true,
    Callback = function(value)
        Library.ShowTooltip = value
    end
})

UIGroup:AddToggle('ShowWatermark', {
    Text = 'Show Watermark',
    Default = true,
    Tooltip = 'Display information watermark',
    Callback = function(value)
        Library:SetWatermarkVisibility(value)
    end
})

UIGroup:AddToggle('CustomCursor', {
    Text = 'Custom Cursor',
    Default = true,
    Tooltip = 'Use custom cursor design',
    Callback = function(value)
        Library.ShowCustomCursor = value
    end
})

UIGroup:AddSlider('CursorSize', {
    Text = 'Custom Cursor Size',
    Default = 15,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Compact = true,
    Callback = function(value)
        Library.CursorSize = value
    end
})

UIGroup:AddInput('CursorImage', {
    Text = 'Custom Cursor Image ID',
    Default = Library.CursorImage,
    Placeholder = 'Enter ID here...',
    Callback = function(value)
        Library.CursorImage = value
    end
})

UIGroup:AddLabel('Menu Toggle Keybind:'):AddKeyPicker('ToggleUI', {
    Mode = 'Toggle',
    Default = 'Q',
    InMenu = false,
    Callback = function()
        Library:Toggle()
    end
})

UIGroup:AddLabel('Menu CantDrag Keybind:'):AddKeyPicker('ToggleLock', {
    Mode = 'Toggle',
    Default = 'L',
    InMenu = false,
    Callback = function()
        Library:ToggleLock()
    end
})

-- Setup Theme and Save Managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})

ThemeManager:SetFolder('LinoriaLib')
SaveManager:SetFolder('LinoriaLib/configs')

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- Watermark setup
Library:SetWatermarkVisibility(true)
local RunService = game:GetService('RunService')
local Stats = game:GetService('Stats')
local fps = 0
local fpsCount = 0

RunService.RenderStepped:Connect(function(dt)
    fpsCount += 1
end)

task.spawn(function()
    while true do
        fps = fpsCount
        fpsCount = 0
        local ping = math.floor(Stats.Network.ServerStatsItem['Data Ping']:GetValue())
        Library:SetWatermark('LinoriaLib | FPS: ' .. fps .. ' | Ping: ' .. ping .. 'ms')
        task.wait(1)
    end
end)

-- Unload callback
Library:OnUnload(function()
    Library:Notify('LinoriaLib Unload')
end)

-- Load autoload config
SaveManager:LoadAutoloadConfig()

-- Initial notification
Library:Notify('LinoriaLib system initialized', 4)
