--[[
    ╔══════════════════════════════════════╗
    ║       Project Crafted V2             ║
    ║       Executor Script                ║
    ╚══════════════════════════════════════╝
]]

-- ══════════════════════════════════
-- SERVICES
-- ══════════════════════════════════
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local HttpService        = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ══════════════════════════════════
-- GAME ID CHECK
-- ══════════════════════════════════
local TARGET_GAME_ID = 119987266683883

if game.PlaceId ~= TARGET_GAME_ID then
    local badGui = Instance.new("ScreenGui")
    badGui.Name           = "PC_Unsupported"
    badGui.ResetOnSpawn   = false
    badGui.DisplayOrder   = 9999
    badGui.IgnoreGuiInset = true
    badGui.Parent         = CoreGui

    local badFrame = Instance.new("Frame", badGui)
    badFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
    badFrame.Position         = UDim2.new(0.5, 0, 0.5, 0)
    badFrame.Size             = UDim2.new(0, 0, 0, 0)
    badFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
    badFrame.BorderSizePixel  = 0
    local bc = Instance.new("UICorner", badFrame)
    bc.CornerRadius = UDim.new(0, 14)
    local bs = Instance.new("UIStroke", badFrame)
    bs.Color     = Color3.fromRGB(220, 60, 60)
    bs.Thickness = 2

    local badLbl = Instance.new("TextLabel", badFrame)
    badLbl.Size                   = UDim2.new(1, -24, 1, 0)
    badLbl.Position               = UDim2.new(0, 12, 0, 0)
    badLbl.BackgroundTransparency = 1
    local gn = "This Game"
    pcall(function() gn = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    badLbl.Text       = gn .. " Is Not Supported!"
    badLbl.TextColor3 = Color3.fromRGB(255, 90, 80)
    badLbl.Font       = Enum.Font.GothamBold
    badLbl.TextScaled = true

    TweenService:Create(badFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.42, 0, 0.09, 0)}):Play()
    task.delay(3.2, function()
        TweenService:Create(badFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.5, function() badGui:Destroy() end)
    end)
    return
end

-- ══════════════════════════════════
-- CONFIG / FILE SYSTEM
-- ══════════════════════════════════
local CFG_ROOT   = "ProjectCrafted"
local CFG_DIR    = CFG_ROOT .. "/configs"
local THEME_FILE = CFG_DIR  .. "/theme.txt"
local COUNT_FILE = CFG_DIR  .. "/execcount.txt"
local CUST_FILE  = CFG_DIR  .. "/customtheme.txt"

local function safeReadFile(path)
    local ok, r = pcall(function()
        if isfile and isfile(path) then return readfile(path) end
    end)
    return ok and r or nil
end

local function safeWriteFile(path, content)
    pcall(function()
        if writefile then writefile(path, tostring(content)) end
    end)
end

local function ensureDirs()
    pcall(function()
        if isfolder then
            if not isfolder(CFG_ROOT) then makefolder(CFG_ROOT) end
            if not isfolder(CFG_DIR)  then makefolder(CFG_DIR)  end
        end
    end)
end
ensureDirs()

local execCount = 1
local savedExec = safeReadFile(COUNT_FILE)
if savedExec then
    local n = tonumber(savedExec)
    if n then execCount = n + 1 end
end
safeWriteFile(COUNT_FILE, tostring(execCount))
local execStartTime = tick()

-- ══════════════════════════════════
-- THEMES
-- ══════════════════════════════════
local Themes = {
    Original = {
        Background   = Color3.fromRGB(14, 22, 14),
        SecondaryBg  = Color3.fromRGB(20, 34, 20),
        Accent       = Color3.fromRGB(60, 210, 90),
        AccentDark   = Color3.fromRGB(35, 130, 55),
        Text         = Color3.fromRGB(215, 255, 215),
        TextDim      = Color3.fromRGB(130, 175, 130),
        TabBg        = Color3.fromRGB(22, 36, 22),
        TabActive    = Color3.fromRGB(60, 210, 90),
        ToggleOn     = Color3.fromRGB(60, 210, 90),
        ToggleOff    = Color3.fromRGB(55, 68, 55),
        SliderFill   = Color3.fromRGB(60, 210, 90),
        SliderBg     = Color3.fromRGB(32, 50, 32),
        Stroke       = Color3.fromRGB(60, 210, 90),
        GradStart    = Color3.fromRGB(14, 22, 14),
        GradEnd      = Color3.fromRGB(22, 40, 22),
        ButtonBg     = Color3.fromRGB(28, 95, 42),
        DropdownBg   = Color3.fromRGB(18, 30, 18),
        OpenCloseBg  = Color3.fromRGB(28, 100, 44),
        ScrollBar    = Color3.fromRGB(60, 210, 90),
        SectionText  = Color3.fromRGB(60, 210, 90),
    },
    Sky = {
        Background   = Color3.fromRGB(12, 18, 34),
        SecondaryBg  = Color3.fromRGB(18, 26, 50),
        Accent       = Color3.fromRGB(80, 175, 255),
        AccentDark   = Color3.fromRGB(45, 115, 200),
        Text         = Color3.fromRGB(210, 232, 255),
        TextDim      = Color3.fromRGB(120, 155, 200),
        TabBg        = Color3.fromRGB(20, 30, 55),
        TabActive    = Color3.fromRGB(80, 175, 255),
        ToggleOn     = Color3.fromRGB(80, 175, 255),
        ToggleOff    = Color3.fromRGB(45, 58, 80),
        SliderFill   = Color3.fromRGB(80, 175, 255),
        SliderBg     = Color3.fromRGB(28, 44, 70),
        Stroke       = Color3.fromRGB(80, 175, 255),
        GradStart    = Color3.fromRGB(12, 18, 38),
        GradEnd      = Color3.fromRGB(20, 32, 62),
        ButtonBg     = Color3.fromRGB(28, 78, 165),
        DropdownBg   = Color3.fromRGB(15, 24, 46),
        OpenCloseBg  = Color3.fromRGB(35, 95, 200),
        ScrollBar    = Color3.fromRGB(80, 175, 255),
        SectionText  = Color3.fromRGB(80, 175, 255),
    },
    Lava = {
        Background   = Color3.fromRGB(24, 10, 5),
        SecondaryBg  = Color3.fromRGB(34, 15, 8),
        Accent       = Color3.fromRGB(255, 105, 30),
        AccentDark   = Color3.fromRGB(195, 60, 10),
        Text         = Color3.fromRGB(255, 220, 195),
        TextDim      = Color3.fromRGB(175, 125, 100),
        TabBg        = Color3.fromRGB(38, 18, 8),
        TabActive    = Color3.fromRGB(255, 105, 30),
        ToggleOn     = Color3.fromRGB(255, 105, 30),
        ToggleOff    = Color3.fromRGB(68, 35, 20),
        SliderFill   = Color3.fromRGB(255, 105, 30),
        SliderBg     = Color3.fromRGB(52, 24, 10),
        Stroke       = Color3.fromRGB(255, 105, 30),
        GradStart    = Color3.fromRGB(26, 10, 5),
        GradEnd      = Color3.fromRGB(40, 20, 8),
        ButtonBg     = Color3.fromRGB(140, 42, 10),
        DropdownBg   = Color3.fromRGB(30, 14, 6),
        OpenCloseBg  = Color3.fromRGB(160, 52, 14),
        ScrollBar    = Color3.fromRGB(255, 105, 30),
        SectionText  = Color3.fromRGB(255, 105, 30),
    },
}

-- ══════════════════════════════════
-- SAFE THEME KEY ACCESSOR
-- Returns T[key] if it exists and is a Color3, else falls back to Original
-- This is the core fix: no more nil Color3 errors anywhere
-- ══════════════════════════════════
local T = {}  -- active theme, populated below

local function tc(key)
    local v = T[key]
    if typeof(v) == "Color3" then return v end
    local fallback = Themes["Original"][key]
    if typeof(fallback) == "Color3" then return fallback end
    return Color3.fromRGB(128, 128, 128)
end

local currentThemeName = "Original"
local savedTheme = safeReadFile(THEME_FILE)
if savedTheme and Themes[savedTheme] then
    currentThemeName = savedTheme
end

-- ── Load custom theme from file ──
local savedCustomRaw = safeReadFile(CUST_FILE)
if savedCustomRaw then
    pcall(function()
        local raw = HttpService:JSONDecode(savedCustomRaw)
        local converted = {}
        for k, v in pairs(raw) do
            if type(v) == "table" then
                if v.r ~= nil then
                    converted[k] = Color3.new(
                        math.clamp(v.r, 0, 1),
                        math.clamp(v.g, 0, 1),
                        math.clamp(v.b, 0, 1)
                    )
                elseif #v == 3 then
                    converted[k] = Color3.new(
                        math.clamp(v[1], 0, 1),
                        math.clamp(v[2], 0, 1),
                        math.clamp(v[3], 0, 1)
                    )
                end
            end
        end
        -- Merge with Original so ALL keys are present
        local merged = {}
        for k, v in pairs(Themes["Original"]) do merged[k] = v end
        for k, v in pairs(converted) do merged[k] = v end
        Themes["Custom"] = merged
    end)
end

-- Populate T from current theme name
for k, v in pairs(Themes[currentThemeName] or Themes["Original"]) do
    T[k] = v
end
-- Always fill any missing keys from Original
for k, v in pairs(Themes["Original"]) do
    if T[k] == nil then T[k] = v end
end

local themeCallbacks = {}
local function onThemeUpdate(fn) table.insert(themeCallbacks, fn) end

local function fireThemeUpdate()
    -- Rebuild T in-place (keeps the same table reference)
    local src = Themes[currentThemeName] or Themes["Original"]
    for k in pairs(T) do T[k] = nil end
    for k, v in pairs(Themes["Original"]) do T[k] = v end  -- fill defaults first
    for k, v in pairs(src) do T[k] = v end                  -- then overlay chosen theme
    for _, fn in ipairs(themeCallbacks) do pcall(fn) end
end

local function setTheme(name, customData)
    if customData then
        -- Build merged theme: start from Original, overlay custom colors
        local merged = {}
        for k, v in pairs(Themes["Original"]) do merged[k] = v end
        for k, v in pairs(customData) do
            if typeof(v) == "Color3" then merged[k] = v end
        end
        -- Save to file (only custom overrides)
        local stored = {}
        for k, v in pairs(customData) do
            if typeof(v) == "Color3" then
                stored[k] = {r = v.R, g = v.G, b = v.B}
            end
        end
        safeWriteFile(CUST_FILE, HttpService:JSONEncode(stored))
        Themes["Custom"]  = merged
        currentThemeName  = "Custom"
        safeWriteFile(THEME_FILE, "Custom")
    elseif Themes[name] then
        currentThemeName = name
        safeWriteFile(THEME_FILE, name)
    end
    fireThemeUpdate()
end

-- ══════════════════════════════════
-- FEATURE STATE
-- ══════════════════════════════════
local state = {
    speedEnabled    = false,
    jumpEnabled     = false,
    godmodeEnabled  = false,
    flyEnabled      = false,
    teleportEnabled = false,
    brainHighlight  = false,
    playerHighlight = false,
    autoCollect     = false,
    playerWarnOk    = false,
    speedValue      = 16,
    jumpValue       = 30,
    speedMaxValue   = 100,
}

-- ══════════════════════════════════
-- HELPERS
-- ══════════════════════════════════
local function addCorner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function addStroke(p, col, thick)
    local s = Instance.new("UIStroke", p)
    s.Color           = typeof(col) == "Color3" and col or tc("Stroke")
    s.Thickness       = thick or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function addGradient(p, c0, c1, rot)
    local g = Instance.new("UIGradient", p)
    g.Color    = ColorSequence.new(
        typeof(c0) == "Color3" and c0 or tc("GradStart"),
        typeof(c1) == "Color3" and c1 or tc("GradEnd")
    )
    g.Rotation = rot or 90
    return g
end

local function tw(obj, props, t, style, dir)
    -- Guard: strip any nil Color3 values from props before tweening
    local safeProps = {}
    for k, v in pairs(props) do
        if v ~= nil then safeProps[k] = v end
    end
    TweenService:Create(obj,
        TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        safeProps):Play()
end

local function formatTime(secs)
    local m = math.floor(secs / 60)
    local s = math.floor(secs % 60)
    return string.format("%d:%02d", m, s)
end

local function getCharHum()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    return char, char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart")
end

-- ══════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════
local function showNotification(text, color, duration)
    local vp = Camera.ViewportSize
    local nW = math.clamp(vp.X * 0.36, 220, 400)
    local nH = math.clamp(vp.Y * 0.065, 44, 62)

    local notifGui = Instance.new("ScreenGui")
    notifGui.Name           = "PC_Notif"
    notifGui.ResetOnSpawn   = false
    notifGui.DisplayOrder   = 500
    notifGui.IgnoreGuiInset = true
    notifGui.Parent         = CoreGui

    local frame = Instance.new("Frame", notifGui)
    frame.Size             = UDim2.new(0, nW, 0, nH)
    frame.AnchorPoint      = Vector2.new(0.5, 0)
    frame.Position         = UDim2.new(0.5, 0, 0, -nH - 10)
    frame.BackgroundColor3 = tc("SecondaryBg")
    frame.BorderSizePixel  = 0
    addCorner(frame, 12)
    local safeColor = typeof(color) == "Color3" and color or tc("Accent")
    addStroke(frame, safeColor, 2)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size                   = UDim2.new(1, -20, 1, 0)
    lbl.Position               = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text
    lbl.TextColor3             = safeColor
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.TextSize               = 13
    lbl.TextWrapped            = true

    tw(frame, {Position = UDim2.new(0.5, 0, 0, 10)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.delay(duration or 2.6, function()
        tw(frame, {Position = UDim2.new(0.5, 0, 0, -nH - 10)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.4, function() notifGui:Destroy() end)
    end)
end

-- ══════════════════════════════════
-- MAIN SCREENGUI
-- ══════════════════════════════════
pcall(function()
    local old = CoreGui:FindFirstChild("ProjectCraftedV2")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "ProjectCraftedV2"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 10
ScreenGui.Parent         = CoreGui

-- ══════════════════════════════════
-- OPEN/CLOSE BUTTON
-- ══════════════════════════════════
local OcBtn = Instance.new("ImageButton", ScreenGui)
OcBtn.Name             = "OpenCloseBtn"
OcBtn.BackgroundColor3 = tc("OpenCloseBg")
OcBtn.BorderSizePixel  = 0
OcBtn.AutoButtonColor  = false
OcBtn.ZIndex           = 100
OcBtn.AnchorPoint      = Vector2.new(1, 0)
addCorner(OcBtn, 10)
local ocStroke = addStroke(OcBtn, tc("Accent"), 2)
local ocGrad   = addGradient(OcBtn, tc("AccentDark"), tc("OpenCloseBg"), 135)

local OcLogo = Instance.new("ImageLabel", OcBtn)
OcLogo.BackgroundTransparency = 1
OcLogo.Image    = "rbxassetid://85816937697749"
OcLogo.ScaleType= Enum.ScaleType.Fit
OcLogo.ZIndex   = 101

local OcText = Instance.new("TextLabel", OcBtn)
OcText.BackgroundTransparency = 1
OcText.Text       = "Project Crafted"
OcText.TextColor3 = tc("Text")
OcText.Font       = Enum.Font.GothamBold
OcText.TextScaled = true
OcText.ZIndex     = 101

local function updateOcSize()
    local vp = Camera.ViewportSize
    local bH = math.clamp(vp.Y * 0.052, 34, 48)
    local bW = math.clamp(vp.X * 0.16, 126, 188)
    OcBtn.Size      = UDim2.new(0, bW, 0, bH)
    OcLogo.Size     = UDim2.new(0, bH - 10, 0, bH - 10)
    OcLogo.Position = UDim2.new(0, 5, 0.5, -(bH - 10) / 2)
    OcText.Size     = UDim2.new(0, bW - bH - 8, 0, bH - 12)
    OcText.Position = UDim2.new(0, bH + 4, 0.5, -(bH - 12) / 2)
end

local function positionOcBtn()
    local vp  = Camera.ViewportSize
    local bSz = OcBtn.AbsoluteSize
    local bW  = bSz.X
    local bH  = bSz.Y

    local function getGuiRects()
        local rects = {}
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetDescendants()) do
                if g:IsA("GuiObject") and g.Visible then
                    local p2 = g.AbsolutePosition
                    local s2 = g.AbsoluteSize
                    if s2.Magnitude > 20 then
                        table.insert(rects, {x1=p2.X, y1=p2.Y, x2=p2.X+s2.X, y2=p2.Y+s2.Y})
                    end
                end
            end
        end
        return rects
    end

    local function overlaps(rects, ax, ay)
        for _, r in ipairs(rects) do
            if not (ax+bW <= r.x1 or ax >= r.x2 or ay+bH <= r.y1 or ay >= r.y2) then
                return true
            end
        end
        return false
    end

    local rects = getGuiRects()
    local candidates = {
        {x = vp.X - bW - 8, y = 8},
        {x = 8,              y = 8},
        {x = vp.X - bW - 8, y = vp.Y - bH - 8},
        {x = 8,              y = vp.Y - bH - 8},
    }
    for _, c in ipairs(candidates) do
        if not overlaps(rects, c.x, c.y) then
            OcBtn.AnchorPoint = Vector2.new(0, 0)
            OcBtn.Position    = UDim2.new(0, c.x, 0, c.y)
            return
        end
    end
    OcBtn.AnchorPoint = Vector2.new(1, 0)
    OcBtn.Position    = UDim2.new(1, -8, 0, 8)
end

updateOcSize()
task.defer(positionOcBtn)

-- ══════════════════════════════════
-- MAIN FRAME
-- ══════════════════════════════════
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name             = "MainFrame"
MainFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
MainFrame.Position         = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = tc("Background")
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex           = 50
local mfStroke = addStroke(MainFrame, tc("Accent"), 2)
addCorner(MainFrame, 14)
local mfGrad = addGradient(MainFrame, tc("GradStart"), tc("GradEnd"), 135)

local function updateMainSize()
    local vp = Camera.ViewportSize
    local w  = math.clamp(vp.X * 0.56, 310, 680)
    local h  = math.clamp(vp.Y * 0.52, 290, 440)
    MainFrame.Size = UDim2.new(0, w, 0, h)
end
updateMainSize()

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = tc("SecondaryBg")
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 51
addCorner(TitleBar, 14)
local tbGrad = addGradient(TitleBar, tc("AccentDark"), tc("Background"), 180)

local TitleLogo = Instance.new("ImageLabel", TitleBar)
TitleLogo.Size                   = UDim2.new(0, 26, 0, 26)
TitleLogo.Position               = UDim2.new(0, 8, 0.5, -13)
TitleLogo.BackgroundTransparency = 1
TitleLogo.Image                  = "rbxassetid://85816937697749"
TitleLogo.ScaleType              = Enum.ScaleType.Fit
TitleLogo.ZIndex                 = 52

local TitleLbl = Instance.new("TextLabel", TitleBar)
TitleLbl.Size                   = UDim2.new(1, -130, 1, 0)
TitleLbl.Position               = UDim2.new(0, 42, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text                   = "Project Crafted V2"
TitleLbl.TextColor3             = tc("Text")
TitleLbl.Font                   = Enum.Font.GothamBold
TitleLbl.TextSize               = 16
TitleLbl.TextXAlignment         = Enum.TextXAlignment.Left
TitleLbl.ZIndex                 = 52

local function makeWinBtn(parent, col, lbl, xOff)
    local b = Instance.new("TextButton", parent)
    b.Size             = UDim2.new(0, 26, 0, 26)
    b.Position         = UDim2.new(1, xOff, 0.5, -13)
    b.BackgroundColor3 = col
    b.Text             = lbl
    b.TextColor3       = Color3.fromRGB(255, 255, 255)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 13
    b.AutoButtonColor  = false
    b.ZIndex           = 52
    addCorner(b, 7)
    return b
end
local TitleClose = makeWinBtn(TitleBar, Color3.fromRGB(200, 55, 55),  "X",  -34)
local TitleMin   = makeWinBtn(TitleBar, Color3.fromRGB(200, 160, 30), "-", -66)

-- Content Area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Name                   = "ContentArea"
ContentArea.Size                   = UDim2.new(1, 0, 1, -40)
ContentArea.Position               = UDim2.new(0, 0, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants       = true
ContentArea.ZIndex                 = 51

-- Tab Bar
local TabBar = Instance.new("Frame", ContentArea)
TabBar.Name             = "TabBar"
TabBar.Size             = UDim2.new(1, 0, 0, 36)
TabBar.BackgroundColor3 = tc("SecondaryBg")
TabBar.BorderSizePixel  = 0
TabBar.ZIndex           = 52
local tabBarGrad = addGradient(TabBar, tc("TabBg"), tc("SecondaryBg"), 90)

local tabLayout = Instance.new("UIListLayout", TabBar)
tabLayout.FillDirection       = Enum.FillDirection.Horizontal
tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.Padding             = UDim.new(0, 3)

local tabBarPad = Instance.new("UIPadding", TabBar)
tabBarPad.PaddingLeft   = UDim.new(0, 5)
tabBarPad.PaddingRight  = UDim.new(0, 5)
tabBarPad.PaddingTop    = UDim.new(0, 4)
tabBarPad.PaddingBottom = UDim.new(0, 4)

-- Tab Content Area
local TabContentArea = Instance.new("Frame", ContentArea)
TabContentArea.Name                   = "TabContentArea"
TabContentArea.Size                   = UDim2.new(1, 0, 1, -36)
TabContentArea.Position               = UDim2.new(0, 0, 0, 36)
TabContentArea.BackgroundTransparency = 1
TabContentArea.ClipsDescendants       = true
TabContentArea.ZIndex                 = 51

-- ══════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════
local TAB_NAMES          = {"Home","Main","Player","Visual","Settings"}
local tabButtons         = {}
local tabPages           = {}
local activeTab          = nil
local playerWarningOverlay = nil

local function createTabButton(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Name             = name .. "_Tab"
    btn.Size             = UDim2.new(0, 0, 1, -4)
    btn.AutomaticSize    = Enum.AutomaticSize.X
    btn.BackgroundColor3 = tc("TabBg")
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.AutoButtonColor  = false
    btn.ZIndex           = 53
    addCorner(btn, 7)

    local tp = Instance.new("UIPadding", btn)
    tp.PaddingLeft  = UDim.new(0, 9)
    tp.PaddingRight = UDim.new(0, 9)

    local tl = Instance.new("TextLabel", btn)
    tl.Name                   = "Lbl"
    tl.Size                   = UDim2.new(0, 0, 1, 0)
    tl.AutomaticSize          = Enum.AutomaticSize.X
    tl.BackgroundTransparency = 1
    tl.Text                   = name
    tl.TextColor3             = tc("TextDim")
    tl.Font                   = Enum.Font.GothamMedium
    tl.TextSize               = 11
    tl.ZIndex                 = 54
    return btn
end

local function createTabPage(name)
    local sf = Instance.new("ScrollingFrame", TabContentArea)
    sf.Name                   = name .. "_Page"
    sf.Size                   = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel        = 0
    sf.ScrollBarThickness     = 4
    sf.ScrollBarImageColor3   = tc("ScrollBar")
    sf.CanvasSize             = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    sf.Visible                = false
    sf.ZIndex                 = 52

    local lyt = Instance.new("UIListLayout", sf)
    lyt.FillDirection = Enum.FillDirection.Vertical
    lyt.Padding       = UDim.new(0, 7)
    lyt.SortOrder     = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", sf)
    pad.PaddingLeft   = UDim.new(0, 11)
    pad.PaddingRight  = UDim.new(0, 13)
    pad.PaddingTop    = UDim.new(0, 9)
    pad.PaddingBottom = UDim.new(0, 12)
    return sf
end

for _, name in ipairs(TAB_NAMES) do
    tabButtons[name] = createTabButton(name)
    tabPages[name]   = createTabPage(name)
end

-- ── switchTab uses tc() so it never gets a nil Color3 ──
local function switchTab(name)
    if activeTab == name then return end
    if activeTab then
        local ob = tabButtons[activeTab]
        local op = tabPages[activeTab]
        tw(ob, {BackgroundColor3 = tc("TabBg")}, 0.18)
        ob.Lbl.TextColor3 = tc("TextDim")
        ob.Lbl.Font       = Enum.Font.GothamMedium
        op.Visible        = false
    end
    activeTab = name
    local nb = tabButtons[name]
    local np = tabPages[name]
    tw(nb, {BackgroundColor3 = tc("TabActive")}, 0.18)
    nb.Lbl.TextColor3 = tc("Text")
    nb.Lbl.Font       = Enum.Font.GothamBold
    np.Visible        = true
    np.Position       = UDim2.new(0, 0, 0, 14)
    tw(np, {Position = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if playerWarningOverlay then
        playerWarningOverlay.Visible = (name == "Player") and not state.playerWarnOk
    end
end

for _, name in ipairs(TAB_NAMES) do
    tabButtons[name].MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ══════════════════════════════════
-- DRAG
-- ══════════════════════════════════
do
    local dragging  = false
    local dragStart = nil
    local startPos  = nil

    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ══════════════════════════════════
-- OPEN / CLOSE ANIMATION
-- ══════════════════════════════════
local isOpen     = true
local lastOpenSz = MainFrame.Size

local function toggleMainGui()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        tw(MainFrame, {Size = lastOpenSz}, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        lastOpenSz = MainFrame.Size
        tw(MainFrame, {Size = UDim2.new(lastOpenSz.X.Scale, lastOpenSz.X.Offset, 0, 0)},
            0.26, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.3, function() MainFrame.Visible = false end)
    end
end

OcBtn.MouseButton1Click:Connect(toggleMainGui)
TitleClose.MouseButton1Click:Connect(toggleMainGui)
TitleMin.MouseButton1Click:Connect(function() if isOpen then toggleMainGui() end end)

-- ══════════════════════════════════
-- UI COMPONENT BUILDERS
-- ══════════════════════════════════
local function sectionLabel(page, txt, order)
    local f = Instance.new("Frame", page)
    f.Size                   = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1
    f.LayoutOrder            = order
    local lbl = Instance.new("TextLabel", f)
    lbl.Size                   = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = "── " .. txt .. " ──"
    lbl.TextColor3             = tc("SectionText")
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 11
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    onThemeUpdate(function() lbl.TextColor3 = tc("SectionText") end)
    return f, lbl
end

local function infoRow(page, lTxt, vTxt, order)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 28)
    f.BackgroundColor3 = tc("SecondaryBg")
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    addCorner(f, 7)
    local fStr = addStroke(f, tc("Stroke"), 1)

    local kl = Instance.new("TextLabel", f)
    kl.Size                   = UDim2.new(0.46, 0, 1, 0)
    kl.Position               = UDim2.new(0, 9, 0, 0)
    kl.BackgroundTransparency = 1
    kl.Text                   = lTxt
    kl.TextColor3             = tc("TextDim")
    kl.Font                   = Enum.Font.GothamMedium
    kl.TextSize               = 11
    kl.TextXAlignment         = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", f)
    vl.Name                   = "Val"
    vl.Size                   = UDim2.new(0.52, 0, 1, 0)
    vl.Position               = UDim2.new(0.47, 0, 0, 0)
    vl.BackgroundTransparency = 1
    vl.Text                   = vTxt or "..."
    vl.TextColor3             = tc("Text")
    vl.Font                   = Enum.Font.Gotham
    vl.TextSize               = 11
    vl.TextXAlignment         = Enum.TextXAlignment.Left

    onThemeUpdate(function()
        f.BackgroundColor3 = tc("SecondaryBg")
        fStr.Color         = tc("Stroke")
        kl.TextColor3      = tc("TextDim")
        vl.TextColor3      = tc("Text")
    end)
    return f, vl, kl
end

local function buildToggle(page, labelTxt, order, onFn)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 40)
    f.BackgroundColor3 = tc("SecondaryBg")
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    addCorner(f, 10)
    local fStr = addStroke(f, tc("Stroke"), 1)

    local ll = Instance.new("TextLabel", f)
    ll.Size                   = UDim2.new(1, -64, 1, 0)
    ll.Position               = UDim2.new(0, 11, 0, 0)
    ll.BackgroundTransparency = 1
    ll.Text                   = labelTxt
    ll.TextColor3             = tc("Text")
    ll.Font                   = Enum.Font.GothamMedium
    ll.TextSize               = 12
    ll.TextXAlignment         = Enum.TextXAlignment.Left
    ll.TextWrapped            = true

    local sbg = Instance.new("Frame", f)
    sbg.Size             = UDim2.new(0, 42, 0, 22)
    sbg.Position         = UDim2.new(1, -52, 0.5, -11)
    sbg.BackgroundColor3 = tc("ToggleOff")
    sbg.BorderSizePixel  = 0
    addCorner(sbg, 11)

    local knob = Instance.new("Frame", sbg)
    knob.Size             = UDim2.new(0, 16, 0, 16)
    knob.Position         = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    addCorner(knob, 8)

    local togOn = false

    local clickArea = Instance.new("TextButton", f)
    clickArea.Size                   = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text                   = ""
    clickArea.ZIndex                 = f.ZIndex + 1

    local function setValue(val, silent)
        togOn = val
        if val then
            tw(sbg,  {BackgroundColor3 = tc("ToggleOn")},  0.16)
            tw(knob, {Position = UDim2.new(0, 23, 0.5, -8)}, 0.16)
        else
            tw(sbg,  {BackgroundColor3 = tc("ToggleOff")}, 0.16)
            tw(knob, {Position = UDim2.new(0, 3, 0.5, -8)},  0.16)
        end
        if not silent and onFn then onFn(togOn) end
    end

    clickArea.MouseButton1Click:Connect(function() setValue(not togOn) end)

    onThemeUpdate(function()
        f.BackgroundColor3   = tc("SecondaryBg")
        fStr.Color           = tc("Stroke")
        ll.TextColor3        = tc("Text")
        sbg.BackgroundColor3 = togOn and tc("ToggleOn") or tc("ToggleOff")
    end)

    return f, setValue, function() return togOn end
end

local function buildSlider(page, labelTxt, minV, maxV, defV, order, onChangeFn)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 56)
    f.BackgroundColor3 = tc("SecondaryBg")
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    addCorner(f, 10)
    local fStr = addStroke(f, tc("Stroke"), 1)

    local nameLbl = Instance.new("TextLabel", f)
    nameLbl.Size                   = UDim2.new(0.65, 0, 0, 20)
    nameLbl.Position               = UDim2.new(0, 11, 0, 5)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text                   = labelTxt
    nameLbl.TextColor3             = tc("Text")
    nameLbl.Font                   = Enum.Font.GothamMedium
    nameLbl.TextSize               = 12
    nameLbl.TextXAlignment         = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", f)
    valLbl.Size                   = UDim2.new(0.32, 0, 0, 20)
    valLbl.Position               = UDim2.new(0.66, 0, 0, 5)
    valLbl.BackgroundTransparency = 1
    valLbl.Text                   = tostring(defV)
    valLbl.TextColor3             = tc("Accent")
    valLbl.Font                   = Enum.Font.GothamBold
    valLbl.TextSize               = 13
    valLbl.TextXAlignment         = Enum.TextXAlignment.Right

    local rail = Instance.new("Frame", f)
    rail.Size             = UDim2.new(1, -22, 0, 7)
    rail.Position         = UDim2.new(0, 11, 0, 34)
    rail.BackgroundColor3 = tc("SliderBg")
    rail.BorderSizePixel  = 0
    addCorner(rail, 4)

    local initT = (defV - minV) / math.max(maxV - minV, 1)
    local fill  = Instance.new("Frame", rail)
    fill.Size             = UDim2.new(initT, 0, 1, 0)
    fill.BackgroundColor3 = tc("SliderFill")
    fill.BorderSizePixel  = 0
    addCorner(fill, 4)

    local kn = Instance.new("Frame", rail)
    kn.Size             = UDim2.new(0, 14, 0, 14)
    kn.AnchorPoint      = Vector2.new(0.5, 0.5)
    kn.Position         = UDim2.new(initT, 0, 0.5, 0)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.BorderSizePixel  = 0
    addCorner(kn, 7)

    local curVal  = defV
    local sliding = false

    local function updateFromX(xPos)
        local rp = rail.AbsolutePosition
        local rs = rail.AbsoluteSize
        local t  = math.clamp((xPos - rp.X) / rs.X, 0, 1)
        curVal   = math.round(minV + t * (maxV - minV))
        valLbl.Text = tostring(curVal)
        fill.Size   = UDim2.new(t, 0, 1, 0)
        kn.Position = UDim2.new(t, 0, 0.5, 0)
        if onChangeFn then onChangeFn(curVal) end
    end

    local hitArea = Instance.new("TextButton", f)
    hitArea.Size                   = UDim2.new(1, 0, 0, 26)
    hitArea.Position               = UDim2.new(0, 0, 0, 26)
    hitArea.BackgroundTransparency = 1
    hitArea.Text                   = ""
    hitArea.ZIndex                 = f.ZIndex + 1

    hitArea.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateFromX(inp.Position.X)
        end
    end)
    hitArea.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sliding and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(inp.Position.X)
        end
    end)

    onThemeUpdate(function()
        f.BackgroundColor3    = tc("SecondaryBg")
        fStr.Color            = tc("Stroke")
        nameLbl.TextColor3    = tc("Text")
        valLbl.TextColor3     = tc("Accent")
        rail.BackgroundColor3 = tc("SliderBg")
        fill.BackgroundColor3 = tc("SliderFill")
    end)

    local function setRange(newMin, newMax)
        minV   = newMin
        maxV   = newMax
        curVal = math.clamp(curVal, minV, maxV)
        local t2 = (curVal - minV) / math.max(maxV - minV, 1)
        valLbl.Text = tostring(curVal)
        fill.Size   = UDim2.new(t2, 0, 1, 0)
        kn.Position = UDim2.new(t2, 0, 0.5, 0)
    end
    local function getVal() return curVal end
    return f, getVal, setRange
end

-- ══════════════════════════════════
-- BRAINROT DETECTION STATE
-- ══════════════════════════════════
local selectedBrainrots   = {}
local spawnTracked        = {}
local detectedHighlights  = {}
local brainrotWatchFolder = nil

local function onBrainrotDetected(model, name)
    if spawnTracked[model] then return end
    spawnTracked[model] = true
    showNotification("A " .. name .. " Has Spawned!", tc("Accent"), 3)
    if state.teleportEnabled then
        task.spawn(function()
            task.wait(0.05)
            pcall(function()
                local _, _, hrp = getCharHum()
                if hrp then hrp.CFrame = model:GetPivot() * CFrame.new(0, 5, 0) end
            end)
        end)
    end
    if state.brainHighlight then
        pcall(function()
            if detectedHighlights[model] then detectedHighlights[model]:Destroy() end
            local hl = Instance.new("Highlight", model)
            hl.FillColor           = tc("Accent")
            hl.OutlineColor        = tc("Accent")
            hl.FillTransparency    = 0.45
            hl.OutlineTransparency = 0
            detectedHighlights[model] = hl
        end)
    end
end

task.spawn(function()
    pcall(function()
        brainrotWatchFolder = workspace:WaitForChild("GameFolder", 15):WaitForChild("Brainrots", 15)
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.8)
        if brainrotWatchFolder then
            pcall(function()
                for _, obj in ipairs(brainrotWatchFolder:GetDescendants()) do
                    if obj:IsA("Model") and selectedBrainrots[obj.Name] then
                        onBrainrotDetected(obj, obj.Name)
                    end
                end
                for m in pairs(spawnTracked) do
                    if not m.Parent then
                        spawnTracked[m] = nil
                        if detectedHighlights[m] then
                            pcall(function() detectedHighlights[m]:Destroy() end)
                            detectedHighlights[m] = nil
                        end
                    end
                end
            end)
        end
    end
end)

-- ══════════════════════════════════
-- HOME TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Home"]
    local lo = 0
    local function nlo() lo += 1 return lo end

    sectionLabel(pg, "Player", nlo())

    local pfCard = Instance.new("Frame", pg)
    pfCard.Size             = UDim2.new(1, 0, 0, 74)
    pfCard.BackgroundColor3 = tc("SecondaryBg")
    pfCard.BorderSizePixel  = 0
    pfCard.LayoutOrder      = nlo()
    addCorner(pfCard, 12)
    local pfStr = addStroke(pfCard, tc("Stroke"), 1)

    local pfImg = Instance.new("ImageLabel", pfCard)
    pfImg.Size             = UDim2.new(0, 56, 0, 56)
    pfImg.Position         = UDim2.new(0, 9, 0.5, -28)
    pfImg.BackgroundColor3 = tc("TabBg")
    pfImg.Image            = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    pfImg.BorderSizePixel  = 0
    addCorner(pfImg, 28)

    local pfInfo = Instance.new("Frame", pfCard)
    pfInfo.Size                   = UDim2.new(1, -78, 1, 0)
    pfInfo.Position               = UDim2.new(0, 72, 0, 0)
    pfInfo.BackgroundTransparency = 1

    local pfl = Instance.new("UIListLayout", pfInfo)
    pfl.FillDirection     = Enum.FillDirection.Vertical
    pfl.VerticalAlignment = Enum.VerticalAlignment.Center
    pfl.Padding           = UDim.new(0, 2)

    local pfRowLabels = {}
    local function pfRow(txt, color)
        local l = Instance.new("TextLabel", pfInfo)
        l.Size                   = UDim2.new(1, 0, 0, 15)
        l.BackgroundTransparency = 1
        l.Text                   = txt
        l.TextColor3             = typeof(color) == "Color3" and color or tc("Text")
        l.Font                   = Enum.Font.Gotham
        l.TextSize               = 11
        l.TextXAlignment         = Enum.TextXAlignment.Left
        l.TextWrapped            = true
        table.insert(pfRowLabels, {lbl = l, colorKey = (color == nil and "Text" or nil), rawColor = color})
        return l
    end

    pfRow("Display: " .. LocalPlayer.DisplayName, tc("Accent"))
    pfRow("@" .. LocalPlayer.Name)
    pfRow("ID: " .. tostring(LocalPlayer.UserId), tc("TextDim"))
    pfRow("Age: " .. tostring(LocalPlayer.AccountAge) .. " days", tc("TextDim"))

    onThemeUpdate(function()
        pfCard.BackgroundColor3 = tc("SecondaryBg")
        pfStr.Color             = tc("Stroke")
        pfImg.BackgroundColor3  = tc("TabBg")
        for _, row in ipairs(pfRowLabels) do
            if row.colorKey then
                row.lbl.TextColor3 = tc(row.colorKey)
            end
        end
    end)

    sectionLabel(pg, "Game", nlo())

    local gName = "Unknown"
    pcall(function() gName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)

    local _, gnV = infoRow(pg, "Game Name",  gName,                         nlo())
    local _, giV = infoRow(pg, "Game ID",    tostring(game.PlaceId),         nlo())
    local _, pcV = infoRow(pg, "Players",    "...",                          nlo())
    local _, siV = infoRow(pg, "Server ID",  game.JobId ~= "" and game.JobId:sub(1,14).."…" or "N/A", nlo())
    local _, upV = infoRow(pg, "Uptime",     "0:00",                        nlo())

    sectionLabel(pg, "Session", nlo())
    local _, ecV = infoRow(pg, "Times Executed", tostring(execCount), nlo())
    local _, etV = infoRow(pg, "Exec Duration",  "0:00",             nlo())

    task.spawn(function()
        while true do
            task.wait(1)
            pcall(function()
                pcV.Text = tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers)
                local elapsed = tick() - execStartTime
                upV.Text = formatTime(elapsed)
                etV.Text = formatTime(elapsed)
            end)
        end
    end)
end

-- ══════════════════════════════════
-- MAIN TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Main"]
    local lo = 0
    local function nlo() lo += 1 return lo end

    sectionLabel(pg, "Brainrot Selector", nlo())

    local dropCtr = Instance.new("Frame", pg)
    dropCtr.Size             = UDim2.new(1, 0, 0, 182)
    dropCtr.BackgroundColor3 = tc("DropdownBg")
    dropCtr.BorderSizePixel  = 0
    dropCtr.LayoutOrder      = nlo()
    dropCtr.ClipsDescendants = true
    addCorner(dropCtr, 10)
    local dcStr = addStroke(dropCtr, tc("Stroke"), 1)

    local searchBox = Instance.new("TextBox", dropCtr)
    searchBox.Size               = UDim2.new(1, -14, 0, 28)
    searchBox.Position           = UDim2.new(0, 7, 0, 6)
    searchBox.BackgroundColor3   = tc("SecondaryBg")
    searchBox.BorderSizePixel    = 0
    searchBox.PlaceholderText    = "  Search brainrots..."
    searchBox.Text               = ""
    searchBox.TextColor3         = tc("Text")
    searchBox.PlaceholderColor3  = tc("TextDim")
    searchBox.Font               = Enum.Font.Gotham
    searchBox.TextSize           = 12
    searchBox.ClearTextOnFocus   = false
    addCorner(searchBox, 7)
    local sbPad = Instance.new("UIPadding", searchBox)
    sbPad.PaddingLeft = UDim.new(0, 7)

    local dropList = Instance.new("ScrollingFrame", dropCtr)
    dropList.Size                  = UDim2.new(1, -10, 0, 136)
    dropList.Position              = UDim2.new(0, 5, 0, 40)
    dropList.BackgroundTransparency= 1
    dropList.BorderSizePixel       = 0
    dropList.ScrollBarThickness    = 3
    dropList.ScrollBarImageColor3  = tc("Accent")
    dropList.CanvasSize            = UDim2.new(0, 0, 0, 0)
    dropList.AutomaticCanvasSize   = Enum.AutomaticSize.Y

    local dlLyt = Instance.new("UIListLayout", dropList)
    dlLyt.FillDirection = Enum.FillDirection.Vertical
    dlLyt.Padding       = UDim.new(0, 2)

    local dlPad = Instance.new("UIPadding", dropList)
    dlPad.PaddingTop    = UDim.new(0, 2)
    dlPad.PaddingBottom = UDim.new(0, 2)

    sectionLabel(pg, "Selected Brainrots", nlo())

    local selBox = Instance.new("Frame", pg)
    selBox.Size             = UDim2.new(1, 0, 0, 48)
    selBox.BackgroundColor3 = tc("SecondaryBg")
    selBox.BorderSizePixel  = 0
    selBox.LayoutOrder      = nlo()
    selBox.ClipsDescendants = true
    addCorner(selBox, 10)
    local sbStr = addStroke(selBox, tc("Stroke"), 1)

    local selScroll = Instance.new("ScrollingFrame", selBox)
    selScroll.Size                    = UDim2.new(1, -8, 1, -8)
    selScroll.Position                = UDim2.new(0, 4, 0, 4)
    selScroll.BackgroundTransparency  = 1
    selScroll.BorderSizePixel         = 0
    selScroll.ScrollBarThickness      = 3
    selScroll.ScrollBarImageColor3    = tc("Accent")
    selScroll.CanvasSize              = UDim2.new(0, 0, 0, 0)
    selScroll.AutomaticCanvasSize     = Enum.AutomaticSize.X
    selScroll.ScrollingDirection      = Enum.ScrollingDirection.X

    local ssLyt = Instance.new("UIListLayout", selScroll)
    ssLyt.FillDirection     = Enum.FillDirection.Horizontal
    ssLyt.VerticalAlignment = Enum.VerticalAlignment.Center
    ssLyt.Padding           = UDim.new(0, 4)

    local ssPad = Instance.new("UIPadding", selScroll)
    ssPad.PaddingLeft  = UDim.new(0, 4)
    ssPad.PaddingRight = UDim.new(0, 4)

    local brainrotNames = {}

    local function refreshSelectedBox()
        for _, c in ipairs(selScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        for name in pairs(selectedBrainrots) do
            local chip = Instance.new("Frame", selScroll)
            chip.Size             = UDim2.new(0, 0, 0, 28)
            chip.AutomaticSize    = Enum.AutomaticSize.X
            chip.BackgroundColor3 = tc("AccentDark")
            chip.BorderSizePixel  = 0
            addCorner(chip, 6)

            local cpPad = Instance.new("UIPadding", chip)
            cpPad.PaddingLeft  = UDim.new(0, 6)
            cpPad.PaddingRight = UDim.new(0, 4)

            local cpLyt = Instance.new("UIListLayout", chip)
            cpLyt.FillDirection     = Enum.FillDirection.Horizontal
            cpLyt.VerticalAlignment = Enum.VerticalAlignment.Center
            cpLyt.Padding           = UDim.new(0, 4)

            local cpLbl = Instance.new("TextLabel", chip)
            cpLbl.Size                   = UDim2.new(0, 0, 0, 20)
            cpLbl.AutomaticSize          = Enum.AutomaticSize.X
            cpLbl.BackgroundTransparency = 1
            cpLbl.Text                   = name
            cpLbl.TextColor3             = tc("Text")
            cpLbl.Font                   = Enum.Font.Gotham
            cpLbl.TextSize               = 11

            local xb = Instance.new("TextButton", chip)
            xb.Size             = UDim2.new(0, 16, 0, 16)
            xb.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
            xb.Text             = "X"
            xb.TextColor3       = Color3.fromRGB(255, 255, 255)
            xb.Font             = Enum.Font.GothamBold
            xb.TextSize         = 9
            xb.AutoButtonColor  = false
            addCorner(xb, 4)
            xb.MouseButton1Click:Connect(function()
                selectedBrainrots[name] = nil
                refreshSelectedBox()
                -- rebuild dropdown to deselect item
                local filter = searchBox.Text
                for _, c2 in ipairs(dropList:GetChildren()) do
                    if c2:IsA("TextButton") then c2:Destroy() end
                end
                for _, n in ipairs(brainrotNames) do
                    if filter == "" or n:lower():find(filter:lower(), 1, true) then
                        local item = Instance.new("TextButton", dropList)
                        item.Size             = UDim2.new(1, 0, 0, 24)
                        item.BackgroundColor3 = selectedBrainrots[n] and tc("Accent") or tc("TabBg")
                        item.BorderSizePixel  = 0
                        item.Text             = "  " .. n
                        item.TextColor3       = selectedBrainrots[n] and Color3.fromRGB(0,0,0) or tc("Text")
                        item.Font             = Enum.Font.Gotham
                        item.TextSize         = 11
                        item.TextXAlignment   = Enum.TextXAlignment.Left
                        item.AutoButtonColor  = false
                        addCorner(item, 5)
                        local itemName = n
                        item.MouseButton1Click:Connect(function()
                            if selectedBrainrots[itemName] then
                                selectedBrainrots[itemName] = nil
                            else
                                selectedBrainrots[itemName] = true
                            end
                            item.BackgroundColor3 = selectedBrainrots[itemName] and tc("Accent") or tc("TabBg")
                            item.TextColor3       = selectedBrainrots[itemName] and Color3.fromRGB(0,0,0) or tc("Text")
                            refreshSelectedBox()
                        end)
                    end
                end
            end)
        end
    end

    local function buildDropdownItems(filter)
        for _, c in ipairs(dropList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, name in ipairs(brainrotNames) do
            if filter == "" or name:lower():find(filter:lower(), 1, true) then
                local item = Instance.new("TextButton", dropList)
                item.Size             = UDim2.new(1, 0, 0, 24)
                item.BackgroundColor3 = selectedBrainrots[name] and tc("Accent") or tc("TabBg")
                item.BorderSizePixel  = 0
                item.Text             = "  " .. name
                item.TextColor3       = selectedBrainrots[name] and Color3.fromRGB(0,0,0) or tc("Text")
                item.Font             = Enum.Font.Gotham
                item.TextSize         = 11
                item.TextXAlignment   = Enum.TextXAlignment.Left
                item.AutoButtonColor  = false
                addCorner(item, 5)
                local itemName = name
                item.MouseButton1Click:Connect(function()
                    if selectedBrainrots[itemName] then
                        selectedBrainrots[itemName] = nil
                    else
                        selectedBrainrots[itemName] = true
                    end
                    item.BackgroundColor3 = selectedBrainrots[itemName] and tc("Accent") or tc("TabBg")
                    item.TextColor3       = selectedBrainrots[itemName] and Color3.fromRGB(0,0,0) or tc("Text")
                    refreshSelectedBox()
                end)
            end
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        buildDropdownItems(searchBox.Text)
    end)

    -- Load brainrot names (deduplicated)
    task.spawn(function()
        pcall(function()
            local bFolder = ReplicatedStorage:WaitForChild("Brainrots", 10)
            if bFolder then
                local seen = {}
                local function collectModel(m)
                    if m:IsA("Model") and m.Name ~= "" then
                        if not seen[m.Name] then
                            seen[m.Name] = true
                            table.insert(brainrotNames, m.Name)
                        end
                    end
                end
                for _, child in ipairs(bFolder:GetChildren()) do
                    if child:IsA("Folder") then
                        for _, m in ipairs(child:GetChildren()) do collectModel(m) end
                    else
                        collectModel(child)
                    end
                end
                table.sort(brainrotNames)
                buildDropdownItems("")
            end
        end)
    end)

    -- Auto Collect Cash
    sectionLabel(pg, "Features", nlo())

    local autoCollectActive = false

    local _, autoTogSet = buildToggle(pg, "Auto Collect Cash", nlo(), function(enabled)
        autoCollectActive = enabled
        state.autoCollect = enabled
        showNotification("Auto Collect Cash " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))

        if enabled then
            task.spawn(function()
                while autoCollectActive do
                    pcall(function()
                        local gf    = workspace:FindFirstChild("GameFolder")
                        local plots = gf and gf:FindFirstChild("Plots")
                        if not plots then return end

                        for _, att in ipairs(plots:GetDescendants()) do
                            if not autoCollectActive then return end
                            if att:IsA("Attachment") and att.Name == "YourBaseAtt" then
                                local ownerModel = att.Parent
                                while ownerModel and not ownerModel:IsA("Model") do
                                    ownerModel = ownerModel.Parent
                                end
                                if not ownerModel then continue end

                                local foundBase = false
                                for _, desc in ipairs(ownerModel:GetDescendants()) do
                                    if desc:IsA("TextLabel") and desc.Name == "Title" and desc.Text == "YOUR BASE" then
                                        foundBase = true
                                        break
                                    end
                                end

                                if foundBase then
                                    local placesFolder = nil
                                    for _, desc in ipairs(ownerModel:GetDescendants()) do
                                        if desc:IsA("Folder") and desc.Name == "Places" then
                                            placesFolder = desc
                                            break
                                        end
                                    end
                                    if placesFolder then
                                        local _, _, hrp = getCharHum()
                                        if hrp then
                                            for _, part in ipairs(placesFolder:GetDescendants()) do
                                                if part:IsA("BasePart") then
                                                    pcall(function()
                                                        if firetouchinterest then
                                                            firetouchinterest(part, hrp, 0)
                                                            task.wait(0.02)
                                                            firetouchinterest(part, hrp, 1)
                                                        end
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end)

    onThemeUpdate(function()
        dropCtr.BackgroundColor3       = tc("DropdownBg")
        dcStr.Color                    = tc("Stroke")
        searchBox.BackgroundColor3     = tc("SecondaryBg")
        searchBox.TextColor3           = tc("Text")
        searchBox.PlaceholderColor3    = tc("TextDim")
        dropList.ScrollBarImageColor3  = tc("Accent")
        selBox.BackgroundColor3        = tc("SecondaryBg")
        sbStr.Color                    = tc("Stroke")
        selScroll.ScrollBarImageColor3 = tc("Accent")
        -- Refresh dropdown item colors
        for _, c in ipairs(dropList:GetChildren()) do
            if c:IsA("TextButton") then
                local itemName = c.Text:gsub("^%s+", "")
                c.BackgroundColor3 = selectedBrainrots[itemName] and tc("Accent") or tc("TabBg")
                c.TextColor3       = selectedBrainrots[itemName] and Color3.fromRGB(0,0,0) or tc("Text")
            end
        end
    end)
end

-- ══════════════════════════════════
-- PLAYER WARNING OVERLAY
-- ══════════════════════════════════
do
    local ov = Instance.new("Frame", TabContentArea)
    playerWarningOverlay       = ov
    ov.Name                    = "WarningOverlay"
    ov.Size                    = UDim2.new(1, 0, 1, 0)
    ov.BackgroundColor3        = Color3.fromRGB(10, 8, 6)
    ov.BackgroundTransparency  = 0.06
    ov.BorderSizePixel         = 0
    ov.ZIndex                  = 200
    ov.Visible                 = false

    local wCard = Instance.new("Frame", ov)
    wCard.Size             = UDim2.new(0.88, 0, 0, 0)
    wCard.AutomaticSize    = Enum.AutomaticSize.Y
    wCard.AnchorPoint      = Vector2.new(0.5, 0.5)
    wCard.Position         = UDim2.new(0.5, 0, 0.5, 0)
    wCard.BackgroundColor3 = Color3.fromRGB(28, 18, 8)
    wCard.BorderSizePixel  = 0
    wCard.ZIndex           = 201
    addCorner(wCard, 14)
    addStroke(wCard, Color3.fromRGB(255, 155, 30), 2)

    local wLyt = Instance.new("UIListLayout", wCard)
    wLyt.FillDirection       = Enum.FillDirection.Vertical
    wLyt.HorizontalAlignment = Enum.HorizontalAlignment.Center
    wLyt.Padding             = UDim.new(0, 8)

    local wPad = Instance.new("UIPadding", wCard)
    wPad.PaddingTop    = UDim.new(0, 16)
    wPad.PaddingBottom = UDim.new(0, 16)
    wPad.PaddingLeft   = UDim.new(0, 16)
    wPad.PaddingRight  = UDim.new(0, 16)

    local wIcon = Instance.new("TextLabel", wCard)
    wIcon.Size                   = UDim2.new(1, 0, 0, 30)
    wIcon.BackgroundTransparency = 1
    wIcon.Text                   = "⚠️ Warning ⚠️"
    wIcon.TextColor3             = Color3.fromRGB(255, 155, 30)
    wIcon.Font                   = Enum.Font.GothamBold
    wIcon.TextSize               = 20
    wIcon.ZIndex                 = 202

    local wTxt = Instance.new("TextLabel", wCard)
    wTxt.Size                   = UDim2.new(1, 0, 0, 50)
    wTxt.BackgroundTransparency = 1
    wTxt.Text                   = "Using These Features Could Get You Banned, Use At Your Own Risk."
    wTxt.TextColor3             = Color3.fromRGB(220, 175, 115)
    wTxt.Font                   = Enum.Font.GothamMedium
    wTxt.TextSize               = 13
    wTxt.TextWrapped            = true
    wTxt.ZIndex                 = 202

    local wBtns = Instance.new("Frame", wCard)
    wBtns.Size                   = UDim2.new(1, 0, 0, 38)
    wBtns.BackgroundTransparency = 1
    wBtns.ZIndex                 = 202

    local wBLyt = Instance.new("UIListLayout", wBtns)
    wBLyt.FillDirection       = Enum.FillDirection.Horizontal
    wBLyt.HorizontalAlignment = Enum.HorizontalAlignment.Center
    wBLyt.VerticalAlignment   = Enum.VerticalAlignment.Center
    wBLyt.Padding             = UDim.new(0, 10)

    local okBtn = Instance.new("TextButton", wBtns)
    okBtn.Size             = UDim2.new(0, 120, 0, 34)
    okBtn.BackgroundColor3 = Color3.fromRGB(38, 155, 58)
    okBtn.Text             = "✓  Ok"
    okBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    okBtn.Font             = Enum.Font.GothamBold
    okBtn.TextSize         = 13
    okBtn.AutoButtonColor  = false
    okBtn.ZIndex           = 203
    addCorner(okBtn, 9)

    local goBackBtn = Instance.new("TextButton", wBtns)
    goBackBtn.Size             = UDim2.new(0, 120, 0, 34)
    goBackBtn.BackgroundColor3 = Color3.fromRGB(175, 38, 38)
    goBackBtn.Text             = "X  Go Back"
    goBackBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    goBackBtn.Font             = Enum.Font.GothamBold
    goBackBtn.TextSize         = 13
    goBackBtn.AutoButtonColor  = false
    goBackBtn.ZIndex           = 203
    addCorner(goBackBtn, 9)

    okBtn.MouseButton1Click:Connect(function()
        state.playerWarnOk = true
        ov.Visible = false
    end)
    goBackBtn.MouseButton1Click:Connect(function()
        switchTab("Home")
    end)
end

-- ══════════════════════════════════
-- MOBILE FLIGHT BUTTONS
-- ══════════════════════════════════
local mobileFlightFrame = Instance.new("Frame", ScreenGui)
mobileFlightFrame.Name                   = "MobileFlightBtns"
mobileFlightFrame.BackgroundTransparency = 1
mobileFlightFrame.AnchorPoint           = Vector2.new(0, 0)
mobileFlightFrame.Size                  = UDim2.new(0, 104, 0, 50)
mobileFlightFrame.ZIndex                = 150
mobileFlightFrame.Visible               = false

local flyUpHeld   = false
local flyDownHeld = false

local function makeFlyBtn(parent, lbl, xOff)
    local b = Instance.new("TextButton", parent)
    b.Size                   = UDim2.new(0, 46, 0, 46)
    b.Position               = UDim2.new(0, xOff, 0, 0)
    b.BackgroundColor3       = tc("OpenCloseBg")
    b.BackgroundTransparency = 0.22
    b.Text                   = lbl
    b.TextColor3             = Color3.fromRGB(255, 255, 255)
    b.Font                   = Enum.Font.GothamBold
    b.TextSize               = 20
    b.AutoButtonColor        = false
    b.ZIndex                 = 151
    addCorner(b, 23)
    addStroke(b, tc("Accent"), 2)
    return b
end

local flyUpBtn   = makeFlyBtn(mobileFlightFrame, "▲", 0)
local flyDownBtn = makeFlyBtn(mobileFlightFrame, "▼", 52)

flyUpBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then flyUpHeld = true end
end)
flyUpBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then flyUpHeld = false end
end)
flyDownBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then flyDownHeld = true end
end)
flyDownBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then flyDownHeld = false end
end)

local function updateMobileFlightPos()
    local vp = Camera.ViewportSize
    mobileFlightFrame.Position = UDim2.new(0, vp.X - 112, 0, vp.Y - 90)
end

onThemeUpdate(function()
    flyUpBtn.BackgroundColor3   = tc("OpenCloseBg")
    flyDownBtn.BackgroundColor3 = tc("OpenCloseBg")
    for _, b in ipairs({flyUpBtn, flyDownBtn}) do
        for _, c in ipairs(b:GetChildren()) do
            if c:IsA("UIStroke") then c.Color = tc("Accent") end
        end
    end
end)

-- ══════════════════════════════════
-- PLAYER TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Player"]
    local lo = 0
    local function nlo() lo += 1 return lo end

    sectionLabel(pg, "Speed", nlo())

    local smRow = Instance.new("Frame", pg)
    smRow.Size             = UDim2.new(1, 0, 0, 34)
    smRow.BackgroundColor3 = tc("SecondaryBg")
    smRow.BorderSizePixel  = 0
    smRow.LayoutOrder      = nlo()
    addCorner(smRow, 8)
    local smStr = addStroke(smRow, tc("Stroke"), 1)

    local smLbl = Instance.new("TextLabel", smRow)
    smLbl.Size                   = UDim2.new(0.55, 0, 1, 0)
    smLbl.Position               = UDim2.new(0, 9, 0, 0)
    smLbl.BackgroundTransparency = 1
    smLbl.Text                   = "Speed Slider Max:"
    smLbl.TextColor3             = tc("TextDim")
    smLbl.Font                   = Enum.Font.GothamMedium
    smLbl.TextSize               = 11
    smLbl.TextXAlignment         = Enum.TextXAlignment.Left

    local smBox = Instance.new("TextBox", smRow)
    smBox.Size             = UDim2.new(0.36, 0, 0, 24)
    smBox.Position         = UDim2.new(0.62, 0, 0.5, -12)
    smBox.BackgroundColor3 = tc("TabBg")
    smBox.BorderSizePixel  = 0
    smBox.Text             = "100"
    smBox.TextColor3       = tc("Text")
    smBox.Font             = Enum.Font.Gotham
    smBox.TextSize         = 12
    smBox.ClearTextOnFocus = false
    addCorner(smBox, 6)

    local _, getSpeedVal, setSpeedRange = buildSlider(pg, "Speed", 16, 100, 16, nlo(), function(v)
        state.speedValue = v
        if state.speedEnabled then
            pcall(function()
                local _, hum = getCharHum()
                if hum then hum.WalkSpeed = v end
            end)
        end
    end)

    smBox:GetPropertyChangedSignal("Text"):Connect(function()
        local n = tonumber(smBox.Text)
        if n and n > 16 then
            state.speedMaxValue = n
            setSpeedRange(16, n)
        end
    end)

    local _, speedTogSet = buildToggle(pg, "Speed Boost", nlo(), function(enabled)
        state.speedEnabled = enabled
        showNotification("Speed Boost " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))
        local _, hum = getCharHum()
        if not hum then return end
        if enabled then
            hum.WalkSpeed = getSpeedVal()
        else
            pcall(function()
                local lbl = LocalPlayer.PlayerGui.HUD.Speed
                local num = lbl.Text:match("%d+%.?%d*")
                if num then hum.WalkSpeed = tonumber(num) end
            end)
        end
    end)

    sectionLabel(pg, "Jump", nlo())

    local _, getJumpVal, _ = buildSlider(pg, "Jump Power", 30, 200, 30, nlo(), function(v)
        state.jumpValue = v
        if state.jumpEnabled then
            pcall(function()
                local _, hum = getCharHum()
                if hum then hum.JumpPower = v end
            end)
        end
    end)

    local _, jumpTogSet = buildToggle(pg, "Jump Boost", nlo(), function(enabled)
        state.jumpEnabled = enabled
        showNotification("Jump Boost " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))
        local _, hum = getCharHum()
        if not hum then return end
        if enabled then
            hum.JumpPower = getJumpVal()
        else
            pcall(function()
                local lbl = LocalPlayer.PlayerGui.HUD.Jump
                local num = lbl.Text:match("%d+%.?%d*")
                if num then hum.JumpPower = 30 + tonumber(num) * (10/3) end
            end)
        end
    end)

    sectionLabel(pg, "Survival", nlo())

    local lavaDisabledParts = {}
    local _, godTogSet = buildToggle(pg, "Godmode (Lava Off)", nlo(), function(enabled)
        state.godmodeEnabled = enabled
        showNotification("Godmode " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))
        if enabled then
            pcall(function()
                local lavas = workspace.GameFolder.Lavas
                for _, part in ipairs(lavas:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanTouch then
                        part.CanTouch = false
                        table.insert(lavaDisabledParts, part)
                    end
                end
            end)
        else
            for _, part in ipairs(lavaDisabledParts) do
                pcall(function() part.CanTouch = true end)
            end
            lavaDisabledParts = {}
        end
    end)

    sectionLabel(pg, "Movement", nlo())

    local flyConn    = nil
    local flyEnabled = false

    local function startFlight()
        local _, hum, hrp = getCharHum()
        if not (hum and hrp) then return end
        hum.PlatformStand = true

        flyConn = RunService.Heartbeat:Connect(function(dt)
            if not flyEnabled then return end
            local _, h2, r2 = getCharHum()
            if not (h2 and r2) then return end

            local camCF    = workspace.CurrentCamera.CFrame
            local moveDir  = Vector3.zero
            local spd      = 50
            local gravComp = workspace.Gravity * dt

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)      then moveDir += Vector3.new(0,  1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)  then moveDir += Vector3.new(0, -1, 0) end

            -- Mobile thumbstick horizontal
            local mobDir = h2.MoveDirection
            if mobDir.Magnitude > 0.1 then
                local fwd   = Vector3.new(camCF.LookVector.X,  0, camCF.LookVector.Z)
                local right = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
                if fwd.Magnitude   > 0.01 then fwd   = fwd.Unit   end
                if right.Magnitude > 0.01 then right = right.Unit  end
                local ld = Vector3.new(mobDir.X, 0, mobDir.Z)
                if ld.Magnitude > 0.01 then
                    ld = ld.Unit
                    moveDir += fwd * (-ld.Z) + right * ld.X
                end
            end

            -- Mobile up/down
            if flyUpHeld   then moveDir += Vector3.new(0,  1, 0) end
            if flyDownHeld then moveDir += Vector3.new(0, -1, 0) end

            if moveDir.Magnitude > 0.01 then
                local vel = moveDir.Unit * spd
                r2.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y + gravComp, vel.Z)
            else
                r2.AssemblyLinearVelocity = Vector3.new(0, gravComp, 0)
            end

            r2.CFrame = CFrame.new(r2.Position, r2.Position + camCF.LookVector)
        end)
    end

    local function stopFlight()
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local _, hum, hrp = getCharHum()
        if hum then hum.PlatformStand = false end
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
        mobileFlightFrame.Visible = false
        flyUpHeld   = false
        flyDownHeld = false
    end

    local _, flyTogSet = buildToggle(pg, "Flight", nlo(), function(enabled)
        flyEnabled       = enabled
        state.flyEnabled = enabled
        showNotification("Flight " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))
        if enabled then
            mobileFlightFrame.Visible = true
            updateMobileFlightPos()
            startFlight()
        else
            stopFlight()
        end
    end)

    local _, teleportTogSet = buildToggle(pg, "Teleport to Brainrots", nlo(), function(enabled)
        state.teleportEnabled = enabled
        showNotification("Teleport to Brainrots " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.8)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        if state.speedEnabled then pcall(function() hum.WalkSpeed = getSpeedVal() end) end
        if state.jumpEnabled  then pcall(function() hum.JumpPower = getJumpVal()  end) end
        if state.flyEnabled   then
            flyEnabled = true
            task.wait(0.3)
            startFlight()
        end
    end)

    onThemeUpdate(function()
        smRow.BackgroundColor3 = tc("SecondaryBg")
        smStr.Color            = tc("Stroke")
        smLbl.TextColor3       = tc("TextDim")
        smBox.BackgroundColor3 = tc("TabBg")
        smBox.TextColor3       = tc("Text")
    end)
end

-- ══════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Visual"]
    local lo = 0
    local function nlo() lo += 1 return lo end

    sectionLabel(pg, "Brainrot Visuals", nlo())

    local _, brainHlTogSet = buildToggle(pg, "Highlight Selected Brainrots", nlo(), function(enabled)
        state.brainHighlight = enabled
        showNotification("Brainrot Highlight " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))
        if not enabled then
            for _, hl in pairs(detectedHighlights) do pcall(function() hl:Destroy() end) end
            detectedHighlights = {}
        end
    end)

    sectionLabel(pg, "Player Visuals", nlo())

    local playerHlActive   = false
    local playerHighlights = {}
    local playerBillboards = {}
    local playerHlConn     = nil
    local playerAddedConn  = nil

    local function addPlayerVisuals(player)
        if player == LocalPlayer then return end
        local char = player.Character
        if not char then return end
        if playerHighlights[player] then pcall(function() playerHighlights[player]:Destroy() end) end
        if playerBillboards[player] then pcall(function() playerBillboards[player].gui:Destroy() end) end

        local hl = Instance.new("Highlight", char)
        hl.FillColor           = Color3.fromRGB(100, 185, 255)
        hl.OutlineColor        = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency    = 0.42
        hl.OutlineTransparency = 0
        playerHighlights[player] = hl

        local head = char:FindFirstChild("Head")
        if head then
            local bb = Instance.new("BillboardGui", head)
            bb.Name        = "PC_PlayerBB"
            bb.Size        = UDim2.new(0, 120, 0, 40)
            bb.StudsOffset = Vector3.new(0, 2.8, 0)
            bb.AlwaysOnTop = true
            local il = Instance.new("TextLabel", bb)
            il.Size                   = UDim2.new(1, 0, 1, 0)
            il.BackgroundTransparency = 1
            il.Text                   = player.DisplayName .. "\n..."
            il.TextColor3             = Color3.fromRGB(255, 255, 255)
            il.Font                   = Enum.Font.GothamBold
            il.TextSize               = 12
            il.TextStrokeTransparency = 0.35
            il.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
            playerBillboards[player]  = {gui = bb, lbl = il}
        end
    end

    local function removeAllPlayerVisuals()
        if playerHlConn   then playerHlConn:Disconnect();   playerHlConn   = nil end
        for _, hl in pairs(playerHighlights) do pcall(function() hl:Destroy() end) end
        for _, d  in pairs(playerBillboards) do pcall(function() d.gui:Destroy() end) end
        playerHighlights = {}
        playerBillboards = {}
    end

    local _, plHlTogSet = buildToggle(pg, "Highlight Other Players", nlo(), function(enabled)
        playerHlActive       = enabled
        state.playerHighlight= enabled
        showNotification("Player Highlight " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(255,80,80))

        if enabled then
            for _, p in ipairs(Players:GetPlayers()) do addPlayerVisuals(p) end
            playerAddedConn = Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if playerHlActive then addPlayerVisuals(p) end
                end)
            end)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    p.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        if playerHlActive then addPlayerVisuals(p) end
                    end)
                end
            end
            playerHlConn = RunService.Heartbeat:Connect(function()
                local lc = LocalPlayer.Character
                local lr = lc and lc:FindFirstChild("HumanoidRootPart")
                for p, data in pairs(playerBillboards) do
                    pcall(function()
                        local pc = p.Character
                        local pr = pc and pc:FindFirstChild("HumanoidRootPart")
                        if pr and lr then
                            local dist = math.floor((pr.Position - lr.Position).Magnitude)
                            data.lbl.Text = p.DisplayName .. "\n" .. dist .. " studs"
                        end
                    end)
                end
            end)
        else
            removeAllPlayerVisuals()
            if playerAddedConn then playerAddedConn:Disconnect(); playerAddedConn = nil end
        end
    end)
end

-- ══════════════════════════════════
-- SETTINGS TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Settings"]
    local lo = 0
    local function nlo() lo += 1 return lo end

    sectionLabel(pg, "Theme", nlo())

    local thHdr = Instance.new("Frame", pg)
    thHdr.Size             = UDim2.new(1, 0, 0, 36)
    thHdr.BackgroundColor3 = tc("SecondaryBg")
    thHdr.BorderSizePixel  = 0
    thHdr.LayoutOrder      = nlo()
    addCorner(thHdr, 10)
    local thHdrStr = addStroke(thHdr, tc("Stroke"), 1)

    local thCurLbl = Instance.new("TextLabel", thHdr)
    thCurLbl.Size                   = UDim2.new(0.6, 0, 1, 0)
    thCurLbl.Position               = UDim2.new(0, 11, 0, 0)
    thCurLbl.BackgroundTransparency = 1
    thCurLbl.Text                   = "Theme: " .. currentThemeName
    thCurLbl.TextColor3             = tc("Text")
    thCurLbl.Font                   = Enum.Font.GothamMedium
    thCurLbl.TextSize               = 12
    thCurLbl.TextXAlignment         = Enum.TextXAlignment.Left

    local thChgBtn = Instance.new("TextButton", thHdr)
    thChgBtn.Size             = UDim2.new(0, 80, 0, 26)
    thChgBtn.Position         = UDim2.new(1, -88, 0.5, -13)
    thChgBtn.BackgroundColor3 = tc("ButtonBg")
    thChgBtn.Text             = "Change"
    thChgBtn.TextColor3       = tc("Text")
    thChgBtn.Font             = Enum.Font.GothamBold
    thChgBtn.TextSize         = 11
    thChgBtn.AutoButtonColor  = false
    addCorner(thChgBtn, 7)

    local thOptions = Instance.new("Frame", pg)
    thOptions.Size             = UDim2.new(1, 0, 0, 0)
    thOptions.BackgroundColor3 = tc("DropdownBg")
    thOptions.BorderSizePixel  = 0
    thOptions.LayoutOrder      = nlo()
    thOptions.ClipsDescendants = true
    addCorner(thOptions, 10)
    local thOptStr = addStroke(thOptions, tc("Stroke"), 1)

    local thOptLyt = Instance.new("UIListLayout", thOptions)
    thOptLyt.FillDirection = Enum.FillDirection.Vertical
    thOptLyt.Padding       = UDim.new(0, 2)

    local thOptPad = Instance.new("UIPadding", thOptions)
    thOptPad.PaddingTop    = UDim.new(0, 4)
    thOptPad.PaddingBottom = UDim.new(0, 4)
    thOptPad.PaddingLeft   = UDim.new(0, 5)
    thOptPad.PaddingRight  = UDim.new(0, 5)

    local THEME_LIST = {"Original", "Sky", "Lava"}
    local thOptBtns  = {}

    local function refreshThemeOptColors()
        for _, nm in ipairs(THEME_LIST) do
            local b = thOptBtns[nm]
            if b then
                b.BackgroundColor3 = (currentThemeName == nm) and tc("Accent") or tc("TabBg")
                b.TextColor3       = (currentThemeName == nm) and Color3.fromRGB(0,0,0) or tc("Text")
            end
        end
    end

    for _, nm in ipairs(THEME_LIST) do
        local b = Instance.new("TextButton", thOptions)
        b.Size             = UDim2.new(1, 0, 0, 30)
        b.BackgroundColor3 = (nm == currentThemeName) and tc("Accent") or tc("TabBg")
        b.Text             = nm
        b.TextColor3       = (nm == currentThemeName) and Color3.fromRGB(0,0,0) or tc("Text")
        b.Font             = Enum.Font.GothamMedium
        b.TextSize         = 12
        b.AutoButtonColor  = false
        addCorner(b, 7)
        thOptBtns[nm] = b
        b.MouseButton1Click:Connect(function()
            setTheme(nm)
            thCurLbl.Text = "Theme: " .. nm
            refreshThemeOptColors()
            tw(thOptions, {Size = UDim2.new(1, 0, 0, 0)}, 0.18)
        end)
    end

    local thExpanded = false
    local thOptH     = #THEME_LIST * 32 + 10
    thChgBtn.MouseButton1Click:Connect(function()
        thExpanded = not thExpanded
        tw(thOptions, {Size = UDim2.new(1, 0, 0, thExpanded and thOptH or 0)}, 0.2)
    end)

    local customBtn = Instance.new("TextButton", pg)
    customBtn.Size             = UDim2.new(1, 0, 0, 52)
    customBtn.BackgroundColor3 = tc("ButtonBg")
    customBtn.Text             = "Can't Find The Theme You Want?\nClick here to Customise the UI To Your Liking!"
    customBtn.TextColor3       = tc("Text")
    customBtn.Font             = Enum.Font.GothamMedium
    customBtn.TextSize         = 11
    customBtn.TextWrapped      = true
    customBtn.AutoButtonColor  = false
    customBtn.LayoutOrder      = nlo()
    addCorner(customBtn, 10)
    local cbStr = addStroke(customBtn, tc("Accent"), 1)

    local custEditor = Instance.new("Frame", pg)
    custEditor.Size             = UDim2.new(1, 0, 0, 0)
    custEditor.BackgroundColor3 = tc("SecondaryBg")
    custEditor.BorderSizePixel  = 0
    custEditor.LayoutOrder      = nlo()
    custEditor.ClipsDescendants = true
    addCorner(custEditor, 12)
    local ceStr = addStroke(custEditor, tc("Stroke"), 1)

    local ceScroll = Instance.new("ScrollingFrame", custEditor)
    ceScroll.Size                   = UDim2.new(1, 0, 1, 0)
    ceScroll.BackgroundTransparency = 1
    ceScroll.BorderSizePixel        = 0
    ceScroll.ScrollBarThickness     = 3
    ceScroll.ScrollBarImageColor3   = tc("Accent")
    ceScroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
    ceScroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y

    local ceLyt = Instance.new("UIListLayout", ceScroll)
    ceLyt.FillDirection = Enum.FillDirection.Vertical
    ceLyt.Padding       = UDim.new(0, 5)

    local cePad = Instance.new("UIPadding", ceScroll)
    cePad.PaddingTop    = UDim.new(0, 8)
    cePad.PaddingBottom = UDim.new(0, 8)
    cePad.PaddingLeft   = UDim.new(0, 8)
    cePad.PaddingRight  = UDim.new(0, 8)

    -- All customisable parts (expanded full list so custom theme has every key)
    local PARTS = {
        "Background","SecondaryBg","Accent","AccentDark","Text","TextDim",
        "TabBg","TabActive","ToggleOn","ToggleOff","SliderFill","SliderBg",
        "Stroke","GradStart","GradEnd","ButtonBg","DropdownBg","OpenCloseBg",
        "ScrollBar","SectionText"
    }

    local customColors = {}
    for _, p in ipairs(PARTS) do
        customColors[p] = tc(p)
    end

    local function c3ToHex(c)
        if typeof(c) ~= "Color3" then return "#808080" end
        return string.format("#%02X%02X%02X",
            math.clamp(math.round(c.R*255), 0, 255),
            math.clamp(math.round(c.G*255), 0, 255),
            math.clamp(math.round(c.B*255), 0, 255))
    end
    local function hexToC3(h)
        h = h:gsub("#", "")
        if #h ~= 6 then return nil end
        local r = tonumber(h:sub(1,2), 16)
        local g = tonumber(h:sub(3,4), 16)
        local b = tonumber(h:sub(5,6), 16)
        if r and g and b then return Color3.fromRGB(r, g, b) end
        return nil
    end

    local ceRowRefs = {}

    for _, partName in ipairs(PARTS) do
        local row = Instance.new("Frame", ceScroll)
        row.Size                   = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1

        local rLyt = Instance.new("UIListLayout", row)
        rLyt.FillDirection     = Enum.FillDirection.Horizontal
        rLyt.VerticalAlignment = Enum.VerticalAlignment.Center
        rLyt.Padding           = UDim.new(0, 6)

        local rLbl = Instance.new("TextLabel", row)
        rLbl.Size                   = UDim2.new(0.44, 0, 1, 0)
        rLbl.BackgroundTransparency = 1
        rLbl.Text                   = partName
        rLbl.TextColor3             = tc("Text")
        rLbl.Font                   = Enum.Font.GothamMedium
        rLbl.TextSize               = 10
        rLbl.TextXAlignment         = Enum.TextXAlignment.Left
        rLbl.TextWrapped            = true

        local rBox = Instance.new("TextBox", row)
        rBox.Size             = UDim2.new(0.36, 0, 0, 22)
        rBox.BackgroundColor3 = tc("TabBg")
        rBox.BorderSizePixel  = 0
        rBox.Text             = c3ToHex(customColors[partName])
        rBox.TextColor3       = tc("Text")
        rBox.Font             = Enum.Font.Code
        rBox.TextSize         = 10
        rBox.ClearTextOnFocus = false
        addCorner(rBox, 5)

        local rPrev = Instance.new("Frame", row)
        rPrev.Size             = UDim2.new(0, 20, 0, 20)
        rPrev.BackgroundColor3 = customColors[partName]
        rPrev.BorderSizePixel  = 0
        addCorner(rPrev, 4)

        rBox:GetPropertyChangedSignal("Text"):Connect(function()
            local c = hexToC3(rBox.Text)
            if c then
                customColors[partName] = c
                rPrev.BackgroundColor3 = c
            end
        end)

        table.insert(ceRowRefs, {lbl = rLbl, box = rBox})

        onThemeUpdate(function()
            rLbl.TextColor3       = tc("Text")
            rBox.BackgroundColor3 = tc("TabBg")
            rBox.TextColor3       = tc("Text")
            -- Also reseed the color input to the current theme value if user hasn't customised
            customColors[partName] = tc(partName)
            rBox.Text             = c3ToHex(customColors[partName])
            rPrev.BackgroundColor3= customColors[partName]
        end)
    end

    local applyBtn = Instance.new("TextButton", ceScroll)
    applyBtn.Size             = UDim2.new(1, 0, 0, 32)
    applyBtn.BackgroundColor3 = tc("Accent")
    applyBtn.Text             = "Apply Custom Theme"
    applyBtn.TextColor3       = Color3.fromRGB(0, 0, 0)
    applyBtn.Font             = Enum.Font.GothamBold
    applyBtn.TextSize         = 12
    applyBtn.AutoButtonColor  = false
    addCorner(applyBtn, 8)

    applyBtn.MouseButton1Click:Connect(function()
        setTheme("Custom", customColors)
        thCurLbl.Text = "Theme: Custom"
        showNotification("Custom Theme Applied!", tc("Accent"))
    end)

    local ceExpanded = false
    local ceH        = (#PARTS * 33) + 56

    customBtn.MouseButton1Click:Connect(function()
        ceExpanded = not ceExpanded
        tw(custEditor, {Size = UDim2.new(1, 0, 0, ceExpanded and ceH or 0)}, 0.26)
    end)

    onThemeUpdate(function()
        thHdr.BackgroundColor3     = tc("SecondaryBg")
        thHdrStr.Color             = tc("Stroke")
        thCurLbl.TextColor3        = tc("Text")
        thChgBtn.BackgroundColor3  = tc("ButtonBg")
        thChgBtn.TextColor3        = tc("Text")
        thOptions.BackgroundColor3 = tc("DropdownBg")
        thOptStr.Color             = tc("Stroke")
        refreshThemeOptColors()
        customBtn.BackgroundColor3 = tc("ButtonBg")
        customBtn.TextColor3       = tc("Text")
        cbStr.Color                = tc("Accent")
        custEditor.BackgroundColor3= tc("SecondaryBg")
        ceStr.Color                = tc("Stroke")
        applyBtn.BackgroundColor3  = tc("Accent")
        ceScroll.ScrollBarImageColor3 = tc("Accent")
    end)
end

-- ══════════════════════════════════
-- GLOBAL THEME UPDATE (main GUI chrome)
-- ══════════════════════════════════
onThemeUpdate(function()
    -- Main frame
    MainFrame.BackgroundColor3 = tc("Background")
    mfStroke.Color             = tc("Accent")
    mfGrad.Color               = ColorSequence.new(tc("GradStart"), tc("GradEnd"))

    -- Title bar
    TitleBar.BackgroundColor3  = tc("SecondaryBg")
    tbGrad.Color               = ColorSequence.new(tc("AccentDark"), tc("Background"))
    TitleLbl.TextColor3        = tc("Text")

    -- Tab bar
    TabBar.BackgroundColor3    = tc("SecondaryBg")
    tabBarGrad.Color           = ColorSequence.new(tc("TabBg"), tc("SecondaryBg"))

    -- Open/close button
    OcBtn.BackgroundColor3     = tc("OpenCloseBg")
    ocStroke.Color             = tc("Accent")
    ocGrad.Color               = ColorSequence.new(tc("AccentDark"), tc("OpenCloseBg"))
    OcText.TextColor3          = tc("Text")

    -- Tab buttons
    for tabName, btn in pairs(tabButtons) do
        if tabName == activeTab then
            btn.BackgroundColor3 = tc("TabActive")
            btn.Lbl.TextColor3   = tc("Text")
        else
            btn.BackgroundColor3 = tc("TabBg")
            btn.Lbl.TextColor3   = tc("TextDim")
        end
    end

    -- Scrollbar colors
    for _, pg in pairs(tabPages) do
        pg.ScrollBarImageColor3 = tc("ScrollBar")
    end
end)

-- ══════════════════════════════════
-- VIEWPORT RESPONSIVENESS
-- ══════════════════════════════════
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updateOcSize()
    updateMainSize()
    task.defer(positionOcBtn)
    updateMobileFlightPos()
end)

-- ══════════════════════════════════
-- INITIAL SETUP
-- ══════════════════════════════════
task.defer(function()
    updateMobileFlightPos()
    switchTab("Home")
    positionOcBtn()
    fireThemeUpdate()
end)

print("[Project Crafted V2] Loaded successfully!")
