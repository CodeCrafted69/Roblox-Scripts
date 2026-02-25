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
                        V2 — by Project Crafted
]]

-- ============================================================
--  SERVICES
-- ============================================================
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ============================================================
--  GAME CHECK
-- ============================================================
local SUPPORTED_PLACE_ID = 119987266683883

if game.PlaceId ~= SUPPORTED_PLACE_ID then
    local function showUnsupportedBanner()
        local ng = Instance.new("ScreenGui")
        ng.Name = "PCUnsupported"; ng.ResetOnSpawn = false
        ng.IgnoreGuiInset = true; ng.DisplayOrder = 9999
        pcall(function() ng.Parent = CoreGui end)

        local f = Instance.new("Frame", ng)
        f.AnchorPoint  = Vector2.new(0.5, 0)
        f.Position     = UDim2.new(0.5, 0, -0.12, 0)
        f.Size         = UDim2.new(0, 360, 0, 58)
        f.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", f)
        st.Color = Color3.fromRGB(220, 55, 55); st.Thickness = 1.8

        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -20, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 15; lbl.TextScaled = false

        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        lbl.Text = "❌ " .. (ok and info.Name or "This Game") .. " Is Not Supported!"

        TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back),
            { Position = UDim2.new(0.5, 0, 0.05, 0) }):Play()
        task.wait(3.5)
        TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            { Position = UDim2.new(0.5, 0, -0.12, 0) }):Play()
        task.wait(0.5)
        pcall(function() ng:Destroy() end)
    end
    task.spawn(showUnsupportedBanner)
    return
end

-- ============================================================
--  CONFIG SYSTEM  (executor writefile / readfile)
-- ============================================================
local CFG_ROOT    = "ProjectCrafted"
local CFG_FOLDER  = "ProjectCrafted/configs"

local function ensureCfgFolders()
    pcall(function()
        if not isfolder(CFG_ROOT)   then makefolder(CFG_ROOT)   end
        if not isfolder(CFG_FOLDER) then makefolder(CFG_FOLDER) end
    end)
end

local function cfgRead(name, default)
    ensureCfgFolders()
    local path = CFG_FOLDER .. "/" .. name .. ".txt"
    local ok, val = pcall(function()
        if isfile(path) then return readfile(path) end
    end)
    return (ok and val) or default
end

local function cfgWrite(name, value)
    ensureCfgFolders()
    pcall(writefile, CFG_FOLDER .. "/" .. name .. ".txt", tostring(value))
end

-- Execution counter
local execCount = (tonumber(cfgRead("execcount", "0")) or 0) + 1
cfgWrite("execcount", execCount)
local execStartTime = os.time()

-- ============================================================
--  THEMES
-- ============================================================
local Themes = {
    Original = {
        Background   = Color3.fromRGB(10, 22, 10),
        Secondary    = Color3.fromRGB(18, 38, 18),
        Accent       = Color3.fromRGB(0, 210, 85),
        AccentDark   = Color3.fromRGB(0, 145, 55),
        Text         = Color3.fromRGB(215, 255, 215),
        TextDim      = Color3.fromRGB(120, 185, 120),
        TabActive    = Color3.fromRGB(0, 190, 75),
        TabInactive  = Color3.fromRGB(14, 32, 14),
        ToggleOn     = Color3.fromRGB(0, 210, 85),
        ToggleOff    = Color3.fromRGB(48, 48, 48),
        Stroke       = Color3.fromRGB(0, 145, 55),
        SliderTrack  = Color3.fromRGB(18, 42, 18),
        SliderFill   = Color3.fromRGB(0, 210, 85),
        DropdownBg   = Color3.fromRGB(14, 32, 14),
        ScrollBar    = Color3.fromRGB(0, 150, 60),
        OpenButton   = Color3.fromRGB(0, 180, 70),
        GradStart    = Color3.fromRGB(0, 210, 85),
        GradEnd      = Color3.fromRGB(0, 100, 40),
        Warn         = Color3.fromRGB(255, 210, 50),
    },
    Sky = {
        Background   = Color3.fromRGB(8, 18, 32),
        Secondary    = Color3.fromRGB(14, 32, 56),
        Accent       = Color3.fromRGB(55, 175, 255),
        AccentDark   = Color3.fromRGB(28, 120, 210),
        Text         = Color3.fromRGB(195, 230, 255),
        TextDim      = Color3.fromRGB(105, 165, 220),
        TabActive    = Color3.fromRGB(50, 165, 245),
        TabInactive  = Color3.fromRGB(10, 24, 46),
        ToggleOn     = Color3.fromRGB(55, 175, 255),
        ToggleOff    = Color3.fromRGB(46, 46, 65),
        Stroke       = Color3.fromRGB(38, 130, 205),
        SliderTrack  = Color3.fromRGB(14, 32, 56),
        SliderFill   = Color3.fromRGB(55, 175, 255),
        DropdownBg   = Color3.fromRGB(10, 24, 46),
        ScrollBar    = Color3.fromRGB(38, 140, 215),
        OpenButton   = Color3.fromRGB(40, 155, 235),
        GradStart    = Color3.fromRGB(55, 175, 255),
        GradEnd      = Color3.fromRGB(18, 80, 165),
        Warn         = Color3.fromRGB(255, 220, 60),
    },
    Lava = {
        Background   = Color3.fromRGB(28, 7, 4),
        Secondary    = Color3.fromRGB(48, 14, 7),
        Accent       = Color3.fromRGB(255, 105, 22),
        AccentDark   = Color3.fromRGB(200, 62, 10),
        Text         = Color3.fromRGB(255, 218, 175),
        TextDim      = Color3.fromRGB(195, 148, 98),
        TabActive    = Color3.fromRGB(240, 92, 16),
        TabInactive  = Color3.fromRGB(38, 11, 5),
        ToggleOn     = Color3.fromRGB(255, 105, 22),
        ToggleOff    = Color3.fromRGB(58, 28, 18),
        Stroke       = Color3.fromRGB(195, 70, 10),
        SliderTrack  = Color3.fromRGB(48, 14, 7),
        SliderFill   = Color3.fromRGB(255, 105, 22),
        DropdownBg   = Color3.fromRGB(38, 11, 5),
        ScrollBar    = Color3.fromRGB(195, 70, 10),
        OpenButton   = Color3.fromRGB(225, 80, 12),
        GradStart    = Color3.fromRGB(255, 125, 22),
        GradEnd      = Color3.fromRGB(175, 38, 5),
        Warn         = Color3.fromRGB(255, 235, 80),
    },
}

local currentThemeName = cfgRead("theme", "Original")
if not Themes[currentThemeName] then currentThemeName = "Original" end
local T = Themes[currentThemeName]  -- active theme shorthand

-- Theme-change event system
local themeCallbacks = {}
local function onThemeChange(fn) table.insert(themeCallbacks, fn) end
local function fireThemeChange(th)
    for _, fn in ipairs(themeCallbacks) do pcall(fn, th) end
end
local function applyTheme(name, themeData)
    if themeData then
        Themes[name] = themeData
    end
    if not Themes[name] then return end
    currentThemeName = name
    T = Themes[name]
    cfgWrite("theme", name)
    fireThemeChange(T)
end

-- ============================================================
--  FORWARD DECLARATIONS  (cross-tab references)
-- ============================================================
local highlightBrainrotToggleRef  -- set after Visual tab built
local teleportToggleRef            -- set after Player tab built
local playerWarningAccepted = false

-- ============================================================
--  DESTROY OLD INSTANCE
-- ============================================================
for _, v in ipairs(CoreGui:GetChildren()) do
    if v.Name == "ProjectCraftedV2" then v:Destroy() end
end

-- ============================================================
--  ROOT SCREEN GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "ProjectCraftedV2"
ScreenGui.ResetOnSpawn    = false
ScreenGui.IgnoreGuiInset  = true
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 100
pcall(function() ScreenGui.Parent = CoreGui end)

-- ============================================================
--  NOTIFICATION SYSTEM
-- ============================================================
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "PCNotifs_V2"; NotifGui.ResetOnSpawn = false
NotifGui.IgnoreGuiInset = true; NotifGui.DisplayOrder = 999
pcall(function() NotifGui.Parent = CoreGui end)

local NOTIF_W, NOTIF_H, NOTIF_GAP = 285, 52, 6
local notifStack = {}

local function rebuildNotifPositions()
    for i, f in ipairs(notifStack) do
        local tY = 0.07 + (i - 1) * (NOTIF_H + NOTIF_GAP) / Camera.ViewportSize.Y
        TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart),
            { Position = UDim2.new(0.5, -NOTIF_W / 2, tY, 0) }):Play()
    end
end

local function showNotification(text, accentColor, duration)
    accentColor = accentColor or T.Accent
    duration    = duration    or 2.6

    local f = Instance.new("Frame", NotifGui)
    f.Size = UDim2.new(0, NOTIF_W, 0, NOTIF_H)
    f.Position = UDim2.new(0.5, -NOTIF_W / 2, -0.12, 0)
    f.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    f.BackgroundTransparency = 0.08
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)
    local st = Instance.new("UIStroke", f); st.Color = accentColor; st.Thickness = 1.6

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 3, 1, -10); bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BackgroundColor3 = accentColor; bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -22, 1, 0); lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(238, 238, 238)
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = text

    table.insert(notifStack, f)
    local idx = #notifStack
    local tY = 0.07 + (idx - 1) * (NOTIF_H + NOTIF_GAP) / Camera.ViewportSize.Y
    TweenService:Create(f, TweenInfo.new(0.45, Enum.EasingStyle.Back),
        { Position = UDim2.new(0.5, -NOTIF_W / 2, tY, 0) }):Play()

    task.delay(duration, function()
        TweenService:Create(f, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            { Position = UDim2.new(0.5, -NOTIF_W / 2, -0.12, 0) }):Play()
        task.wait(0.42)
        local pos = table.find(notifStack, f)
        if pos then table.remove(notifStack, pos) end
        pcall(function() f:Destroy() end)
        rebuildNotifPositions()
    end)
end

-- ============================================================
--  MAIN FRAME  (with UIScaleConstraint for responsiveness)
-- ============================================================
local GUI_W, GUI_H = 530, 415

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name            = "MainFrame"
MainFrame.AnchorPoint     = Vector2.new(0.5, 0.5)
MainFrame.Position        = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size            = UDim2.new(0, GUI_W, 0, GUI_H)
MainFrame.BackgroundColor3 = T.Background
MainFrame.ClipsDescendants = true

local uiScale = Instance.new("UIScale", MainFrame)

local function updateGuiScale()
    local vp   = Camera.ViewportSize
    local s    = math.clamp(math.min(vp.X / 1280, vp.Y / 720), 0.55, 1.35)
    uiScale.Scale = s
end
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateGuiScale)
updateGuiScale()

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 13)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = T.Stroke; mainStroke.Thickness = 1.6
local mainGrad = Instance.new("UIGradient", MainFrame)
mainGrad.Color    = ColorSequence.new(T.Background, T.Secondary)
mainGrad.Rotation = 140

onThemeChange(function(th)
    MainFrame.BackgroundColor3   = th.Background
    mainStroke.Color             = th.Stroke
    mainGrad.Color               = ColorSequence.new(th.Background, th.Secondary)
end)

-- ============================================================
--  TITLE BAR
-- ============================================================
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name  = "TitleBar"
TitleBar.Size  = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = T.Secondary
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 13)

-- Fix bottom-rounding of title bar (fill lower half)
local tbFix = Instance.new("Frame", TitleBar)
tbFix.Size = UDim2.new(1, 0, 0.5, 0); tbFix.Position = UDim2.new(0, 0, 0.5, 0)
tbFix.BackgroundColor3 = T.Secondary; tbFix.BorderSizePixel = 0

local tbGrad = Instance.new("UIGradient", TitleBar)
tbGrad.Color    = ColorSequence.new(T.AccentDark, T.Secondary)
tbGrad.Rotation = 90

onThemeChange(function(th)
    TitleBar.BackgroundColor3 = th.Secondary
    tbFix.BackgroundColor3    = th.Secondary
    tbGrad.Color              = ColorSequence.new(th.AccentDark, th.Secondary)
end)

-- Logo image
local LogoImg = Instance.new("ImageLabel", TitleBar)
LogoImg.Size = UDim2.new(0, 34, 0, 34); LogoImg.Position = UDim2.new(0, 10, 0.5, -17)
LogoImg.BackgroundTransparency = 1; LogoImg.Image = "rbxassetid://85816937697749"
LogoImg.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", LogoImg).CornerRadius = UDim.new(0, 6)

-- Title text
local TitleLbl = Instance.new("TextLabel", TitleBar)
TitleLbl.Size = UDim2.new(0, 220, 1, 0); TitleLbl.Position = UDim2.new(0, 50, 0, 0)
TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "Project Crafted V2"
TitleLbl.TextColor3 = T.Text; TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 16; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
onThemeChange(function(th) TitleLbl.TextColor3 = th.Text end)

-- Close button  (minimises – same as toggle btn)
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 32, 0, 32); CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
CloseBtn.Position = UDim2.new(1, -10, 0.5, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)

-- ============================================================
--  DRAGGABILITY
-- ============================================================
local dragData = { active = false, start = nil, origin = nil }

TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragData.active = true
        dragData.start  = inp.Position
        dragData.origin = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragData.active = false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragData.active and (
        inp.UserInputType == Enum.UserInputType.MouseMovement or
        inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragData.start
        MainFrame.Position = UDim2.new(
            dragData.origin.X.Scale, dragData.origin.X.Offset + d.X,
            dragData.origin.Y.Scale, dragData.origin.Y.Offset + d.Y
        )
    end
end)

-- ============================================================
--  OPEN / CLOSE TOGGLE BUTTON
-- ============================================================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name   = "PCToggle"; OpenBtn.ZIndex = 20
OpenBtn.Size   = UDim2.new(0, 148, 0, 38)
OpenBtn.Position = UDim2.new(1, -160, 0, 44)   -- top-right, below Roblox top bar
OpenBtn.BackgroundColor3 = T.OpenButton
OpenBtn.Text   = "⚡ Project Crafted"; OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font   = Enum.Font.GothamBold; OpenBtn.TextSize = 13
OpenBtn.BorderSizePixel = 0
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 9)
local obStroke = Instance.new("UIStroke", OpenBtn)
obStroke.Color = Color3.fromRGB(255, 255, 255); obStroke.Transparency = 0.65; obStroke.Thickness = 1
local obGrad = Instance.new("UIGradient", OpenBtn)
obGrad.Color    = ColorSequence.new(T.GradStart, T.GradEnd)
obGrad.Rotation = 90

onThemeChange(function(th)
    OpenBtn.BackgroundColor3 = th.OpenButton
    obGrad.Color = ColorSequence.new(th.GradStart, th.GradEnd)
end)

-- Draggable open button
local obDrag = { active = false, start = nil, origin = nil, moved = false }

OpenBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        obDrag.active = true; obDrag.moved = false
        obDrag.start  = inp.Position
        obDrag.origin = OpenBtn.Position
    end
end)

OpenBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        obDrag.active = false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if obDrag.active and (
        inp.UserInputType == Enum.UserInputType.MouseMovement or
        inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - obDrag.start
        if d.Magnitude > 4 then obDrag.moved = true end
        OpenBtn.Position = UDim2.new(
            obDrag.origin.X.Scale, obDrag.origin.X.Offset + d.X,
            obDrag.origin.Y.Scale, obDrag.origin.Y.Offset + d.Y
        )
    end
end)

local guiOpen = true

local function openGUI()
    guiOpen = true
    MainFrame.Visible = true
    MainFrame.Size    = UDim2.new(0, 1, 0, 1)
    TweenService:Create(MainFrame, TweenInfo.new(0.42, Enum.EasingStyle.Back),
        { Size = UDim2.new(0, GUI_W, 0, GUI_H) }):Play()
end

local function closeGUI()
    guiOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        { Size = UDim2.new(0, 1, 0, 1) }):Play()
    task.delay(0.36, function()
        MainFrame.Visible = false
        MainFrame.Size    = UDim2.new(0, GUI_W, 0, GUI_H)
    end)
end

CloseBtn.MouseButton1Click:Connect(closeGUI)

OpenBtn.MouseButton1Click:Connect(function()
    if obDrag.moved then return end
    if guiOpen then closeGUI() else openGUI() end
end)

-- ============================================================
--  TAB SYSTEM
-- ============================================================
local TAB_NAMES = { "Home", "Main", "Player", "Visual", "Settings" }

-- Tab bar
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -16, 0, 38)
TabBar.Position = UDim2.new(0, 8, 0, 56)
TabBar.BackgroundColor3 = T.Secondary
TabBar.ClipsDescendants = false
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 9)

local tabBarLayout = Instance.new("UIListLayout", TabBar)
tabBarLayout.FillDirection          = Enum.FillDirection.Horizontal
tabBarLayout.HorizontalAlignment    = Enum.HorizontalAlignment.Center
tabBarLayout.VerticalAlignment      = Enum.VerticalAlignment.Center
tabBarLayout.Padding                = UDim.new(0, 3)

local tabBarPad = Instance.new("UIPadding", TabBar)
tabBarPad.PaddingLeft  = UDim.new(0, 4)
tabBarPad.PaddingRight = UDim.new(0, 4)

onThemeChange(function(th) TabBar.BackgroundColor3 = th.Secondary end)

-- Content area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -106)
ContentArea.Position = UDim2.new(0, 8, 0, 100)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true

local tabButtons = {}
local tabFrames  = {}
local activeTab  = nil

-- Build tab buttons + frames
for i, tName in ipairs(TAB_NAMES) do
    local btn = Instance.new("TextButton", TabBar)
    btn.Name = tName
    btn.Size = UDim2.new(1 / #TAB_NAMES, -4, 0, 30)
    btn.BackgroundColor3 = (i == 1) and T.TabActive or T.TabInactive
    btn.Text      = tName
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255,255,255) or T.TextDim
    btn.Font      = Enum.Font.GothamBold; btn.TextSize = 12
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    tabButtons[tName] = btn

    local frame = Instance.new("Frame", ContentArea)
    frame.Name  = tName; frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position   = (i == 1) and UDim2.new(0, 0, 0, 0) or UDim2.new(1.1, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible    = (i == 1)
    frame.ClipsDescendants = true
    tabFrames[tName] = frame

    onThemeChange(function(th)
        if tName == activeTab then
            btn.BackgroundColor3 = th.TabActive
            btn.TextColor3       = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = th.TabInactive
            btn.TextColor3       = th.TextDim
        end
    end)
end
activeTab = "Home"

-- Switch tab function
local function switchTab(target)
    if activeTab == target then return end

    -- Animate out current
    local old = tabFrames[activeTab]
    if old then
        TweenService:Create(old, TweenInfo.new(0.22, Enum.EasingStyle.Quart),
            { Position = UDim2.new(-1.1, 0, 0, 0) }):Play()
        task.delay(0.22, function() old.Visible = false end)
    end

    -- Update button styles
    for _, tName in ipairs(TAB_NAMES) do
        local btn = tabButtons[tName]
        if tName == target then
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = T.TabActive }):Play()
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(btn, TweenInfo.new(0.18), { BackgroundColor3 = T.TabInactive }):Play()
            btn.TextColor3 = T.TextDim
        end
    end

    -- Animate in new
    local newF = tabFrames[target]
    if newF then
        newF.Position = UDim2.new(1.1, 0, 0, 0)
        newF.Visible  = true
        TweenService:Create(newF, TweenInfo.new(0.28, Enum.EasingStyle.Quart),
            { Position = UDim2.new(0, 0, 0, 0) }):Play()
    end

    activeTab = target
end

-- Tab click handlers (Player tab gets special treatment)
for _, tName in ipairs(TAB_NAMES) do
    tabButtons[tName].MouseButton1Click:Connect(function()
        if tName == "Player" and not playerWarningAccepted then
            switchTab("Player")
        else
            switchTab(tName)
        end
    end)
end

-- ============================================================
--  REUSABLE UI BUILDER HELPERS
-- ============================================================

-- Scrollable container inside a tab frame
local function makeScrollFrame(parent)
    local sf = Instance.new("ScrollingFrame", parent)
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.ScrollBarThickness = 5
    sf.ScrollBarImageColor3 = T.ScrollBar
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.BorderSizePixel = 0
    local ul = Instance.new("UIListLayout", sf)
    ul.Padding = UDim.new(0, 8)
    ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    local up = Instance.new("UIPadding", sf)
    up.PaddingTop    = UDim.new(0, 8); up.PaddingBottom = UDim.new(0, 10)
    up.PaddingLeft   = UDim.new(0, 4); up.PaddingRight  = UDim.new(0, 4)
    onThemeChange(function(th) sf.ScrollBarImageColor3 = th.ScrollBar end)
    return sf
end

-- Card (grouped content block)
local function makeCard(parent, order)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, -6, 0, 0)
    c.AutomaticSize  = Enum.AutomaticSize.Y
    c.BackgroundColor3 = T.Secondary
    c.LayoutOrder    = order or 0
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 9)
    local cst = Instance.new("UIStroke", c); cst.Color = T.Stroke
    cst.Thickness = 1; cst.Transparency = 0.45
    local ul = Instance.new("UIListLayout", c)
    ul.Padding = UDim.new(0, 6); ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local cp = Instance.new("UIPadding", c)
    cp.PaddingTop = UDim.new(0, 9); cp.PaddingBottom = UDim.new(0, 9)
    cp.PaddingLeft = UDim.new(0, 10); cp.PaddingRight = UDim.new(0, 10)
    onThemeChange(function(th)
        c.BackgroundColor3 = th.Secondary; cst.Color = th.Stroke
    end)
    return c
end

-- Section header inside a card
local function makeSectionHeader(parent, icon, label, order)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. "  " .. label
    lbl.TextColor3 = T.Accent; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    onThemeChange(function(th) lbl.TextColor3 = th.Accent end)
    return lbl
end

-- Info row (label: value)
local function makeInfoRow(parent, labelTxt, valueTxt, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1; row.LayoutOrder = order or 0
    local ll = Instance.new("TextLabel", row)
    ll.Size = UDim2.new(0.46, 0, 1, 0); ll.BackgroundTransparency = 1
    ll.Text = labelTxt; ll.TextColor3 = T.TextDim; ll.Font = Enum.Font.Gotham
    ll.TextSize = 12; ll.TextXAlignment = Enum.TextXAlignment.Left
    local vl = Instance.new("TextLabel", row)
    vl.Size = UDim2.new(0.54, 0, 1, 0); vl.Position = UDim2.new(0.46, 0, 0, 0)
    vl.BackgroundTransparency = 1; vl.Text = tostring(valueTxt)
    vl.TextColor3 = T.Text; vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12; vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.TextTruncate = Enum.TextTruncate.AtEnd
    onThemeChange(function(th) ll.TextColor3 = th.TextDim; vl.TextColor3 = th.Text end)
    return vl  -- return value label for later updating
end

-- Toggle row
local function makeToggle(parent, label, default, onChanged, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34); row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0

    local ll = Instance.new("TextLabel", row)
    ll.Size = UDim2.new(1, -58, 1, 0); ll.BackgroundTransparency = 1
    ll.Text = label; ll.TextColor3 = T.Text; ll.Font = Enum.Font.Gotham
    ll.TextSize = 13; ll.TextXAlignment = Enum.TextXAlignment.Left
    ll.TextWrapped = true

    local track = Instance.new("TextButton", row)
    track.Size = UDim2.new(0, 48, 0, 26); track.AnchorPoint = Vector2.new(1, 0.5)
    track.Position = UDim2.new(1, 0, 0.5, 0)
    track.BackgroundColor3 = default and T.ToggleOn or T.ToggleOff
    track.Text = ""; track.BorderSizePixel = 0; track.AutoButtonColor = false
    Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 20, 0, 20); knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = default and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)

    local state = default or false

    local function setState(val, silent)
        state = val
        TweenService:Create(track, TweenInfo.new(0.2),
            { BackgroundColor3 = val and T.ToggleOn or T.ToggleOff }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2),
            { Position = val and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }):Play()
        if onChanged and not silent then onChanged(val) end
    end

    track.MouseButton1Click:Connect(function()
        setState(not state)
        showNotification(
            label .. (state and " Enabled!" or " Disabled!"),
            state and T.Accent or Color3.fromRGB(210, 65, 65)
        )
    end)

    onThemeChange(function(th)
        ll.TextColor3 = th.Text
        track.BackgroundColor3 = state and th.ToggleOn or th.ToggleOff
    end)

    return {
        getState  = function() return state end,
        setState  = setState,
    }
end

-- Slider row
local function makeSlider(parent, label, minV, maxV, defaultV, onChanged, order)
    local cont = Instance.new("Frame", parent)
    cont.Size = UDim2.new(1, 0, 0, 54); cont.BackgroundTransparency = 1
    cont.LayoutOrder = order or 0

    local ll = Instance.new("TextLabel", cont)
    ll.Size = UDim2.new(0.72, 0, 0, 22); ll.BackgroundTransparency = 1
    ll.Text = label; ll.TextColor3 = T.TextDim; ll.Font = Enum.Font.Gotham
    ll.TextSize = 12; ll.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", cont)
    vl.Size = UDim2.new(0.28, 0, 0, 22); vl.Position = UDim2.new(0.72, 0, 0, 0)
    vl.BackgroundTransparency = 1; vl.Text = tostring(defaultV)
    vl.TextColor3 = T.Accent; vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12; vl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", cont)
    track.Size = UDim2.new(1, 0, 0, 7); track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = T.SliderTrack; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultV - minV) / math.max(maxV - minV, 1), 0, 1, 0)
    fill.BackgroundColor3 = T.SliderFill; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0.5, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 17, 0, 17); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultV - minV) / math.max(maxV - minV, 1), 0, 0.5, 0)
    knob.BackgroundColor3 = T.Accent; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0.5, 0)

    local curVal  = defaultV
    local sliding = false
    local curMax  = maxV

    local function updateFromX(x)
        local abs = track.AbsolutePosition; local sz = track.AbsoluteSize
        local r = math.clamp((x - abs.X) / math.max(sz.X, 1), 0, 1)
        curVal = math.round(minV + r * (curMax - minV))
        local fr = (curVal - minV) / math.max(curMax - minV, 1)
        fill.Size = UDim2.new(fr, 0, 1, 0)
        knob.Position = UDim2.new(fr, 0, 0.5, 0)
        vl.Text = tostring(curVal)
        if onChanged then onChanged(curVal) end
    end

    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            sliding = true; updateFromX(inp.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if sliding and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(inp.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    onThemeChange(function(th)
        ll.TextColor3 = th.TextDim; vl.TextColor3 = th.Accent
        track.BackgroundColor3 = th.SliderTrack; fill.BackgroundColor3 = th.SliderFill
        knob.BackgroundColor3  = th.Accent
    end)

    return {
        getValue = function() return curVal end,
        setMax   = function(m)
            curMax = math.max(m, minV + 1)
            local fr = (curVal - minV) / math.max(curMax - minV, 1)
            fill.Size  = UDim2.new(fr, 0, 1, 0)
            knob.Position = UDim2.new(fr, 0, 0.5, 0)
        end,
        setValue = function(v)
            curVal = math.clamp(v, minV, curMax)
            local fr = (curVal - minV) / math.max(curMax - minV, 1)
            fill.Size = UDim2.new(fr, 0, 1, 0)
            knob.Position = UDim2.new(fr, 0, 0.5, 0)
            vl.Text = tostring(curVal)
        end,
    }
end

-- Small action button
local function makeButton(parent, txt, onClick, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = T.AccentDark
    btn.Text = txt; btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
    btn.BorderSizePixel = 0; btn.LayoutOrder = order or 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    btn.MouseButton1Click:Connect(onClick)
    onThemeChange(function(th) btn.BackgroundColor3 = th.AccentDark end)
    return btn
end

-- Separator line
local function makeSep(parent, order)
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, 0, 0, 1); s.BackgroundColor3 = T.Stroke
    s.BackgroundTransparency = 0.4; s.BorderSizePixel = 0; s.LayoutOrder = order or 0
    onThemeChange(function(th) s.BackgroundColor3 = th.Stroke end)
end

-- ============================================================
--  ████████╗ █████╗ ██████╗ ███████╗
--     ██╔══╝██╔══██╗██╔══██╗██╔════╝
--     ██║   ███████║██████╔╝███████╗
--     ██║   ██╔══██║██╔══██╗╚════██║
--     ██║   ██║  ██║██████╔╝███████║
--     ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝
--                  HOME TAB
-- ============================================================
local homeScroll = makeScrollFrame(tabFrames["Home"])

-- ── User Card ──────────────────────────────────────────────
local userCard = makeCard(homeScroll, 1)
makeSectionHeader(userCard, "👤", "Your Profile", 0)

-- Profile picture
local pfpFrame = Instance.new("Frame", userCard)
pfpFrame.Size = UDim2.new(1, 0, 0, 78); pfpFrame.BackgroundTransparency = 1; pfpFrame.LayoutOrder = 1
local pfpImg = Instance.new("ImageLabel", pfpFrame)
pfpImg.AnchorPoint = Vector2.new(0.5, 0); pfpImg.Position = UDim2.new(0.5, 0, 0, 3)
pfpImg.Size = UDim2.new(0, 68, 0, 68); pfpImg.BackgroundColor3 = T.Secondary
pfpImg.Image = "rbxassetid://0"
Instance.new("UICorner", pfpImg).CornerRadius = UDim.new(0.5, 0)
local pfpStroke = Instance.new("UIStroke", pfpImg); pfpStroke.Color = T.Accent; pfpStroke.Thickness = 2.5
onThemeChange(function(th) pfpStroke.Color = th.Accent; pfpImg.BackgroundColor3 = th.Secondary end)

task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok then pfpImg.Image = url end
end)

makeInfoRow(userCard, "Username",     "@" .. LocalPlayer.Name, 2)
makeInfoRow(userCard, "Display Name", LocalPlayer.DisplayName, 3)
makeInfoRow(userCard, "User ID",      LocalPlayer.UserId,      4)
makeInfoRow(userCard, "Account Age",  LocalPlayer.AccountAge .. " days", 5)

-- ── Game Info Card ─────────────────────────────────────────
local gameCard = makeCard(homeScroll, 2)
makeSectionHeader(gameCard, "🎮", "Game Info", 0)

local gameNameLbl = makeInfoRow(gameCard, "Game Name", "Loading…", 1)
task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    gameNameLbl.Text = ok and info.Name or tostring(game.PlaceId)
end)
makeInfoRow(gameCard, "Place ID",   game.PlaceId, 2)
makeInfoRow(gameCard, "Universe ID", game.GameId,  3)

-- ── Server Info Card ───────────────────────────────────────
local serverCard = makeCard(homeScroll, 3)
makeSectionHeader(serverCard, "🖥️", "Server Info", 0)

local playerCountLbl = makeInfoRow(serverCard, "Players",
    #Players:GetPlayers() .. "/" .. Players.MaxPlayers, 1)
local serverIdLbl = makeInfoRow(serverCard, "Server ID",
    (game.JobId ~= "" and game.JobId:sub(1,14) .. "…") or "Private", 2)
local uptimeLbl   = makeInfoRow(serverCard, "Uptime", "00:00:00", 3)

local serverStart = os.time()
task.spawn(function()
    while task.wait(1) do
        local e  = os.time() - serverStart
        local h  = math.floor(e / 3600)
        local m  = math.floor((e % 3600) / 60)
        local s  = e % 60
        uptimeLbl.Text = string.format("%02d:%02d:%02d", h, m, s)
    end
end)
Players.PlayerAdded:Connect(function()
    playerCountLbl.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
end)
Players.PlayerRemoving:Connect(function()
    task.wait()
    playerCountLbl.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
end)

-- ── Script Stats Card ──────────────────────────────────────
local statsCard = makeCard(homeScroll, 4)
makeSectionHeader(statsCard, "📊", "Script Stats", 0)
makeInfoRow(statsCard, "Times Executed", tostring(execCount), 1)
local scriptTimeLbl = makeInfoRow(statsCard, "Script Uptime", "00:00:00", 2)

task.spawn(function()
    while task.wait(1) do
        local e = os.time() - execStartTime
        scriptTimeLbl.Text = string.format("%02d:%02d:%02d",
            math.floor(e/3600), math.floor((e%3600)/60), e%60)
    end
end)

-- ============================================================
--  ███╗   ███╗ █████╗ ██╗███╗   ██╗
--  ████╗ ████║██╔══██╗██║████╗  ██║
--  ██╔████╔██║███████║██║██╔██╗ ██║
--  ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
--  ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
--  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
--                MAIN TAB
-- ============================================================
local mainScroll = makeScrollFrame(tabFrames["Main"])

-- Shared brainrot state
local selectedBrainrots  = {}
local spawnDetectorConns = {}

-- ── Brainrot detector helper ───────────────────────────────
local function restartBrainrotDetector()
    for _, c in ipairs(spawnDetectorConns) do pcall(function() c:Disconnect() end) end
    spawnDetectorConns = {}
    if #selectedBrainrots == 0 then return end

    local ok, brainrotFolder = pcall(function()
        return workspace:WaitForChild("GameFolder", 8):WaitForChild("Brainrots", 8)
    end)
    if not ok or not brainrotFolder then return end

    local function onModelAdded(model)
        if not model:IsA("Model") then return end
        if not table.find(selectedBrainrots, model.Name) then return end

        -- Spawn notification banner
        task.spawn(function()
            local ng = Instance.new("ScreenGui")
            ng.Name = "PCSpawnBanner"; ng.ResetOnSpawn = false
            ng.IgnoreGuiInset = true; ng.DisplayOrder = 500
            pcall(function() ng.Parent = CoreGui end)

            local f = Instance.new("Frame", ng)
            f.AnchorPoint = Vector2.new(0.5, 0)
            f.Position    = UDim2.new(0.5, 0, -0.12, 0)
            f.Size        = UDim2.new(0, 320, 0, 58)
            f.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
            local st2 = Instance.new("UIStroke", f); st2.Color = T.Accent; st2.Thickness = 2

            local txt = Instance.new("TextLabel", f)
            txt.Size = UDim2.new(1, -16, 1, 0); txt.Position = UDim2.new(0, 8, 0, 0)
            txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            txt.Font = Enum.Font.GothamBold; txt.TextSize = 15; txt.TextWrapped = true
            txt.Text = "🌀 A " .. model.Name .. " Has Spawned!"

            TweenService:Create(f, TweenInfo.new(0.45, Enum.EasingStyle.Back),
                { Position = UDim2.new(0.5, 0, 0.06, 0) }):Play()

            -- Highlight if enabled
            if highlightBrainrotToggleRef and highlightBrainrotToggleRef.getState() then
                local hl = Instance.new("SelectionBox", CoreGui)
                hl.Adornee          = model
                hl.Color3           = T.Accent
                hl.LineThickness    = 0.12
                hl.SurfaceColor3    = T.Accent
                hl.SurfaceTransparency = 0.7
                model.AncestryChanged:Connect(function()
                    if not model:IsDescendantOf(workspace) then
                        pcall(function() hl:Destroy() end)
                    end
                end)
            end

            -- Teleport if enabled
            if teleportToggleRef and teleportToggleRef.getState() then
                task.spawn(function()
                    task.wait(0.15)
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local pp = model.PrimaryPart or model:FindFirstChildOfClass("BasePart")
                    if pp then
                        hrp.CFrame = pp.CFrame * CFrame.new(0, 5, 0)
                    end
                end)
            end

            task.wait(3.6)
            TweenService:Create(f, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                { Position = UDim2.new(0.5, 0, -0.12, 0) }):Play()
            task.wait(0.42)
            pcall(function() ng:Destroy() end)
        end)
    end

    -- Check existing
    for _, child in ipairs(brainrotFolder:GetChildren()) do
        pcall(onModelAdded, child)
    end
    local conn = brainrotFolder.ChildAdded:Connect(function(m) pcall(onModelAdded, m) end)
    table.insert(spawnDetectorConns, conn)
end

-- ── Brainrot Selector Card ─────────────────────────────────
local dropCard = makeCard(mainScroll, 1)
makeSectionHeader(dropCard, "🌀", "Select Brainrots to Track", 0)

-- Search box
local searchBox = Instance.new("TextBox", dropCard)
searchBox.Size = UDim2.new(1, 0, 0, 32); searchBox.LayoutOrder = 1
searchBox.BackgroundColor3 = T.Background
searchBox.PlaceholderText  = "🔍 Search brainrots…"
searchBox.Text = ""; searchBox.TextColor3 = T.Text
searchBox.PlaceholderColor3 = T.TextDim
searchBox.Font = Enum.Font.Gotham; searchBox.TextSize = 13
searchBox.ClearTextOnFocus = false
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 7)
local sbSt = Instance.new("UIStroke", searchBox); sbSt.Color = T.Stroke
local sbPad = Instance.new("UIPadding", searchBox)
sbPad.PaddingLeft = UDim.new(0, 8); sbPad.PaddingRight = UDim.new(0, 8)
onThemeChange(function(th)
    searchBox.BackgroundColor3 = th.Background; searchBox.TextColor3 = th.Text
    searchBox.PlaceholderColor3 = th.TextDim;   sbSt.Color = th.Stroke
end)

-- Dropdown list
local dropList = Instance.new("ScrollingFrame", dropCard)
dropList.Size = UDim2.new(1, 0, 0, 140); dropList.LayoutOrder = 2
dropList.BackgroundColor3 = T.Background
dropList.ScrollBarThickness = 4; dropList.ScrollBarImageColor3 = T.ScrollBar
dropList.CanvasSize = UDim2.new(0, 0, 0, 0); dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
dropList.BorderSizePixel = 0
Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 7)
local dlSt = Instance.new("UIStroke", dropList); dlSt.Color = T.Stroke
local dlUL = Instance.new("UIListLayout", dropList)
dlUL.Padding = UDim.new(0, 2); dlUL.SortOrder = Enum.SortOrder.LayoutOrder
local dlPad = Instance.new("UIPadding", dropList)
dlPad.PaddingTop = UDim.new(0, 3); dlPad.PaddingBottom = UDim.new(0, 3)
dlPad.PaddingLeft = UDim.new(0, 4); dlPad.PaddingRight = UDim.new(0, 4)
onThemeChange(function(th)
    dropList.BackgroundColor3 = th.Background
    dropList.ScrollBarImageColor3 = th.ScrollBar; dlSt.Color = th.Stroke
end)

-- Selected tags area
local selHeaderLbl = Instance.new("TextLabel", dropCard)
selHeaderLbl.Size = UDim2.new(1, 0, 0, 16); selHeaderLbl.LayoutOrder = 3
selHeaderLbl.BackgroundTransparency = 1; selHeaderLbl.Text = "Selected:"
selHeaderLbl.TextColor3 = T.TextDim; selHeaderLbl.Font = Enum.Font.Gotham
selHeaderLbl.TextSize = 11; selHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
onThemeChange(function(th) selHeaderLbl.TextColor3 = th.TextDim end)

local tagsFrame = Instance.new("Frame", dropCard)
tagsFrame.Size = UDim2.new(1, 0, 0, 0); tagsFrame.AutomaticSize = Enum.AutomaticSize.Y
tagsFrame.BackgroundTransparency = 1; tagsFrame.LayoutOrder = 4
local tagFlow = Instance.new("UIFlowLayout", tagsFrame)
tagFlow.Padding = UDim2.new(0, 4, 0, 4)
tagFlow.HorizontalAlignment = Enum.HorizontalAlignment.Left

-- All dropdown item buttons
local allDropButtons = {}

local function updateDropFilter(filter)
    filter = filter:lower()
    for _, btn in ipairs(allDropButtons) do
        btn.Visible = filter == "" or btn.Name:lower():find(filter, 1, true) ~= nil
    end
end

local function removeSelectedTag(name)
    local tag = tagsFrame:FindFirstChild("tag_" .. name)
    if tag then tag:Destroy() end
    local idx = table.find(selectedBrainrots, name)
    if idx then table.remove(selectedBrainrots, idx) end
    for _, btn in ipairs(allDropButtons) do
        if btn.Name == name then
            btn.BackgroundColor3 = T.DropdownBg; btn.TextColor3 = T.Text
        end
    end
    restartBrainrotDetector()
end

local function addSelectedTag(name)
    local tag = Instance.new("Frame", tagsFrame)
    tag.Name = "tag_" .. name
    tag.Size = UDim2.new(0, 0, 0, 26); tag.AutomaticSize = Enum.AutomaticSize.X
    tag.BackgroundColor3 = T.AccentDark
    Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 5)
    local tl = Instance.new("UIListLayout", tag)
    tl.FillDirection = Enum.FillDirection.Horizontal; tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.Padding = UDim.new(0, 3)
    local tp = Instance.new("UIPadding", tag)
    tp.PaddingLeft = UDim.new(0, 6); tp.PaddingRight = UDim.new(0, 4)

    local tnl = Instance.new("TextLabel", tag)
    tnl.BackgroundTransparency = 1; tnl.Text = name
    tnl.TextColor3 = Color3.fromRGB(255,255,255); tnl.Font = Enum.Font.Gotham
    tnl.TextSize = 11; tnl.Size = UDim2.new(0, 0, 1, 0); tnl.AutomaticSize = Enum.AutomaticSize.X

    local xb = Instance.new("TextButton", tag)
    xb.BackgroundTransparency = 1; xb.Text = "✕"
    xb.TextColor3 = Color3.fromRGB(255, 100, 100); xb.Font = Enum.Font.GothamBold
    xb.TextSize = 10; xb.Size = UDim2.new(0, 14, 1, 0)
    xb.MouseButton1Click:Connect(function() removeSelectedTag(name) end)

    onThemeChange(function(th) tag.BackgroundColor3 = th.AccentDark end)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateDropFilter(searchBox.Text)
end)

-- Load brainrots async
task.spawn(function()
    local ok, brainrotRS = pcall(function()
        return ReplicatedStorage:WaitForChild("Brainrots", 15)
    end)
    if not ok or not brainrotRS then
        local el = Instance.new("TextLabel", dropList)
        el.Size = UDim2.new(1, 0, 0, 28); el.BackgroundTransparency = 1
        el.Text = "⚠️ Brainrots folder not found"; el.TextColor3 = T.TextDim
        el.Font = Enum.Font.Gotham; el.TextSize = 12
        return
    end

    local names = {}
    for _, folder in ipairs(brainrotRS:GetChildren()) do
        if folder:IsA("Folder") then
            for _, model in ipairs(folder:GetChildren()) do
                if not table.find(names, model.Name) then
                    table.insert(names, model.Name)
                end
            end
        end
    end
    table.sort(names)

    for i, name in ipairs(names) do
        local btn = Instance.new("TextButton", dropList)
        btn.Name = name; btn.LayoutOrder = i
        btn.Size = UDim2.new(1, -6, 0, 28)
        btn.BackgroundColor3 = T.DropdownBg; btn.Text = name
        btn.TextColor3 = T.Text; btn.Font = Enum.Font.Gotham
        btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0; btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local bp = Instance.new("UIPadding", btn)
        bp.PaddingLeft = UDim.new(0, 8)

        table.insert(allDropButtons, btn)

        btn.MouseButton1Click:Connect(function()
            if table.find(selectedBrainrots, name) then
                removeSelectedTag(name)
            else
                table.insert(selectedBrainrots, name)
                btn.BackgroundColor3 = T.Accent
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                addSelectedTag(name)
                restartBrainrotDetector()
            end
        end)

        onThemeChange(function(th)
            if not table.find(selectedBrainrots, name) then
                btn.BackgroundColor3 = th.DropdownBg; btn.TextColor3 = th.Text
            end
        end)
    end
end)

makeSep(mainScroll, 2)

-- ── Auto Collect Cash ──────────────────────────────────────
local acCard = makeCard(mainScroll, 3)
makeSectionHeader(acCard, "💰", "Auto Collect Cash", 0)

local autoCollectConn = nil
makeToggle(acCard, "Auto Collect Cash", false, function(val)
    if autoCollectConn then
        pcall(function() autoCollectConn:Disconnect() end)
        autoCollectConn = nil
    end
    if not val then return end

    task.spawn(function()
        local ok2, plotsFolder = pcall(function()
            return workspace:WaitForChild("GameFolder", 5):WaitForChild("Plots", 5)
        end)
        if not ok2 or not plotsFolder then return end

        -- Find our base via YourBaseAtt + Title == "YOUR BASE"
        local myBaseMod = nil
        for _, desc in ipairs(plotsFolder:GetDescendants()) do
            if desc:IsA("Attachment") and desc.Name == "YourBaseAtt" then
                for _, d2 in ipairs(desc:GetDescendants()) do
                    if d2:IsA("TextLabel") and d2.Name == "Title" and d2.Text == "YOUR BASE" then
                        myBaseMod = desc:FindFirstAncestorOfClass("Model")
                        break
                    end
                end
            end
            if myBaseMod then break end
        end
        if not myBaseMod then return end

        local placesFolder = myBaseMod:FindFirstChild("Places", true)
        if not placesFolder then return end

        local touchParts = {}
        for _, d in ipairs(placesFolder:GetDescendants()) do
            if d.ClassName == "TouchTransmitter" and d.Parent and d.Parent:IsA("BasePart") then
                table.insert(touchParts, d.Parent)
            end
        end

        autoCollectConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, part in ipairs(touchParts) do
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(hrp, part, 0)
                    end
                end)
            end
        end)
    end)
end, 1)

-- ============================================================
--  ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗
--  ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗
--  ██████╔╝██║     ███████║ ╚████╔╝ █████╗  ██████╔╝
--  ██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗
--  ██║     ███████╗██║  ██║   ██║   ███████╗██║  ██║
--  ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
--               PLAYER TAB
-- ============================================================
local playerTabFrame = tabFrames["Player"]

-- ── Warning Overlay ────────────────────────────────────────
local warningOverlay = Instance.new("Frame", playerTabFrame)
warningOverlay.Size = UDim2.new(1, 0, 1, 0); warningOverlay.ZIndex = 20
warningOverlay.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
warningOverlay.BackgroundTransparency = 0.06
Instance.new("UICorner", warningOverlay).CornerRadius = UDim.new(0, 10)

local warnUL = Instance.new("UIListLayout", warningOverlay)
warnUL.HorizontalAlignment = Enum.HorizontalAlignment.Center
warnUL.VerticalAlignment   = Enum.VerticalAlignment.Center
warnUL.Padding = UDim.new(0, 12)
local warnPad = Instance.new("UIPadding", warningOverlay)
warnPad.PaddingLeft = UDim.new(0, 18); warnPad.PaddingRight = UDim.new(0, 18)

local warnTitle = Instance.new("TextLabel", warningOverlay)
warnTitle.Size = UDim2.new(1, 0, 0, 36); warnTitle.BackgroundTransparency = 1
warnTitle.Text = "⚠️"; warnTitle.TextColor3 = Color3.fromRGB(255, 210, 50)
warnTitle.Font = Enum.Font.GothamBold; warnTitle.TextSize = 30

local warnText = Instance.new("TextLabel", warningOverlay)
warnText.Size = UDim2.new(1, 0, 0, 72); warnText.BackgroundTransparency = 1
warnText.TextColor3 = Color3.fromRGB(255, 230, 120); warnText.Font = Enum.Font.GothamBold
warnText.TextSize = 13; warnText.TextWrapped = true
warnText.Text = "⚠️ Warning: Using These Features Could Get You Banned, Use At Your Own Risk. ⚠️"

local warnBtnRow = Instance.new("Frame", warningOverlay)
warnBtnRow.Size = UDim2.new(0.8, 0, 0, 38); warnBtnRow.BackgroundTransparency = 1
local wbrUL = Instance.new("UIListLayout", warnBtnRow)
wbrUL.FillDirection = Enum.FillDirection.Horizontal
wbrUL.HorizontalAlignment = Enum.HorizontalAlignment.Center; wbrUL.Padding = UDim.new(0, 12)

local okBtn = Instance.new("TextButton", warnBtnRow)
okBtn.Size = UDim2.new(0, 110, 1, 0); okBtn.BackgroundColor3 = Color3.fromRGB(0, 185, 70)
okBtn.Text = "✓  Ok"; okBtn.TextColor3 = Color3.fromRGB(255,255,255)
okBtn.Font = Enum.Font.GothamBold; okBtn.TextSize = 14; okBtn.AutoButtonColor = false
Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 7)

local goBackBtn = Instance.new("TextButton", warnBtnRow)
goBackBtn.Size = UDim2.new(0, 110, 1, 0); goBackBtn.BackgroundColor3 = Color3.fromRGB(200, 48, 48)
goBackBtn.Text = "✕  Go Back"; goBackBtn.TextColor3 = Color3.fromRGB(255,255,255)
goBackBtn.Font = Enum.Font.GothamBold; goBackBtn.TextSize = 14; goBackBtn.AutoButtonColor = false
Instance.new("UICorner", goBackBtn).CornerRadius = UDim.new(0, 7)

okBtn.MouseButton1Click:Connect(function()
    playerWarningAccepted = true
    TweenService:Create(warningOverlay, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
    for _, d in ipairs(warningOverlay:GetDescendants()) do
        if d:IsA("GuiObject") then
            TweenService:Create(d, TweenInfo.new(0.3), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
        end
    end
    task.delay(0.32, function() warningOverlay.Visible = false end)
end)

goBackBtn.MouseButton1Click:Connect(function()
    switchTab("Home")
end)

-- ── Player Scroll ──────────────────────────────────────────
local playerScroll = makeScrollFrame(playerTabFrame)
playerScroll.ZIndex = 5

-- ── Speed Boost ────────────────────────────────────────────
local speedCard = makeCard(playerScroll, 1)
makeSectionHeader(speedCard, "🏃", "Speed Boost", 0)

-- Max speed input row
local speedMaxRow = Instance.new("Frame", speedCard)
speedMaxRow.Size = UDim2.new(1, 0, 0, 30); speedMaxRow.BackgroundTransparency = 1; speedMaxRow.LayoutOrder = 1
local speedMaxLbl = Instance.new("TextLabel", speedMaxRow)
speedMaxLbl.Size = UDim2.new(0.6, 0, 1, 0); speedMaxLbl.BackgroundTransparency = 1
speedMaxLbl.Text = "Max Speed Value:"; speedMaxLbl.TextColor3 = T.TextDim
speedMaxLbl.Font = Enum.Font.Gotham; speedMaxLbl.TextSize = 12
speedMaxLbl.TextXAlignment = Enum.TextXAlignment.Left
onThemeChange(function(th) speedMaxLbl.TextColor3 = th.TextDim end)

local speedMaxInput = Instance.new("TextBox", speedMaxRow)
speedMaxInput.Size = UDim2.new(0, 72, 0, 26); speedMaxInput.AnchorPoint = Vector2.new(1, 0.5)
speedMaxInput.Position = UDim2.new(1, 0, 0.5, 0)
speedMaxInput.BackgroundColor3 = T.Background; speedMaxInput.Text = "100"
speedMaxInput.TextColor3 = T.Text; speedMaxInput.Font = Enum.Font.Gotham; speedMaxInput.TextSize = 12
Instance.new("UICorner", speedMaxInput).CornerRadius = UDim.new(0, 6)
local smiSt = Instance.new("UIStroke", speedMaxInput); smiSt.Color = T.Stroke
onThemeChange(function(th)
    speedMaxInput.BackgroundColor3 = th.Background; speedMaxInput.TextColor3 = th.Text; smiSt.Color = th.Stroke
end)

local speedSlider = makeSlider(speedCard, "Walk Speed", 16, 100, 32, nil, 2)

speedMaxInput:GetPropertyChangedSignal("Text"):Connect(function()
    local v = tonumber(speedMaxInput.Text)
    if v and v > 16 then speedSlider.setMax(v) end
end)

local speedToggle = makeToggle(speedCard, "Speed Boost", false, function(val)
    local char = LocalPlayer.Character; if not char then return end
    local hum  = char:FindFirstChild("Humanoid"); if not hum then return end
    if val then
        hum.WalkSpeed = speedSlider.getValue()
    else
        local ok3, hudSpd = pcall(function()
            return LocalPlayer.PlayerGui:WaitForChild("HUD", 1):WaitForChild("Speed", 1)
        end)
        if ok3 and hudSpd then
            local n = tonumber(hudSpd.Text:match("%d+%.?%d*"))
            hum.WalkSpeed = n or 16
        else
            hum.WalkSpeed = 16
        end
    end
end, 3)

-- ── Jump Boost ─────────────────────────────────────────────
local jumpCard = makeCard(playerScroll, 2)
makeSectionHeader(jumpCard, "🦘", "Jump Boost", 0)

local jumpSlider = makeSlider(jumpCard, "Jump Power", 30, 200, 50, nil, 1)

local jumpToggle = makeToggle(jumpCard, "Jump Boost", false, function(val)
    local char = LocalPlayer.Character; if not char then return end
    local hum  = char:FindFirstChild("Humanoid"); if not hum then return end
    if val then
        hum.JumpPower = jumpSlider.getValue()
    else
        local ok4, hudJmp = pcall(function()
            return LocalPlayer.PlayerGui:WaitForChild("HUD", 1):WaitForChild("Jump", 1)
        end)
        if ok4 and hudJmp then
            local n = tonumber(hudJmp.Text:match("%d+%.?%d*"))
            if n then
                hum.JumpPower = 30 + n * (10 / 3)
            else
                hum.JumpPower = 30
            end
        else
            hum.JumpPower = 30
        end
    end
end, 2)

-- Re-apply on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.6)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    if speedToggle.getState() then hum.WalkSpeed = speedSlider.getValue() end
    if jumpToggle.getState()  then hum.JumpPower  = jumpSlider.getValue()  end
end)

-- ── Godmode ────────────────────────────────────────────────
local godCard = makeCard(playerScroll, 3)
makeSectionHeader(godCard, "🛡️", "Godmode (Lava)", 0)

local lavaConns = {}
local godToggle = makeToggle(godCard, "Godmode", false, function(val)
    -- Clear old connections
    for _, c in ipairs(lavaConns) do pcall(function() c:Disconnect() end) end
    lavaConns = {}

    if not val then return end

    task.spawn(function()
        local ok5, lavas = pcall(function()
            return workspace:WaitForChild("GameFolder", 5):WaitForChild("Lavas", 5)
        end)
        if not ok5 or not lavas then return end

        local RESPAWN_POS = Vector3.new(156.999, 4.762, 39.935)

        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp  = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- Monitor if we get teleported to the respawn position and undo it
        local lastPos = hrp.CFrame
        local godConn = RunService.Heartbeat:Connect(function()
            local curChar = LocalPlayer.Character
            if not curChar then return end
            local curHRP = curChar:FindFirstChild("HumanoidRootPart")
            if not curHRP then return end

            local diff = (curHRP.Position - RESPAWN_POS).Magnitude
            if diff < 3 then
                -- We got teleported by lava – revert
                curHRP.CFrame = lastPos
            else
                lastPos = curHRP.CFrame
            end
        end)
        table.insert(lavaConns, godConn)

        -- Also handle respawn
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            if not godToggle.getState() then return end
            task.wait(0.4)
            local nhrp = newChar:FindFirstChild("HumanoidRootPart")
            if nhrp then lastPos = nhrp.CFrame end
        end)
    end)
end, 1)

-- ── Flight ─────────────────────────────────────────────────
local flightCard = makeCard(playerScroll, 4)
makeSectionHeader(flightCard, "✈️", "Flight", 0)

-- Mobile buttons gui
local flightMobileGui = Instance.new("ScreenGui")
flightMobileGui.Name = "PCFlightMobile"; flightMobileGui.ResetOnSpawn = false
flightMobileGui.IgnoreGuiInset = true; flightMobileGui.Enabled = false
flightMobileGui.DisplayOrder = 90
pcall(function() flightMobileGui.Parent = CoreGui end)

local function makeMobileFlightBtn(txt, posX, posY)
    local b = Instance.new("TextButton", flightMobileGui)
    b.Size = UDim2.new(0, 62, 0, 62)
    b.Position = UDim2.new(posX, -31, posY, -31)
    b.BackgroundColor3 = T.Accent; b.BackgroundTransparency = 0.28
    b.Text = txt; b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold; b.TextSize = 22
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0.5, 0)
    onThemeChange(function(th) b.BackgroundColor3 = th.Accent end)
    return b
end

local mUpBtn   = makeMobileFlightBtn("▲", 0.88, 0.44)
local mDownBtn = makeMobileFlightBtn("▼", 0.88, 0.58)

local upHeld   = false
local downHeld = false

mUpBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then upHeld = true end
end)
mUpBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then upHeld = false end
end)
mDownBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then downHeld = true end
end)
mDownBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then downHeld = false end
end)

local FLIGHT_SPD = 52
local flightConn = nil

local flightToggle = makeToggle(flightCard, "Flight", false, function(val)
    flightMobileGui.Enabled = val

    if flightConn then flightConn:Disconnect(); flightConn = nil end

    if not val then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
        end
        return
    end

    flightConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character; if not char then return end
        local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum  = char:FindFirstChild("Humanoid"); if not hum then return end

        local camCF   = Camera.CFrame
        local camLook = camCF.LookVector
        local camRight= camCF.RightVector

        -- Keyboard input
        local fwd, rt, up = 0, 0, 0
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then fwd =  1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then fwd = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then rt  = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then rt  =  1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or upHeld   then up =  1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or downHeld then up = -1 end

        -- Mobile: use humanoid MoveDirection for horizontal
        local md = hum.MoveDirection
        if md.Magnitude > 0.1 then
            local flat = Vector3.new(md.X, 0, md.Z)
            if flat.Magnitude > 0 then
                flat = flat.Unit
                fwd = -flat:Dot(camCF.LookVector)
                rt  =  flat:Dot(camCF.RightVector)
            end
        end

        -- Build velocity (camera-relative)
        local vel = camLook * fwd * FLIGHT_SPD
                  + camRight * rt * FLIGHT_SPD
                  + Vector3.new(0, up * FLIGHT_SPD, 0)

        if vel.Magnitude > 0.3 then
            hrp.AssemblyLinearVelocity = vel
            -- Face direction of horizontal movement
            local hz = Vector3.new(vel.X, 0, vel.Z)
            if hz.Magnitude > 0.5 then
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + hz)
            end
        else
            -- Hover: kill gravity, slight damping
            hrp.AssemblyLinearVelocity = Vector3.new(
                hrp.AssemblyLinearVelocity.X * 0.75,
                0,
                hrp.AssemblyLinearVelocity.Z * 0.75
            )
        end
    end)
end, 1)

-- ── Teleport to Brainrots ──────────────────────────────────
local teleCard = makeCard(playerScroll, 5)
makeSectionHeader(teleCard, "🔮", "Teleport to Brainrots", 0)

local teleportToggleObj = makeToggle(teleCard, "Teleport to Selected Brainrots", false, nil, 1)
teleportToggleRef = teleportToggleObj   -- expose to Main tab spawn detector

-- ============================================================
--  ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗
--  ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║
--  ██║   ██║██║███████╗██║   ██║███████║██║
--  ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║
--   ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗
--    ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
--               VISUAL TAB
-- ============================================================
local visualScroll = makeScrollFrame(tabFrames["Visual"])

local visCard = makeCard(visualScroll, 1)
makeSectionHeader(visCard, "👁️", "Visuals", 0)

-- Highlight brainrots
local hlBrainrotToggle = makeToggle(visCard, "Highlight Selected Brainrots", false, nil, 1)
highlightBrainrotToggleRef = hlBrainrotToggle  -- expose to Main tab

makeSep(visCard, 2)

-- Highlight players
local playerHLItems = {}

local hlPlayerToggle = makeToggle(visCard, "Highlight Other Players", false, function(val)
    if not val then
        for _, item in ipairs(playerHLItems) do
            if typeof(item) == "Instance" then pcall(function() item:Destroy() end) end
            if typeof(item) == "RBXScriptConnection" then pcall(function() item:Disconnect() end) end
        end
        playerHLItems = {}
        return
    end

    local function attachHighlight(player)
        if player == LocalPlayer then return end
        local char = player.Character
        if not char then return end

        local hl = Instance.new("Highlight", CoreGui)
        hl.Name            = "PCPlayerHL_" .. player.UserId
        hl.Adornee         = char
        hl.FillColor        = Color3.fromRGB(0, 160, 255)
        hl.OutlineColor     = Color3.fromRGB(100, 210, 255)
        hl.FillTransparency = 0.52
        table.insert(playerHLItems, hl)

        local bb = Instance.new("BillboardGui", CoreGui)
        bb.Name = "PCPlayerBB_" .. player.UserId
        bb.AlwaysOnTop = true
        bb.Size        = UDim2.new(0, 155, 0, 48)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.Adornee     = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildOfClass("BasePart")
        table.insert(playerHLItems, bb)

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.48
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

        local nameLbl2 = Instance.new("TextLabel", bg)
        nameLbl2.Size = UDim2.new(1, -8, 0.55, 0); nameLbl2.Position = UDim2.new(0, 4, 0, 0)
        nameLbl2.BackgroundTransparency = 1; nameLbl2.Text = player.DisplayName
        nameLbl2.TextColor3 = Color3.fromRGB(255,255,255); nameLbl2.Font = Enum.Font.GothamBold
        nameLbl2.TextSize = 12; nameLbl2.TextTruncate = Enum.TextTruncate.AtEnd

        local distLbl2 = Instance.new("TextLabel", bg)
        distLbl2.Size = UDim2.new(1, -8, 0.45, 0); distLbl2.Position = UDim2.new(0, 4, 0.55, 0)
        distLbl2.BackgroundTransparency = 1; distLbl2.TextColor3 = Color3.fromRGB(200,200,200)
        distLbl2.Font = Enum.Font.Gotham; distLbl2.TextSize = 11; distLbl2.Text = "…"

        local distConn = RunService.Heartbeat:Connect(function()
            local mc = LocalPlayer.Character; local oc = player.Character
            if not mc or not oc then return end
            local mh = mc:FindFirstChild("HumanoidRootPart"); local oh = oc:FindFirstChild("HumanoidRootPart")
            if not mh or not oh then return end
            distLbl2.Text = math.floor((mh.Position - oh.Position).Magnitude) .. " studs"
        end)
        table.insert(playerHLItems, distConn)

        player.CharacterAdded:Connect(function(nc)
            task.wait(0.4)
            hl.Adornee = nc
            local nhrp = nc:FindFirstChild("HumanoidRootPart") or nc:FindFirstChildOfClass("BasePart")
            bb.Adornee = nhrp
        end)
    end

    for _, p in ipairs(Players:GetPlayers()) do pcall(attachHighlight, p) end
    local paConn = Players.PlayerAdded:Connect(function(p)
        task.wait(0.8)
        if hlPlayerToggle.getState() then pcall(attachHighlight, p) end
    end)
    table.insert(playerHLItems, paConn)
end, 3)

-- ============================================================
--  ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
--  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
--  ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
--  ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
--  ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
--  ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
--                     SETTINGS TAB
-- ============================================================
local settingsScroll = makeScrollFrame(tabFrames["Settings"])

-- ── Theme Selector ─────────────────────────────────────────
local themeCard = makeCard(settingsScroll, 1)
makeSectionHeader(themeCard, "🎨", "Theme", 0)

-- Preset theme buttons row
local themeRow = Instance.new("Frame", themeCard)
themeRow.Size = UDim2.new(1, 0, 0, 36); themeRow.BackgroundTransparency = 1; themeRow.LayoutOrder = 1
local trl = Instance.new("UIListLayout", themeRow)
trl.FillDirection = Enum.FillDirection.Horizontal; trl.Padding = UDim.new(0, 7)
trl.HorizontalAlignment = Enum.HorizontalAlignment.Left

local themePresetBtns = {}
for _, tName in ipairs({"Original", "Sky", "Lava"}) do
    local tb = Instance.new("TextButton", themeRow)
    tb.Size = UDim2.new(0, 82, 1, 0)
    tb.BackgroundColor3 = tName == currentThemeName and T.Accent or T.Secondary
    tb.Text = tName; tb.TextColor3 = Color3.fromRGB(255,255,255)
    tb.Font = Enum.Font.GothamBold; tb.TextSize = 12
    tb.AutoButtonColor = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
    themePresetBtns[tName] = tb

    tb.MouseButton1Click:Connect(function()
        applyTheme(tName)
        for nm, b in pairs(themePresetBtns) do
            b.BackgroundColor3 = nm == tName and T.Accent or T.Secondary
        end
        showNotification("🎨 Theme: " .. tName, T.Accent)
    end)

    onThemeChange(function(th)
        tb.BackgroundColor3 = tName == currentThemeName and th.Accent or th.Secondary
    end)
end

makeSep(themeCard, 2)

-- Customise info label
local custInfoLbl = Instance.new("TextLabel", themeCard)
custInfoLbl.Size = UDim2.new(1, 0, 0, 42); custInfoLbl.LayoutOrder = 3
custInfoLbl.BackgroundTransparency = 1
custInfoLbl.Text = "Can't Find The Theme You Want? Click the button below to Customise the UI To Your Liking!"
custInfoLbl.TextColor3 = T.TextDim; custInfoLbl.Font = Enum.Font.Gotham
custInfoLbl.TextSize = 11; custInfoLbl.TextWrapped = true; custInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
onThemeChange(function(th) custInfoLbl.TextColor3 = th.TextDim end)

local custBtn = makeButton(themeCard, "🎨  Customise Theme", nil, 4)

-- Custom editor panel
local custEditor = Instance.new("Frame", themeCard)
custEditor.Size = UDim2.new(1, 0, 0, 0); custEditor.AutomaticSize = Enum.AutomaticSize.Y
custEditor.BackgroundColor3 = T.Background; custEditor.Visible = false; custEditor.LayoutOrder = 5
Instance.new("UICorner", custEditor).CornerRadius = UDim.new(0, 8)
local ceSt = Instance.new("UIStroke", custEditor); ceSt.Color = T.Stroke
local ceUL = Instance.new("UIListLayout", custEditor); ceUL.Padding = UDim.new(0, 5)
ceUL.HorizontalAlignment = Enum.HorizontalAlignment.Center
local cePad = Instance.new("UIPadding", custEditor)
cePad.PaddingTop = UDim.new(0, 8); cePad.PaddingBottom = UDim.new(0, 8)
cePad.PaddingLeft = UDim.new(0, 8); cePad.PaddingRight = UDim.new(0, 8)
onThemeChange(function(th) custEditor.BackgroundColor3 = th.Background; ceSt.Color = th.Stroke end)

-- Customisable color parts
local CUST_PARTS = {
    { label = "Background",   key = "Background"  },
    { label = "Cards/Secondary", key = "Secondary" },
    { label = "Accent Color", key = "Accent"      },
    { label = "Active Tab",   key = "TabActive"   },
    { label = "Toggle On",    key = "ToggleOn"    },
    { label = "Slider Fill",  key = "SliderFill"  },
    { label = "Open Button",  key = "OpenButton"  },
    { label = "Text Color",   key = "Text"        },
}

local customColorValues = {}
for _, cp in ipairs(CUST_PARTS) do
    customColorValues[cp.key] = T[cp.key]
end

for _, cp in ipairs(CUST_PARTS) do
    local row = Instance.new("Frame", custEditor)
    row.Size = UDim2.new(1, 0, 0, 30); row.BackgroundTransparency = 1

    local ll = Instance.new("TextLabel", row)
    ll.Size = UDim2.new(0.5, 0, 1, 0); ll.BackgroundTransparency = 1
    ll.Text = cp.label; ll.TextColor3 = T.Text; ll.Font = Enum.Font.Gotham
    ll.TextSize = 12; ll.TextXAlignment = Enum.TextXAlignment.Left
    onThemeChange(function(th) ll.TextColor3 = th.Text end)

    local swatch = Instance.new("Frame", row)
    swatch.Size = UDim2.new(0, 22, 0, 22); swatch.AnchorPoint = Vector2.new(1, 0.5)
    swatch.Position = UDim2.new(1, -82, 0.5, 0)
    swatch.BackgroundColor3 = T[cp.key]; swatch.BorderSizePixel = 0
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 4)

    local hexBox = Instance.new("TextBox", row)
    hexBox.Size = UDim2.new(0, 76, 0, 24); hexBox.AnchorPoint = Vector2.new(1, 0.5)
    hexBox.Position = UDim2.new(1, 0, 0.5, 0)
    hexBox.BackgroundColor3 = T.Background
    local initC = T[cp.key]
    hexBox.Text = string.format("#%02X%02X%02X",
        math.floor(initC.R*255), math.floor(initC.G*255), math.floor(initC.B*255))
    hexBox.TextColor3 = T.Text; hexBox.Font = Enum.Font.RobotoMono; hexBox.TextSize = 11
    hexBox.PlaceholderText = "#RRGGBB"
    hexBox.ClearTextOnFocus = false
    Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 5)
    local hexSt = Instance.new("UIStroke", hexBox); hexSt.Color = T.Stroke
    onThemeChange(function(th)
        hexBox.BackgroundColor3 = th.Background; hexBox.TextColor3 = th.Text; hexSt.Color = th.Stroke
    end)

    hexBox:GetPropertyChangedSignal("Text"):Connect(function()
        local h = hexBox.Text:gsub("[#xX ]", "")
        if #h == 6 then
            local r, g, b = tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)
            if r and g and b then
                local col = Color3.fromRGB(r, g, b)
                customColorValues[cp.key] = col
                swatch.BackgroundColor3   = col
            end
        end
    end)
end

-- Apply custom theme button
local applyCustomBtn = Instance.new("TextButton", custEditor)
applyCustomBtn.Size = UDim2.new(1, 0, 0, 32); applyCustomBtn.BackgroundColor3 = T.Accent
applyCustomBtn.Text = "✓  Apply Custom Theme"; applyCustomBtn.TextColor3 = Color3.fromRGB(255,255,255)
applyCustomBtn.Font = Enum.Font.GothamBold; applyCustomBtn.TextSize = 13
applyCustomBtn.AutoButtonColor = false
Instance.new("UICorner", applyCustomBtn).CornerRadius = UDim.new(0, 7)
onThemeChange(function(th) applyCustomBtn.BackgroundColor3 = th.Accent end)

applyCustomBtn.MouseButton1Click:Connect(function()
    local newTheme = {}
    for k, v in pairs(Themes.Original) do
        newTheme[k] = customColorValues[k] or v
    end
    -- Derive GradStart/End from Accent if not explicitly set
    newTheme.GradStart = customColorValues.Accent or T.Accent
    newTheme.GradEnd   = customColorValues.AccentDark or T.AccentDark
    applyTheme("Custom", newTheme)
    -- Update preset buttons
    for _, b in pairs(themePresetBtns) do b.BackgroundColor3 = T.Secondary end
    showNotification("✨ Custom theme applied!", T.Accent)
end)

local custEditorOpen = false
custBtn.MouseButton1Click:Connect(function()
    custEditorOpen = not custEditorOpen
    custEditor.Visible = custEditorOpen
    custBtn.Text = custEditorOpen and "▲  Close Customiser" or "🎨  Customise Theme"
end)

-- ============================================================
--  INITIAL OPEN ANIMATION
-- ============================================================
MainFrame.Size    = UDim2.new(0, 1, 0, 1)
MainFrame.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back),
    { Size = UDim2.new(0, GUI_W, 0, GUI_H) }):Play()

task.delay(0.7, function()
    showNotification("✅ Project Crafted V2 Loaded! | Exec #" .. execCount, T.Accent, 3.5)
end)

-- ============================================================
--  CLEANUP ON GUI REMOVAL  (executor re-execution safety)
-- ============================================================
ScreenGui.AncestryChanged:Connect(function()
    pcall(function() flightMobileGui:Destroy() end)
    pcall(function() NotifGui:Destroy()        end)
    for _, c in ipairs(spawnDetectorConns) do pcall(function() c:Disconnect() end) end
    for _, c in ipairs(lavaConns)          do pcall(function() c:Disconnect() end) end
    if flightConn     then pcall(function() flightConn:Disconnect()     end) end
    if autoCollectConn then pcall(function() autoCollectConn:Disconnect() end) end
end)

print("[Project Crafted V2] Loaded successfully — Execution #" .. execCount)
