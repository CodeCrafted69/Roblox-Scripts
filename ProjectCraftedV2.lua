--[[
    ╔══════════════════════════════════════╗
    ║       Project Crafted V2             ║
    ║       Executor Script                ║
    ╚══════════════════════════════════════╝
]]

-- ══════════════════════════════════
-- SERVICES
-- ══════════════════════════════════
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local MarketplaceService= game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local StarterGui        = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ══════════════════════════════════
-- GAME ID CHECK
-- ══════════════════════════════════
local TARGET_GAME_ID = 119987266683883

if game.PlaceId ~= TARGET_GAME_ID then
    local badGui = Instance.new("ScreenGui")
    badGui.Name         = "PC_Unsupported"
    badGui.ResetOnSpawn = false
    badGui.DisplayOrder = 9999
    badGui.IgnoreGuiInset = true
    badGui.Parent       = CoreGui

    local badFrame = Instance.new("Frame")
    badFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    badFrame.Position    = UDim2.new(0.5, 0, 0.5, 0)
    badFrame.Size        = UDim2.new(0, 0, 0, 0)
    badFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
    badFrame.BorderSizePixel  = 0
    badFrame.Parent = badGui

    Instance.new("UICorner", badFrame).CornerRadius = UDim.new(0, 14)
    local bs = Instance.new("UIStroke", badFrame)
    bs.Color     = Color3.fromRGB(220, 60, 60)
    bs.Thickness = 2

    local badLbl = Instance.new("TextLabel", badFrame)
    badLbl.Size               = UDim2.new(1, -24, 1, 0)
    badLbl.Position           = UDim2.new(0, 12, 0, 0)
    badLbl.BackgroundTransparency = 1
    local gn = "This Game"
    pcall(function() gn = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    badLbl.Text      = gn .. " Is Not Supported!"
    badLbl.TextColor3 = Color3.fromRGB(255, 90, 80)
    badLbl.Font       = Enum.Font.GothamBold
    badLbl.TextScaled = true

    TweenService:Create(badFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.38, 0, 0.08, 0)}):Play()
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
local CFG_ROOT    = "ProjectCrafted"
local CFG_DIR     = CFG_ROOT .. "/configs"
local THEME_FILE  = CFG_DIR  .. "/theme.txt"
local COUNT_FILE  = CFG_DIR  .. "/execcount.txt"
local CUSTOM_FILE = CFG_DIR  .. "/customtheme.txt"

local function safeReadFile(path)
    local ok, result = pcall(function()
        if isfile and isfile(path) then return readfile(path) end
    end)
    if ok then return result end
    return nil
end

local function safeWriteFile(path, content)
    pcall(function()
        if writefile then writefile(path, tostring(content)) end
    end)
end

local function ensureDirs()
    pcall(function()
        if isfolder and not isfolder(CFG_ROOT) then makefolder(CFG_ROOT) end
        if isfolder and not isfolder(CFG_DIR)  then makefolder(CFG_DIR)  end
    end)
end
ensureDirs()

-- Execution Count
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
        Background    = Color3.fromRGB(14, 22, 14),
        SecondaryBg   = Color3.fromRGB(20, 34, 20),
        Accent        = Color3.fromRGB(60, 210, 90),
        AccentDark    = Color3.fromRGB(35, 130, 55),
        Text          = Color3.fromRGB(215, 255, 215),
        TextDim       = Color3.fromRGB(130, 175, 130),
        TabBg         = Color3.fromRGB(22, 36, 22),
        TabActive     = Color3.fromRGB(60, 210, 90),
        ToggleOn      = Color3.fromRGB(60, 210, 90),
        ToggleOff     = Color3.fromRGB(55, 68, 55),
        SliderFill    = Color3.fromRGB(60, 210, 90),
        SliderBg      = Color3.fromRGB(32, 50, 32),
        Stroke        = Color3.fromRGB(60, 210, 90),
        GradStart     = Color3.fromRGB(14, 22, 14),
        GradEnd       = Color3.fromRGB(22, 40, 22),
        ButtonBg      = Color3.fromRGB(28, 95, 42),
        DropdownBg    = Color3.fromRGB(18, 30, 18),
        OpenCloseBg   = Color3.fromRGB(28, 100, 44),
        ScrollBar     = Color3.fromRGB(60, 210, 90),
        SectionText   = Color3.fromRGB(60, 210, 90),
    },
    Sky = {
        Background    = Color3.fromRGB(12, 18, 34),
        SecondaryBg   = Color3.fromRGB(18, 26, 50),
        Accent        = Color3.fromRGB(80, 175, 255),
        AccentDark    = Color3.fromRGB(45, 115, 200),
        Text          = Color3.fromRGB(210, 232, 255),
        TextDim       = Color3.fromRGB(120, 155, 200),
        TabBg         = Color3.fromRGB(20, 30, 55),
        TabActive     = Color3.fromRGB(80, 175, 255),
        ToggleOn      = Color3.fromRGB(80, 175, 255),
        ToggleOff     = Color3.fromRGB(45, 58, 80),
        SliderFill    = Color3.fromRGB(80, 175, 255),
        SliderBg      = Color3.fromRGB(28, 44, 70),
        Stroke        = Color3.fromRGB(80, 175, 255),
        GradStart     = Color3.fromRGB(12, 18, 38),
        GradEnd       = Color3.fromRGB(20, 32, 62),
        ButtonBg      = Color3.fromRGB(28, 78, 165),
        DropdownBg    = Color3.fromRGB(15, 24, 46),
        OpenCloseBg   = Color3.fromRGB(35, 95, 200),
        ScrollBar     = Color3.fromRGB(80, 175, 255),
        SectionText   = Color3.fromRGB(80, 175, 255),
    },
    Lava = {
        Background    = Color3.fromRGB(24, 10, 5),
        SecondaryBg   = Color3.fromRGB(34, 15, 8),
        Accent        = Color3.fromRGB(255, 105, 30),
        AccentDark    = Color3.fromRGB(195, 60, 10),
        Text          = Color3.fromRGB(255, 220, 195),
        TextDim       = Color3.fromRGB(175, 125, 100),
        TabBg         = Color3.fromRGB(38, 18, 8),
        TabActive     = Color3.fromRGB(255, 105, 30),
        ToggleOn      = Color3.fromRGB(255, 105, 30),
        ToggleOff     = Color3.fromRGB(68, 35, 20),
        SliderFill    = Color3.fromRGB(255, 105, 30),
        SliderBg      = Color3.fromRGB(52, 24, 10),
        Stroke        = Color3.fromRGB(255, 105, 30),
        GradStart     = Color3.fromRGB(26, 10, 5),
        GradEnd       = Color3.fromRGB(40, 20, 8),
        ButtonBg      = Color3.fromRGB(140, 42, 10),
        DropdownBg    = Color3.fromRGB(30, 14, 6),
        OpenCloseBg   = Color3.fromRGB(160, 52, 14),
        ScrollBar     = Color3.fromRGB(255, 105, 30),
        SectionText   = Color3.fromRGB(255, 105, 30),
    },
}

-- Load saved theme
local currentThemeName = "Original"
local savedThemeName   = safeReadFile(THEME_FILE)
if savedThemeName and Themes[savedThemeName] then
    currentThemeName = savedThemeName
end

-- Custom theme support
local savedCustomRaw = safeReadFile(CUSTOM_FILE)
if savedCustomRaw and currentThemeName == "Custom" then
    pcall(function()
        local t = HttpService:JSONDecode(savedCustomRaw)
        -- convert arrays to Color3
        local converted = {}
        for k, v in pairs(t) do
            if type(v) == "table" and v.r then
                converted[k] = Color3.new(v.r, v.g, v.b)
            elseif type(v) == "table" and #v == 3 then
                converted[k] = Color3.new(v[1], v[2], v[3])
            end
        end
        if next(converted) then
            Themes["Custom"] = converted
        end
    end)
end

local T = Themes[currentThemeName] or Themes["Original"]  -- active theme table

-- Theme update callbacks
local themeCallbacks = {}
local function onThemeUpdate(fn) table.insert(themeCallbacks, fn) end
local function fireThemeUpdate()
    T = Themes[currentThemeName] or Themes["Original"]
    for _, fn in ipairs(themeCallbacks) do pcall(fn) end
end

local function setTheme(name, customData)
    if customData then
        local stored = {}
        for k, c in pairs(customData) do
            stored[k] = {r = c.R, g = c.G, b = c.B}
        end
        safeWriteFile(CUSTOM_FILE, HttpService:JSONEncode(stored))
        Themes["Custom"] = customData
        currentThemeName  = "Custom"
        safeWriteFile(THEME_FILE, "Custom")
    elseif Themes[name] then
        currentThemeName = name
        safeWriteFile(THEME_FILE, name)
    end
    fireThemeUpdate()
end

-- ══════════════════════════════════
-- FEATURE STATE (forward declarations)
-- ══════════════════════════════════
local state = {
    speedEnabled      = false,
    jumpEnabled       = false,
    godmodeEnabled    = false,
    flyEnabled        = false,
    teleportEnabled   = false,
    brainHighlight    = false,
    playerHighlight   = false,
    autoCollect       = false,
    playerWarnOk      = false,
    speedValue        = 16,
    jumpValue         = 30,
    speedMaxValue     = 100,
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
    s.Color           = col or T.Stroke
    s.Thickness       = thick or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function addGradient(p, c0, c1, rot)
    local g = Instance.new("UIGradient", p)
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    return g
end

local function tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function formatTime(secs)
    local m = math.floor(secs / 60)
    local s = math.floor(secs % 60)
    return string.format("%d:%02d", m, s)
end

local function getCharHum()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, hum, hrp
end

-- ══════════════════════════════════
-- NOTIFICATION SYSTEM
-- ══════════════════════════════════
local notifQueue   = {}
local notifRunning = false

local function showNotification(text, color, duration)
    local vp = Camera.ViewportSize
    local nW = math.clamp(vp.X * 0.36, 230, 420)
    local nH = math.clamp(vp.Y * 0.068, 46, 68)

    local notifGui = Instance.new("ScreenGui")
    notifGui.Name            = "PC_Notif"
    notifGui.ResetOnSpawn    = false
    notifGui.DisplayOrder    = 500
    notifGui.IgnoreGuiInset  = true
    notifGui.Parent          = CoreGui

    local frame = Instance.new("Frame", notifGui)
    frame.Size        = UDim2.new(0, nW, 0, nH)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position    = UDim2.new(0.5, 0, 0, -nH - 10)
    frame.BackgroundColor3 = T.SecondaryBg
    frame.BorderSizePixel  = 0
    addCorner(frame, 12)
    local ns = addStroke(frame, color or T.Accent, 2)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size                  = UDim2.new(1, -20, 1, 0)
    lbl.Position              = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency= 1
    lbl.Text                  = text
    lbl.TextColor3            = color or T.Text
    lbl.Font                  = Enum.Font.GothamMedium
    lbl.TextSize              = 14
    lbl.TextWrapped           = true
    lbl.TextScaled            = false

    tween(frame, {Position = UDim2.new(0.5, 0, 0, 10)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.delay(duration or 2.6, function()
        tween(frame, {Position = UDim2.new(0.5, 0, 0, -nH - 10)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.4, function() notifGui:Destroy() end)
    end)
end

-- ══════════════════════════════════
-- MAIN SCREENGUI
-- ══════════════════════════════════
-- Clean up old instances
pcall(function()
    if CoreGui:FindFirstChild("ProjectCraftedV2") then
        CoreGui:FindFirstChild("ProjectCraftedV2"):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "ProjectCraftedV2"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 10
ScreenGui.Parent         = CoreGui

-- ══════════════════════════════════
-- OPEN/CLOSE TOGGLE BUTTON
-- ══════════════════════════════════
local OcBtn = Instance.new("ImageButton", ScreenGui)
OcBtn.Name             = "OpenCloseBtn"
OcBtn.BackgroundColor3 = T.OpenCloseBg
OcBtn.BorderSizePixel  = 0
OcBtn.AutoButtonColor  = false
OcBtn.ZIndex           = 100
OcBtn.AnchorPoint      = Vector2.new(1, 0)
addCorner(OcBtn, 10)
local ocStroke  = addStroke(OcBtn, T.Accent, 2)
addGradient(OcBtn, T.AccentDark, T.OpenCloseBg, 135)

local OcLogo = Instance.new("ImageLabel", OcBtn)
OcLogo.BackgroundTransparency = 1
OcLogo.Image    = "rbxassetid://85816937697749"
OcLogo.ScaleType = Enum.ScaleType.Fit
OcLogo.ZIndex   = 101

local OcText = Instance.new("TextLabel", OcBtn)
OcText.BackgroundTransparency = 1
OcText.Text      = "Project Crafted"
OcText.TextColor3 = T.Text
OcText.Font      = Enum.Font.GothamBold
OcText.TextScaled = true
OcText.ZIndex    = 101

local function updateOcSize()
    local vp = Camera.ViewportSize
    local bH = math.clamp(vp.Y * 0.055, 36, 52)
    local bW = math.clamp(vp.X * 0.165, 130, 195)
    OcBtn.Size     = UDim2.new(0, bW, 0, bH)
    OcLogo.Size    = UDim2.new(0, bH - 10, 0, bH - 10)
    OcLogo.Position = UDim2.new(0, 5, 0.5, -(bH - 10) / 2)
    OcText.Size    = UDim2.new(0, bW - bH - 8, 0, bH - 12)
    OcText.Position = UDim2.new(0, bH + 4, 0.5, -(bH - 12) / 2)
end

local function positionOcBtn()
    local vp = Camera.ViewportSize
    local bSz = OcBtn.AbsoluteSize
    local bW, bH = bSz.X, bSz.Y

    local function getGuiRects()
        local rects = {}
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetDescendants()) do
                if g:IsA("GuiObject") and g.Visible then
                    local p2 = g.AbsolutePosition
                    local s2 = g.AbsoluteSize
                    if s2.Magnitude > 10 then
                        table.insert(rects, {x1=p2.X, y1=p2.Y, x2=p2.X+s2.X, y2=p2.Y+s2.Y})
                    end
                end
            end
        end
        return rects
    end

    local function rectOverlaps(rects, ax, ay)
        for _, r in ipairs(rects) do
            if not (ax + bW <= r.x1 or ax >= r.x2 or ay + bH <= r.y1 or ay >= r.y2) then
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
    local anchors = {
        Vector2.new(0,0), Vector2.new(0,0), Vector2.new(0,0), Vector2.new(0,0)
    }

    for i, cand in ipairs(candidates) do
        if not rectOverlaps(rects, cand.x, cand.y) then
            OcBtn.AnchorPoint = Vector2.new(0, 0)
            OcBtn.Position    = UDim2.new(0, cand.x, 0, cand.y)
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
MainFrame.BackgroundColor3 = T.Background
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex           = 50
local mfCorner = addCorner(MainFrame, 14)
local mfStroke = addStroke(MainFrame, T.Accent, 2)
local mfGrad   = addGradient(MainFrame, T.GradStart, T.GradEnd, 135)

local function updateMainSize()
    local vp = Camera.ViewportSize
    local w  = math.clamp(vp.X * 0.58, 330, 720)
    local h  = math.clamp(vp.Y * 0.72, 420, 620)
    MainFrame.Size = UDim2.new(0, w, 0, h)
end
updateMainSize()

-- ── Title Bar ──
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = T.SecondaryBg
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 51
addCorner(TitleBar, 14)
local tbGrad = addGradient(TitleBar, T.AccentDark, T.Background, 180)

local TitleLogo = Instance.new("ImageLabel", TitleBar)
TitleLogo.Size                = UDim2.new(0, 28, 0, 28)
TitleLogo.Position            = UDim2.new(0, 8, 0.5, -14)
TitleLogo.BackgroundTransparency = 1
TitleLogo.Image               = "rbxassetid://85816937697749"
TitleLogo.ScaleType           = Enum.ScaleType.Fit
TitleLogo.ZIndex              = 52

local TitleLbl = Instance.new("TextLabel", TitleBar)
TitleLbl.Size                  = UDim2.new(1, -130, 1, 0)
TitleLbl.Position              = UDim2.new(0, 44, 0, 0)
TitleLbl.BackgroundTransparency= 1
TitleLbl.Text                  = "Project Crafted V2"
TitleLbl.TextColor3            = T.Text
TitleLbl.Font                  = Enum.Font.GothamBold
TitleLbl.TextSize              = 17
TitleLbl.TextXAlignment        = Enum.TextXAlignment.Left
TitleLbl.ZIndex                = 52

-- Close / Minimise buttons
local function makeWindowBtn(parent, col, lbl, xOff)
    local b = Instance.new("TextButton", parent)
    b.Size             = UDim2.new(0, 28, 0, 28)
    b.Position         = UDim2.new(1, xOff, 0.5, -14)
    b.BackgroundColor3 = col
    b.Text             = lbl
    b.TextColor3       = Color3.fromRGB(255,255,255)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 14
    b.AutoButtonColor  = false
    b.ZIndex           = 52
    addCorner(b, 7)
    return b
end
local TitleClose = makeWindowBtn(TitleBar, Color3.fromRGB(200,55,55), "X",  -36)
local TitleMin   = makeWindowBtn(TitleBar, Color3.fromRGB(200,160,30), "-", -70)

-- ── Content Area ──
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Name              = "ContentArea"
ContentArea.Size              = UDim2.new(1, 0, 1, -42)
ContentArea.Position          = UDim2.new(0, 0, 0, 42)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants  = true
ContentArea.ZIndex            = 51

-- ── Tab Bar ──
local TabBar = Instance.new("Frame", ContentArea)
TabBar.Name             = "TabBar"
TabBar.Size             = UDim2.new(1, 0, 0, 40)
TabBar.BackgroundColor3 = T.SecondaryBg
TabBar.BorderSizePixel  = 0
TabBar.ZIndex           = 52
addGradient(TabBar, T.TabBg, T.SecondaryBg, 90)

local tabLayout = Instance.new("UIListLayout", TabBar)
tabLayout.FillDirection       = Enum.FillDirection.Horizontal
tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.Padding             = UDim.new(0, 3)

local tabBarPad = Instance.new("UIPadding", TabBar)
tabBarPad.PaddingLeft   = UDim.new(0, 6)
tabBarPad.PaddingRight  = UDim.new(0, 6)
tabBarPad.PaddingTop    = UDim.new(0, 5)
tabBarPad.PaddingBottom = UDim.new(0, 5)

-- ── Tab Content Area ──
local TabContentArea = Instance.new("Frame", ContentArea)
TabContentArea.Name              = "TabContentArea"
TabContentArea.Size              = UDim2.new(1, 0, 1, -40)
TabContentArea.Position          = UDim2.new(0, 0, 0, 40)
TabContentArea.BackgroundTransparency = 1
TabContentArea.ClipsDescendants  = true
TabContentArea.ZIndex            = 51

-- ══════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════
local TAB_NAMES = {"Home", "Main", "Player", "Visual", "Settings"}
local tabButtons = {}
local tabPages   = {}
local activeTab  = nil

local function createTabButton(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Name             = name .. "_Tab"
    btn.Size             = UDim2.new(0, 0, 1, -4)
    btn.AutomaticSize    = Enum.AutomaticSize.X
    btn.BackgroundColor3 = T.TabBg
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.AutoButtonColor  = false
    btn.ZIndex           = 53
    addCorner(btn, 8)

    local tpad = Instance.new("UIPadding", btn)
    tpad.PaddingLeft  = UDim.new(0, 10)
    tpad.PaddingRight = UDim.new(0, 10)

    local tlbl = Instance.new("TextLabel", btn)
    tlbl.Name                  = "Lbl"
    tlbl.Size                  = UDim2.new(0, 0, 1, 0)
    tlbl.AutomaticSize         = Enum.AutomaticSize.X
    tlbl.BackgroundTransparency= 1
    tlbl.Text                  = name
    tlbl.TextColor3            = T.TextDim
    tlbl.Font                  = Enum.Font.GothamMedium
    tlbl.TextSize              = 12
    tlbl.ZIndex                = 54
    return btn
end

local function createTabPage(name)
    local sf = Instance.new("ScrollingFrame", TabContentArea)
    sf.Name                  = name .. "_Page"
    sf.Size                  = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency= 1
    sf.BorderSizePixel        = 0
    sf.ScrollBarThickness     = 4
    sf.ScrollBarImageColor3   = T.ScrollBar
    sf.CanvasSize             = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    sf.Visible                = false
    sf.ZIndex                 = 52

    local lyt = Instance.new("UIListLayout", sf)
    lyt.FillDirection  = Enum.FillDirection.Vertical
    lyt.Padding        = UDim.new(0, 8)
    lyt.SortOrder      = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", sf)
    pad.PaddingLeft   = UDim.new(0, 12)
    pad.PaddingRight  = UDim.new(0, 14)
    pad.PaddingTop    = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 14)
    return sf
end

for _, name in ipairs(TAB_NAMES) do
    tabButtons[name] = createTabButton(name)
    tabPages[name]   = createTabPage(name)
end

-- Player Warning state (persists)
local playerWarningOverlay

local function switchTab(name)
    if activeTab == name then return end

    if activeTab then
        local ob = tabButtons[activeTab]
        local op = tabPages[activeTab]
        tween(ob, {BackgroundColor3 = T.TabBg}, 0.2)
        ob.Lbl.TextColor3 = T.TextDim
        ob.Lbl.Font       = Enum.Font.GothamMedium
        op.Visible = false
    end

    activeTab = name
    local nb = tabButtons[name]
    local np = tabPages[name]

    tween(nb, {BackgroundColor3 = T.TabActive}, 0.2)
    nb.Lbl.TextColor3 = T.Text
    nb.Lbl.Font       = Enum.Font.GothamBold
    np.Visible = true
    np.Position = UDim2.new(0, 0, 0, 16)
    tween(np, {Position = UDim2.new(0, 0, 0, 0)}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Show/hide warning overlay
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
-- DRAG (Title Bar)
-- ══════════════════════════════════
do
    local dragging   = false
    local dragStart  = nil
    local startPos   = nil

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
local isOpen = true
local lastOpenSize = MainFrame.Size

local function toggleMainGui()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.ClipsDescendants = true
        tween(MainFrame, {Size = lastOpenSize}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        lastOpenSize = MainFrame.Size
        tween(MainFrame, {Size = UDim2.new(lastOpenSize.X.Scale, lastOpenSize.X.Offset, 0, 0)},
              0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.32, function() MainFrame.Visible = false end)
    end
end

OcBtn.MouseButton1Click:Connect(toggleMainGui)
TitleClose.MouseButton1Click:Connect(toggleMainGui)
TitleMin.MouseButton1Click:Connect(function()
    if isOpen then toggleMainGui() end
end)

-- ══════════════════════════════════
-- UI COMPONENT BUILDERS
-- ══════════════════════════════════

local function sectionLabel(page, txt, order)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.LayoutOrder      = order

    local lbl = Instance.new("TextLabel", f)
    lbl.Size             = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text             = "── " .. txt .. " ──"
    lbl.TextColor3       = T.SectionText
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextSize         = 12
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    return f, lbl
end

local function infoRow(page, lTxt, vTxt, order)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = T.SecondaryBg
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    addCorner(f, 8)

    local kl = Instance.new("TextLabel", f)
    kl.Size               = UDim2.new(0.46, 0, 1, 0)
    kl.Position           = UDim2.new(0, 10, 0, 0)
    kl.BackgroundTransparency = 1
    kl.Text               = lTxt
    kl.TextColor3         = T.TextDim
    kl.Font               = Enum.Font.GothamMedium
    kl.TextSize           = 12
    kl.TextXAlignment     = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", f)
    vl.Name               = "Val"
    vl.Size               = UDim2.new(0.52, 0, 1, 0)
    vl.Position           = UDim2.new(0.47, 0, 0, 0)
    vl.BackgroundTransparency = 1
    vl.Text               = vTxt or "..."
    vl.TextColor3         = T.Text
    vl.Font               = Enum.Font.Gotham
    vl.TextSize           = 12
    vl.TextXAlignment     = Enum.TextXAlignment.Left

    return f, vl, kl
end

-- Toggle builder
local function buildToggle(page, labelTxt, order, onFn)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 44)
    f.BackgroundColor3 = T.SecondaryBg
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    addCorner(f, 10)
    local fStroke = addStroke(f, T.Stroke, 1)

    local ll = Instance.new("TextLabel", f)
    ll.Size               = UDim2.new(1, -68, 1, 0)
    ll.Position           = UDim2.new(0, 12, 0, 0)
    ll.BackgroundTransparency = 1
    ll.Text               = labelTxt
    ll.TextColor3         = T.Text
    ll.Font               = Enum.Font.GothamMedium
    ll.TextSize           = 13
    ll.TextXAlignment     = Enum.TextXAlignment.Left
    ll.TextWrapped        = true

    local sbg = Instance.new("Frame", f)
    sbg.Size             = UDim2.new(0, 46, 0, 24)
    sbg.Position         = UDim2.new(1, -56, 0.5, -12)
    sbg.BackgroundColor3 = T.ToggleOff
    sbg.BorderSizePixel  = 0
    addCorner(sbg, 12)

    local knob = Instance.new("Frame", sbg)
    knob.Size             = UDim2.new(0, 18, 0, 18)
    knob.Position         = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel  = 0
    addCorner(knob, 9)

    local togOn = false

    local clickArea = Instance.new("TextButton", f)
    clickArea.Size             = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text             = ""
    clickArea.ZIndex           = f.ZIndex + 1

    local function setValue(val, silent)
        togOn = val
        if val then
            tween(sbg,  {BackgroundColor3 = T.ToggleOn}, 0.18)
            tween(knob, {Position = UDim2.new(0, 25, 0.5, -9)}, 0.18)
        else
            tween(sbg,  {BackgroundColor3 = T.ToggleOff}, 0.18)
            tween(knob, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.18)
        end
        if not silent and onFn then onFn(togOn) end
    end

    clickArea.MouseButton1Click:Connect(function()
        setValue(not togOn)
    end)

    -- theme update
    onThemeUpdate(function()
        f.BackgroundColor3  = T.SecondaryBg
        fStroke.Color       = T.Stroke
        ll.TextColor3       = T.Text
        sbg.BackgroundColor3= togOn and T.ToggleOn or T.ToggleOff
    end)

    return f, setValue, function() return togOn end
end

-- Slider builder
local function buildSlider(page, labelTxt, minV, maxV, defV, order, onChangeFn)
    local f = Instance.new("Frame", page)
    f.Size             = UDim2.new(1, 0, 0, 60)
    f.BackgroundColor3 = T.SecondaryBg
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order
    addCorner(f, 10)
    local fStr = addStroke(f, T.Stroke, 1)

    local nameLbl = Instance.new("TextLabel", f)
    nameLbl.Size               = UDim2.new(0.65, 0, 0, 22)
    nameLbl.Position           = UDim2.new(0, 12, 0, 5)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text               = labelTxt
    nameLbl.TextColor3         = T.Text
    nameLbl.Font               = Enum.Font.GothamMedium
    nameLbl.TextSize           = 12
    nameLbl.TextXAlignment     = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", f)
    valLbl.Size               = UDim2.new(0.3, 0, 0, 22)
    valLbl.Position           = UDim2.new(0.68, 0, 0, 5)
    valLbl.BackgroundTransparency = 1
    valLbl.Text               = tostring(defV)
    valLbl.TextColor3         = T.Accent
    valLbl.Font               = Enum.Font.GothamBold
    valLbl.TextSize           = 13
    valLbl.TextXAlignment     = Enum.TextXAlignment.Right

    local rail = Instance.new("Frame", f)
    rail.Size             = UDim2.new(1, -24, 0, 7)
    rail.Position         = UDim2.new(0, 12, 0, 37)
    rail.BackgroundColor3 = T.SliderBg
    rail.BorderSizePixel  = 0
    addCorner(rail, 4)

    local fill = Instance.new("Frame", rail)
    local initT = (defV - minV) / math.max(maxV - minV, 1)
    fill.Size             = UDim2.new(initT, 0, 1, 0)
    fill.BackgroundColor3 = T.SliderFill
    fill.BorderSizePixel  = 0
    addCorner(fill, 4)

    local kn = Instance.new("Frame", rail)
    kn.Size             = UDim2.new(0, 14, 0, 14)
    kn.AnchorPoint      = Vector2.new(0.5, 0.5)
    kn.Position         = UDim2.new(initT, 0, 0.5, 0)
    kn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    kn.BorderSizePixel  = 0
    addCorner(kn, 7)

    local curVal = defV
    local sliding = false

    local function updateFromX(xPos)
        local railPos = rail.AbsolutePosition
        local railSz  = rail.AbsoluteSize
        local t = math.clamp((xPos - railPos.X) / railSz.X, 0, 1)
        curVal = math.round(minV + t * (maxV - minV))
        valLbl.Text    = tostring(curVal)
        fill.Size      = UDim2.new(t, 0, 1, 0)
        kn.Position    = UDim2.new(t, 0, 0.5, 0)
        if onChangeFn then onChangeFn(curVal) end
    end

    local hitArea = Instance.new("TextButton", f)
    hitArea.Size             = UDim2.new(1, 0, 0, 28)
    hitArea.Position         = UDim2.new(0, 0, 0, 28)
    hitArea.BackgroundTransparency = 1
    hitArea.Text             = ""
    hitArea.ZIndex           = f.ZIndex + 1

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
        f.BackgroundColor3   = T.SecondaryBg
        fStr.Color           = T.Stroke
        nameLbl.TextColor3   = T.Text
        valLbl.TextColor3    = T.Accent
        rail.BackgroundColor3= T.SliderBg
        fill.BackgroundColor3= T.SliderFill
    end)

    local function setRange(newMin, newMax)
        minV = newMin
        maxV = newMax
        curVal = math.clamp(curVal, minV, maxV)
        local t2 = (curVal - minV) / math.max(maxV - minV, 1)
        valLbl.Text  = tostring(curVal)
        fill.Size    = UDim2.new(t2, 0, 1, 0)
        kn.Position  = UDim2.new(t2, 0, 0.5, 0)
    end
    local function getVal() return curVal end

    return f, getVal, setRange
end

-- ══════════════════════════════════
-- HOME TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Home"]
    local lo = 0
    local function nlo() lo = lo + 1 return lo end

    -- Profile card
    sectionLabel(pg, "Player Info", nlo())

    local pfCard = Instance.new("Frame", pg)
    pfCard.Size             = UDim2.new(1, 0, 0, 82)
    pfCard.BackgroundColor3 = T.SecondaryBg
    pfCard.BorderSizePixel  = 0
    pfCard.LayoutOrder      = nlo()
    addCorner(pfCard, 12)
    local pfStr = addStroke(pfCard, T.Stroke, 1)

    local pfImg = Instance.new("ImageLabel", pfCard)
    pfImg.Size             = UDim2.new(0, 62, 0, 62)
    pfImg.Position         = UDim2.new(0, 10, 0.5, -31)
    pfImg.BackgroundColor3 = T.TabBg
    pfImg.Image            = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    pfImg.BorderSizePixel  = 0
    addCorner(pfImg, 31)

    local pfInfo = Instance.new("Frame", pfCard)
    pfInfo.Size             = UDim2.new(1, -86, 1, 0)
    pfInfo.Position         = UDim2.new(0, 80, 0, 0)
    pfInfo.BackgroundTransparency = 1

    local pfl = Instance.new("UIListLayout", pfInfo)
    pfl.FillDirection       = Enum.FillDirection.Vertical
    pfl.VerticalAlignment   = Enum.VerticalAlignment.Center
    pfl.Padding             = UDim.new(0, 2)

    local function pfRow(txt)
        local l = Instance.new("TextLabel", pfInfo)
        l.Size               = UDim2.new(1, 0, 0, 17)
        l.BackgroundTransparency = 1
        l.Text               = txt
        l.TextColor3         = T.Text
        l.Font               = Enum.Font.Gotham
        l.TextSize           = 12
        l.TextXAlignment     = Enum.TextXAlignment.Left
        l.TextWrapped        = true
        return l
    end

    pfRow("Display: " .. LocalPlayer.DisplayName)
    pfRow("Username: @" .. LocalPlayer.Name)
    pfRow("User ID: " .. tostring(LocalPlayer.UserId))
    pfRow("Account Age: " .. tostring(LocalPlayer.AccountAge) .. " days")

    onThemeUpdate(function()
        pfCard.BackgroundColor3 = T.SecondaryBg
        pfStr.Color = T.Stroke
        for _, v in ipairs(pfInfo:GetChildren()) do
            if v:IsA("TextLabel") then v.TextColor3 = T.Text end
        end
    end)

    sectionLabel(pg, "Game Info", nlo())

    local gName = "Unknown"
    pcall(function() gName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)

    local _, gnV = infoRow(pg, "Game Name",  gName,              nlo())
    local _, giV = infoRow(pg, "Game ID",    tostring(game.PlaceId), nlo())
    local _, pcV = infoRow(pg, "Players",    "...",              nlo())
    local _, siV = infoRow(pg, "Server ID",  game.JobId ~= "" and game.JobId:sub(1,14).."…" or "N/A", nlo())
    local _, upV = infoRow(pg, "Uptime",     "0:00",             nlo())

    sectionLabel(pg, "Session Stats", nlo())

    local _, ecV = infoRow(pg, "Times Executed", tostring(execCount), nlo())
    local _, etV = infoRow(pg, "Exec Duration",  "0:00",              nlo())

    task.spawn(function()
        while true do
            task.wait(1)
            pcall(function()
                pcV.Text = tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers)
                upV.Text = formatTime(tick() - execStartTime)  -- approximate server uptime via local timer
                etV.Text = formatTime(tick() - execStartTime)
            end)
        end
    end)
end

-- ══════════════════════════════════
-- MAIN TAB
-- ══════════════════════════════════
local selectedBrainrots = {}      -- name -> true
local spawnTracked      = {}      -- model -> true
local detectedHighlights = {}     -- model -> Highlight instance
local brainrotWatchFolder = nil   -- workspace.GameFolder.Brainrots reference

-- called when a tracked brainrot is found
local function onBrainrotDetected(model, name)
    if spawnTracked[model] then return end
    spawnTracked[model] = true

    showNotification("A " .. name .. " Has Spawned!", T.Accent, 3)

    if state.teleportEnabled then
        task.spawn(function()
            task.wait(0.05)
            pcall(function()
                local _, _, hrp = getCharHum()
                if hrp then
                    hrp.CFrame = model:GetPivot() * CFrame.new(0, 5, 0)
                end
            end)
        end)
    end

    if state.brainHighlight then
        pcall(function()
            if detectedHighlights[model] then
                detectedHighlights[model]:Destroy()
            end
            local hl = Instance.new("Highlight", model)
            hl.FillColor          = T.Accent
            hl.OutlineColor       = T.Accent
            hl.FillTransparency   = 0.45
            hl.OutlineTransparency= 0
            detectedHighlights[model] = hl
        end)
    end
end

task.spawn(function()
    -- setup watcher folder
    pcall(function()
        brainrotWatchFolder = workspace:WaitForChild("GameFolder", 15):WaitForChild("Brainrots", 15)
    end)
end)

-- Periodic brainrot watcher
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
                -- clean dead references
                for m, _ in pairs(spawnTracked) do
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

do
    local pg = tabPages["Main"]
    local lo = 0
    local function nlo() lo = lo + 1 return lo end

    sectionLabel(pg, "Brainrot Selector", nlo())

    -- Dropdown container
    local dropCtr = Instance.new("Frame", pg)
    dropCtr.Size             = UDim2.new(1, 0, 0, 188)
    dropCtr.BackgroundColor3 = T.DropdownBg
    dropCtr.BorderSizePixel  = 0
    dropCtr.LayoutOrder      = nlo()
    dropCtr.ClipsDescendants = true
    addCorner(dropCtr, 10)
    local dcStr = addStroke(dropCtr, T.Stroke, 1)

    -- Search box
    local searchBox = Instance.new("TextBox", dropCtr)
    searchBox.Size             = UDim2.new(1, -14, 0, 30)
    searchBox.Position         = UDim2.new(0, 7, 0, 6)
    searchBox.BackgroundColor3 = T.SecondaryBg
    searchBox.BorderSizePixel  = 0
    searchBox.PlaceholderText  = "  Search brainrots..."
    searchBox.Text             = ""
    searchBox.TextColor3       = T.Text
    searchBox.PlaceholderColor3= T.TextDim
    searchBox.Font             = Enum.Font.Gotham
    searchBox.TextSize         = 13
    searchBox.ClearTextOnFocus = false
    addCorner(searchBox, 7)
    local sbPad = Instance.new("UIPadding", searchBox)
    sbPad.PaddingLeft = UDim.new(0, 8)

    -- Dropdown list
    local dropList = Instance.new("ScrollingFrame", dropCtr)
    dropList.Size                = UDim2.new(1, -10, 0, 140)
    dropList.Position            = UDim2.new(0, 5, 0, 42)
    dropList.BackgroundTransparency = 1
    dropList.BorderSizePixel     = 0
    dropList.ScrollBarThickness  = 3
    dropList.ScrollBarImageColor3= T.Accent
    dropList.CanvasSize          = UDim2.new(0, 0, 0, 0)
    dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local dlLyt = Instance.new("UIListLayout", dropList)
    dlLyt.FillDirection = Enum.FillDirection.Vertical
    dlLyt.Padding       = UDim.new(0, 2)

    local dlPad = Instance.new("UIPadding", dropList)
    dlPad.PaddingTop    = UDim.new(0, 2)
    dlPad.PaddingBottom = UDim.new(0, 2)

    -- Selected box
    sectionLabel(pg, "Selected Brainrots", nlo())

    local selBox = Instance.new("Frame", pg)
    selBox.Size             = UDim2.new(1, 0, 0, 52)
    selBox.BackgroundColor3 = T.SecondaryBg
    selBox.BorderSizePixel  = 0
    selBox.LayoutOrder      = nlo()
    selBox.ClipsDescendants = true
    addCorner(selBox, 10)
    local sbStr = addStroke(selBox, T.Stroke, 1)

    local selScroll = Instance.new("ScrollingFrame", selBox)
    selScroll.Size                  = UDim2.new(1, -8, 1, -8)
    selScroll.Position              = UDim2.new(0, 4, 0, 4)
    selScroll.BackgroundTransparency= 1
    selScroll.BorderSizePixel       = 0
    selScroll.ScrollBarThickness    = 3
    selScroll.ScrollBarImageColor3  = T.Accent
    selScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    selScroll.AutomaticCanvasSize   = Enum.AutomaticSize.X
    selScroll.ScrollingDirection    = Enum.ScrollingDirection.X

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
        for name, _ in pairs(selectedBrainrots) do
            local chip = Instance.new("Frame", selScroll)
            chip.Size             = UDim2.new(0, 0, 0, 30)
            chip.AutomaticSize    = Enum.AutomaticSize.X
            chip.BackgroundColor3 = T.AccentDark
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
            cpLbl.Size               = UDim2.new(0, 0, 0, 22)
            cpLbl.AutomaticSize      = Enum.AutomaticSize.X
            cpLbl.BackgroundTransparency = 1
            cpLbl.Text               = name
            cpLbl.TextColor3         = T.Text
            cpLbl.Font               = Enum.Font.Gotham
            cpLbl.TextSize           = 11

            local xb = Instance.new("TextButton", chip)
            xb.Size             = UDim2.new(0, 16, 0, 16)
            xb.BackgroundColor3 = Color3.fromRGB(200,55,55)
            xb.Text             = "X"
            xb.TextColor3       = Color3.fromRGB(255,255,255)
            xb.Font             = Enum.Font.GothamBold
            xb.TextSize         = 9
            xb.AutoButtonColor  = false
            addCorner(xb, 4)

            xb.MouseButton1Click:Connect(function()
                selectedBrainrots[name] = nil
                refreshSelectedBox()
                -- refresh dropdown items
                searchBox.Text = searchBox.Text  -- trigger changed
            end)
        end
    end

    local function refreshDropdown(filter)
        for _, c in ipairs(dropList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, name in ipairs(brainrotNames) do
            if filter == "" or name:lower():find(filter:lower(), 1, true) then
                local item = Instance.new("TextButton", dropList)
                item.Size             = UDim2.new(1, 0, 0, 26)
                item.BackgroundColor3 = selectedBrainrots[name] and T.Accent or T.TabBg
                item.BorderSizePixel  = 0
                item.Text             = "  " .. name
                item.TextColor3       = selectedBrainrots[name] and Color3.fromRGB(0,0,0) or T.Text
                item.Font             = Enum.Font.Gotham
                item.TextSize         = 12
                item.TextXAlignment   = Enum.TextXAlignment.Left
                item.AutoButtonColor  = false
                addCorner(item, 5)

                item.MouseButton1Click:Connect(function()
                    if selectedBrainrots[name] then
                        selectedBrainrots[name] = nil
                    else
                        selectedBrainrots[name] = true
                    end
                    refreshDropdown(searchBox.Text)
                    refreshSelectedBox()
                end)
            end
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        refreshDropdown(searchBox.Text)
    end)

    -- Load brainrot names async
    task.spawn(function()
        pcall(function()
            local bFolder = ReplicatedStorage:WaitForChild("Brainrots", 10)
            if bFolder then
                for _, child in ipairs(bFolder:GetChildren()) do
                    if child:IsA("Folder") then
                        for _, model in ipairs(child:GetChildren()) do
                            if model:IsA("Model") and model.Name ~= "" then
                                table.insert(brainrotNames, model.Name)
                            end
                        end
                    elseif child:IsA("Model") then
                        table.insert(brainrotNames, child.Name)
                    end
                end
                table.sort(brainrotNames)
                refreshDropdown("")
            end
        end)
    end)

    -- Auto Collect Cash
    sectionLabel(pg, "Features", nlo())

    local autoCollectActive = false
    local autoCollectThread = nil

    local _, autoToggleSet = buildToggle(pg, "Auto Collect Cash", nlo(), function(enabled)
        autoCollectActive = enabled
        state.autoCollect = enabled
        showNotification("Auto Collect Cash " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and T.Accent or Color3.fromRGB(255,80,80))

        if enabled then
            autoCollectThread = task.spawn(function()
                while autoCollectActive do
                    pcall(function()
                        local plots = workspace:FindFirstChild("GameFolder") and
                                      workspace.GameFolder:FindFirstChild("Plots")
                        if not plots then return end

                        for _, desc in ipairs(plots:GetDescendants()) do
                            if desc:IsA("Attachment") and desc.Name == "YourBaseAtt" then
                                -- find Title label
                                local titleLbl = nil
                                for _, d2 in ipairs(desc.Parent:GetDescendants()) do
                                    if d2:IsA("TextLabel") and d2.Name == "Title" then
                                        titleLbl = d2
                                        break
                                    end
                                end
                                if not titleLbl then
                                    -- check siblings
                                    for _, sib in ipairs(desc.Parent:GetChildren()) do
                                        for _, d2 in ipairs(sib:GetDescendants()) do
                                            if d2:IsA("TextLabel") and d2.Name == "Title" then
                                                titleLbl = d2
                                                break
                                            end
                                        end
                                        if titleLbl then break end
                                    end
                                end

                                if titleLbl and titleLbl.Text == "YOUR BASE" then
                                    -- Find parent model
                                    local model = desc.Parent
                                    while model and not model:IsA("Model") do
                                        model = model.Parent
                                    end
                                    if model then
                                        local placesFolder = model:FindFirstChild("Places", true)
                                        if placesFolder then
                                            for _, d3 in ipairs(placesFolder:GetDescendants()) do
                                                if d3:IsA("BasePart") then
                                                    local _, _, hrp = getCharHum()
                                                    if hrp then
                                                        pcall(function()
                                                            -- Use firetouchinterest executor API
                                                            if firetouchinterest then
                                                                firetouchinterest(d3, hrp, 0)
                                                                task.wait(0.05)
                                                                firetouchinterest(d3, hrp, 1)
                                                            end
                                                        end)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.4)
                end
            end)
        end
    end)

    onThemeUpdate(function()
        dropCtr.BackgroundColor3 = T.DropdownBg
        dcStr.Color              = T.Stroke
        searchBox.BackgroundColor3 = T.SecondaryBg
        searchBox.TextColor3     = T.Text
        searchBox.PlaceholderColor3 = T.TextDim
        dropList.ScrollBarImageColor3 = T.Accent
        selBox.BackgroundColor3  = T.SecondaryBg
        sbStr.Color              = T.Stroke
        selScroll.ScrollBarImageColor3 = T.Accent
    end)
end

-- ══════════════════════════════════
-- PLAYER WARNING OVERLAY
-- ══════════════════════════════════
do
    local ov = Instance.new("Frame", TabContentArea)
    playerWarningOverlay     = ov
    ov.Name                  = "WarningOverlay"
    ov.Size                  = UDim2.new(1, 0, 1, 0)
    ov.BackgroundColor3      = Color3.fromRGB(10, 8, 6)
    ov.BackgroundTransparency= 0.08
    ov.BorderSizePixel        = 0
    ov.ZIndex                = 200
    ov.Visible               = false  -- will be shown when Player tab opens

    local wCard = Instance.new("Frame", ov)
    wCard.Size             = UDim2.new(0.84, 0, 0, 0)
    wCard.AutomaticSize    = Enum.AutomaticSize.Y
    wCard.AnchorPoint      = Vector2.new(0.5, 0.5)
    wCard.Position         = UDim2.new(0.5, 0, 0.5, 0)
    wCard.BackgroundColor3 = Color3.fromRGB(28, 18, 8)
    wCard.BorderSizePixel  = 0
    wCard.ZIndex           = 201
    addCorner(wCard, 14)
    local wStr = addStroke(wCard, Color3.fromRGB(255,155,30), 2)

    local wLyt = Instance.new("UIListLayout", wCard)
    wLyt.FillDirection       = Enum.FillDirection.Vertical
    wLyt.HorizontalAlignment = Enum.HorizontalAlignment.Center
    wLyt.Padding             = UDim.new(0, 10)

    local wPad = Instance.new("UIPadding", wCard)
    wPad.PaddingTop    = UDim.new(0, 18)
    wPad.PaddingBottom = UDim.new(0, 18)
    wPad.PaddingLeft   = UDim.new(0, 18)
    wPad.PaddingRight  = UDim.new(0, 18)

    local wIcon = Instance.new("TextLabel", wCard)
    wIcon.Size               = UDim2.new(1, 0, 0, 34)
    wIcon.BackgroundTransparency = 1
    wIcon.Text               = "⚠️ Warning ⚠️"
    wIcon.TextColor3         = Color3.fromRGB(255,155,30)
    wIcon.Font               = Enum.Font.GothamBold
    wIcon.TextSize           = 22
    wIcon.ZIndex             = 202

    local wTxt = Instance.new("TextLabel", wCard)
    wTxt.Size                = UDim2.new(1, 0, 0, 56)
    wTxt.BackgroundTransparency = 1
    wTxt.Text                = "Using These Features Could Get You Banned, Use At Your Own Risk."
    wTxt.TextColor3          = Color3.fromRGB(220,175,115)
    wTxt.Font                = Enum.Font.GothamMedium
    wTxt.TextSize            = 14
    wTxt.TextWrapped         = true
    wTxt.ZIndex              = 202

    local wBtns = Instance.new("Frame", wCard)
    wBtns.Size               = UDim2.new(1, 0, 0, 40)
    wBtns.BackgroundTransparency = 1
    wBtns.ZIndex             = 202

    local wBLyt = Instance.new("UIListLayout", wBtns)
    wBLyt.FillDirection       = Enum.FillDirection.Horizontal
    wBLyt.HorizontalAlignment = Enum.HorizontalAlignment.Center
    wBLyt.VerticalAlignment   = Enum.VerticalAlignment.Center
    wBLyt.Padding             = UDim.new(0, 12)

    local okBtn = Instance.new("TextButton", wBtns)
    okBtn.Size             = UDim2.new(0, 130, 0, 38)
    okBtn.BackgroundColor3 = Color3.fromRGB(38,155,58)
    okBtn.Text             = "✓  Ok"
    okBtn.TextColor3       = Color3.fromRGB(255,255,255)
    okBtn.Font             = Enum.Font.GothamBold
    okBtn.TextSize         = 14
    okBtn.AutoButtonColor  = false
    okBtn.ZIndex           = 203
    addCorner(okBtn, 10)

    local goBackBtn = Instance.new("TextButton", wBtns)
    goBackBtn.Size             = UDim2.new(0, 130, 0, 38)
    goBackBtn.BackgroundColor3 = Color3.fromRGB(175,38,38)
    goBackBtn.Text             = "X  Go Back"
    goBackBtn.TextColor3       = Color3.fromRGB(255,255,255)
    goBackBtn.Font             = Enum.Font.GothamBold
    goBackBtn.TextSize         = 14
    goBackBtn.AutoButtonColor  = false
    goBackBtn.ZIndex           = 203
    addCorner(goBackBtn, 10)

    okBtn.MouseButton1Click:Connect(function()
        state.playerWarnOk = true
        ov.Visible = false
    end)

    goBackBtn.MouseButton1Click:Connect(function()
        -- Leave warning visible, go back to Home
        switchTab("Home")
    end)
end

-- Patch switchTab to handle warning
local _origSwitch = switchTab
switchTab = function(name)
    _origSwitch(name)
    if playerWarningOverlay then
        playerWarningOverlay.Visible = (name == "Player") and not state.playerWarnOk
    end
end

-- Re-wire tab buttons with patched switchTab
for _, name in ipairs(TAB_NAMES) do
    -- Disconnect old and reconnect (simpler: just override the function reference used)
end

-- Actually cleanest fix: override buttons to use the new switchTab
for _, name in ipairs(TAB_NAMES) do
    local btn = tabButtons[name]
    -- clear old connection by replacing button (or just check in the callback)
    -- We'll just use a flag check in a new connection; the old one won't interfere
    -- because we already called switchTab; now we just need to add the warning logic after
    -- The cleanest way: we already stored playerWarningOverlay and update it in _origSwitch override above
    -- This works because the original buttons call _origSwitch -> which is now the wrapped version
end

-- ══════════════════════════════════
-- PLAYER TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Player"]
    local lo = 0
    local function nlo() lo = lo + 1 return lo end

    sectionLabel(pg, "Speed", nlo())

    -- Speed max input row
    local smRow = Instance.new("Frame", pg)
    smRow.Size             = UDim2.new(1, 0, 0, 36)
    smRow.BackgroundColor3 = T.SecondaryBg
    smRow.BorderSizePixel  = 0
    smRow.LayoutOrder      = nlo()
    addCorner(smRow, 8)
    local smStr = addStroke(smRow, T.Stroke, 1)

    local smLbl = Instance.new("TextLabel", smRow)
    smLbl.Size               = UDim2.new(0.55, 0, 1, 0)
    smLbl.Position           = UDim2.new(0, 10, 0, 0)
    smLbl.BackgroundTransparency = 1
    smLbl.Text               = "Speed Slider Max:"
    smLbl.TextColor3         = T.TextDim
    smLbl.Font               = Enum.Font.GothamMedium
    smLbl.TextSize           = 12
    smLbl.TextXAlignment     = Enum.TextXAlignment.Left

    local smBox = Instance.new("TextBox", smRow)
    smBox.Size             = UDim2.new(0.36, 0, 0, 26)
    smBox.Position         = UDim2.new(0.62, 0, 0.5, -13)
    smBox.BackgroundColor3 = T.TabBg
    smBox.BorderSizePixel  = 0
    smBox.Text             = "100"
    smBox.TextColor3       = T.Text
    smBox.Font             = Enum.Font.Gotham
    smBox.TextSize         = 13
    smBox.ClearTextOnFocus = false
    addCorner(smBox, 7)

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
            enabled and T.Accent or Color3.fromRGB(255,80,80))
        local _, hum = getCharHum()
        if not hum then return end
        if enabled then
            hum.WalkSpeed = getSpeedVal()
        else
            pcall(function()
                local lbl = LocalPlayer.PlayerGui.HUD.Speed
                local num = lbl.Text:match("%d+")
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
            enabled and T.Accent or Color3.fromRGB(255,80,80))
        local _, hum = getCharHum()
        if not hum then return end
        if enabled then
            hum.JumpPower = getJumpVal()
        else
            pcall(function()
                local lbl = LocalPlayer.PlayerGui.HUD.Jump
                local num = lbl.Text:match("%d+%.?%d*")
                if num then
                    hum.JumpPower = 30 + tonumber(num) * (10/3)
                end
            end)
        end
    end)

    sectionLabel(pg, "Survival", nlo())

    -- Godmode
    local lavaDisabledParts = {}

    local _, godTogSet = buildToggle(pg, "Godmode (Disable Lavas)", nlo(), function(enabled)
        state.godmodeEnabled = enabled
        showNotification("Godmode " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and T.Accent or Color3.fromRGB(255,80,80))

        if enabled then
            pcall(function()
                local lavas = workspace.GameFolder.Lavas
                for _, part in ipairs(lavas:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if part.CanTouch then
                            part.CanTouch = false
                            table.insert(lavaDisabledParts, part)
                        end
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

    -- Flight
    local flyConn    = nil
    local flyEnabled = false

    local function startFlight()
        local char, hum, hrp = getCharHum()
        if not (hum and hrp) then return end
        hum.PlatformStand = true

        flyConn = RunService.Heartbeat:Connect(function(dt)
            if not flyEnabled then return end
            local c2, h2, r2 = getCharHum()
            if not (h2 and r2) then return end

            local cam     = workspace.CurrentCamera
            local camCF   = cam.CFrame
            local moveDir = Vector3.zero
            local spd     = 50

            -- PC keys
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir += camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir -= camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir -= camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir += camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir -= Vector3.new(0, 1, 0)
            end

            -- Mobile / thumbstick
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

            -- counteract gravity each frame
            local gravComp = workspace.Gravity * dt

            if moveDir.Magnitude > 0.01 then
                local vel = moveDir.Unit * spd
                r2.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y + gravComp, vel.Z)
            else
                -- hover in place
                r2.AssemblyLinearVelocity = Vector3.new(0, gravComp, 0)
            end

            -- Face camera look direction
            local lookTarget = r2.Position + Vector3.new(camCF.LookVector.X, camCF.LookVector.Y, camCF.LookVector.Z)
            r2.CFrame = CFrame.new(r2.Position, lookTarget)
        end)
    end

    local function stopFlight()
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char, hum, hrp = getCharHum()
        if hum then hum.PlatformStand = false end
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
    end

    local _, flyTogSet = buildToggle(pg, "Flight", nlo(), function(enabled)
        flyEnabled = enabled
        state.flyEnabled = enabled
        showNotification("Flight " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and T.Accent or Color3.fromRGB(255,80,80))
        if enabled then
            startFlight()
        else
            stopFlight()
        end
    end)

    -- Teleport to selected brainrots
    local _, teleportTogSet = buildToggle(pg, "Teleport to Brainrots", nlo(), function(enabled)
        state.teleportEnabled = enabled
        showNotification("Teleport to Brainrots " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and T.Accent or Color3.fromRGB(255,80,80))
    end)

    -- Re-apply on respawn
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.8)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        if state.speedEnabled then
            pcall(function() hum.WalkSpeed  = getSpeedVal() end)
        end
        if state.jumpEnabled then
            pcall(function() hum.JumpPower  = getJumpVal() end)
        end
        if state.flyEnabled then
            flyEnabled = true
            task.wait(0.3)
            startFlight()
        end
    end)

    onThemeUpdate(function()
        smRow.BackgroundColor3 = T.SecondaryBg
        smStr.Color            = T.Stroke
        smLbl.TextColor3       = T.TextDim
        smBox.BackgroundColor3 = T.TabBg
        smBox.TextColor3       = T.Text
    end)
end

-- ══════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════
do
    local pg = tabPages["Visual"]
    local lo = 0
    local function nlo() lo = lo + 1 return lo end

    sectionLabel(pg, "Brainrot Visuals", nlo())

    local _, brainHlTogSet = buildToggle(pg, "Highlight Selected Brainrots", nlo(), function(enabled)
        state.brainHighlight = enabled
        showNotification("Brainrot Highlight " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and T.Accent or Color3.fromRGB(255,80,80))
        if not enabled then
            for model, hl in pairs(detectedHighlights) do
                pcall(function() hl:Destroy() end)
            end
            detectedHighlights = {}
        end
    end)

    sectionLabel(pg, "Player Visuals", nlo())

    local playerHlActive  = false
    local playerHighlights  = {}
    local playerBillboards  = {}
    local playerHlUpdateConn = nil

    local function addPlayerVisuals(player)
        if player == LocalPlayer then return end
        local char = player.Character
        if not char then return end

        -- Remove old
        if playerHighlights[player] then
            pcall(function() playerHighlights[player]:Destroy() end)
        end
        if playerBillboards[player] then
            pcall(function() playerBillboards[player].gui:Destroy() end)
        end

        local hl = Instance.new("Highlight", char)
        hl.FillColor           = Color3.fromRGB(100, 185, 255)
        hl.OutlineColor        = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency    = 0.42
        hl.OutlineTransparency = 0
        playerHighlights[player] = hl

        local head = char:FindFirstChild("Head")
        if head then
            local bb = Instance.new("BillboardGui", head)
            bb.Name          = "PC_PlayerBillboard"
            bb.Size          = UDim2.new(0, 130, 0, 44)
            bb.StudsOffset   = Vector3.new(0, 2.8, 0)
            bb.AlwaysOnTop   = true

            local il = Instance.new("TextLabel", bb)
            il.Size               = UDim2.new(1, 0, 1, 0)
            il.BackgroundTransparency = 1
            il.Text               = player.DisplayName .. "\n..."
            il.TextColor3         = Color3.fromRGB(255,255,255)
            il.Font               = Enum.Font.GothamBold
            il.TextSize           = 13
            il.TextStrokeTransparency = 0.4
            il.TextStrokeColor3   = Color3.fromRGB(0,0,0)

            playerBillboards[player] = {gui = bb, lbl = il}
        end
    end

    local function removeAllPlayerVisuals()
        if playerHlUpdateConn then playerHlUpdateConn:Disconnect(); playerHlUpdateConn = nil end
        for p, hl in pairs(playerHighlights) do
            pcall(function() hl:Destroy() end)
        end
        for p, d in pairs(playerBillboards) do
            pcall(function() d.gui:Destroy() end)
        end
        playerHighlights  = {}
        playerBillboards  = {}
    end

    local playerAddedConn

    local _, plHlTogSet = buildToggle(pg, "Highlight Other Players", nlo(), function(enabled)
        playerHlActive = enabled
        state.playerHighlight = enabled
        showNotification("Player Highlight " .. (enabled and "Enabled!" or "Disabled!"),
            enabled and T.Accent or Color3.fromRGB(255,80,80))

        if enabled then
            for _, p in ipairs(Players:GetPlayers()) do
                addPlayerVisuals(p)
            end

            playerAddedConn = Players.PlayerAdded:Connect(function(p)
                if playerHlActive then
                    p.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        if playerHlActive then addPlayerVisuals(p) end
                    end)
                end
            end)

            -- Character respawn handling
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    p.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        if playerHlActive then addPlayerVisuals(p) end
                    end)
                end
            end

            -- Distance updater
            playerHlUpdateConn = RunService.Heartbeat:Connect(function()
                local localChar = LocalPlayer.Character
                local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
                for p, data in pairs(playerBillboards) do
                    pcall(function()
                        local pc = p.Character
                        local pr = pc and pc:FindFirstChild("HumanoidRootPart")
                        if pr and localRoot then
                            local dist = math.floor((pr.Position - localRoot.Position).Magnitude)
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
    local function nlo() lo = lo + 1 return lo end

    sectionLabel(pg, "Theme", nlo())

    -- Theme selector header
    local thHdr = Instance.new("Frame", pg)
    thHdr.Size             = UDim2.new(1, 0, 0, 38)
    thHdr.BackgroundColor3 = T.SecondaryBg
    thHdr.BorderSizePixel  = 0
    thHdr.LayoutOrder      = nlo()
    addCorner(thHdr, 10)
    local thHdrStr = addStroke(thHdr, T.Stroke, 1)

    local thCurLbl = Instance.new("TextLabel", thHdr)
    thCurLbl.Size               = UDim2.new(0.6, 0, 1, 0)
    thCurLbl.Position           = UDim2.new(0, 12, 0, 0)
    thCurLbl.BackgroundTransparency = 1
    thCurLbl.Text               = "Theme: " .. currentThemeName
    thCurLbl.TextColor3         = T.Text
    thCurLbl.Font               = Enum.Font.GothamMedium
    thCurLbl.TextSize           = 13
    thCurLbl.TextXAlignment     = Enum.TextXAlignment.Left

    local thChgBtn = Instance.new("TextButton", thHdr)
    thChgBtn.Size             = UDim2.new(0.33, 0, 0, 28)
    thChgBtn.Position         = UDim2.new(0.65, 0, 0.5, -14)
    thChgBtn.BackgroundColor3 = T.ButtonBg
    thChgBtn.Text             = "Change"
    thChgBtn.TextColor3       = T.Text
    thChgBtn.Font             = Enum.Font.GothamBold
    thChgBtn.TextSize         = 12
    thChgBtn.AutoButtonColor  = false
    addCorner(thChgBtn, 8)

    -- Theme options (expandable)
    local thOptions = Instance.new("Frame", pg)
    thOptions.Size             = UDim2.new(1, 0, 0, 0)
    thOptions.BackgroundColor3 = T.DropdownBg
    thOptions.BorderSizePixel  = 0
    thOptions.LayoutOrder      = nlo()
    thOptions.ClipsDescendants = true
    addCorner(thOptions, 10)
    local thOptStr = addStroke(thOptions, T.Stroke, 1)

    local thOptLyt = Instance.new("UIListLayout", thOptions)
    thOptLyt.FillDirection = Enum.FillDirection.Vertical
    thOptLyt.Padding       = UDim.new(0, 2)

    local thOptPad = Instance.new("UIPadding", thOptions)
    thOptPad.PaddingTop    = UDim.new(0, 4)
    thOptPad.PaddingBottom = UDim.new(0, 4)
    thOptPad.PaddingLeft   = UDim.new(0, 6)
    thOptPad.PaddingRight  = UDim.new(0, 6)

    local THEME_LIST = {"Original", "Sky", "Lava"}

    local thOptBtns = {}
    local function refreshThemeOptColors()
        for _, nm in ipairs(THEME_LIST) do
            local b = thOptBtns[nm]
            if b then
                b.BackgroundColor3 = (currentThemeName == nm) and T.Accent or T.TabBg
                b.TextColor3       = (currentThemeName == nm) and Color3.fromRGB(0,0,0) or T.Text
            end
        end
    end

    for _, nm in ipairs(THEME_LIST) do
        local b = Instance.new("TextButton", thOptions)
        b.Size             = UDim2.new(1, 0, 0, 32)
        b.BackgroundColor3 = (nm == currentThemeName) and T.Accent or T.TabBg
        b.Text             = nm
        b.TextColor3       = (nm == currentThemeName) and Color3.fromRGB(0,0,0) or T.Text
        b.Font             = Enum.Font.GothamMedium
        b.TextSize         = 13
        b.AutoButtonColor  = false
        addCorner(b, 7)
        thOptBtns[nm] = b

        b.MouseButton1Click:Connect(function()
            setTheme(nm)
            thCurLbl.Text = "Theme: " .. nm
            refreshThemeOptColors()
            tween(thOptions, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        end)
    end

    local thExpanded = false
    local thOptH     = (#THEME_LIST * 34) + 10

    thChgBtn.MouseButton1Click:Connect(function()
        thExpanded = not thExpanded
        tween(thOptions, {Size = UDim2.new(1, 0, 0, thExpanded and thOptH or 0)}, 0.22)
    end)

    -- Custom theme button
    local customBtn = Instance.new("TextButton", pg)
    customBtn.Size             = UDim2.new(1, 0, 0, 56)
    customBtn.BackgroundColor3 = T.ButtonBg
    customBtn.Text             = "Can't Find The Theme You Want?\nClick here to Customise the UI To Your Liking!"
    customBtn.TextColor3       = T.Text
    customBtn.Font             = Enum.Font.GothamMedium
    customBtn.TextSize         = 12
    customBtn.TextWrapped      = true
    customBtn.AutoButtonColor  = false
    customBtn.LayoutOrder      = nlo()
    addCorner(customBtn, 10)
    local cbStr = addStroke(customBtn, T.Accent, 1)

    -- Custom editor
    local custEditor = Instance.new("Frame", pg)
    custEditor.Size             = UDim2.new(1, 0, 0, 0)
    custEditor.BackgroundColor3 = T.SecondaryBg
    custEditor.BorderSizePixel  = 0
    custEditor.LayoutOrder      = nlo()
    custEditor.ClipsDescendants = true
    addCorner(custEditor, 12)
    local ceStr = addStroke(custEditor, T.Stroke, 1)

    local ceInner = Instance.new("Frame", custEditor)
    ceInner.Size             = UDim2.new(1, -16, 1, -16)
    ceInner.Position         = UDim2.new(0, 8, 0, 8)
    ceInner.BackgroundTransparency = 1

    local ceLyt = Instance.new("UIListLayout", ceInner)
    ceLyt.FillDirection  = Enum.FillDirection.Vertical
    ceLyt.Padding        = UDim.new(0, 5)

    local PARTS = {"Background","Accent","Text","TabBg","TabActive","ToggleOn","SliderFill","OpenCloseBg","ButtonBg","SecondaryBg"}
    local customColors = {}

    -- Seed with current theme
    for _, p in ipairs(PARTS) do
        customColors[p] = T[p] or Color3.fromRGB(100,100,100)
    end

    local function c3ToHex(c)
        return string.format("#%02X%02X%02X",
            math.clamp(math.round(c.R*255),0,255),
            math.clamp(math.round(c.G*255),0,255),
            math.clamp(math.round(c.B*255),0,255))
    end

    local function hexToC3(h)
        h = h:gsub("#","")
        if #h ~= 6 then return nil end
        local r = tonumber(h:sub(1,2),16)
        local g = tonumber(h:sub(3,4),16)
        local b = tonumber(h:sub(5,6),16)
        if r and g and b then return Color3.fromRGB(r,g,b) end
        return nil
    end

    for _, partName in ipairs(PARTS) do
        local row = Instance.new("Frame", ceInner)
        row.Size               = UDim2.new(1, 0, 0, 30)
        row.BackgroundTransparency = 1

        local rLyt = Instance.new("UIListLayout", row)
        rLyt.FillDirection     = Enum.FillDirection.Horizontal
        rLyt.VerticalAlignment = Enum.VerticalAlignment.Center
        rLyt.Padding           = UDim.new(0, 6)

        local rLbl = Instance.new("TextLabel", row)
        rLbl.Size              = UDim2.new(0.44, 0, 1, 0)
        rLbl.BackgroundTransparency = 1
        rLbl.Text              = partName
        rLbl.TextColor3        = T.Text
        rLbl.Font              = Enum.Font.GothamMedium
        rLbl.TextSize          = 11
        rLbl.TextXAlignment    = Enum.TextXAlignment.Left
        rLbl.TextWrapped       = true

        local rBox = Instance.new("TextBox", row)
        rBox.Size              = UDim2.new(0.36, 0, 0, 24)
        rBox.BackgroundColor3  = T.TabBg
        rBox.BorderSizePixel   = 0
        rBox.Text              = c3ToHex(customColors[partName] or Color3.fromRGB(128,128,128))
        rBox.TextColor3        = T.Text
        rBox.Font              = Enum.Font.Code
        rBox.TextSize          = 11
        rBox.ClearTextOnFocus  = false
        addCorner(rBox, 5)

        local rPrev = Instance.new("Frame", row)
        rPrev.Size             = UDim2.new(0, 22, 0, 22)
        rPrev.BackgroundColor3 = customColors[partName] or Color3.fromRGB(128,128,128)
        rPrev.BorderSizePixel  = 0
        addCorner(rPrev, 4)

        rBox:GetPropertyChangedSignal("Text"):Connect(function()
            local c = hexToC3(rBox.Text)
            if c then
                customColors[partName] = c
                rPrev.BackgroundColor3 = c
            end
        end)
    end

    local applyBtn = Instance.new("TextButton", ceInner)
    applyBtn.Size             = UDim2.new(1, 0, 0, 34)
    applyBtn.BackgroundColor3 = T.Accent
    applyBtn.Text             = "Apply Custom Theme"
    applyBtn.TextColor3       = Color3.fromRGB(0,0,0)
    applyBtn.Font             = Enum.Font.GothamBold
    applyBtn.TextSize         = 13
    applyBtn.AutoButtonColor  = false
    addCorner(applyBtn, 8)

    applyBtn.MouseButton1Click:Connect(function()
        setTheme("Custom", customColors)
        thCurLbl.Text = "Theme: Custom"
        showNotification("Custom Theme Applied!", T.Accent)
    end)

    local ceExpanded = false
    local ceH        = (#PARTS * 35) + 50

    customBtn.MouseButton1Click:Connect(function()
        ceExpanded = not ceExpanded
        tween(custEditor, {Size = UDim2.new(1, 0, 0, ceExpanded and ceH or 0)}, 0.28)
    end)

    onThemeUpdate(function()
        thHdr.BackgroundColor3  = T.SecondaryBg
        thHdrStr.Color          = T.Stroke
        thCurLbl.TextColor3     = T.Text
        thChgBtn.BackgroundColor3 = T.ButtonBg
        thChgBtn.TextColor3     = T.Text
        thOptions.BackgroundColor3 = T.DropdownBg
        thOptStr.Color          = T.Stroke
        refreshThemeOptColors()
        customBtn.BackgroundColor3 = T.ButtonBg
        customBtn.TextColor3    = T.Text
        cbStr.Color             = T.Accent
        custEditor.BackgroundColor3 = T.SecondaryBg
        ceStr.Color             = T.Stroke
        applyBtn.BackgroundColor3  = T.Accent
        for _, c in ipairs(ceInner:GetDescendants()) do
            if c:IsA("TextLabel") then c.TextColor3 = T.Text end
        end
    end)
end

-- ══════════════════════════════════
-- THEME UPDATE CALLBACKS
-- ══════════════════════════════════
onThemeUpdate(function()
    T = Themes[currentThemeName] or Themes["Original"]

    -- Main frame
    MainFrame.BackgroundColor3  = T.Background
    mfStroke.Color              = T.Accent
    mfGrad.Color                = ColorSequence.new(T.GradStart, T.GradEnd)

    -- Title bar
    TitleBar.BackgroundColor3   = T.SecondaryBg
    tbGrad.Color                = ColorSequence.new(T.AccentDark, T.Background)
    TitleLbl.TextColor3         = T.Text

    -- Tab bar
    TabBar.BackgroundColor3     = T.SecondaryBg

    -- OC Button
    OcBtn.BackgroundColor3      = T.OpenCloseBg
    ocStroke.Color              = T.Accent
    OcText.TextColor3           = T.Text

    -- Tab buttons
    for tabName, btn in pairs(tabButtons) do
        if tabName == activeTab then
            btn.BackgroundColor3 = T.TabActive
            btn.Lbl.TextColor3   = T.Text
        else
            btn.BackgroundColor3 = T.TabBg
            btn.Lbl.TextColor3   = T.TextDim
        end
    end

    -- Scrollbars
    for _, pg in pairs(tabPages) do
        pg.ScrollBarImageColor3 = T.ScrollBar
    end
end)

-- ══════════════════════════════════
-- VIEWPORT RESPONSIVENESS
-- ══════════════════════════════════
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updateOcSize()
    updateMainSize()
    task.defer(positionOcBtn)
end)

-- ══════════════════════════════════
-- INITIAL SWITCH
-- ══════════════════════════════════
task.defer(function()
    switchTab("Home")
    positionOcBtn()
    -- Apply theme callbacks to sync initial state
    fireThemeUpdate()
end)

print("[Project Crafted V2] Loaded successfully!")
