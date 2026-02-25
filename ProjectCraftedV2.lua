--[[
██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗
██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝
██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║
██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║
██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║
╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝
██████╗██████╗  █████╗ ███████╗████████╗███████╗██████╗
██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██║     ██████╔╝███████║█████╗     ██║   █████╗  ██║  ██║
██║     ██╔══██╗██╔══██║██╔══╝     ██║   ██╔══╝  ██║  ██║
╚██████╗██║  ██║██║  ██║██║        ██║   ███████╗██████╔╝
╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚══════╝╚═════╝
Project Crafted V2 — by your executor
Version: 2.0.0
--]]
-- ============================================================
-- SERVICES
-- ============================================================
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TextService        = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
-- ============================================================
-- FILE SYSTEM / CONFIG
-- ============================================================
local CONFIG_FOLDER  = "ProjectCrafted"
local CONFIGS_FOLDER = CONFIG_FOLDER .. "/configs"
local THEME_FILE     = CONFIGS_FOLDER .. "/theme.txt"
local EXEC_FILE      = CONFIGS_FOLDER .. "/execcount.txt"
local function pcallFS(fn, ...) return pcall(fn, ...) end
pcallFS(function()
if not isfolder(CONFIG_FOLDER)  then makefolder(CONFIG_FOLDER)  end
if not isfolder(CONFIGS_FOLDER) then makefolder(CONFIGS_FOLDER) end
end)
local function safeReadFile(path, default)
local ok, result = pcallFS(function() return readfile(path) end)
return (ok and result) or default
end
local function safeWriteFile(path, content)
pcallFS(function() writefile(path, tostring(content)) end)
end
local execCount = tonumber(safeReadFile(EXEC_FILE, "0")) or 0
execCount = execCount + 1
safeWriteFile(EXEC_FILE, execCount)
local execStartTime    = os.time()
local currentThemeName = safeReadFile(THEME_FILE, "Original"):gsub("%s+", "")
-- ============================================================
-- THEME DEFINITIONS
-- ============================================================
local THEMES = {
Original = {
Primary    = Color3.fromRGB(0,   180,  80),
Secondary  = Color3.fromRGB(0,   140,  55),
Background = Color3.fromRGB(12,   22,  17),
Panel      = Color3.fromRGB(18,   32,  24),
Element    = Color3.fromRGB(24,   44,  33),
ElementHov = Color3.fromRGB(30,   55,  42),
Text       = Color3.fromRGB(215, 255, 230),
TextDim    = Color3.fromRGB(130, 190, 155),
Accent     = Color3.fromRGB(50,  255, 130),
Grad1      = Color3.fromRGB(0,   210,  95),
Grad2      = Color3.fromRGB(0,   120,  50),
Stroke     = Color3.fromRGB(0,   200, 100),
StrokeDim  = Color3.fromRGB(0,    80,  40),
ToggleOn   = Color3.fromRGB(0,   200,  90),
SliderFill = Color3.fromRGB(0,   200,  90),
Notify     = Color3.fromRGB(0,   160,  70),
},
Sky = {
Primary    = Color3.fromRGB(40,  160, 245),
Secondary  = Color3.fromRGB(25,  120, 210),
Background = Color3.fromRGB(10,   18,  32),
Panel      = Color3.fromRGB(15,   26,  48),
Element    = Color3.fromRGB(20,   36,  65),
ElementHov = Color3.fromRGB(28,   48,  82),
Text       = Color3.fromRGB(215, 235, 255),
TextDim    = Color3.fromRGB(130, 170, 220),
Accent     = Color3.fromRGB(100, 210, 255),
Grad1      = Color3.fromRGB(70,  190, 255),
Grad2      = Color3.fromRGB(25,  100, 210),
Stroke     = Color3.fromRGB(70,  190, 255),
StrokeDim  = Color3.fromRGB(20,   70, 140),
ToggleOn   = Color3.fromRGB(40,  170, 255),
SliderFill = Color3.fromRGB(40,  170, 255),
Notify     = Color3.fromRGB(30,  140, 220),
},
Lava = {
Primary    = Color3.fromRGB(235,  85,  20),
Secondary  = Color3.fromRGB(200,  60,  10),
Background = Color3.fromRGB(22,    8,   4),
Panel      = Color3.fromRGB(38,   14,   7),
Element    = Color3.fromRGB(55,   20,   9),
ElementHov = Color3.fromRGB(72,   28,  12),
Text       = Color3.fromRGB(255, 230, 210),
TextDim    = Color3.fromRGB(200, 155, 120),
Accent     = Color3.fromRGB(255, 160,  50),
Grad1      = Color3.fromRGB(255, 110,  30),
Grad2      = Color3.fromRGB(180,  40,  10),
Stroke     = Color3.fromRGB(255, 130,  40),
StrokeDim  = Color3.fromRGB(120,  35,  10),
ToggleOn   = Color3.fromRGB(240,  90,  25),
SliderFill = Color3.fromRGB(240,  90,  25),
Notify     = Color3.fromRGB(210,  75,  15),
},
}
local T = THEMES[currentThemeName] or THEMES["Original"]
-- ============================================================
-- CLEANUP OLD INSTANCES
-- ============================================================
for _, name in ipairs({"ProjectCraftedV2", "PC_ToggleGui", "PC_NotifGui"}) do
local old = CoreGui:FindFirstChild(name)
if old then old:Destroy() end
end
-- ============================================================
-- SCREEN GUIS
-- ============================================================
local MainGui = Instance.new("ScreenGui")
MainGui.Name           = "ProjectCraftedV2"
MainGui.ResetOnSpawn   = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.IgnoreGuiInset = true
MainGui.DisplayOrder   = 10
MainGui.Parent         = CoreGui
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name           = "PC_ToggleGui"
ToggleGui.ResetOnSpawn   = false
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.IgnoreGuiInset = true
ToggleGui.DisplayOrder   = 5
ToggleGui.Parent         = CoreGui
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name           = "PC_NotifGui"
NotifGui.ResetOnSpawn   = false
NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifGui.IgnoreGuiInset = true
NotifGui.DisplayOrder   = 15
NotifGui.Parent         = CoreGui
-- ============================================================
-- UI UTILITY FUNCTIONS
-- ============================================================
local function New(class, props, parent)
local i = Instance.new(class)
for k, v in pairs(props) do i[k] = v end
if parent then i.Parent = parent end
return i
end
local function Corner(parent, r)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, r or 8)
c.Parent = parent
return c
end
local function Stroke(parent, col, thick, mode)
local s = Instance.new("UIStroke")
s.Color           = col or T.Stroke
s.Thickness       = thick or 1.5
s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
s.Parent          = parent
return s
end
local function Gradient(parent, c0, c1, rot)
local g = Instance.new("UIGradient")
g.Color    = ColorSequence.new(c0 or T.Grad1, c1 or T.Grad2)
g.Rotation = rot or 90
g.Parent   = parent
return g
end
local function ListLayout(parent, dir, pad, ha, va)
local l = Instance.new("UIListLayout")
l.FillDirection       = dir or Enum.FillDirection.Vertical
l.SortOrder           = Enum.SortOrder.LayoutOrder
l.Padding             = UDim.new(0, pad or 6)
l.HorizontalAlignment = ha or Enum.HorizontalAlignment.Left
l.VerticalAlignment   = va or Enum.VerticalAlignment.Top
l.Parent = parent
return l
end
local function Padding(parent, t, b, l, r)
local p = Instance.new("UIPadding")
p.PaddingTop    = UDim.new(0, t or 8)
p.PaddingBottom = UDim.new(0, b or 8)
p.PaddingLeft   = UDim.new(0, l or 10)
p.PaddingRight  = UDim.new(0, r or 10)
p.Parent = parent
return p
end
local function Tween(obj, info, props)
return TweenService:Create(obj, info, props)
end
local FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local MED    = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SPRING = TweenInfo.new(0.35, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
-- ============================================================
-- LAYOUT CONSTANTS  (drives tab/content positioning)
-- ============================================================
local TITLEBAR_H = 44
local TABBAR_Y   = TITLEBAR_H + 4
local TABBAR_H   = 36
local CONTENT_Y  = TABBAR_Y + TABBAR_H + 4   -- = 88
-- ============================================================
-- SCROLLING FRAME FACTORY
-- ============================================================
local function MakeScroll(parent)
local sf = New("ScrollingFrame", {
Size                 = UDim2.new(1, 0, 1, 0),
BackgroundTransparency = 1,
BorderSizePixel      = 0,
ScrollBarThickness   = 3,
ScrollBarImageColor3 = T.Stroke,
CanvasSize           = UDim2.new(0, 0, 0, 0),
AutomaticCanvasSize  = Enum.AutomaticSize.Y,
ScrollingDirection   = Enum.ScrollingDirection.Y,
ElasticBehavior      = Enum.ElasticBehavior.Always,
ClipsDescendants     = true,
}, parent)
ListLayout(sf, nil, 8)
Padding(sf, 10, 14, 10, 10)
return sf
end
-- ============================================================
-- CARD FACTORY
-- ============================================================
local function MakeCard(parent, order)
local card = New("Frame", {
Name             = "Card",
Size             = UDim2.new(1, 0, 0, 0),
AutomaticSize    = Enum.AutomaticSize.Y,
BackgroundColor3 = T.Panel,
BorderSizePixel  = 0,
LayoutOrder      = order or 1,
ClipsDescendants = false,
}, parent)
Corner(card, 10)
Stroke(card, T.StrokeDim, 1)
Padding(card, 10, 10, 12, 12)
ListLayout(card, nil, 7)
return card
end
-- ============================================================
-- SECTION TITLE FACTORY
-- ============================================================
local function SectionLabel(parent, text, order)
return New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 20),
BackgroundTransparency = 1,
Text                 = text,
TextColor3           = T.Accent,
TextSize             = 12,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = order or 1,
}, parent)
end
-- ============================================================
-- INFO ROW FACTORY
-- ============================================================
local function InfoRow(parent, key, val, order)
local row = New("Frame", {
Size                 = UDim2.new(1, 0, 0, 22),
BackgroundTransparency = 1,
LayoutOrder          = order,
}, parent)
New("TextLabel", {
Size                 = UDim2.new(0.42, 0, 1, 0),
BackgroundTransparency = 1,
Text                 = key,
TextColor3           = T.TextDim,
TextSize             = 11,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Left,
}, row)
local valLbl = New("TextLabel", {
Name                 = "Val",
Size                 = UDim2.new(0.58, 0, 1, 0),
Position             = UDim2.new(0.42, 0, 0, 0),
BackgroundTransparency = 1,
Text                 = tostring(val),
TextColor3           = T.Text,
TextSize             = 11,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
TextTruncate         = Enum.TextTruncate.AtEnd,
}, row)
return valLbl
end
-- ============================================================
-- DIVIDER FACTORY
-- ============================================================
local function Divider(parent, order)
return New("Frame", {
Size             = UDim2.new(1, 0, 0, 1),
BackgroundColor3 = T.StrokeDim,
BorderSizePixel  = 0,
LayoutOrder      = order,
}, parent)
end
-- ============================================================
-- TOGGLE FACTORY
-- ============================================================
local function MakeToggle(parent, label, order, onChanged)
local togState = false
local row = New("Frame", {
    Name             = "Toggle_" .. label,
    Size             = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = T.Element,
    BorderSizePixel  = 0,
    LayoutOrder      = order,
    ClipsDescendants = false,
}, parent)
Corner(row, 7)
Stroke(row, T.StrokeDim, 1)
Padding(row, 0, 0, 10, 10)

New("TextLabel", {
    Size                 = UDim2.new(1, -56, 1, 0),
    BackgroundTransparency = 1,
    Text                 = label,
    TextColor3           = T.Text,
    TextSize             = 12,
    Font                 = Enum.Font.Gotham,
    TextXAlignment       = Enum.TextXAlignment.Left,
}, row)

local track = New("Frame", {
    Name             = "Track",
    Size             = UDim2.new(0, 44, 0, 24),
    Position         = UDim2.new(1, -44, 0.5, -12),
    BackgroundColor3 = T.Element,
    BorderSizePixel  = 0,
}, row)
Corner(track, 12)
Stroke(track, T.StrokeDim, 1)

local knob = New("Frame", {
    Name             = "Knob",
    Size             = UDim2.new(0, 18, 0, 18),
    Position         = UDim2.new(0, 3, 0.5, -9),
    BackgroundColor3 = Color3.fromRGB(180, 180, 190),
    BorderSizePixel  = 0,
    ZIndex           = 2,
}, track)
Corner(knob, 9)

local hitBtn = New("TextButton", {
    Size                 = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                 = "",
    ZIndex               = 5,
}, row)

local function setState(s, noCallback)
    togState = s
    if s then
        Tween(track, FAST, {BackgroundColor3 = T.ToggleOn}):Play()
        Tween(knob,  FAST, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
    else
        Tween(track, FAST, {BackgroundColor3 = T.Element}):Play()
        Tween(knob,  FAST, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(180,180,190)}):Play()
    end
    if not noCallback and onChanged then onChanged(s) end
end

hitBtn.MouseButton1Click:Connect(function() setState(not togState) end)
return row, function() return togState end, setState
end
-- ============================================================
-- SLIDER FACTORY  (fixed — fully absolute, no nested layouts)
-- ============================================================
local function MakeSlider(parent, label, order, minV, maxV, defaultV, onChanged)
local curVal = math.clamp(defaultV or minV, minV, maxV)
local wrap = New("Frame", {
    Name             = "Slider_" .. label,
    Size             = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = T.Element,
    BorderSizePixel  = 0,
    LayoutOrder      = order,
    ClipsDescendants = true,
}, parent)
Corner(wrap, 7)
Stroke(wrap, T.StrokeDim, 1)

-- Label top-left
New("TextLabel", {
    Size                 = UDim2.new(0.6, 0, 0, 22),
    Position             = UDim2.new(0, 10, 0, 6),
    BackgroundTransparency = 1,
    Text                 = label,
    TextColor3           = T.TextDim,
    TextSize             = 11,
    Font                 = Enum.Font.Gotham,
    TextXAlignment       = Enum.TextXAlignment.Left,
}, wrap)

-- Value label top-right
local valLbl = New("TextLabel", {
    Size                 = UDim2.new(0.38, 0, 0, 22),
    Position             = UDim2.new(0.62, 0, 0, 6),
    BackgroundTransparency = 1,
    Text                 = tostring(curVal),
    TextColor3           = T.Accent,
    TextSize             = 11,
    Font                 = Enum.Font.GothamBold,
    TextXAlignment       = Enum.TextXAlignment.Right,
}, wrap)

-- Track background
local track = New("Frame", {
    Size             = UDim2.new(1, -20, 0, 6),
    Position         = UDim2.new(0, 10, 0, 38),
    BackgroundColor3 = T.Background,
    BorderSizePixel  = 0,
    ClipsDescendants = false,
}, wrap)
Corner(track, 3)
Stroke(track, T.StrokeDim, 1)

local initPct = math.clamp((curVal - minV) / math.max(maxV - minV, 1), 0, 1)

local fill = New("Frame", {
    Size             = UDim2.new(initPct, 0, 1, 0),
    BackgroundColor3 = T.SliderFill,
    BorderSizePixel  = 0,
    ZIndex           = 1,
}, track)
Corner(fill, 3)

local knob = New("Frame", {
    Size             = UDim2.new(0, 14, 0, 14),
    Position         = UDim2.new(initPct, -7, 0.5, -7),
    BackgroundColor3 = Color3.fromRGB(240, 245, 255),
    BorderSizePixel  = 0,
    ZIndex           = 3,
}, track)
Corner(knob, 7)

-- Large invisible hit area covering the whole slider row area
local hitArea = New("TextButton", {
    Size                 = UDim2.new(1, -20, 0, 32),
    Position             = UDim2.new(0, 10, 0, 26),
    BackgroundTransparency = 1,
    Text                 = "",
    ZIndex               = 10,
}, wrap)

local sliding = false

local function updateFromX(absX)
    local abs  = track.AbsolutePosition.X
    local size = track.AbsoluteSize.X
    if size <= 0 then return end
    local pct = math.clamp((absX - abs) / size, 0, 1)
    curVal = math.floor(minV + pct * (maxV - minV) + 0.5)
    pct    = (curVal - minV) / math.max(maxV - minV, 1)
    fill.Size     = UDim2.new(pct, 0, 1, 0)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    valLbl.Text   = tostring(curVal)
    if onChanged then onChanged(curVal) end
end

hitArea.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateFromX(inp.Position.X)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if sliding and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        updateFromX(inp.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

local function setMax(newMax)
    newMax = math.max(newMax, minV + 1)
    maxV   = newMax
    if curVal > newMax then curVal = newMax end
    local pct = (curVal - minV) / math.max(maxV - minV, 1)
    fill.Size     = UDim2.new(pct, 0, 1, 0)
    knob.Position = UDim2.new(pct, -7, 0.5, -7)
    valLbl.Text   = tostring(curVal)
end

return wrap, function() return curVal end, setMax
end
-- ============================================================
-- MAX INPUT BOX FACTORY
-- ============================================================
local function MakeMaxInput(parent, order, defaultMax, label, onChanged)
local row = New("Frame", {
Size                 = UDim2.new(1, 0, 0, 30),
BackgroundTransparency = 1,
LayoutOrder          = order,
}, parent)
New("TextLabel", {
Size                 = UDim2.new(0.52, 0, 1, 0),
BackgroundTransparency = 1,
Text                 = label or "Max Value:",
TextColor3           = T.TextDim,
TextSize             = 11,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
}, row)
local box = New("TextBox", {
Size             = UDim2.new(0.44, 0, 0.8, 0),
Position         = UDim2.new(0.54, 0, 0.1, 0),
BackgroundColor3 = T.Element,
BorderSizePixel  = 0,
Text             = tostring(defaultMax),
TextColor3       = T.Text,
TextSize         = 11,
Font             = Enum.Font.Gotham,
ClearTextOnFocus = false,
TextXAlignment   = Enum.TextXAlignment.Center,
}, row)
Corner(box, 5)
Stroke(box, T.StrokeDim, 1)
Padding(box, 0, 0, 6, 6)
box.FocusLost:Connect(function()
local n = tonumber(box.Text)
if n and n > 0 then
if onChanged then onChanged(math.floor(n)) end
else
box.Text = tostring(defaultMax)
end
end)
return row
end
-- ============================================================
-- DROPDOWN FACTORY
-- ============================================================
local function MakeDropdown(parent, order, onSelectionChanged)
local selected = {}
local items    = {}
local itemBtns = {}
local wrap = New("Frame", {
    Name                 = "Dropdown",
    Size                 = UDim2.new(1, 0, 0, 0),
    AutomaticSize        = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    LayoutOrder          = order,
}, parent)
ListLayout(wrap, nil, 5)

local searchBox = New("TextBox", {
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = T.Element,
    BorderSizePixel  = 0,
    Text             = "",
    PlaceholderText  = "Search...",
    PlaceholderColor3= T.TextDim,
    TextColor3       = T.Text,
    TextSize         = 12,
    Font             = Enum.Font.Gotham,
    ClearTextOnFocus = false,
    TextXAlignment   = Enum.TextXAlignment.Left,
    LayoutOrder      = 1,
}, wrap)
Corner(searchBox, 6)
Stroke(searchBox, T.StrokeDim, 1)
Padding(searchBox, 0, 0, 8, 8)

local listScroll = New("ScrollingFrame", {
    Name                 = "DropList",
    Size                 = UDim2.new(1, 0, 0, 160),
    BackgroundColor3     = T.Background,
    BorderSizePixel      = 0,
    ScrollBarThickness   = 3,
    ScrollBarImageColor3 = T.Stroke,
    CanvasSize           = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    ScrollingDirection   = Enum.ScrollingDirection.Y,
    LayoutOrder          = 2,
    ClipsDescendants     = true,
}, wrap)
Corner(listScroll, 6)
Stroke(listScroll, T.StrokeDim, 1)
ListLayout(listScroll, nil, 2)
Padding(listScroll, 4, 4, 4, 4)

local function rebuildList(filter)
    for _, c in ipairs(listScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    itemBtns = {}
    local lf       = (filter or ""):lower()
    local filtered = {}
    for _, name in ipairs(items) do
        if lf == "" or name:lower():find(lf, 1, true) then
            table.insert(filtered, name)
        end
    end
    for i, name in ipairs(filtered) do
        local isSel = selected[name] == true
        local btn = New("TextButton", {
            Name             = name,
            Size             = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = isSel and T.Primary or T.Element,
            BorderSizePixel  = 0,
            Text             = name,
            TextColor3       = isSel and Color3.fromRGB(255,255,255) or T.Text,
            TextSize         = 11,
            Font             = Enum.Font.Gotham,
            TextXAlignment   = Enum.TextXAlignment.Left,
            AutoButtonColor  = false,
            LayoutOrder      = i,
            ZIndex           = 2,
        }, listScroll)
        Corner(btn, 4)
        Padding(btn, 0, 0, 8, 8)
        local capName = name
        btn.MouseButton1Click:Connect(function()
            if selected[capName] then
                selected[capName] = nil
                Tween(btn, FAST, {BackgroundColor3 = T.Element, TextColor3 = T.Text}):Play()
            else
                selected[capName] = true
                Tween(btn, FAST, {BackgroundColor3 = T.Primary, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            end
            if onSelectionChanged then onSelectionChanged(selected) end
        end)
        itemBtns[name] = btn
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildList(searchBox.Text)
end)

local function setItems(newItems)
    items = newItems
    rebuildList(searchBox.Text)
end

local function getSelected()
    local result = {}
    for k in pairs(selected) do table.insert(result, k) end
    return result
end

local function removeSelected(name)
    selected[name] = nil
    if itemBtns[name] then
        Tween(itemBtns[name], FAST, {BackgroundColor3 = T.Element, TextColor3 = T.Text}):Play()
    end
    if onSelectionChanged then onSelectionChanged(selected) end
end

return wrap, getSelected, setItems, removeSelected
end
-- ============================================================
-- SELECTED CHIPS DISPLAY
-- ============================================================
local function MakeSelectedDisplay(parent, order, onRemove)
local container = New("Frame", {
Name                 = "SelectedChips",
Size                 = UDim2.new(1, 0, 0, 0),
AutomaticSize        = Enum.AutomaticSize.Y,
BackgroundTransparency = 1,
LayoutOrder          = order,
}, parent)
ListLayout(container, nil, 4)
local function rebuild(selTable)
    for _, c in ipairs(container:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    local names = {}
    for k in pairs(selTable) do table.insert(names, k) end
    table.sort(names)
    for i, name in ipairs(names) do
        local chip = New("Frame", {
            Name             = "Chip_" .. name,
            Size             = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = T.Element,
            BorderSizePixel  = 0,
            LayoutOrder      = i,
        }, container)
        Corner(chip, 6)
        Stroke(chip, T.StrokeDim, 1)
        New("TextLabel", {
            Size                 = UDim2.new(1, -34, 1, 0),
            Position             = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text                 = name,
            TextColor3           = T.Text,
            TextSize             = 11,
            Font                 = Enum.Font.Gotham,
            TextXAlignment       = Enum.TextXAlignment.Left,
            TextTruncate         = Enum.TextTruncate.AtEnd,
        }, chip)
        local xBtn = New("TextButton", {
            Size             = UDim2.new(0, 22, 0, 22),
            Position         = UDim2.new(1, -24, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(200, 55, 55),
            BorderSizePixel  = 0,
            Text             = "x",
            TextColor3       = Color3.fromRGB(255,255,255),
            TextSize         = 11,
            Font             = Enum.Font.GothamBold,
            AutoButtonColor  = false,
            ZIndex           = 3,
        }, chip)
        Corner(xBtn, 4)
        local capName = name
        xBtn.MouseButton1Click:Connect(function()
            chip:Destroy()
            if onRemove then onRemove(capName) end
        end)
    end
end

return container, rebuild
end
-- ============================================================
-- NOTIFICATION SYSTEM
-- ============================================================
local notifContainer = New("Frame", {
Name                 = "NotifContainer",
Size                 = UDim2.new(0.38, 0, 1, 0),
Position             = UDim2.new(0.31, 0, 0, 0),
BackgroundTransparency = 1,
AnchorPoint          = Vector2.new(0, 0),
}, NotifGui)
ListLayout(notifContainer, nil, 6, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
Padding(notifContainer, 10, 10, 0, 0)
local function ShowNotification(text, duration)
local frame = New("Frame", {
Name             = "Notif",
Size             = UDim2.new(1, 0, 0, 0),
BackgroundColor3 = T.Notify,
BorderSizePixel  = 0,
ClipsDescendants = true,
}, notifContainer)
Corner(frame, 10)
Stroke(frame, T.Stroke, 1.5)
Gradient(frame, T.Grad1, T.Grad2)
New("TextLabel", {
Size                 = UDim2.new(1, -16, 1, 0),
Position             = UDim2.new(0, 8, 0, 0),
BackgroundTransparency = 1,
Text                 = text,
TextColor3           = Color3.fromRGB(255,255,255),
TextSize             = 12,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Center,
TextWrapped          = true,
RichText             = true,
}, frame)
Tween(frame, SPRING, {Size = UDim2.new(1, 0, 0, 46)}):Play()
task.delay(duration or 3, function()
if not frame or not frame.Parent then return end
Tween(frame, MED, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
task.delay(0.3, function() pcall(function() frame:Destroy() end) end)
end)
end
-- ============================================================
-- MAIN FRAME  (original 420x520 size)
-- ============================================================
local MainFrame = New("Frame", {
Name             = "MainFrame",
Size             = UDim2.new(0, 420, 0, 520),
Position         = UDim2.new(0.5, -210, 0.5, -260),
BackgroundColor3 = T.Background,
BorderSizePixel  = 0,
ClipsDescendants = true,
}, MainGui)
Corner(MainFrame, 14)
Stroke(MainFrame, T.Stroke, 1.5)
local function rescaleMain()
local vp = Camera.ViewportSize
local w  = math.min(vp.X - 20, 420)
local h  = math.min(vp.Y - 20, 520)
MainFrame.Size     = UDim2.new(0, w, 0, h)
MainFrame.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
end
rescaleMain()
-- ============================================================
-- TITLE BAR
-- ============================================================
local TitleBar = New("Frame", {
Name             = "TitleBar",
Size             = UDim2.new(1, 0, 0, TITLEBAR_H),
BackgroundColor3 = T.Panel,
BorderSizePixel  = 0,
ZIndex           = 4,
ClipsDescendants = false,
}, MainFrame)
Corner(TitleBar, 14)
Gradient(TitleBar, T.Grad1, T.Grad2)
-- Cover bottom rounded corners of title bar
New("Frame", {
Size             = UDim2.new(1, 0, 0, 10),
Position         = UDim2.new(0, 0, 1, -10),
BackgroundColor3 = T.Grad2,
BorderSizePixel  = 0,
ZIndex           = 3,
}, TitleBar)
New("TextLabel", {
Size                 = UDim2.new(1, -20, 1, 0),
Position             = UDim2.new(0, 16, 0, 0),
BackgroundTransparency = 1,
Text                 = "Project Crafted V2",
TextColor3           = Color3.fromRGB(255,255,255),
TextSize             = 15,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Left,
ZIndex               = 5,
}, TitleBar)
local accentDot = New("Frame", {
Size             = UDim2.new(0, 6, 0, 6),
Position         = UDim2.new(0, 7, 0.5, -3),
BackgroundColor3 = T.Accent,
BorderSizePixel  = 0,
ZIndex           = 5,
}, TitleBar)
Corner(accentDot, 3)
-- ============================================================
-- DRAGGABLE TITLE BAR
-- ============================================================
do
local dragging, dragStart, dragOrigPos
TitleBar.InputBegan:Connect(function(inp)
if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
dragging    = true
dragStart   = inp.Position
dragOrigPos = MainFrame.Position
end
end)
UserInputService.InputChanged:Connect(function(inp)
if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
local d  = inp.Position - dragStart
local vp = Camera.ViewportSize
local nx = math.clamp(dragOrigPos.X.Offset + d.X, -MainFrame.AbsoluteSize.X + 30, vp.X - 30)
local ny = math.clamp(dragOrigPos.Y.Offset + d.Y, 0, vp.Y - 30)
MainFrame.Position = UDim2.new(0, nx, 0, ny)
end
end)
UserInputService.InputEnded:Connect(function(inp)
if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
end
-- ============================================================
-- TAB BAR  (positioned using constants so content never overlaps)
-- ============================================================
local TabBar = New("Frame", {
Name             = "TabBar",
Size             = UDim2.new(1, -16, 0, TABBAR_H),
Position         = UDim2.new(0, 8, 0, TABBAR_Y),
BackgroundColor3 = T.Panel,
BorderSizePixel  = 0,
ZIndex           = 4,
ClipsDescendants = true,
}, MainFrame)
Corner(TabBar, 8)
Stroke(TabBar, T.StrokeDim, 1)
ListLayout(TabBar, Enum.FillDirection.Horizontal, 4, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
Padding(TabBar, 4, 4, 4, 4)
-- ============================================================
-- CONTENT AREA  (starts exactly at CONTENT_Y = 88)
-- ============================================================
local ContentArea = New("Frame", {
Name             = "ContentArea",
Size             = UDim2.new(1, 0, 1, -CONTENT_Y),
Position         = UDim2.new(0, 0, 0, CONTENT_Y),
BackgroundTransparency = 1,
BorderSizePixel  = 0,
ClipsDescendants = true,
}, MainFrame)
-- ============================================================
-- TABS
-- ============================================================
local TAB_NAMES  = {"Home", "Main", "Player", "Visual", "Settings"}
local tabBtns    = {}
local tabFrames  = {}
local currentTab = 1
local switching  = false
for i, name in ipairs(TAB_NAMES) do
local f = New("Frame", {
Name             = name .. "Tab",
Size             = UDim2.new(1, 0, 1, 0),
Position         = UDim2.new(i == 1 and 0 or 1, 0, 0, 0),
BackgroundTransparency = 1,
BorderSizePixel  = 0,
Visible          = i == 1,
ClipsDescendants = true,
}, ContentArea)
tabFrames[i] = f
end
local function SwitchTab(idx)
if idx == currentTab or switching then return end
switching = true
local prev = tabFrames[currentTab]
local next = tabFrames[idx]
local dir  = idx > currentTab and 1 or -1
next.Position = UDim2.new(dir, 0, 0, 0)
next.Visible  = true
Tween(prev, MED, {Position = UDim2.new(-dir, 0, 0, 0)}):Play()
Tween(next, MED, {Position = UDim2.new(0,    0, 0, 0)}):Play()
for i, btn in ipairs(tabBtns) do
local isActive = (i == idx)
Tween(btn, FAST, {BackgroundColor3 = isActive and T.Primary or Color3.fromRGB(0,0,0)}):Play()
btn.BackgroundTransparency = isActive and 0 or 1
local lbl = btn:FindFirstChildOfClass("TextLabel")
if lbl then
Tween(lbl, FAST, {TextColor3 = isActive and Color3.fromRGB(255,255,255) or T.TextDim}):Play()
end
end
task.delay(MED.Time + 0.05, function()
prev.Visible = false
switching    = false
end)
currentTab = idx
end
for i, name in ipairs(TAB_NAMES) do
local btn = New("TextButton", {
Name                 = name .. "Btn",
Size                 = UDim2.new(0, 1, 0.88, 0),
AutomaticSize        = Enum.AutomaticSize.X,
BackgroundColor3     = i == 1 and T.Primary or Color3.fromRGB(0,0,0),
BackgroundTransparency = i == 1 and 0 or 1,
BorderSizePixel      = 0,
Text                 = "",
AutoButtonColor      = false,
LayoutOrder          = i,
ZIndex               = 5,
}, TabBar)
Corner(btn, 5)
New("TextLabel", {
Size                 = UDim2.new(0, 0, 1, 0),
AutomaticSize        = Enum.AutomaticSize.X,
BackgroundTransparency = 1,
Text                 = name,
TextColor3           = i == 1 and Color3.fromRGB(255,255,255) or T.TextDim,
TextSize             = 11,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Center,
ZIndex               = 6,
}, btn)
Padding(btn, 0, 0, 10, 10)
local idx = i
btn.MouseButton1Click:Connect(function() SwitchTab(idx) end)
tabBtns[i] = btn
end
-- ============================================================
-- HOME TAB
-- ============================================================
local homeScroll = MakeScroll(tabFrames[1])
local profileCard = MakeCard(homeScroll, 1)
SectionLabel(profileCard, "Player", 1)
local avatarRow = New("Frame", {
Size                 = UDim2.new(1, 0, 0, 72),
BackgroundTransparency = 1,
LayoutOrder          = 2,
}, profileCard)
local pfpFrame = New("Frame", {
Name             = "PfpFrame",
Size             = UDim2.new(0, 64, 0, 64),
Position         = UDim2.new(0, 0, 0.5, -32),
BackgroundColor3 = T.Element,
BorderSizePixel  = 0,
}, avatarRow)
Corner(pfpFrame, 32)
Stroke(pfpFrame, T.Stroke, 2)
local pfpImg = New("ImageLabel", {
Size                 = UDim2.new(1, -4, 1, -4),
Position             = UDim2.new(0, 2, 0, 2),
BackgroundTransparency = 1,
Image                = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
ScaleType            = Enum.ScaleType.Crop,
}, pfpFrame)
Corner(pfpImg, 30)
local nameCol = New("Frame", {
Size                 = UDim2.new(1, -74, 1, 0),
Position             = UDim2.new(0, 72, 0, 0),
BackgroundTransparency = 1,
}, avatarRow)
ListLayout(nameCol, nil, 2, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 18),
BackgroundTransparency = 1,
Text                 = LocalPlayer.DisplayName,
TextColor3           = T.Text,
TextSize             = 14,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Left,
TextTruncate         = Enum.TextTruncate.AtEnd,
LayoutOrder          = 1,
}, nameCol)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 14),
BackgroundTransparency = 1,
Text                 = "@" .. LocalPlayer.Name,
TextColor3           = T.TextDim,
TextSize             = 11,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = 2,
}, nameCol)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 12),
BackgroundTransparency = 1,
Text                 = "ID: " .. LocalPlayer.UserId,
TextColor3           = T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = 3,
}, nameCol)
Divider(profileCard, 3)
InfoRow(profileCard, "Account Age:", LocalPlayer.AccountAge .. " days", 4)
local serverCard   = MakeCard(homeScroll, 2)
SectionLabel(serverCard, "Server", 1)
local gameNameVal  = InfoRow(serverCard, "Game:",      "Loading...", 2)
local gameIdVal    = InfoRow(serverCard, "Place ID:",  tostring(game.PlaceId), 3)
local playerCntVal = InfoRow(serverCard, "Players:",   "...", 4)
local jobIdVal     = InfoRow(serverCard, "Server ID:", tostring(game.JobId):sub(1,16).."...", 5)
local uptimeVal    = InfoRow(serverCard, "Uptime:",    "00:00:00", 6)
local statsCard  = MakeCard(homeScroll, 3)
SectionLabel(statsCard, "Script Stats", 1)
InfoRow(statsCard, "Times Executed:", tostring(execCount), 2)
local sessTimeVal = InfoRow(statsCard, "Session Time:", "00:00:00", 3)
task.spawn(function()
local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
gameNameVal.Text = (ok and info) and info.Name or tostring(game.PlaceId)
end)
task.spawn(function()
local serverStart = os.time()
while true do
task.wait(1)
local up   = os.time() - serverStart
uptimeVal.Text   = string.format("%02d:%02d:%02d", math.floor(up/3600), math.floor(up/60)%60, up%60)
local sess = os.time() - execStartTime
sessTimeVal.Text = string.format("%02d:%02d:%02d", math.floor(sess/3600), math.floor(sess/60)%60, sess%60)
pcall(function() playerCntVal.Text = #Players:GetPlayers() .. " / " .. Players.MaxPlayers end)
end
end)
-- ============================================================
-- MAIN TAB
-- ============================================================
local mainScroll = MakeScroll(tabFrames[2])
local selectedBrainrots      = {}
local highlightEnabled       = false
local teleportOnSpawnEnabled = false
local trackedModels          = {}
local selCard = MakeCard(mainScroll, 1)
SectionLabel(selCard, "Select Brainrots", 1)
local dropWrap, getDropSelected, setDropItems, removeDropItem = MakeDropdown(selCard, 2, function(sel)
selectedBrainrots = sel
end)
local chipsCard = MakeCard(mainScroll, 2)
SectionLabel(chipsCard, "Selected", 1)
local chipsContainer, rebuildChips = MakeSelectedDisplay(chipsCard, 2, function(name)
removeDropItem(name)
selectedBrainrots[name] = nil
end)
-- Sync chip display with selection state
task.spawn(function()
while true do
task.wait(0.1)
rebuildChips(selectedBrainrots)
end
end)
-- Load brainrot names
task.spawn(function()
local ok, bsFolder = pcall(function() return ReplicatedStorage:WaitForChild("Brainrots", 10) end)
if not ok or not bsFolder then setDropItems({"[Brainrots folder not found]"}) return end
local nameSet  = {}
local nameList = {}
local function scanFolder(folder)
for _, child in ipairs(folder:GetChildren()) do
if child:IsA("Folder") then scanFolder(child)
elseif child:IsA("Model") and not nameSet[child.Name] then
nameSet[child.Name] = true
table.insert(nameList, child.Name)
end
end
end
scanFolder(bsFolder)
table.sort(nameList)
setDropItems(nameList)
end)
-- Spawn detection loop
task.spawn(function()
while true do
task.wait(0.5)
local selList = {}
for name in pairs(selectedBrainrots) do table.insert(selList, name) end
if #selList == 0 then continue end
local gf = workspace:FindFirstChild("GameFolder")
local bf = gf and gf:FindFirstChild("Brainrots")
if not bf then continue end
local function searchFor(parent, targetName)
for _, child in ipairs(parent:GetChildren()) do
if child.Name == targetName and (child:IsA("Model") or child:IsA("BasePart")) then return child end
local found = searchFor(child, targetName)
if found then return found end
end
end
for _, name in ipairs(selList) do
local model = searchFor(bf, name)
if model and not trackedModels[model] then
trackedModels[model] = true
ShowNotification("A " .. name .. " Has Spawned!")
if teleportOnSpawnEnabled then
task.spawn(function()
task.wait(0.1)
local char = LocalPlayer.Character
local hrp  = char and char:FindFirstChild("HumanoidRootPart")
if hrp then
local ok2, pivot = pcall(function() return model:GetPivot() end)
if ok2 then hrp.CFrame = pivot * CFrame.new(0, 4, 0) end
end
end)
end
if highlightEnabled then
task.spawn(function()
local hl = Instance.new("Highlight")
hl.Name             = "PCHighlight"
hl.FillColor        = T.Primary
hl.OutlineColor     = T.Accent
hl.FillTransparency = 0.45
hl.Parent           = model
end)
end
model.AncestryChanged:Connect(function()
if not model:IsDescendantOf(workspace) then trackedModels[model] = nil end
end)
end
end
end
end)
-- ============================================================
-- PLAYER TAB
-- ============================================================
local playerScroll = MakeScroll(tabFrames[3])
-- Speed Boost
local speedCard    = MakeCard(playerScroll, 1)
SectionLabel(speedCard, "Speed Boost", 1)
local speedEnabled = false
local speedVal     = 30
local speedMaxVal  = 200
local function applySpeed(val)
local char = LocalPlayer.Character
local hum  = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = val end
end
local function restoreDefaultSpeed()
pcall(function()
local hud    = LocalPlayer.PlayerGui:FindFirstChild("HUD")
local lbl    = hud and hud:FindFirstChild("Speed")
local digits = lbl and lbl.Text:match("(%d+%.?%d*)")
local char   = LocalPlayer.Character
local hum    = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = tonumber(digits) or 16 end
end)
end
local _, getSpeedState, setSpeedToggle = MakeToggle(speedCard, "Speed Boost", 2, function(state)
speedEnabled = state
if state then applySpeed(speedVal) else restoreDefaultSpeed() end
end)
local speedSlider, getSpeedVal, setSpeedMax = MakeSlider(speedCard, "Speed", 3, 16, speedMaxVal, speedVal, function(val)
speedVal = val
if speedEnabled then applySpeed(val) end
end)
MakeMaxInput(speedCard, 4, speedMaxVal, "Max Speed:", function(newMax)
speedMaxVal = newMax
setSpeedMax(newMax)
end)
-- Jump Boost
local jumpCard    = MakeCard(playerScroll, 2)
SectionLabel(jumpCard, "Jump Boost", 1)
local jumpEnabled = false
local jumpVal     = 80
local function applyJump(val)
local char = LocalPlayer.Character
local hum  = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.JumpPower = val end
end
local function restoreDefaultJump()
pcall(function()
local hud    = LocalPlayer.PlayerGui:FindFirstChild("HUD")
local lbl    = hud and hud:FindFirstChild("Jump")
local digits = lbl and lbl.Text:match("(%d+%.?%d*)")
local char   = LocalPlayer.Character
local hum    = char and char:FindFirstChildOfClass("Humanoid")
if hum then
local n = tonumber(digits) or 0
hum.JumpPower = 30 + n * (10/3)
end
end)
end
local _, getJumpState, setJumpToggle = MakeToggle(jumpCard, "Jump Boost", 2, function(state)
jumpEnabled = state
if state then applyJump(jumpVal) else restoreDefaultJump() end
end)
MakeSlider(jumpCard, "Jump Power", 3, 30, 200, jumpVal, function(val)
jumpVal = val
if jumpEnabled then applyJump(val) end
end)
-- Godmode
local godCard        = MakeCard(playerScroll, 3)
SectionLabel(godCard, "Godmode", 1)
local godmodeEnabled = false
local function setGodmode(state)
godmodeEnabled = state
pcall(function()
local gf    = workspace:FindFirstChild("GameFolder")
local lavas = gf and gf:FindFirstChild("Lavas")
if not lavas then return end
for _, desc in ipairs(lavas:GetDescendants()) do
if desc:IsA("BasePart") then
desc.CanTouch = not state
if state then
for _, child in ipairs(desc:GetChildren()) do
if child.ClassName == "TouchTransmitter" then child:Destroy() end
end
end
end
end
end)
end
MakeToggle(godCard, "Godmode (Lava)", 2, function(state)
setGodmode(state)
if state then ShowNotification("Godmode enabled", 2) end
end)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 14),
BackgroundTransparency = 1,
Text                 = "Prevents lava damage by disabling touch",
TextColor3           = T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = 3,
}, godCard)
-- Flight
local flightCard      = MakeCard(playerScroll, 4)
SectionLabel(flightCard, "Flight", 1)
local flightEnabled   = false
local flightConnection= nil
local FLIGHT_SPEED    = 45
local fKeys = {up = false, down = false}
UserInputService.InputBegan:Connect(function(inp, gp)
if gp then return end
if inp.KeyCode == Enum.KeyCode.E then fKeys.up   = true end
if inp.KeyCode == Enum.KeyCode.Q then fKeys.down = true end
end)
UserInputService.InputEnded:Connect(function(inp)
if inp.KeyCode == Enum.KeyCode.E then fKeys.up   = false end
if inp.KeyCode == Enum.KeyCode.Q then fKeys.down = false end
end)
local function stopFlight()
flightEnabled = false
if flightConnection then flightConnection:Disconnect() flightConnection = nil end
pcall(function()
local char = LocalPlayer.Character
local hum  = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.PlatformStand = false hum.AutoRotate = true end
end)
end
local function startFlight()
if flightConnection then flightConnection:Disconnect() end
flightEnabled = true
local char = LocalPlayer.Character
local hum  = char and char:FindFirstChildOfClass("Humanoid")
local hrp  = char and char:FindFirstChild("HumanoidRootPart")
if not hum or not hrp then return end
hum.PlatformStand = true
hum.AutoRotate    = false
flightConnection  = RunService.RenderStepped:Connect(function(dt)
if not flightEnabled then return end
local c = LocalPlayer.Character
if not c then return end
local r = c:FindFirstChild("HumanoidRootPart")
local h = c:FindFirstChildOfClass("Humanoid")
if not r or not h then return end
if not h.PlatformStand then h.PlatformStand = true h.AutoRotate = false end
local cam   = Camera.CFrame
local look  = cam.LookVector
local right = cam.RightVector
local up    = Vector3.new(0, 1, 0)
local move  = Vector3.zero
if UserInputService:IsKeyDown(Enum.KeyCode.W)     then move = move + look  end
if UserInputService:IsKeyDown(Enum.KeyCode.S)     then move = move - look  end
if UserInputService:IsKeyDown(Enum.KeyCode.A)     then move = move - right end
if UserInputService:IsKeyDown(Enum.KeyCode.D)     then move = move + right end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) or fKeys.up   then move = move + up end
if fKeys.down then move = move - up end
if move.Magnitude > 0 then move = move.Unit end
local newPos = r.Position + move * FLIGHT_SPEED * dt
r.CFrame     = CFrame.new(newPos, newPos + look)
r.AssemblyLinearVelocity  = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
end)
end
MakeToggle(flightCard, "Flight", 2, function(state)
if state then startFlight() else stopFlight() end
end)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 14),
BackgroundTransparency = 1,
Text                 = "WASD move  |  Space = up  |  Q = down  |  E = up",
TextColor3           = T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = 3,
}, flightCard)
-- Teleport to Brainrots
local tpCard = MakeCard(playerScroll, 5)
SectionLabel(tpCard, "Teleport", 1)
MakeToggle(tpCard, "Teleport to Selected Brainrots", 2, function(state)
teleportOnSpawnEnabled = state
end)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 14),
BackgroundTransparency = 1,
Text                 = "Teleports to brainrot when it spawns",
TextColor3           = T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = 3,
}, tpCard)
-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
task.wait(0.8)
pcall(function()
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if speedEnabled   then hum.WalkSpeed = speedVal end
if jumpEnabled    then hum.JumpPower = jumpVal  end
if godmodeEnabled then task.wait(0.3) setGodmode(true) end
if flightEnabled  then task.wait(0.3) startFlight()    end
end)
end)
-- ============================================================
-- VISUAL TAB
-- ============================================================
local visualScroll = MakeScroll(tabFrames[4])
local brainrotHLCard = MakeCard(visualScroll, 1)
SectionLabel(brainrotHLCard, "Brainrot Highlight", 1)
MakeToggle(brainrotHLCard, "Highlight Selected Brainrots", 2, function(state)
highlightEnabled = state
if not state then
pcall(function()
local gf = workspace:FindFirstChild("GameFolder")
local bf = gf and gf:FindFirstChild("Brainrots")
if bf then
for _, desc in ipairs(bf:GetDescendants()) do
if desc:IsA("Highlight") and desc.Name == "PCHighlight" then desc:Destroy() end
end
end
end)
end
end)
local playerHLCard    = MakeCard(visualScroll, 2)
SectionLabel(playerHLCard, "Player Highlight", 1)
local playerHLEnabled = false
local playerHLData    = {}
local function cleanupPlayerHL(player)
if playerHLData[player] then
pcall(function()
local d = playerHLData[player]
if d.highlight and d.highlight.Parent then d.highlight:Destroy() end
if d.billboard and d.billboard.Parent then d.billboard:Destroy() end
end)
playerHLData[player] = nil
end
end
local function updatePlayerHighlights()
if not playerHLEnabled then
for player in pairs(playerHLData) do cleanupPlayerHL(player) end
return
end
local myChar = LocalPlayer.Character
local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
for _, player in ipairs(Players:GetPlayers()) do
if player == LocalPlayer then continue end
local pChar = player.Character
local pHead = pChar and (pChar:FindFirstChild("Head") or pChar:FindFirstChild("HumanoidRootPart"))
local pHRP  = pChar and pChar:FindFirstChild("HumanoidRootPart")
if not pChar or not pHead or not pHRP then cleanupPlayerHL(player) continue end
if not playerHLData[player] or not playerHLData[player].highlight.Parent then
cleanupPlayerHL(player)
local hl = Instance.new("Highlight")
hl.Name             = "PCPlayerHL"
hl.FillColor        = Color3.fromRGB(80, 180, 255)
hl.OutlineColor     = Color3.fromRGB(200, 235, 255)
hl.FillTransparency = 0.55
hl.Parent           = pChar
local bb = New("BillboardGui", {
Name        = "PCBB",
Size        = UDim2.new(0, 110, 0, 44),
StudsOffset = Vector3.new(0, 2.8, 0),
AlwaysOnTop = true,
Parent      = pHead,
})
local bbBg = New("Frame", {
Size                 = UDim2.new(1, 0, 1, 0),
BackgroundColor3     = Color3.fromRGB(0,0,0),
BackgroundTransparency = 0.45,
BorderSizePixel      = 0,
}, bb)
Corner(bbBg, 6)
local bbLbl = New("TextLabel", {
Size                 = UDim2.new(1, -8, 1, 0),
Position             = UDim2.new(0, 4, 0, 0),
BackgroundTransparency = 1,
Text                 = player.DisplayName .. "\n0 studs",
TextColor3           = Color3.fromRGB(255,255,255),
TextSize             = 11,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Center,
TextStrokeTransparency = 0.5,
TextStrokeColor3     = Color3.fromRGB(0,0,0),
}, bbBg)
playerHLData[player] = {highlight = hl, billboard = bb, label = bbLbl}
end
if myHRP and playerHLData[player] and playerHLData[player].label then
local dist = math.floor((myHRP.Position - pHRP.Position).Magnitude)
playerHLData[player].label.Text = player.DisplayName .. "\n" .. dist .. " studs"
end
end
end
Players.PlayerRemoving:Connect(function(player) cleanupPlayerHL(player) end)
MakeToggle(playerHLCard, "Highlight Other Players", 2, function(state)
playerHLEnabled = state
if not state then updatePlayerHighlights() end
end)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 14),
BackgroundTransparency = 1,
Text                 = "Shows highlight + distance billboard above players",
TextColor3           = T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
LayoutOrder          = 3,
}, playerHLCard)
task.spawn(function()
while true do task.wait(0.3) pcall(updatePlayerHighlights) end
end)
-- ============================================================
-- SETTINGS TAB
-- ============================================================
local settingsScroll = MakeScroll(tabFrames[5])
local themeCard      = MakeCard(settingsScroll, 1)
SectionLabel(themeCard, "GUI Theme", 1)
local themeDescs = {
Original = "Classic green — sleek and sharp",
Sky      = "Cool sky blue — calm and crisp",
Lava     = "Fiery orange-red — bold and aggressive",
}
for i, themeName in ipairs({"Original", "Sky", "Lava"}) do
local isActive = (themeName == currentThemeName)
local themeBtn = New("TextButton", {
Name             = "ThemeBtn_" .. themeName,
Size             = UDim2.new(1, 0, 0, 48),
BackgroundColor3 = isActive and T.Primary or T.Element,
BorderSizePixel  = 0,
Text             = "",
AutoButtonColor  = false,
LayoutOrder      = i + 1,
}, themeCard)
Corner(themeBtn, 8)
Stroke(themeBtn, isActive and T.Stroke or T.StrokeDim, isActive and 1.5 or 1)
New("TextLabel", {
Size                 = UDim2.new(1, -16, 0, 18),
Position             = UDim2.new(0, 10, 0, 7),
BackgroundTransparency = 1,
Text                 = themeName,
TextColor3           = isActive and Color3.fromRGB(255,255,255) or T.Text,
TextSize             = 13,
Font                 = Enum.Font.GothamBold,
TextXAlignment       = Enum.TextXAlignment.Left,
}, themeBtn)
New("TextLabel", {
Size                 = UDim2.new(1, -16, 0, 14),
Position             = UDim2.new(0, 10, 0, 27),
BackgroundTransparency = 1,
Text                 = themeDescs[themeName],
TextColor3           = isActive and Color3.fromRGB(220,255,230) or T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Gotham,
TextXAlignment       = Enum.TextXAlignment.Left,
}, themeBtn)
if isActive then
local dot = New("Frame", {
Size             = UDim2.new(0, 6, 0, 6),
Position         = UDim2.new(1, -14, 0.5, -3),
BackgroundColor3 = T.Accent,
BorderSizePixel  = 0,
}, themeBtn)
Corner(dot, 3)
end
local capTheme = themeName
themeBtn.MouseButton1Click:Connect(function()
safeWriteFile(THEME_FILE, capTheme)
for , child in ipairs(themeCard:GetChildren()) do
if child:IsA("TextButton") then
local active = child.Name == "ThemeBtn" .. capTheme
Tween(child, FAST, {BackgroundColor3 = active and T.Primary or T.Element}):Play()
local nameLbl = child:FindFirstChildOfClass("TextLabel")
if nameLbl then
Tween(nameLbl, FAST, {TextColor3 = active and Color3.fromRGB(255,255,255) or T.Text}):Play()
end
end
end
ShowNotification("Theme saved to config!\nRe-run script to apply " .. capTheme .. " theme.", 3)
end)
end
local noteCard = MakeCard(settingsScroll, 2)
SectionLabel(noteCard, "Config Location", 1)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 0, 28),
BackgroundTransparency = 1,
Text                 = "workspace/ProjectCrafted/configs/",
TextColor3           = T.TextDim,
TextSize             = 10,
Font                 = Enum.Font.Code,
TextXAlignment       = Enum.TextXAlignment.Left,
TextWrapped          = true,
LayoutOrder          = 2,
}, noteCard)
-- ============================================================
-- TOGGLE BUTTON (open/close GUI)
-- ============================================================
local toggleBtn = New("TextButton", {
Name             = "PCToggle",
Size             = UDim2.new(0, 48, 0, 48),
Position         = UDim2.new(1, -58, 1, -58),
BackgroundColor3 = T.Primary,
BorderSizePixel  = 0,
Text             = "",
AutoButtonColor  = false,
ZIndex           = 1,
}, ToggleGui)
Corner(toggleBtn, 24)
Stroke(toggleBtn, T.Stroke, 2)
Gradient(toggleBtn, T.Grad1, T.Grad2, 135)
New("TextLabel", {
Size                 = UDim2.new(1, 0, 1, 0),
BackgroundTransparency = 1,
Text                 = "PC",
TextColor3           = Color3.fromRGB(255,255,255),
TextSize             = 13,
Font                 = Enum.Font.GothamBold,
ZIndex               = 2,
}, toggleBtn)
local pulseFrame = New("Frame", {
Size                 = UDim2.new(1, 0, 1, 0),
BackgroundColor3     = T.Accent,
BackgroundTransparency = 0.7,
BorderSizePixel      = 0,
ZIndex               = 0,
}, toggleBtn)
Corner(pulseFrame, 24)
task.spawn(function()
while true do
Tween(pulseFrame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.95}):Play()
task.wait(1)
Tween(pulseFrame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6}):Play()
task.wait(1)
end
end)
do
local tbDragging    = false
local tbDragStart   = nil
local tbStartPos    = nil
local tbDragDist    = 0
local tbInputStarted= false
toggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        tbDragging     = true
        tbInputStarted = true
        tbDragStart    = inp.Position
        tbStartPos     = toggleBtn.Position
        tbDragDist     = 0
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if tbDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local d    = inp.Position - tbDragStart
        tbDragDist = d.Magnitude
        if tbDragDist > 6 then
            local vp   = Camera.ViewportSize
            local newX = math.clamp(tbStartPos.X.Offset + d.X, -vp.X + 58, 0)
            local newY = math.clamp(tbStartPos.Y.Offset + d.Y, -vp.Y + 58, 0)
            toggleBtn.Position = UDim2.new(1, newX, 1, newY)
        end
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if tbInputStarted and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
        tbInputStarted = false
        tbDragging     = false
        if tbDragDist <= 6 then
            local isOpen = MainGui.Enabled
            if not isOpen then
                MainGui.Enabled   = true
                MainFrame.Visible = true
                local vp = Camera.ViewportSize
                local w  = math.min(vp.X - 20, 420)
                local h  = math.min(vp.Y - 20, 520)
                MainFrame.Size     = UDim2.new(0, 0, 0, 0)
                MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                Tween(MainFrame, SPRING, {
                    Size     = UDim2.new(0, w, 0, h),
                    Position = UDim2.new(0.5, -w/2, 0.5, -h/2),
                }):Play()
            else
                local cx = MainFrame.Position.X.Offset + MainFrame.AbsoluteSize.X * 0.5
                local cy = MainFrame.Position.Y.Offset + MainFrame.AbsoluteSize.Y * 0.5
                Tween(MainFrame, MED, {
                    Size     = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0, cx, 0, cy),
                }):Play()
                task.delay(MED.Time, function() MainGui.Enabled = false end)
            end
        end
    end
end)
end
-- ============================================================
-- TOGGLE BUTTON OVERLAP CHECK
-- ============================================================
task.spawn(function()
task.wait(3)
pcall(function()
local tbAP = toggleBtn.AbsolutePosition
local tbSZ = toggleBtn.AbsoluteSize
local function overlapsAny(guiObj)
for _, obj in ipairs(guiObj:GetDescendants()) do
if obj:IsA("GuiObject") and obj.Visible and obj ~= toggleBtn and obj ~= pulseFrame then
local ap = obj.AbsolutePosition
local sz = obj.AbsoluteSize
if sz.X > 4 and sz.Y > 4 then
local overlap = not (
tbAP.X + tbSZ.X < ap.X or
ap.X + sz.X < tbAP.X or
tbAP.Y + tbSZ.Y < ap.Y or
ap.Y + sz.Y < tbAP.Y
)
if overlap then return true end
end
end
end
return false
end
local hasOverlap = false
for _, sg in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
if sg:IsA("ScreenGui") and sg.Enabled and overlapsAny(sg) then
hasOverlap = true break
end
end
if not hasOverlap then
for _, sg in ipairs(CoreGui:GetChildren()) do
if sg:IsA("ScreenGui") and sg.Name ~= "PC_ToggleGui" and sg.Name ~= "ProjectCraftedV2" and sg.Name ~= "PC_NotifGui" and sg.Enabled then
if overlapsAny(sg) then hasOverlap = true break end
end
end
end
if hasOverlap then
Tween(toggleBtn, MED, {Position = UDim2.new(0, 10, 1, -58)}):Play()
end
end)
end)
-- ============================================================
-- OPEN AT START
-- ============================================================
MainGui.Enabled   = true
MainFrame.Visible = true
-- ============================================================
-- DONE
-- ============================================================
print("╔══════════════════════════════╗")
print("║  Project Crafted V2 Loaded   ║")
print("║  Times Executed: " .. execCount .. string.rep(" ", 12 - #tostring(execCount)) .. "║")
print("║  Theme: " .. currentThemeName .. string.rep(" ", 21 - #currentThemeName) .. "║")
print("╚══════════════════════════════╝")
ShowNotification("Project Crafted V2 loaded!\nExecutions: " .. execCount, 4)
