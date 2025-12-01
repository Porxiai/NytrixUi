# LinoriaLib - Complete Documentation
*A modern, lightweight, and optimized UI library for Roblox*

![Interface](https://raw.githubusercontent.com/DH-SOARESE/LinoriaLib/main/assets/Interface.jpg)

### 🚀 Features
- ✨ Lightweight and Optimized
- 🎨 Modern Interface
- 📱 Mobile-Friendly
- 🔧 Easy to Use
- 💾 Save System
- 🎭 Customizable Themes

## 📥 Installation

### 🚀 Quick Install (Direct Loading)
Load the library directly from GitHub without saving files locally:

```lua
-- Repository base URL
local repo = 'https://raw.githubusercontent.com/DH-SOARESE/LinoriaLib/main/'

-- Load core library and addons
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
```

**Pros:** Fast and simple  
**Cons:** Requires internet connection on every script execution

---

### 💾 Local Install (Persistent Files)
Download and cache the library files locally for offline use:

```lua
local LinoriaLib = "https://raw.githubusercontent.com/DH-SOARESE/LinoriaLib/main/"
local folderName = "Linoria Library"
local basePath = folderName
local addonsPath = basePath .. "/addons"

-- Create necessary folders
if not isfolder(basePath) then makefolder(basePath) end
if not isfolder(addonsPath) then makefolder(addonsPath) end

-- Helper function to download and save files
local function ensureFile(filePath, url)
    if not isfile(filePath) then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result then
            writefile(filePath, result)
            print("✓ Downloaded: " .. filePath)
        else
            warn("✗ Failed to download " .. filePath .. ": " .. tostring(result))
        end
    end
end

-- Download library files
ensureFile(basePath .. "/Library.lua", LinoriaLib .. "Library.lua")
ensureFile(addonsPath .. "/SaveManager.lua", LinoriaLib .. "addons/SaveManager.lua")
ensureFile(addonsPath .. "/ThemeManager.lua", LinoriaLib .. "addons/ThemeManager.lua")

-- Load from local files
local Library = loadfile(basePath .. "/Library.lua")()
local SaveManager = loadfile(addonsPath .. "/SaveManager.lua")()
local ThemeManager = loadfile(addonsPath .. "/ThemeManager.lua")()

-- Initialize managers
SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
```

**Pros:** Works offline after first download, faster load times  
**Cons:** Requires more initial setup
```
### Key improvements:

1. **Descriptive titles** - "Quick Install" vs "Local Install" makes the difference clear
2. **Clear explanations** - Added descriptions of what each method does
3. **Pros and Cons** - Helps users choose the best method
4. **Better comments** - Clearer and more informative
5. **Visual feedback** - Added success/error prints in the download method
6. **Visual organization** - Horizontal separator between methods
7. **Appropriate emojis** - 🚀 for quick, 💾 for persistent
8. **Manager initialization** - Included the missing setup in the second method
```

### 1. Creating a Window
```lua
-- Global library settings
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = 'Left'

-- Creating the main window
local Window = Library:CreateWindow({
    Title = 'LinoriaLib',
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})
```

### 2. Creating Tabs
```lua
local Tabs = {
    Main = Window:AddTab('Main'),
    Settings = Window:AddTab('Settings')
}
```

## Available Components

### Groupboxes
```lua
local Left  = Tabs.Main:AddLeftGroupbox('Left') -- Optional name, side position can be {Left, Center, Right}
local Right = Tabs.Main:AddRightGroupbox('Right')
```

### 🎨 Tabboxes
```lua
local SubTabs = Tabs.Main:AddRightTabbox()
local Tab1 = SubTabs:AddTab('Sub tab1')
local Tab2 = SubTabs:AddTab('Sub tab2')
```

## Interface Elements

### Toggle
```lua
Groupbox:AddToggle('BasicToggle', {
    Text = 'Enable Feature',
    Default = false,
    Tooltip = 'Toggles the feature on or off',
    Risky = false,
    Disabled = false,
    DisabledTooltip = false,
    Callback = function(Value)
        print('Toggle:', Value)
    end
})
```

#### Toggle Controls
```lua
Toggles.BasicToggle:SetText('example') -- string 
Toggles.BasicToggle:SetValue(not Toggles.BasicToggle.Value) -- boolean 
Toggles.BasicToggle:SetVisible(not Toggles.BasicToggle.Visible) -- boolean 
Toggles.BasicToggle:OnChanged(function(value) -- Callback 
    print('New value changed callback:', value)
end)
```

#### Toggle with KeyPicker and ColorPicker
```lua
Groupbox:AddToggle('ExampleToggle', {
    Text = 'Enable Feature',
    Default = false,
    Callback = function(Value)
        print('Feature:', Value and 'Enabled' or 'Disabled')
    end
}):AddKeyPicker('FeatureKeyPicker', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'Feature',
    SyncToggleState = true,
    Callback = function(Toggled)
        print('Feature KeyPicker Toggle:', Toggled)
    end
}):AddColorPicker('FeatureColor', {
    Title = 'Feature Color',
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0.1,
    Callback = function(Color, Alpha)
        local r = math.floor(Color.R * 255)
        local g = math.floor(Color.G * 255)
        local b = math.floor(Color.B * 255)
        print(string.format('Color: (%d, %d, %d)  Alpha: %.2f', r, g, b, Alpha))
    end
})
```

#### Toggle Properties

| Property        | Type     | Default              | Description |
|-----------------|----------|----------------------|-------------|
| Text            | string   | Required             | Label displayed next to the toggle. |
| Default         | boolean  | false                | Initial state of the toggle (on/off). |
| Value           | boolean  | false                | Current state of the toggle (on/off). |
| Visible         | boolean  | true                 | Whether the toggle is visible. |
| Disabled        | boolean  | false                | If true, the toggle cannot be interacted with. |
| Risky           | boolean  | false                | Marks the toggle as "risky" (red text). |
| Callback        | function | function(Value) end  | Function called whenever the toggle changes. |
| Addons          | table    | {}                   | List of attached UI elements that depend on the toggle (e.g., key pickers). |
| Tooltip         | string   | nil                  | Tooltip text shown on hover. |
| DisabledTooltip | string   | nil                  | Tooltip text shown when disabled. |
| OriginalText    | string   | —                    | Stores the initial label text (internal). |
| OriginalValue   | boolean  | —                    | Stores the initial toggle state (internal). |

### Slider
```lua
Groupbox:AddSlider('ScreenBrightness', {
    Text = 'Screen Brightness', -- Optional Text
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Disabled = false,
    Tooltip = 'Adjusts screen brightness from 0% to 100%.',
    Callback = function(Value)
        print('Brightness:', Value)
    end
})

Groupbox:AddSlider('GeneralVolume', {
    Text = 'Volume',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Prefix = '::',
    Suffix = '::',
    Tooltip = 'Adjusts general volume (0 to 1).',
    Callback = function(Value)
        print('Volume:', Value)
    end
})
```

#### Slider Controls
```lua
Options.ScreenBrightness:SetText('example') -- string 
Options.ScreenBrightness:SetMin(0.1) -- number 
Options.ScreenBrightness:SetMax(2.0) -- number 
Options.ScreenBrightness:SetValue(1.2) -- number 
Options.ScreenBrightness:SetPrefix('to left') -- string 
Options.ScreenBrightness:SetSuffix('to right') -- string 
Options.ScreenBrightness:SetDisabled(false) -- boolean 
Options.ScreenBrightness:SetVisible(true) -- boolean 
Options.ScreenBrightness:OnChanged(function(value) -- Callback 
    print('New value changed callback:', value)
end)
```

#### Slider Properties

| Property         | Type     | Default              | Description |
|------------------|----------|----------------------|-------------|
| Text             | string   | ""                   | The text displayed next to the slider. |
| Default          | number   | Required             | Initial value of the slider (clamped between Min and Max). |
| Value            | number   | Required (Default)   | Current value of the slider. |
| Min              | number   | Required             | Minimum value of the slider. |
| Max              | number   | Required             | Maximum value of the slider. |
| Rounding         | number   | Required             | Number of decimal places to round the value. |
| Visible          | boolean  | true                 | Whether the slider is visible. |
| Disabled         | boolean  | false                | Whether the slider is disabled. |
| Prefix           | string   | ""                   | Text displayed before the value. |
| Suffix           | string   | ""                   | Text displayed after the value. |
| ValueText        | table    | {}                   | Custom text displayed when the slider is at the value set in table. |
| Callback         | function | function(Value) end  | Function called when the slider value changes. |
| Compact          | boolean  | false                | If true, displays text and value in a compact format. |
| HideMax          | boolean  | false                | If true, hides the maximum value display. |
| Tooltip          | string   | nil                  | Text displayed on hover. |
| DisabledTooltip  | string   | nil                  | Tooltip displayed when slider is disabled. |
| MaxSize          | number   | 232                  | Maximum width of the slider (internal). |
| OriginalText     | string   | —                    | Stores the initial text (internal). |
| OriginalValue    | number   | —                    | Stores the initial value (internal). |

### Dropdown
```lua
Groupbox:AddDropdown('GameMode', {
    Text = 'Select Game Mode',
    Values = {'Easy', 'Medium', 'Hard'},
    Default = 'Medium',
    Multi = false,
    AllowNull = false,
    Tooltip = 'Choose the difficulty level.',
    Callback = function(Value)
        print('Selected mode:', Value)
    end
})

Groupbox:AddDropdown('PlayerSelect', {
    Text = 'Select Player',
    SpecialType = 'Player',
    ExcludeLocalPlayer = true,
    Multi = true,
    Tooltip = 'Select one or more players (excludes self).',
    Callback = function(Values)
        print('Selected players:', table.concat(Values, ', '))
    end
})
```

#### Dropdown Controls
```lua
Options.GameMode:SetText('Example') -- string 
Options.GameMode:AddValues({'New Option 1', 'New Option 2'}) -- table
Options.GameMode:SetValue({}) -- table
Options.GameMode:SetDisabledValues({'Easy'}) -- table
Options.GameMode:AddDisabledValues({'Hard'}) -- table
Options.GameMode:SetVisible(true) -- boolean 
Options.GameMode:SetDisabled(false) -- boolean 
Options.GameMode:OnChanged(function(value) -- Callback 
    print('New value changed callback:', value)
end)

```

#### Dropdown Properties

| Property                | Type     | Default              | Description |
|-------------------------|----------|----------------------|-------------|
| Text                    | string   | ""                   | The text displayed on the dropdown. |
| Values                  | table    | nil                  | List of options for the dropdown. Ignored if SpecialType is 'Player' or 'Team'. |
| Default                 | string/number/table | nil | Initial selected value. For multi-select, use a table or dictionary {Value = true}. |
| Value                   | any/table| nil                  | Current selected value(s). Empty table {} for Multi/DictMulti, nil otherwise. |
| Multi                   | boolean  | false                | Allows multiple selections if true. |
| DictMulti               | boolean  | false                | Allows using a dictionary with boolean values for multi-select (new format). |
| SpecialType             | string   | nil                  | 'Player' or 'Team' to automatically populate options. |
| ExcludeLocalPlayer      | boolean  | false                | Used with SpecialType = 'Player' to exclude the local player. |
| ReturnInstanceInstead   | boolean  | false                | Returns the Instance of the player or team instead of the name. |
| Searchable              | boolean  | false                | Allows searching within the dropdown. |
| Disabled                | boolean  | false                | Disables the dropdown. |
| Visible                 | boolean  | true                 | Whether the dropdown is visible. |
| AllowNull               | boolean  | false                | Allows no option to be selected. |
| DisabledValues          | table    | {}                   | List of values that cannot be selected. |
| Tooltip                 | string   | nil                  | Tooltip text shown when hovering over the dropdown. |
| DisabledTooltip         | string   | nil                  | Tooltip text shown when the dropdown is disabled. |
| MaxVisibleDropdownItems | number   | 8                    | Maximum number of items visible when the dropdown is open. |
| Callback                | function | function(Value) end  | Function called when selection changes. |
| OriginalText            | string   | —                    | Stores the initial text (internal). |
| OriginalValue           | any      | —                    | Stores the initial value (internal). |

### ⌨️ Input
#### Basic Input
```lua
Groupbox:AddInput('UsernameInput', {
    Text = 'Player Name',
    Default = 'Player123',
    Placeholder = 'Enter your username...',
    Callback = function(value)
        print('Name updated to:', value)
    end
})
```

#### Input on Enter
```lua
Groupbox:AddInput('CommandInput', {
    Text = 'Execute Command',
    Placeholder = 'Enter a command...',
    Finished = true,
    Callback = function(cmd)
        print('Executing command:', cmd)
    end
})
```

#### Input with Character Limit
```lua
Groupbox:AddInput('CodeInput', {
    Text = 'Code',
    Placeholder = 'ABC123',
    MaxLength = 6,
    AllowEmpty = false,
    EmptyReset = 'ABC123',
    Callback = function(value)
        print('New code:', value)
    end
})
```

#### Disabled Input (Read-Only)
```lua
Groupbox:AddInput('LockedInput', {
    Text = 'Read-Only',
    Default = 'Locked',
    Disabled = true,
    Tooltip = 'This field cannot be edited',
})
```

#### Input Controls
```lua
Options.UsernameInput:SetValue('Example') -- string 
Options.UsernameInput:SetDisabled(true) -- boolean 
Options.UsernameInput:SetVisible(false) -- boolean 
Options.UsernameInput:SetDisabled(false) -- boolean 
Options.UsernameInput:SetVisible(false) -- boolean 
Options.UsernameInput:SetValue('not') -- string 
Options.UsernameInput:OnChanged(function(v) -- Callback 
    print('Value changed:', v)
end)
```

#### Input Properties
| Property         | Type     | Default              | Description |
|------------------|----------|----------------------|-------------|
| Text             | string   | Required             | Label text displayed above the input box. |
| Default          | string   | ""                   | Initial value of the input box. |
| Value            | string   | "" or Default        | Current value of the input box. |
| Numeric          | boolean  | false                | If true, only allows numeric input. |
| Finished         | boolean  | false                | If true, triggers callback only after focus is lost or enter is pressed. |
| Visible          | boolean  | true                 | Whether the input box is visible. |
| Disabled         | boolean  | false                | Whether the input box is disabled. |
| AllowEmpty       | boolean  | true                 | If false, empty input resets to EmptyReset. |
| EmptyReset       | string   | "---"                | Value used when input is empty and AllowEmpty is false. |
| Placeholder      | string   | ""                   | Placeholder text shown when input is empty. |
| ClearTextOnFocus | boolean  | true                 | Clears the input text when focused (if not disabled). |
| MaxLength        | number   | nil                  | Maximum number of characters allowed. |
| Tooltip          | string   | nil                  | Tooltip text shown on hover. |
| DisabledTooltip  | string   | nil                  | Tooltip text shown when input is disabled. |
| Callback         | function | function(Value) end  | Function called when input value changes. |
| Type             | string   | "Input"              | Component type identifier (internal). |
| OriginalValue    | string   | —                    | Stores the initial value (internal). |

### 🎨 ColorPicker
```lua
Toggle:AddColorPicker('ColorPicker', {
    Title = 'Highlight Color',
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0.1,
    Callback = function(Color, Alpha)
        local r = math.floor(Color.R * 255)
        local g = math.floor(Color.G * 255)
        local b = math.floor(Color.B * 255)
        print(string.format('Color: (%d, %d, %d)  Alpha: %.2f', r, g, b, Alpha))
    end
})
```

#### ColorPicker Controls 

```lua
ColorPicker:SetValueRGB(Color3.fromRGB(255, 0, 0), 0.5) -- Color3 and number 
ColorPicker:OnChanged(function(v, i) -- Callback 
    print("Cor:", v, "Alpha:", i)
end)

```

#### ColorPicker Properties

| Property     | Type     | Default                     | Description |
|--------------|----------|-----------------------------|-------------|
| Title        | string   | Required                    | The title of the color picker. |
| Value        | Color3   | Required (Default)          | Current color value. |
| Transparency | number   | nil                         | Initial transparency value (0-1). |
| Visible      | boolean  | true                        | Whether the color picker is visible. |
| Disabled     | boolean  | false                       | Whether the color picker is disabled. |
| Tooltip      | string   | nil                         | Tooltip text shown on hover. |
| DisabledTooltip | string | nil                       | Tooltip text shown when disabled. |
| Callback     | function | function(Color, Transparency) end | Called when color or transparency changes. |

###  KeyPicker
```lua
Toggle:AddKeyPicker('KeyPicker', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'Enable',
    Callback = function(isActive)
        
    end
})

Toggle:AddKeyPicker('FeatureKey', {
    Default = 'E',
    Mode = 'Toggle',
    Text = 'Primary Feature',
    SyncToggleState = true,
    Callback = function(Toggled)
        print('KeyPicker Toggle:', Toggled)
    end
})

Label:AddKeyPicker('KeyFeatureKEY', {
    Default = 'N',
    Mode = 'Toggle',
    Text = 'M',
    SyncToggleState = true,
    Callback = function(Toggled)
        print('KEYKeyPicker Toggle:', Toggled)
    end
})
```

#### KeyPicker Controls

```lua
KeyPicker:SetValue({"E", "Hold"}) -- table 
KeyPicker:SetModePickerVisibility(true) -- boolean 
KeyPicker:OnChanged(function(newKey) -- Callback 
    print("New tecla:", newKey)
end)

```

#### KeyPicker Properties

| Property             | Type                | Default             | Description |
|----------------------|---------------------|---------------------|-----------|
| Default            | string or nil   | **Required**        | Default key (e.g. "E", "MB1", "None"). Use nil or "None" for unbound. |
| Text               | string            | ""                | Text shown in the keybind list (e.g. "Fly"). |
| Mode               | string            | "Toggle"          | Initial mode. Possible values: "Always", "Toggle", "Hold", **"Press"**. |
| Modes              | table             | {"Always","Toggle","Hold","Press"} | List of modes that appear in the selector (you can remove any you don’t want). |
| Callback           | function(toggled) | nil               | Called every time the state changes (toggle/press/hold). Receives true when active, false when inactive. |
| ChangedCallback    | function(newKey)  | nil               | Called when the bound key is changed (bind/unbind). Receives the new Enum.UserInputType or nil. |
| SyncToggleState    | boolean           | false             | If true, the keybind directly controls its parent toggle’s state (commonly used for toggles with a keybind). Forces "Toggle" mode. |
| NoUI               | boolean           | false             | If true, no visual elements are created (useful for completely hidden keybinds). |
| **InMenu**           | boolean           | true              | **New** – If false, the keybind **will not appear** in the on-screen keybind list (perfect for secret or internal binds). |


### Image
#### Roblox Asset Image
```lua
Groupbox:AddImage('MainLogo', {
    Image = 'rbxassetid://1234567890',
    Height = 150,
    Color = Color3.fromRGB(255, 255, 255),
    RectOffset = Vector2.new(0, 0),
    RectSize = Vector2.new(0, 0),
    ScaleType = Enum.ScaleType.Fit,
    Transparency = 0,
    Visible = true,
    Tooltip = 'Main system logo.'
})
```

#### Lucide Icon
```lua
Groupbox:AddImage('WarningIcon', {
    Image = 'alert-triangle',
    Color = Color3.fromRGB(255, 200, 0),
    Height = 60,
    ScaleType = Enum.ScaleType.Fit,
    Transparency = 0,
    Visible = true,
    Tooltip = 'Yellow warning icon.'
})
```

#### External Image (URL)
```lua
Groupbox:AddImage('PromoBanner', {
    Image = 'https://i.imgur.com/Example.png',
    Height = 180,
    Color = Color3.fromRGB(255, 255, 255),
    ScaleType = Enum.ScaleType.Crop,
    Transparency = 0.1,
    Visible = true,
    Tooltip = 'Example promotional banner.'
})
```

#### Image Controls 

```lua
Options.WarningIcon:SetVisible(true) -- boolean
Options.WarningIcon:SetTransparency(0.5) -- number
Options.WarningIcon:SetScaleType(Enum.ScaleType.Stretch) -- ScaleType
Options.WarningIcon:SetRectSize(Vector2.new(100, 50)) -- Vector2
Options.WarningIcon:SetRectOffset(Vector2.new(0, 0)) -- Vector2
Options.WarningIcon:SetColor(Color3.fromRGB(255, 255, 255)) -- Color3
Options.WarningIcon:SetImage("rbxassetid://1234567890") -- string
Options.WarningIcon:SetHeight(50) -- number

```

#### Image Properties

| Property     | Type             | Default              | Description |
|--------------|------------------|----------------------|-------------|
| Image        | string           | Required             | Image asset ID, Lucide icon name, or URL. |
| Height       | number           | nil                  | Height of the image (width auto-adjusts). |
| Color        | Color3           | Color3.fromRGB(255, 255, 255) | Tint color applied to the image. |
| RectOffset   | Vector2          | Vector2.new(0, 0)    | Offset for slicing the image. |
| RectSize     | Vector2          | Vector2.new(0, 0)    | Size for slicing the image (0 uses full size). |
| ScaleType    | Enum.ScaleType   | Enum.ScaleType.Stretch | How the image scales: Stretch, Fit, Crop, etc. |
| Transparency | number           | 0                    | Transparency level (0-1). |
| Visible      | boolean          | true                 | Whether the image is visible. |
| Tooltip      | string           | nil                  | Tooltip text shown on hover. |


### Video
```lua
Groupbox:AddVideo('MyVideo', {
    Video = 'rbxassetid://Your Image ID',
    Height = 200,
    Looped = true,
    Playing = true,
    Volume = 0.5,
    Visible = true
})
```

#### Video Controls 

```lua
Options.MyVideo:SetVideo('ID') -- string
Options.MyVideo:SetVisible(true) -- boolean
Options.MyVideo:SetPlaying(true) -- boolean
Options.MyVideo:SetLooped(true) -- boolean
Options.MyVideo:SetVolume(5) -- number
Options.MyVideo:SetHeight(250) -- number
```

### Video Properties
| Property    | Type      | Description                                                                 |
|-------------|-----------|-----------------------------------------------------------------------------|
| Video   | string  | Sets the video asset ID in Roblox, in the format rbxassetid://<ID>. Example: 'rbxassetid://123456789'. |
| Height  | number  | Sets the height of the video in the interface, in pixels. Example: 200.   |
| Looped  | boolean | Determines whether the video will loop. Example: true to repeat continuously. |
| Playing | boolean | Sets whether the video starts playing automatically. Example: true to start immediately. |
| Volume  | number  | Controls the video's audio volume (from 0 to 1). Example: 0.5 for half the maximum volume. |
| Visible | boolean | Sets whether the video is visible in the interface. Example: true to display the video. |


###  DependencyBox
```lua
Groupbox:AddToggle('BasicToggle', {
    Text = 'Toggle Example',
    Default = false,
    Tooltip = 'Enables the feature.',
    Callback = function(Value)
        print('Toggled:', Value)
    end
})

local FeatureDepBox = Groupbox:AddDependencyBox()
FeatureDepBox:SetupDependencies({ { Toggles.BasicToggle, true } })

FeatureDepBox:AddSlider('Example', {
    Text = 'Example',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = 'Adjusts feature opacity.',
    Callback = function(Value)
        print('Ex:', Value)
    end
})

FeatureDepBox:AddDropdown('Example', {
    Text = 'Example',
    Values = { 'A', 'B', 'C' },
    Default = 'A',
    Tooltip = 'ABC',
    Callback = function(Value)
        print('Selected:', Value)
    end
})
```
#### DependencyBox Control 

```lua
FeatureDepBox:SetupDependencies({
    {Toggles.BasicToggle, not Toggles.BasicToggle},
})
```

#### DependencyBox Properties

| Property      | Type     | Default              | Description |
|---------------|----------|----------------------|-------------|
| Dependencies | table    | {}                   | Table of dependencies, e.g., { { Toggle, true } }. Visibility depends on these. |
| Visible       | boolean  | true                 | Whether the dependency box and its children are visible (overridden by dependencies). |

###  Button
```lua
local Button1
Button1 = Groupbox:AddButton({
    Text = 'Execute Action',
    Tooltip = 'Click to execute',
    Func = function()
        print('Button pressed!')
        Library:Notify('Action executed successfully!')
    end
})

Groupbox:AddButton({
    Text = 'Special Action',
    DoubleClick = true,
    Func = function()
        Library:Notify('Special action executed!', 3)
    end
})

Groupbox:AddButton({
    Text = 'Unavailable',
    Disabled = true,
    DisabledTooltip = 'This function is unavailable',
    Func = function() end
})
```

#### Button controls

```lua
Button1:SetVisible(true) -- boolean 
Button1:SetText('Example') -- string 
Button1:SetDisabled(true) -- boolean 

```

#### Button Properties

| Property        | Type     | Default              | Description |
|-----------------|----------|----------------------|-------------|
| Text            | string   | Required             | Button text. |
| Tooltip         | string   | nil                  | Tooltip text shown on hover. |
| Func            | function | Required             | Function called when the button is clicked. |
| DoubleClick     | boolean  | false                | If true, requires double-click to activate. |
| Disabled        | boolean  | false                | If true, the button cannot be clicked. |
| DisabledTooltip | string   | nil                  | Tooltip shown when the button is disabled. |
| Visible         | boolean  | true                 | Whether the button is visible. |


###  Labels and Dividers
```lua
local Label = Groupbox:AddLabel('Status: Connected')
Groupbox:AddLabel('Multi-line:\nEverything working!', true)
Groupbox:AddDivider()
Groupbox:AddDivider('Divider with label')
```

#### Label Properties

| Property   | Type    | Default  | Description |
|------------|---------|----------|-------------|
| Text       | string  | Required | Label text (supports \n for new lines). |
| Multiline  | boolean | false    | If true, allows multi-line text wrapping. |
| Visible    | boolean | true     | Whether the label is visible. |
| Tooltip    | string  | nil      | Tooltip text shown on hover. |

#### Label Control
```lua
Label:SetText(Text)    
```

#### Divider Properties

| Property | Type   | Default  | Description |
|----------|--------|----------|-------------|
| Text     | string | nil      | Optional text displayed on the divider. |
| Visible  | boolean| true     | Whether the divider is visible. |

##  Save System and Themes
```lua
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})

ThemeManager:SetFolder('MyScript')
SaveManager:SetFolder('MyScript/Configs')

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()
```

##  Special Features

### Watermark
```lua
Library:SetWatermarkVisibility(true)

local function updateWatermark()
    game:GetService('RunService').Heartbeat:Connect(function()
        local fps = math.floor(1 / game:GetService('RunService').Heartbeat:Wait())
        local ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
        Library:SetWatermark(('LinoriaLib | %d FPS | %d ms'):format(fps, ping))
    end)
end
updateWatermark()
```

### Notifications
```lua
Library:Notify('Success message!')

Library:Notify('Error detected!', 10, 4590657391)

Library:Notify({
    Title = 'ExampleLib',
    Description = 'Example of Description',
    Time = 7,
    SoundId = 6534947243
})

local EXAMPLE = Library:Notify({
    Title = 'ExampleLib',
    Description = 'Example of Description',
    Time = 10
})

local signal = Instance.new('Attachment')

Library:Notify({
    Title = 'Monitor',
    Description = 'To last as long as the object exists.',
    Time = signal
})

```

##  Accessing Values
```lua
print(Toggles.BasicToggle.Value)
print(Options.Speed.Value)
print(Options.GameMode.Value)

Toggles.BasicToggle:SetValue(true)
Options.Speed:SetValue(50)
Options.GameMode:SetValue('Fast')
```

##  Menu Controls
```lua
local MenuControls = Tabs.Settings:AddLeftGroupbox('Menu Controls')

MenuControls:AddToggle('ShowKeybinds', {
    Text = 'Show Keybinds Menu',
    Default = true,
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end
})

MenuControls:AddButton({
    Text = 'Unload Menu',
    Func = function()
        Library:LinoriaUnload()
    end
})

MenuControls:AddButton({
    Text = 'Reset UI',
    Func = function()
        Library:ResetUI()
    end
})
```
## Complete Example  
[Example with all Library options](https://github.com/DH-SOARESE/LinoriaLib/blob/main/Example.lua)
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/DH-SOARESE/LinoriaLib/refs/heads/main/Example.lua'))()
```

## UI library Code 
[UI Library](https://github.com/DH-SOARESE/LinoriaLib/blob/main/Library.lua)

## Original design 
[go to original project](https://github.com/mstudio45/LinoriaLib)

### Playbook Tips
- Organize features in groupboxes for readability.
- Use tooltips to explain each control.
- Implement callbacks for all functionalities.
- Set up the save system to persist configurations.
- Add keybinds for quick access.
- Test on mobile devices for compatibility.
- Use dependency boxes for advanced options.
- Leverage ColorPickers and KeyPickers for customization.

### Performance
LinoriaLib is optimized for maximum performance:
- Efficient Rendering
- Clean Code
- Mobile Optimized
- Fast Loading

*Developed with ❤️ for the Roblox community*
