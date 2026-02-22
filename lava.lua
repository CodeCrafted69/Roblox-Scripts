
-- Project Crafted
-- Executor Script

local CoreGui = game:GetService("CoreGui")
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "ProjectCrafted" then gui:Destroy() end
end

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService         = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

if not _G.PCraftedExecCount then _G.PCraftedExecCount = 0 end
_G.PCraftedExecCount = _G.PCraftedExecCount + 1
local executeCount = _G.PCraftedExecCount

local LOGO_ID = "rbxassetid://85816937697749"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProjectCrafted"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = CoreGui

local uiScale = Instance.new("UIScale")
uiScale.Parent = ScreenGui

local camera = workspace.CurrentCamera
local function updateScale()
    local vp = camera.ViewportSize
    uiScale.Scale = math.clamp(math.min(vp.X/1920, vp.Y/1080), 0.45, 1.2)
end
updateScale()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local C = {
    Bg         = Color3.fromRGB(9,  16,  11),
    Surface    = Color3.fromRGB(15, 24,  17),
    SurfaceB   = Color3.fromRGB(20, 34,  24),
    SurfaceC   = Color3.fromRGB(26, 44,  30),
    Accent     = Color3.fromRGB(52, 211, 95),
    AccentDim  = Color3.fromRGB(28, 130, 58),
    AccentGlow = Color3.fromRGB(16, 60,  28),
    AccentDeep = Color3.fromRGB(10, 35,  18),
    Text       = Color3.fromRGB(218,255, 228),
    TextMid    = Color3.fromRGB(140,200, 158),
    TextDim    = Color3.fromRGB(80, 130, 95),
    Border     = Color3.fromRGB(30, 58,  38),
    Off        = Color3.fromRGB(38, 52,  42),
    Close      = Color3.fromRGB(195, 55,  55),
    Warn       = Color3.fromRGB(220, 160, 30),
    WarnDim    = Color3.fromRGB(120, 80, 10),
    WarnDeep   = Color3.fromRGB(40, 25, 5),
}

local function tw(obj, props, t, s, d)
    s = s or Enum.EasingStyle.Quart; d = d or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t, s, d), props):Play()
end
local function corner(obj, r)
    local c = Instance.new("UICorner"); c.CornerRadius = r or UDim.new(0,10); c.Parent = obj; return c
end
local function mkStroke(obj, color, thick)
    local s = Instance.new("UIStroke"); s.Color = color or C.Border; s.Thickness = thick or 1; s.Parent = obj; return s
end
local function glow(parent, col, tr)
    local s = Instance.new("ImageLabel")
    s.Size = UDim2.new(1,46,1,46); s.Position = UDim2.new(0,-23,0,-23)
    s.BackgroundTransparency = 1; s.Image = "rbxassetid://5554236805"
    s.ImageColor3 = col or C.Accent; s.ImageTransparency = tr or 0.72
    s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(23,23,277,277)
    s.ZIndex = (parent.ZIndex or 10)-1; s.Parent = parent; return s
end
local function logoImage(parent, size, zidx, pos)
    local img = Instance.new("ImageLabel")
    img.Size = size or UDim2.new(1,0,1,0); img.Position = pos or UDim2.new(0,0,0,0)
    img.BackgroundTransparency = 1; img.Image = LOGO_ID
    img.ZIndex = zidx or 13; img.Parent = parent; return img
end

local TogglePill = Instance.new("TextButton")
TogglePill.Size = UDim2.new(0,48,0,48); TogglePill.Position = UDim2.new(0,16,0.5,-24)
TogglePill.BackgroundColor3 = C.Accent; TogglePill.BorderSizePixel = 0
TogglePill.Text = ""; TogglePill.ZIndex = 100; TogglePill.Parent = ScreenGui
corner(TogglePill, UDim.new(0,14)); glow(TogglePill, C.Accent, 0.62)
logoImage(TogglePill, UDim2.new(0,30,0,30), 101, UDim2.new(0.5,-15,0.5,-15))

local MAIN_W, MAIN_H = 400, 560
local Main = Instance.new("Frame")
Main.Name = "Main"; Main.Size = UDim2.new(0,MAIN_W,0,MAIN_H)
Main.Position = UDim2.new(0.5,-MAIN_W/2,0.5,-MAIN_H/2)
Main.BackgroundColor3 = C.Bg; Main.BorderSizePixel = 0
Main.ClipsDescendants = true; Main.ZIndex = 10; Main.Parent = ScreenGui
corner(Main, UDim.new(0,18)); mkStroke(Main, C.Border, 1.5); glow(Main, C.Accent, 0.78)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,56); Header.BackgroundColor3 = C.Surface
Header.BorderSizePixel = 0; Header.ZIndex = 11; Header.Parent = Main
corner(Header, UDim.new(0,18))
local hPatch = Instance.new("Frame")
hPatch.Size = UDim2.new(1,0,0.5,0); hPatch.Position = UDim2.new(0,0,0.5,0)
hPatch.BackgroundColor3 = C.Surface; hPatch.BorderSizePixel = 0; hPatch.ZIndex = 11; hPatch.Parent = Header
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1,0,0,1.5); hLine.Position = UDim2.new(0,0,1,-1.5)
hLine.BackgroundColor3 = C.Accent; hLine.BorderSizePixel = 0; hLine.ZIndex = 12; hLine.Parent = Header
local hGrad = Instance.new("UIGradient")
hGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.AccentDeep), ColorSequenceKeypoint.new(0.3, C.AccentDim),
    ColorSequenceKeypoint.new(0.5, C.Accent), ColorSequenceKeypoint.new(0.7, C.AccentDim),
    ColorSequenceKeypoint.new(1, C.AccentDeep),
}); hGrad.Parent = hLine
local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0,28,0,28); logoFrame.Position = UDim2.new(0,14,0.5,-14)
logoFrame.BackgroundTransparency = 1; logoFrame.ZIndex = 12; logoFrame.Parent = Header
logoImage(logoFrame, UDim2.new(1,0,1,0), 13)
local TitleTxt = Instance.new("TextLabel")
TitleTxt.Size = UDim2.new(1,-100,0,22); TitleTxt.Position = UDim2.new(0,48,0,9)
TitleTxt.BackgroundTransparency = 1; TitleTxt.Text = "Project Crafted"
TitleTxt.TextColor3 = C.Text; TitleTxt.TextSize = 15; TitleTxt.Font = Enum.Font.GothamBold
TitleTxt.TextXAlignment = Enum.TextXAlignment.Left; TitleTxt.ZIndex = 13; TitleTxt.Parent = Header
local SubTxt = Instance.new("TextLabel")
SubTxt.Size = UDim2.new(1,-100,0,13); SubTxt.Position = UDim2.new(0,48,0,33)
SubTxt.BackgroundTransparency = 1; SubTxt.Text = "Spawn Detection System"
SubTxt.TextColor3 = C.TextDim; SubTxt.TextSize = 9; SubTxt.Font = Enum.Font.Gotham
SubTxt.TextXAlignment = Enum.TextXAlignment.Left; SubTxt.ZIndex = 13; SubTxt.Parent = Header
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,26,0,26); CloseBtn.Position = UDim2.new(1,-38,0.5,-13)
CloseBtn.BackgroundColor3 = C.Close; CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"; CloseBtn.TextColor3 = C.Text; CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.Code; CloseBtn.ZIndex = 14; CloseBtn.Parent = Header
corner(CloseBtn, UDim.new(0,7))

local TAB_COUNT  = 4
local TAB_BAR_H  = 40
local TAB_BAR_Y  = 62
local TAB_PILL_V = 5

local TabBarOuter = Instance.new("Frame")
TabBarOuter.Size = UDim2.new(1,-24,0,TAB_BAR_H); TabBarOuter.Position = UDim2.new(0,12,0,TAB_BAR_Y)
TabBarOuter.BackgroundColor3 = C.SurfaceB; TabBarOuter.BorderSizePixel = 0
TabBarOuter.ZIndex = 11; TabBarOuter.ClipsDescendants = false; TabBarOuter.Parent = Main
corner(TabBarOuter, UDim.new(0,12)); mkStroke(TabBarOuter, C.Border, 1)
local TabPill = Instance.new("Frame")
TabPill.Size = UDim2.new(1/TAB_COUNT,-2,0,TAB_BAR_H-TAB_PILL_V*2); TabPill.Position = UDim2.new(0,2,0,TAB_PILL_V)
TabPill.BackgroundColor3 = C.AccentGlow; TabPill.BorderSizePixel = 0; TabPill.ZIndex = 12; TabPill.Parent = TabBarOuter
corner(TabPill, UDim.new(0,8)); mkStroke(TabPill, C.AccentDim, 1)

local CONTENT_Y = TAB_BAR_Y + TAB_BAR_H + 6
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1,0,1,-CONTENT_Y); ContentArea.Position = UDim2.new(0,0,0,CONTENT_Y)
ContentArea.BackgroundTransparency = 1; ContentArea.ZIndex = 10; ContentArea.Parent = Main

-- ========================
-- CUSTOM SCROLLBAR
-- ========================
local SB_W   = 5
local SB_PAD = 10

local sbTrack = Instance.new("Frame")
sbTrack.Size = UDim2.new(0, SB_W, 1, -(SB_PAD*2 + CONTENT_Y))
sbTrack.Position = UDim2.new(1, -(SB_W + 4), 0, CONTENT_Y + SB_PAD)
sbTrack.BackgroundColor3 = C.SurfaceC; sbTrack.BorderSizePixel = 0
sbTrack.Visible = false; sbTrack.ZIndex = 20; sbTrack.Parent = Main
corner(sbTrack, UDim.new(1,0))
local sbThumb = Instance.new("Frame")
sbThumb.Size = UDim2.new(1,0,0,40); sbThumb.Position = UDim2.new(0,0,0,0)
sbThumb.BackgroundColor3 = C.Accent; sbThumb.BorderSizePixel = 0
sbThumb.ZIndex = 21; sbThumb.Parent = sbTrack
corner(sbThumb, UDim.new(1,0))

local function updateScrollbar(sf)
    local trackH = sbTrack.AbsoluteSize.Y
    if trackH <= 0 then return end
    local contentH = sf.CanvasSize.Y.Offset
    local frameH   = sf.AbsoluteSize.Y
    if contentH <= frameH then sbTrack.Visible = false; return end
    sbTrack.Visible = true
    local ratio    = math.clamp(frameH / contentH, 0, 1)
    local thumbH   = math.max(28, trackH * ratio)
    local maxScroll = contentH - frameH
    local scrollPct = maxScroll > 0 and math.clamp(sf.CanvasPosition.Y / maxScroll, 0, 1) or 0
    sbThumb.Size     = UDim2.new(1, 0, 0, thumbH)
    sbThumb.Position = UDim2.new(0, 0, 0, scrollPct * (trackH - thumbH))
end

-- ========================
-- WARNING STATE
-- ========================
local warningAcknowledged  = false
local playerTabWarningActive = false

-- ========================
-- TAB SYSTEM
-- ========================
local tabs = {}; local tabPages = {}; local activeTab = nil

local tabDefs = {
    {key="Home",   label="Home",   icon="👤", idx=0},
    {key="Visual", label="Visual", icon="👁",  idx=1},
    {key="Player", label="Player", icon="⚡",  idx=2},
    {key="Misc",   label="Misc",   icon="⚙",  idx=3},
}

local switchTab  -- forward declare so warning buttons can call it
local warningOverlay -- forward declare

local function showPlayerWarning()
    playerTabWarningActive = true
    sbTrack.Visible = false
    if warningOverlay then warningOverlay.Visible = true end
end

local function hidePlayerWarning()
    playerTabWarningActive = false
    if warningOverlay then warningOverlay.Visible = false end
    RunService.Heartbeat:Wait()
    updateScrollbar(tabPages["Player"])
end

switchTab = function(key)
    if activeTab == key then return end; activeTab = key
    local idx = 0
    for _, d in ipairs(tabDefs) do if d.key == key then idx = d.idx end end
    tw(TabPill, {Position = UDim2.new(idx/TAB_COUNT, 2, 0, TAB_PILL_V)}, 0.26, Enum.EasingStyle.Back)
    for k, btn in pairs(tabs) do
        tw(btn, {TextColor3 = k == key and C.Accent or C.TextDim}, 0.2)
        tabPages[k].Visible = k == key
    end
    if key == "Player" then
        if not warningAcknowledged then
            showPlayerWarning()
        else
            sbTrack.Visible = false
            RunService.Heartbeat:Wait()
            updateScrollbar(tabPages["Player"])
        end
    else
        sbTrack.Visible = false
        playerTabWarningActive = false
    end
end

for _, def in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/TAB_COUNT,0,1,-TAB_PILL_V*2)
    btn.Position = UDim2.new(def.idx/TAB_COUNT,0,0,TAB_PILL_V)
    btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
    btn.Text = def.icon.."  "..def.label; btn.TextColor3 = C.TextDim
    btn.TextSize = 10; btn.Font = Enum.Font.GothamMedium; btn.ZIndex = 13; btn.Parent = TabBarOuter

    local isPlayer = def.key == "Player"
    local page = Instance.new("ScrollingFrame")
    page.Name = def.key.."Page"
    page.Size = UDim2.new(1,0,1,0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 0; page.ScrollingEnabled = true
    page.ElasticBehavior = Enum.ElasticBehavior.Never
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.CanvasSize = UDim2.new(0,0,0,0); page.Visible = false; page.ZIndex = 11; page.Parent = ContentArea

    local pl = Instance.new("UIListLayout")
    pl.SortOrder = Enum.SortOrder.LayoutOrder; pl.Padding = UDim.new(0,10); pl.Parent = page
    local pp = Instance.new("UIPadding")
    pp.PaddingTop = UDim.new(0,14); pp.PaddingBottom = UDim.new(0,18)
    pp.PaddingLeft = UDim.new(0,14); pp.PaddingRight = UDim.new(0, isPlayer and 18 or 14)
    pp.Parent = page

    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+32)
        if isPlayer and activeTab == "Player" and not playerTabWarningActive then
            updateScrollbar(page)
        end
    end)

    if isPlayer then
        page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if activeTab == "Player" and not playerTabWarningActive then
                updateScrollbar(page)
            end
        end)
    end

    tabs[def.key] = btn; tabPages[def.key] = page
    btn.MouseButton1Click:Connect(function() switchTab(def.key) end)
end

-- ========================
-- WARNING OVERLAY (Player Tab)
-- Must be created after tabPages are built, before content is added
-- ========================
warningOverlay = Instance.new("Frame")
warningOverlay.Size = UDim2.new(1, 0, 1, -CONTENT_Y)
warningOverlay.Position = UDim2.new(0, 0, 0, CONTENT_Y)
warningOverlay.BackgroundColor3 = Color3.fromRGB(4, 8, 6)
warningOverlay.BackgroundTransparency = 0.08
warningOverlay.BorderSizePixel = 0
warningOverlay.Visible = false
warningOverlay.ZIndex = 22
warningOverlay.Parent = Main
-- Blurred grid pattern to simulate blur
local blurLines = Instance.new("UIGradient")
blurLines.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(4,12,7)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8,20,12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4,12,7)),
})
blurLines.Rotation = 45
blurLines.Parent = warningOverlay

-- Warning card
local warnCard = Instance.new("Frame")
warnCard.Size = UDim2.new(1, -48, 0, 230)
warnCard.Position = UDim2.new(0, 24, 0.5, -115)
warnCard.BackgroundColor3 = C.WarnDeep
warnCard.BorderSizePixel = 0; warnCard.ZIndex = 23; warnCard.Parent = warningOverlay
corner(warnCard, UDim.new(0,16)); mkStroke(warnCard, C.Warn, 1.5)

-- Warning glow
local warnGlow = Instance.new("ImageLabel")
warnGlow.Size = UDim2.new(1,46,1,46); warnGlow.Position = UDim2.new(0,-23,0,-23)
warnGlow.BackgroundTransparency = 1; warnGlow.Image = "rbxassetid://5554236805"
warnGlow.ImageColor3 = C.Warn; warnGlow.ImageTransparency = 0.75
warnGlow.ScaleType = Enum.ScaleType.Slice; warnGlow.SliceCenter = Rect.new(23,23,277,277)
warnGlow.ZIndex = 22; warnGlow.Parent = warnCard

-- Warning icon
local warnIcon = Instance.new("TextLabel")
warnIcon.Size = UDim2.new(1,0,0,46); warnIcon.Position = UDim2.new(0,0,0,18)
warnIcon.BackgroundTransparency = 1; warnIcon.Text = "⚠"
warnIcon.TextColor3 = C.Warn; warnIcon.TextSize = 36; warnIcon.Font = Enum.Font.GothamBold
warnIcon.TextXAlignment = Enum.TextXAlignment.Center; warnIcon.ZIndex = 24; warnIcon.Parent = warnCard

-- Warning title
local warnTitle = Instance.new("TextLabel")
warnTitle.Size = UDim2.new(1,-24,0,22); warnTitle.Position = UDim2.new(0,12,0,68)
warnTitle.BackgroundTransparency = 1; warnTitle.Text = "WARNING"
warnTitle.TextColor3 = C.Warn; warnTitle.TextSize = 15; warnTitle.Font = Enum.Font.GothamBold
warnTitle.TextXAlignment = Enum.TextXAlignment.Center; warnTitle.ZIndex = 24; warnTitle.Parent = warnCard

-- Warning body
local warnBody = Instance.new("TextLabel")
warnBody.Size = UDim2.new(1,-24,0,72); warnBody.Position = UDim2.new(0,12,0,94)
warnBody.BackgroundTransparency = 1
warnBody.Text = "Using these Features May Get You Banned\nUse At Your Own Risk!"
warnBody.TextColor3 = C.TextMid; warnBody.TextSize = 12; warnBody.Font = Enum.Font.GothamMedium
warnBody.TextXAlignment = Enum.TextXAlignment.Center; warnBody.TextWrapped = true
warnBody.ZIndex = 24; warnBody.Parent = warnCard

-- Divider
local warnDiv = Instance.new("Frame")
warnDiv.Size = UDim2.new(1,-24,0,1); warnDiv.Position = UDim2.new(0,12,0,170)
warnDiv.BackgroundColor3 = C.WarnDim; warnDiv.BorderSizePixel = 0; warnDiv.ZIndex = 24; warnDiv.Parent = warnCard

-- Ok button
local warnOk = Instance.new("TextButton")
warnOk.Size = UDim2.new(0.5,-16,0,36); warnOk.Position = UDim2.new(0,12,0,180)
warnOk.BackgroundColor3 = C.AccentGlow; warnOk.BorderSizePixel = 0
warnOk.Text = "✓  I Understand"; warnOk.TextColor3 = C.Accent
warnOk.TextSize = 12; warnOk.Font = Enum.Font.GothamBold; warnOk.ZIndex = 25; warnOk.Parent = warnCard
corner(warnOk, UDim.new(0,9)); mkStroke(warnOk, C.AccentDim, 1.5)
warnOk.MouseButton1Click:Connect(function()
    warningAcknowledged = true
    hidePlayerWarning()
end)
warnOk.MouseEnter:Connect(function() tw(warnOk,{BackgroundColor3=C.AccentDim},0.12) end)
warnOk.MouseLeave:Connect(function() tw(warnOk,{BackgroundColor3=C.AccentGlow},0.12) end)

-- Cancel button
local warnCancel = Instance.new("TextButton")
warnCancel.Size = UDim2.new(0.5,-16,0,36); warnCancel.Position = UDim2.new(0.5,4,0,180)
warnCancel.BackgroundColor3 = Color3.fromRGB(50,15,15); warnCancel.BorderSizePixel = 0
warnCancel.Text = "✕  Go Back"; warnCancel.TextColor3 = Color3.fromRGB(220,100,100)
warnCancel.TextSize = 12; warnCancel.Font = Enum.Font.GothamBold; warnCancel.ZIndex = 25; warnCancel.Parent = warnCard
corner(warnCancel, UDim.new(0,9)); mkStroke(warnCancel, Color3.fromRGB(120,40,40), 1.5)
warnCancel.MouseButton1Click:Connect(function()
    -- Don't acknowledge, just go back to home — warning stays for next visit
    switchTab("Home")
end)
warnCancel.MouseEnter:Connect(function() tw(warnCancel,{BackgroundColor3=Color3.fromRGB(80,20,20)},0.12) end)
warnCancel.MouseLeave:Connect(function() tw(warnCancel,{BackgroundColor3=Color3.fromRGB(50,15,15)},0.12) end)

-- ========================
-- GLOBAL MOBILE SCROLL (uses UIS directly, not per-element hooks)
-- ========================
local function setupMobileScroll(scrollFrame)
    local scrolling   = false
    local startY      = 0
    local startCanvas = 0

    local function insideBounds(pos)
        local ap = scrollFrame.AbsolutePosition
        local as = scrollFrame.AbsoluteSize
        return pos.X >= ap.X and pos.X <= ap.X + as.X
           and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
    end

    UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if playerTabWarningActive then return end
        if scrollFrame.Visible and insideBounds(inp.Position) then
            scrolling   = true
            startY      = inp.Position.Y
            startCanvas = scrollFrame.CanvasPosition.Y
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not scrolling then return end
        if inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = startY - inp.Position.Y
        local maxY  = math.max(0, scrollFrame.CanvasSize.Y.Offset - scrollFrame.AbsoluteSize.Y)
        scrollFrame.CanvasPosition = Vector2.new(0, math.clamp(startCanvas + delta, 0, maxY))
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.Touch then return end
        scrolling = false
    end)
end

-- ========================
-- HELPERS
-- ========================
local function sectionLbl(parent, text, order)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1
    f.LayoutOrder=order; f.ZIndex=12; f.Parent=parent
    local line=Instance.new("Frame"); line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,0.5,0)
    line.BackgroundColor3=C.Border; line.BorderSizePixel=0; line.ZIndex=12; line.Parent=f
    local bg=Instance.new("Frame"); bg.Size=UDim2.new(0,0,1,0); bg.AutomaticSize=Enum.AutomaticSize.X
    bg.BackgroundColor3=C.Bg; bg.BorderSizePixel=0; bg.ZIndex=13; bg.Parent=f
    local bgp=Instance.new("UIPadding"); bgp.PaddingLeft=UDim.new(0,6); bgp.PaddingRight=UDim.new(0,8); bgp.Parent=bg
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0,0,1,0); lbl.AutomaticSize=Enum.AutomaticSize.X
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.TextColor3=C.TextDim
    lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold; lbl.ZIndex=14; lbl.Parent=bg
    return f
end

local function infoRow(parent, label, value, order)
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=C.Surface
    row.BorderSizePixel=0; row.LayoutOrder=order; row.ZIndex=12; row.Parent=parent
    corner(row,UDim.new(0,9)); mkStroke(row,C.Border,1)
    local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,3,0.55,0); acc.Position=UDim2.new(0,0,0.225,0)
    acc.BackgroundColor3=C.Accent; acc.BorderSizePixel=0; acc.ZIndex=13; acc.Parent=row; corner(acc,UDim.new(0,3))
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.5,-8,1,0); lbl.Position=UDim2.new(0,14,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.TextMid; lbl.TextSize=11
    lbl.Font=Enum.Font.GothamMedium; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=13; lbl.Parent=row
    local val=Instance.new("TextLabel"); val.Name="Val"; val.Size=UDim2.new(0.5,-14,1,0)
    val.Position=UDim2.new(0.5,0,0,0); val.BackgroundTransparency=1; val.Text=value
    val.TextColor3=C.Text; val.TextSize=11; val.Font=Enum.Font.GothamBold
    val.TextXAlignment=Enum.TextXAlignment.Right; val.TextTruncate=Enum.TextTruncate.AtEnd; val.ZIndex=13; val.Parent=row
    local vp=Instance.new("UIPadding"); vp.PaddingRight=UDim.new(0,12); vp.Parent=val
    return row, val
end

local function toggleRow(parent, label, sub, order)
    local h = sub ~= "" and 50 or 38
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,h); row.BackgroundColor3=C.Surface
    row.BorderSizePixel=0; row.LayoutOrder=order; row.ZIndex=12; row.Parent=parent
    corner(row,UDim.new(0,10)); mkStroke(row,C.Border,1)
    local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,3,0.55,0); acc.Position=UDim2.new(0,0,0.225,0)
    acc.BackgroundColor3=C.Accent; acc.BorderSizePixel=0; acc.ZIndex=13; acc.Parent=row; corner(acc,UDim.new(0,3))
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-64,0,sub~="" and 20 or h)
    lbl.Position=UDim2.new(0,14,0,sub~="" and 8 or 0); lbl.BackgroundTransparency=1; lbl.Text=label
    lbl.TextColor3=C.Text; lbl.TextSize=12; lbl.Font=Enum.Font.GothamMedium
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=13; lbl.Parent=row
    if sub ~= "" then
        local s=Instance.new("TextLabel"); s.Size=UDim2.new(1,-64,0,14); s.Position=UDim2.new(0,14,0,28)
        s.BackgroundTransparency=1; s.Text=sub; s.TextColor3=C.TextDim; s.TextSize=9
        s.Font=Enum.Font.Gotham; s.TextXAlignment=Enum.TextXAlignment.Left; s.ZIndex=13; s.Parent=row
    end
    local track=Instance.new("Frame"); track.Size=UDim2.new(0,42,0,22); track.Position=UDim2.new(1,-54,0.5,-11)
    track.BackgroundColor3=C.Off; track.BorderSizePixel=0; track.ZIndex=13; track.Parent=row
    corner(track,UDim.new(1,0)); local tStr=mkStroke(track,C.Border,1)
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,16,0,16); knob.Position=UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3=C.TextDim; knob.BorderSizePixel=0; knob.ZIndex=14; knob.Parent=track; corner(knob,UDim.new(1,0))
    local hit=Instance.new("TextButton"); hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1
    hit.Text=""; hit.ZIndex=15; hit.Parent=track
    return row, track, knob, hit, tStr
end

local function makeSlider(parent, label, minVal, maxVal, defaultVal, order, onChange)
    local container=Instance.new("Frame"); container.Size=UDim2.new(1,0,0,64)
    container.BackgroundColor3=C.Surface; container.BorderSizePixel=0
    container.LayoutOrder=order; container.ZIndex=12; container.Parent=parent
    corner(container,UDim.new(0,10)); mkStroke(container,C.Border,1)
    local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,3,0.55,0); acc.Position=UDim2.new(0,0,0.225,0)
    acc.BackgroundColor3=C.Accent; acc.BorderSizePixel=0; acc.ZIndex=13; acc.Parent=container; corner(acc,UDim.new(0,3))
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-70,0,20); lbl.Position=UDim2.new(0,14,0,10)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.Text; lbl.TextSize=12
    lbl.Font=Enum.Font.GothamMedium; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=13; lbl.Parent=container
    local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0,60,0,20); valLbl.Position=UDim2.new(1,-72,0,10)
    valLbl.BackgroundTransparency=1; valLbl.Text=tostring(math.round(defaultVal)); valLbl.TextColor3=C.Accent
    valLbl.TextSize=12; valLbl.Font=Enum.Font.GothamBold; valLbl.TextXAlignment=Enum.TextXAlignment.Right
    valLbl.ZIndex=13; valLbl.Parent=container
    local vlp=Instance.new("UIPadding"); vlp.PaddingRight=UDim.new(0,12); vlp.Parent=valLbl
    local trackBg=Instance.new("Frame"); trackBg.Size=UDim2.new(1,-28,0,6); trackBg.Position=UDim2.new(0,14,0,42)
    trackBg.BackgroundColor3=C.SurfaceC; trackBg.BorderSizePixel=0; trackBg.ZIndex=13; trackBg.Parent=container
    corner(trackBg,UDim.new(1,0))
    local rel0=(defaultVal-minVal)/(maxVal-minVal)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new(rel0,0,1,0); fill.BackgroundColor3=C.Accent
    fill.BorderSizePixel=0; fill.ZIndex=14; fill.Parent=trackBg; corner(fill,UDim.new(1,0))
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,18,0,18); knob.Position=UDim2.new(rel0,-9,0.5,-9)
    knob.BackgroundColor3=C.Text; knob.BorderSizePixel=0; knob.ZIndex=15; knob.Parent=trackBg
    corner(knob,UDim.new(1,0)); mkStroke(knob,C.Accent,1.5)
    local sDrag=false
    local function updateFromX(absX)
        local rel=math.clamp((absX-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        local value=minVal+rel*(maxVal-minVal)
        knob.Position=UDim2.new(rel,-9,0.5,-9); fill.Size=UDim2.new(rel,0,1,0)
        valLbl.Text=tostring(math.round(value)); onChange(value)
    end
    local hitArea=Instance.new("TextButton"); hitArea.Size=UDim2.new(1,0,0,30)
    hitArea.Position=UDim2.new(0,0,0.5,-15); hitArea.BackgroundTransparency=1
    hitArea.Text=""; hitArea.ZIndex=16; hitArea.Parent=trackBg
    hitArea.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            sDrag=true; updateFromX(inp.Position.X)
        end
    end)
    hitArea.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then sDrag=false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            updateFromX(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then sDrag=false end
    end)
    return container
end

local function makeActionBtn(parent, label, bgColor, order, onClick)
    bgColor = bgColor or C.Surface
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,40)
    btn.BackgroundColor3=bgColor; btn.BorderSizePixel=0; btn.Text=label
    btn.TextColor3=C.Text; btn.TextSize=13; btn.Font=Enum.Font.GothamMedium
    btn.LayoutOrder=order; btn.ZIndex=12; btn.Parent=parent
    corner(btn,UDim.new(0,10)); mkStroke(btn,C.Border,1)
    local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,3,0.55,0); acc.Position=UDim2.new(0,0,0.225,0)
    acc.BackgroundColor3=C.Accent; acc.BorderSizePixel=0; acc.ZIndex=13; acc.Parent=btn; corner(acc,UDim.new(0,3))
    btn.MouseButton1Click:Connect(onClick)
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=C.SurfaceC},0.12) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=bgColor},0.12) end)
    return btn
end

-- ========================
-- HOME TAB
-- ========================
local homePage = tabPages["Home"]
local profileCard=Instance.new("Frame"); profileCard.Size=UDim2.new(1,0,0,110)
profileCard.BackgroundColor3=C.Surface; profileCard.BorderSizePixel=0
profileCard.LayoutOrder=1; profileCard.ZIndex=12; profileCard.Parent=homePage
corner(profileCard,UDim.new(0,14)); mkStroke(profileCard,C.Border,1)
local cardGrad=Instance.new("UIGradient")
cardGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.SurfaceB),ColorSequenceKeypoint.new(1,C.Surface)})
cardGrad.Rotation=135; cardGrad.Parent=profileCard
local avatarRing=Instance.new("Frame"); avatarRing.Size=UDim2.new(0,76,0,76)
avatarRing.Position=UDim2.new(0,16,0.5,-38); avatarRing.BackgroundColor3=C.Accent
avatarRing.BorderSizePixel=0; avatarRing.ZIndex=13; avatarRing.Parent=profileCard; corner(avatarRing,UDim.new(0,14))
local avatarInner=Instance.new("Frame"); avatarInner.Size=UDim2.new(1,-4,1,-4)
avatarInner.Position=UDim2.new(0,2,0,2); avatarInner.BackgroundColor3=C.AccentDeep
avatarInner.BorderSizePixel=0; avatarInner.ZIndex=14; avatarInner.Parent=avatarRing; corner(avatarInner,UDim.new(0,12))
local avatarImg=Instance.new("ImageLabel"); avatarImg.Size=UDim2.new(1,0,1,0)
avatarImg.BackgroundTransparency=1; avatarImg.ZIndex=15; avatarImg.Parent=avatarInner; corner(avatarImg,UDim.new(0,12))
task.spawn(function()
    local ok,img=pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    end)
    if ok then avatarImg.Image=img end
end)
local displayNameLbl=Instance.new("TextLabel"); displayNameLbl.Size=UDim2.new(1,-108,0,24)
displayNameLbl.Position=UDim2.new(0,106,0,12); displayNameLbl.BackgroundTransparency=1
displayNameLbl.Text=LocalPlayer.DisplayName; displayNameLbl.TextColor3=C.Text; displayNameLbl.TextSize=17
displayNameLbl.Font=Enum.Font.GothamBold; displayNameLbl.TextXAlignment=Enum.TextXAlignment.Left
displayNameLbl.ZIndex=13; displayNameLbl.Parent=profileCard
local userNameLbl=Instance.new("TextLabel"); userNameLbl.Size=UDim2.new(1,-108,0,16)
userNameLbl.Position=UDim2.new(0,106,0,38); userNameLbl.BackgroundTransparency=1
userNameLbl.Text="@"..LocalPlayer.Name; userNameLbl.TextColor3=C.TextMid; userNameLbl.TextSize=11
userNameLbl.Font=Enum.Font.GothamMedium; userNameLbl.TextXAlignment=Enum.TextXAlignment.Left
userNameLbl.ZIndex=13; userNameLbl.Parent=profileCard
local execPill=Instance.new("Frame"); execPill.Size=UDim2.new(0,0,0,20); execPill.AutomaticSize=Enum.AutomaticSize.X
execPill.Position=UDim2.new(0,106,0,60); execPill.BackgroundColor3=C.AccentGlow
execPill.BorderSizePixel=0; execPill.ZIndex=13; execPill.Parent=profileCard
corner(execPill,UDim.new(0,6)); mkStroke(execPill,C.AccentDim,1)
local epp=Instance.new("UIPadding"); epp.PaddingLeft=UDim.new(0,7); epp.PaddingRight=UDim.new(0,7); epp.Parent=execPill
local execPillTxt=Instance.new("TextLabel"); execPillTxt.Size=UDim2.new(0,0,1,0); execPillTxt.AutomaticSize=Enum.AutomaticSize.X
execPillTxt.BackgroundTransparency=1; execPillTxt.Text="Executed  "..tostring(executeCount).."x"
execPillTxt.TextColor3=C.Accent; execPillTxt.TextSize=9; execPillTxt.Font=Enum.Font.GothamBold
execPillTxt.ZIndex=14; execPillTxt.Parent=execPill
local uidPill=Instance.new("Frame"); uidPill.Size=UDim2.new(0,0,0,20); uidPill.AutomaticSize=Enum.AutomaticSize.X
uidPill.Position=UDim2.new(0,106,0,84); uidPill.BackgroundColor3=C.SurfaceC
uidPill.BorderSizePixel=0; uidPill.ZIndex=13; uidPill.Parent=profileCard
corner(uidPill,UDim.new(0,6)); mkStroke(uidPill,C.Border,1)
local upp=Instance.new("UIPadding"); upp.PaddingLeft=UDim.new(0,7); upp.PaddingRight=UDim.new(0,7); upp.Parent=uidPill
local uidPillTxt=Instance.new("TextLabel"); uidPillTxt.Size=UDim2.new(0,0,1,0); uidPillTxt.AutomaticSize=Enum.AutomaticSize.X
uidPillTxt.BackgroundTransparency=1; uidPillTxt.Text="UID  "..tostring(LocalPlayer.UserId)
uidPillTxt.TextColor3=C.TextMid; uidPillTxt.TextSize=9; uidPillTxt.Font=Enum.Font.GothamMedium
uidPillTxt.ZIndex=14; uidPillTxt.Parent=uidPill
sectionLbl(homePage,"SERVER",2)
local _,playerCountVal=infoRow(homePage,"Players in Server","...",3)
local _,serverIdVal   =infoRow(homePage,"Server ID","...",4)
sectionLbl(homePage,"GAME",5)
local _,gameNameVal=infoRow(homePage,"Game Name","...",6)
local _,gameIdVal  =infoRow(homePage,"Place ID",tostring(game.PlaceId),7)
task.spawn(function()
    local ok1,sid=pcall(function() return game.JobId end)
    serverIdVal.Text=(ok1 and sid and sid~="") and (sid:sub(1,16).."...") or "N/A"
    local function refreshCount() playerCountVal.Text=#Players:GetPlayers().." / "..Players.MaxPlayers end
    refreshCount()
    Players.PlayerAdded:Connect(refreshCount)
    Players.PlayerRemoving:Connect(function() task.wait(); refreshCount() end)
    local ok2,info=pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if ok2 and info and info.Name then
        local n=info.Name; gameNameVal.Text=#n>22 and n:sub(1,22).."..." or n
    else gameNameVal.Text="Unknown" end
end)

-- ========================
-- VISUAL TAB
-- ========================
local visualPage=tabPages["Visual"]
local highlightOn=false; local activeHighlights={}
local function applyHighlight(model)
    if not highlightOn or not model or not model.Parent then return end
    local ex=model:FindFirstChildOfClass("Highlight"); if ex then ex:Destroy() end
    local hl=Instance.new("Highlight"); hl.FillColor=C.Accent
    hl.OutlineColor=Color3.fromRGB(180,255,195); hl.FillTransparency=0.42
    hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=model
    table.insert(activeHighlights,hl)
end
sectionLbl(visualPage,"RENDER OPTIONS",1)
local _,hlTrack,hlKnob,hlHit,hlStr=toggleRow(visualPage,"Highlight Spawned Brainrots","Visible through walls at any distance",2)
hlHit.MouseButton1Click:Connect(function()
    highlightOn=not highlightOn
    if highlightOn then
        tw(hlTrack,{BackgroundColor3=C.AccentDim},0.2); tw(hlKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back); hlStr.Color=C.Accent
    else
        tw(hlTrack,{BackgroundColor3=C.Off},0.2); tw(hlKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back); hlStr.Color=C.Border
        for _,h in pairs(activeHighlights) do if h and h.Parent then h:Destroy() end end; activeHighlights={}
    end
end)

-- ========================
-- PLAYER TAB
-- ========================
local playerPage = tabPages["Player"]
setupMobileScroll(playerPage)

local flyEnabled=false; local flyBodyVel=nil; local flyBodyGyro=nil; local flyConn=nil
local flyUp=false; local flyDown=false; local FLY_SPEED=60
local speedOverride=false; local jumpOverride=false; local sliderSpeed=16; local sliderJump=50
local teleportOnSpawn=false; local godmodeOn=false; local lavaTouchConns={}; local disabledParts={}
local flingEnabled=false; local flingBAV=nil; local flingTouchConn=nil

local function getChar() return LocalPlayer.Character end
local function getHRP() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- Speed/Jump sync
local speedSyncConn=nil; local jumpSyncConn=nil
local function startSpeedSync()
    if speedSyncConn then speedSyncConn:Disconnect() end
    local lbl=LocalPlayer.PlayerGui:FindFirstChild("HUD") and LocalPlayer.PlayerGui.HUD:FindFirstChild("Speed")
    if lbl then
        local v=tonumber(lbl.Text:match("-?%d+%.?%d*"))
        if v then local h=getHum(); if h then h.WalkSpeed=v end end
        speedSyncConn=lbl:GetPropertyChangedSignal("Text"):Connect(function()
            if speedOverride then return end
            local v2=tonumber(lbl.Text:match("-?%d+%.?%d*"))
            if v2 then local h=getHum(); if h then h.WalkSpeed=v2 end end
        end)
    end
end
local function stopSpeedSync() if speedSyncConn then speedSyncConn:Disconnect(); speedSyncConn=nil end end
local function startJumpSync()
    if jumpSyncConn then jumpSyncConn:Disconnect() end
    local lbl=LocalPlayer.PlayerGui:FindFirstChild("HUD") and LocalPlayer.PlayerGui.HUD:FindFirstChild("Jump")
    if lbl then
        local v=tonumber(lbl.Text:match("-?%d+%.?%d*"))
        if v then local jp=30+v*(10/3); local h=getHum(); if h then h.JumpPower=jp end end
        jumpSyncConn=lbl:GetPropertyChangedSignal("Text"):Connect(function()
            if jumpOverride then return end
            local v2=tonumber(lbl.Text:match("-?%d+%.?%d*"))
            if v2 then local jp=30+v2*(10/3); local h=getHum(); if h then h.JumpPower=jp end end
        end)
    end
end
local function stopJumpSync() if jumpSyncConn then jumpSyncConn:Disconnect(); jumpSyncConn=nil end end
local function applySpeed(v) sliderSpeed=v; if not speedOverride then return end; local h=getHum(); if h then h.WalkSpeed=v end end
local function applyJump(v) sliderJump=v; if not jumpOverride then return end; local h=getHum(); if h then h.JumpPower=v end end

-- Godmode
local function disableLavaPart(part)
    if not part or not part:IsA("Part") then return end
    for _,e in ipairs(disabledParts) do if e.part==part then return end end
    table.insert(disabledParts,{part=part,was=part.CanTouch}); part.CanTouch=false
end
local function scanLavas()
    local gf=workspace:FindFirstChild("GameFolder"); if not gf then return end
    local lavas=gf:FindFirstChild("Lavas"); if not lavas then return end
    for _,desc in ipairs(lavas:GetDescendants()) do disableLavaPart(desc) end
    disableLavaPart(lavas)
    table.insert(lavaTouchConns,lavas.DescendantAdded:Connect(function(d) if godmodeOn then disableLavaPart(d) end end))
end
local function enableGodmode() godmodeOn=true; disabledParts={}; scanLavas() end
local function disableGodmode()
    godmodeOn=false
    for _,c in ipairs(lavaTouchConns) do c:Disconnect() end; lavaTouchConns={}
    for _,e in ipairs(disabledParts) do if e.part and e.part.Parent then e.part.CanTouch=e.was end end
    disabledParts={}
end

-- ========================
-- FLY - fully directional (camera pitch included)
-- ========================
local function enableFly()
    local hrp=getHRP(); local hum=getHum(); if not hrp or not hum then return end
    if flyBodyVel then flyBodyVel:Destroy() end; if flyBodyGyro then flyBodyGyro:Destroy() end
    local bv=Instance.new("BodyVelocity"); bv.Velocity=Vector3.zero
    bv.MaxForce=Vector3.new(1e5,1e5,1e5); bv.Parent=hrp; flyBodyVel=bv
    local bg=Instance.new("BodyGyro"); bg.MaxTorque=Vector3.new(1e5,1e5,1e5); bg.P=1e5; bg.Parent=hrp; flyBodyGyro=bg
    hum.PlatformStand=true
    if flyConn then flyConn:Disconnect() end
    flyConn=RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        local hrp2=getHRP(); if not hrp2 then return end
        local cf=workspace.CurrentCamera.CFrame
        local camLook  = cf.LookVector   -- full 3D direction (includes pitch)
        local camRight = cf.RightVector  -- full 3D right
        local move=Vector3.zero
        local hum2=getHum()

        -- PC keys: fully directional using camera's real 3D vectors
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move=move+camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move=move-camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move=move-camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move=move+camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or flyUp   then move=move+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or flyDown then move=move-Vector3.new(0,1,0) end

        -- Mobile joystick: map joystick intent to full 3D camera direction
        if hum2 and hum2.MoveDirection.Magnitude>0.1 then
            local md=hum2.MoveDirection
            -- Flat camera vectors to determine joystick intent amounts
            local flatLook  = Vector3.new(camLook.X,  0, camLook.Z)
            local flatRight = Vector3.new(camRight.X, 0, camRight.Z)
            if flatLook.Magnitude  > 0.001 then flatLook  = flatLook.Unit  end
            if flatRight.Magnitude > 0.001 then flatRight = flatRight.Unit end
            local fwd   = md:Dot(flatLook)   -- how much joystick pushes camera-forward
            local right = md:Dot(flatRight)  -- how much joystick pushes camera-right
            -- Apply to full 3D camera direction so pitch is respected
            move = move + camLook*fwd + camRight*right
        end

        if move.Magnitude>0 then move=move.Unit end
        bv.Velocity=move*FLY_SPEED; bg.CFrame=cf
    end)
end
local function disableFly()
    flyEnabled=false
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel=nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro=nil end
    local h=getHum(); if h then h.PlatformStand=false end
end

-- ========================
-- FLING - toggle, spin + touch flings other players
-- ========================
local function enableFling()
    local hrp=getHRP(); if not hrp then return end
    if flingBAV then flingBAV:Destroy() end
    flingBAV=Instance.new("BodyAngularVelocity")
    flingBAV.AngularVelocity=Vector3.new(0, 9999, 0)
    flingBAV.MaxTorque=Vector3.new(0, math.huge, 0)
    flingBAV.Parent=hrp
    local char=getChar()
    if flingTouchConn then flingTouchConn:Disconnect() end
    if char then
        flingTouchConn=char.Touched:Connect(function(part)
            if not flingEnabled then return end
            local otherChar=part.Parent
            if not otherChar or otherChar==char then return end
            local otherHum=otherChar:FindFirstChildOfClass("Humanoid")
            local otherHRP=otherChar:FindFirstChild("HumanoidRootPart")
            if not otherHum or not otherHRP or otherHum.Health<=0 then return end
            local isPlayer=false
            for _,p in pairs(Players:GetPlayers()) do
                if p.Character==otherChar then isPlayer=true; break end
            end
            if not isPlayer then return end
            local myHRP=getHRP()
            local dir=myHRP and (otherHRP.Position-myHRP.Position) or Vector3.new(0,1,0)
            if dir.Magnitude>0 then dir=dir.Unit end
            local bv=Instance.new("BodyVelocity")
            bv.Velocity=dir*500+Vector3.new(0,700,0)
            bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
            bv.Parent=otherHRP
            game:GetService("Debris"):AddItem(bv,0.18)
        end)
    end
end
local function disableFling()
    flingEnabled=false
    if flingBAV then flingBAV:Destroy(); flingBAV=nil end
    if flingTouchConn then flingTouchConn:Disconnect(); flingTouchConn=nil end
end

-- Respawn handler
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedOverride then local h=getHum(); if h then h.WalkSpeed=sliderSpeed end else startSpeedSync() end
    if jumpOverride  then local h=getHum(); if h then h.JumpPower=sliderJump  end else startJumpSync()  end
    if flyEnabled then task.wait(0.2); enableFly() end
    if flingEnabled then task.wait(0.2); enableFling() end
    if godmodeOn then
        for _,e in ipairs(disabledParts) do if e.part and e.part.Parent then e.part.CanTouch=false end end
        scanLavas()
    end
end)

-- Fly mobile buttons
local FlyPanel=Instance.new("Frame")
FlyPanel.Size=UDim2.new(0,120,0,56); FlyPanel.Position=UDim2.new(1,-136,1,-176)
FlyPanel.BackgroundTransparency=1; FlyPanel.Visible=false; FlyPanel.ZIndex=150; FlyPanel.Parent=ScreenGui
local function makeMobileBtn(txt,xPos,onDown,onUp)
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,52,0,52); b.Position=UDim2.new(0,xPos,0,2)
    b.BackgroundColor3=C.AccentGlow; b.BorderSizePixel=0; b.Text=txt; b.TextColor3=C.Accent
    b.TextSize=24; b.Font=Enum.Font.GothamBold; b.ZIndex=151; b.Parent=FlyPanel
    corner(b,UDim.new(0,12)); mkStroke(b,C.AccentDim,1.5)
    b.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            tw(b,{BackgroundColor3=C.Accent},0.08); onDown()
        end
    end)
    b.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            tw(b,{BackgroundColor3=C.AccentGlow},0.1); onUp()
        end
    end)
end
makeMobileBtn("▲",0,  function() flyUp=true  end, function() flyUp=false  end)
makeMobileBtn("▼",62, function() flyDown=true end, function() flyDown=false end)

-- Player tab content
sectionLbl(playerPage,"MOVEMENT",1)
local _,spTogTrack,spTogKnob,spTogHit,spTogStr=toggleRow(playerPage,"Custom Speed","Off: mirrors game HUD speed  |  On: slider controls speed",2)
spTogHit.MouseButton1Click:Connect(function()
    speedOverride=not speedOverride
    if speedOverride then
        tw(spTogTrack,{BackgroundColor3=C.AccentDim},0.2); tw(spTogKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back)
        spTogStr.Color=C.Accent; stopSpeedSync(); local h=getHum(); if h then h.WalkSpeed=sliderSpeed end
    else
        tw(spTogTrack,{BackgroundColor3=C.Off},0.2); tw(spTogKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back)
        spTogStr.Color=C.Border; startSpeedSync()
    end
end)
makeSlider(playerPage,"Walk Speed",16,1000,16,3,function(v) applySpeed(v) end)

local _,jpTogTrack,jpTogKnob,jpTogHit,jpTogStr=toggleRow(playerPage,"Custom Jump","Off: mirrors game HUD jump  |  On: slider controls jump",4)
jpTogHit.MouseButton1Click:Connect(function()
    jumpOverride=not jumpOverride
    if jumpOverride then
        tw(jpTogTrack,{BackgroundColor3=C.AccentDim},0.2); tw(jpTogKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back)
        jpTogStr.Color=C.Accent; stopJumpSync(); local h=getHum(); if h then h.JumpPower=sliderJump end
    else
        tw(jpTogTrack,{BackgroundColor3=C.Off},0.2); tw(jpTogKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back)
        jpTogStr.Color=C.Border; startJumpSync()
    end
end)
makeSlider(playerPage,"Jump Power",30,150,50,5,function(v) applyJump(v) end)

sectionLbl(playerPage,"FLY",6)
local _,flyTrack,flyKnob,flyHit,flyStr=toggleRow(playerPage,"Fly Mode","Directional: fly faces where camera looks",7)
flyHit.MouseButton1Click:Connect(function()
    flyEnabled=not flyEnabled
    if flyEnabled then
        tw(flyTrack,{BackgroundColor3=C.AccentDim},0.2); tw(flyKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back)
        flyStr.Color=C.Accent; FlyPanel.Visible=true; enableFly()
    else
        tw(flyTrack,{BackgroundColor3=C.Off},0.2); tw(flyKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back)
        flyStr.Color=C.Border; FlyPanel.Visible=false; flyUp=false; flyDown=false; disableFly()
    end
end)

sectionLbl(playerPage,"FLING",8)
local _,flgTrack,flgKnob,flgHit,flgStr=toggleRow(playerPage,"Fling Mode","Spins you at insane speed — touch a player to send them flying",9)
flgHit.MouseButton1Click:Connect(function()
    flingEnabled=not flingEnabled
    if flingEnabled then
        tw(flgTrack,{BackgroundColor3=C.AccentDim},0.2); tw(flgKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back)
        flgStr.Color=C.Accent; enableFling()
    else
        tw(flgTrack,{BackgroundColor3=C.Off},0.2); tw(flgKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back)
        flgStr.Color=C.Border; disableFling()
    end
end)

sectionLbl(playerPage,"GODMODE",10)
local _,gmTrack,gmKnob,gmHit,gmStr=toggleRow(playerPage,"God Mode","Disables all lava Parts client-side via CanTouch",11)
gmHit.MouseButton1Click:Connect(function()
    godmodeOn=not godmodeOn
    if godmodeOn then
        tw(gmTrack,{BackgroundColor3=C.AccentDim},0.2); tw(gmKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back)
        gmStr.Color=C.Accent; enableGodmode()
    else
        tw(gmTrack,{BackgroundColor3=C.Off},0.2); tw(gmKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back)
        gmStr.Color=C.Border; disableGodmode()
    end
end)

sectionLbl(playerPage,"SPAWN TELEPORT",12)
local _,tpTrack,tpKnob,tpHit,tpStr=toggleRow(playerPage,"Teleport to Brainrot","Auto-teleport when a selected brainrot spawns",13)
tpHit.MouseButton1Click:Connect(function()
    teleportOnSpawn=not teleportOnSpawn
    if teleportOnSpawn then
        tw(tpTrack,{BackgroundColor3=C.AccentDim},0.2); tw(tpKnob,{Position=UDim2.new(0,22,0.5,-8),BackgroundColor3=C.Text},0.2,Enum.EasingStyle.Back)
        tpStr.Color=C.Accent
    else
        tw(tpTrack,{BackgroundColor3=C.Off},0.2); tw(tpKnob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=C.TextDim},0.2,Enum.EasingStyle.Back)
        tpStr.Color=C.Border
    end
end)

sectionLbl(playerPage,"ACTIONS",14)
makeActionBtn(playerPage,"🔄  Reset Character",C.Surface,15,function()
    local hum=getHum(); if hum then hum.Health=0 end
end)

-- ========================
-- MISC TAB
-- ========================
local miscPage=tabPages["Misc"]; local selectedBrainrots={}; local allBrainrots={}; local dropdownItems={}; local dropOpen=false
sectionLbl(miscPage,"BRAINROT MONITOR",1)
local DropBtn=Instance.new("TextButton"); DropBtn.Size=UDim2.new(1,0,0,40)
DropBtn.BackgroundColor3=C.Surface; DropBtn.BorderSizePixel=0; DropBtn.Text=""; DropBtn.LayoutOrder=2; DropBtn.ZIndex=12; DropBtn.Parent=miscPage
corner(DropBtn,UDim.new(0,10)); local dropBtnStr=mkStroke(DropBtn,C.Border,1)
local dbAcc=Instance.new("Frame"); dbAcc.Size=UDim2.new(0,3,0.55,0); dbAcc.Position=UDim2.new(0,0,0.225,0)
dbAcc.BackgroundColor3=C.Accent; dbAcc.BorderSizePixel=0; dbAcc.ZIndex=13; dbAcc.Parent=DropBtn; corner(dbAcc,UDim.new(0,3))
local DropBtnTxt=Instance.new("TextLabel"); DropBtnTxt.Size=UDim2.new(1,-42,1,0); DropBtnTxt.Position=UDim2.new(0,14,0,0)
DropBtnTxt.BackgroundTransparency=1; DropBtnTxt.Text="Select brainrots to monitor..."
DropBtnTxt.TextColor3=C.TextDim; DropBtnTxt.TextSize=12; DropBtnTxt.Font=Enum.Font.Gotham
DropBtnTxt.TextXAlignment=Enum.TextXAlignment.Left; DropBtnTxt.ZIndex=13; DropBtnTxt.Parent=DropBtn
local DropArrow=Instance.new("TextLabel"); DropArrow.Size=UDim2.new(0,28,1,0); DropArrow.Position=UDim2.new(1,-32,0,0)
DropArrow.BackgroundTransparency=1; DropArrow.Text="v"; DropArrow.TextColor3=C.Accent; DropArrow.TextSize=12
DropArrow.Font=Enum.Font.GothamBold; DropArrow.ZIndex=13; DropArrow.Parent=DropBtn

local DropPanel=Instance.new("Frame"); DropPanel.Size=UDim2.new(1,0,0,0)
DropPanel.BackgroundColor3=C.SurfaceB; DropPanel.BorderSizePixel=0; DropPanel.LayoutOrder=3
DropPanel.ClipsDescendants=true; DropPanel.ZIndex=12; DropPanel.Visible=false; DropPanel.Parent=miscPage
corner(DropPanel,UDim.new(0,10)); mkStroke(DropPanel,C.Border,1)
local panelLL=Instance.new("UIListLayout"); panelLL.SortOrder=Enum.SortOrder.LayoutOrder; panelLL.Parent=DropPanel
local SearchCont=Instance.new("Frame"); SearchCont.Size=UDim2.new(1,0,0,36)
SearchCont.BackgroundColor3=C.Surface; SearchCont.BorderSizePixel=0; SearchCont.LayoutOrder=0; SearchCont.ZIndex=14; SearchCont.Parent=DropPanel
local scp=Instance.new("UIPadding"); scp.PaddingLeft=UDim.new(0,8); scp.PaddingRight=UDim.new(0,8); scp.PaddingTop=UDim.new(0,6); scp.PaddingBottom=UDim.new(0,6); scp.Parent=SearchCont
local SearchBox=Instance.new("TextBox"); SearchBox.Size=UDim2.new(1,0,1,0)
SearchBox.BackgroundColor3=C.Bg; SearchBox.BorderSizePixel=0; SearchBox.PlaceholderText="Search brainrots..."
SearchBox.PlaceholderColor3=C.TextDim; SearchBox.Text=""; SearchBox.TextColor3=C.Text
SearchBox.TextSize=11; SearchBox.Font=Enum.Font.Gotham; SearchBox.TextXAlignment=Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus=false; SearchBox.ZIndex=15; SearchBox.Parent=SearchCont
corner(SearchBox,UDim.new(0,7)); mkStroke(SearchBox,C.Border,1)
local sbp2=Instance.new("UIPadding"); sbp2.PaddingLeft=UDim.new(0,8); sbp2.PaddingRight=UDim.new(0,8); sbp2.Parent=SearchBox
local SDivider=Instance.new("Frame"); SDivider.Size=UDim2.new(1,0,0,1)
SDivider.BackgroundColor3=C.Border; SDivider.BorderSizePixel=0; SDivider.LayoutOrder=1; SDivider.ZIndex=13; SDivider.Parent=DropPanel
local DropList=Instance.new("ScrollingFrame"); DropList.Size=UDim2.new(1,0,1,-37)
DropList.BackgroundTransparency=1; DropList.BorderSizePixel=0; DropList.LayoutOrder=2
DropList.ClipsDescendants=true; DropList.ScrollBarThickness=3; DropList.ScrollBarImageColor3=C.Accent
DropList.CanvasSize=UDim2.new(0,0,0,0); DropList.ZIndex=13; DropList.Parent=DropPanel
local dropLL=Instance.new("UIListLayout"); dropLL.SortOrder=Enum.SortOrder.LayoutOrder; dropLL.Padding=UDim.new(0,2); dropLL.Parent=DropList
local dlp=Instance.new("UIPadding"); dlp.PaddingTop=UDim.new(0,4); dlp.PaddingBottom=UDim.new(0,4); dlp.PaddingLeft=UDim.new(0,6); dlp.PaddingRight=UDim.new(0,6); dlp.Parent=DropList

local Sep=Instance.new("Frame"); Sep.Size=UDim2.new(1,0,0,1); Sep.BackgroundColor3=C.Border
Sep.BorderSizePixel=0; Sep.LayoutOrder=4; Sep.ZIndex=12; Sep.Parent=miscPage
sectionLbl(miscPage,"ACTIVE MONITORING",5)
local ActiveList=Instance.new("ScrollingFrame"); ActiveList.Size=UDim2.new(1,0,0,115)
ActiveList.BackgroundColor3=C.Surface; ActiveList.BorderSizePixel=0; ActiveList.LayoutOrder=6
ActiveList.ClipsDescendants=true; ActiveList.ScrollBarThickness=3; ActiveList.ScrollBarImageColor3=C.Accent
ActiveList.CanvasSize=UDim2.new(0,0,0,0); ActiveList.ZIndex=12; ActiveList.Parent=miscPage
corner(ActiveList,UDim.new(0,10)); mkStroke(ActiveList,C.Border,1)
local activeLL=Instance.new("UIListLayout"); activeLL.SortOrder=Enum.SortOrder.LayoutOrder; activeLL.Padding=UDim.new(0,4); activeLL.Parent=ActiveList
local alp=Instance.new("UIPadding"); alp.PaddingTop=UDim.new(0,8); alp.PaddingBottom=UDim.new(0,8); alp.PaddingLeft=UDim.new(0,10); alp.PaddingRight=UDim.new(0,10); alp.Parent=ActiveList
local EmptyLbl=Instance.new("TextLabel"); EmptyLbl.Size=UDim2.new(1,0,0,28)
EmptyLbl.BackgroundTransparency=1; EmptyLbl.Text="No brainrots selected..."
EmptyLbl.TextColor3=C.TextDim; EmptyLbl.TextSize=11; EmptyLbl.Font=Enum.Font.GothamMedium; EmptyLbl.ZIndex=13; EmptyLbl.Parent=ActiveList

local PopupFrame=Instance.new("Frame"); PopupFrame.Size=UDim2.new(0,330,0,62)
PopupFrame.Position=UDim2.new(0.5,-165,0,-100); PopupFrame.BackgroundColor3=C.Surface
PopupFrame.BorderSizePixel=0; PopupFrame.Visible=false; PopupFrame.ZIndex=200; PopupFrame.Parent=ScreenGui
corner(PopupFrame,UDim.new(0,14)); mkStroke(PopupFrame,C.Accent,1.5); glow(PopupFrame,C.Accent,0.72)
local PIBg=Instance.new("Frame"); PIBg.Size=UDim2.new(0,46,1,0); PIBg.BackgroundColor3=C.Accent
PIBg.BorderSizePixel=0; PIBg.ZIndex=201; PIBg.Parent=PopupFrame; corner(PIBg,UDim.new(0,14))
local piPatch=Instance.new("Frame"); piPatch.Size=UDim2.new(0.5,0,1,0); piPatch.Position=UDim2.new(0.5,0,0,0)
piPatch.BackgroundColor3=C.Accent; piPatch.BorderSizePixel=0; piPatch.ZIndex=201; piPatch.Parent=PIBg
logoImage(PIBg,UDim2.new(0,30,0,30),202,UDim2.new(0.5,-15,0.5,-15))
local PopTop=Instance.new("TextLabel"); PopTop.Size=UDim2.new(1,-58,0,26); PopTop.Position=UDim2.new(0,54,0,8)
PopTop.BackgroundTransparency=1; PopTop.Text="! BRAINROT SPAWNED"; PopTop.TextColor3=C.Accent
PopTop.TextSize=10; PopTop.Font=Enum.Font.GothamBold; PopTop.TextXAlignment=Enum.TextXAlignment.Left; PopTop.ZIndex=201; PopTop.Parent=PopupFrame
local PopBot=Instance.new("TextLabel"); PopBot.Size=UDim2.new(1,-58,0,22); PopBot.Position=UDim2.new(0,54,0,32)
PopBot.BackgroundTransparency=1; PopBot.Text=""; PopBot.TextColor3=C.Text
PopBot.TextSize=13; PopBot.Font=Enum.Font.GothamBold; PopBot.TextXAlignment=Enum.TextXAlignment.Left; PopBot.ZIndex=201; PopBot.Parent=PopupFrame

local guiOpen=true; local popupQ={}; local popShowing=false; local monConns={}

local function teleportToModel(model)
    if not model or not model.Parent then return end
    local hrp=getHRP(); if not hrp then return end
    local ok,cf=pcall(function() return model:GetPivot() end)
    if ok and cf then hrp.CFrame=cf*CFrame.new(0,5,0) end
end

local function updateActiveList()
    for _,ch in pairs(ActiveList:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    EmptyLbl.Visible=#selectedBrainrots==0
    for i,name in ipairs(selectedBrainrots) do
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,28); row.BackgroundColor3=C.SurfaceC
        row.BorderSizePixel=0; row.LayoutOrder=i; row.ZIndex=13; row.Parent=ActiveList; corner(row,UDim.new(0,7))
        local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,7,0,7); dot.Position=UDim2.new(0,9,0.5,-3.5)
        dot.BackgroundColor3=C.Accent; dot.BorderSizePixel=0; dot.ZIndex=14; dot.Parent=row; corner(dot,UDim.new(1,0))
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-26,1,0); lbl.Position=UDim2.new(0,22,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=name; lbl.TextColor3=C.Text; lbl.TextSize=11
        lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=14; lbl.Parent=row
    end
    ActiveList.CanvasSize=UDim2.new(0,0,0,activeLL.AbsoluteContentSize.Y+16)
end

local function processPopupQ()
    if popShowing or #popupQ==0 then return end; popShowing=true
    local entry=table.remove(popupQ,1); PopBot.Text=entry.name.." Has Spawned!"
    PopupFrame.Position=UDim2.new(0.5,-165,0,-100); PopupFrame.Visible=true
    tw(PopupFrame,{Position=UDim2.new(0.5,-165,0,16)},0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.wait(3.2)
    tw(PopupFrame,{Position=UDim2.new(0.5,-165,0,-100)},0.32,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
    task.wait(0.35); PopupFrame.Visible=false; popShowing=false; processPopupQ()
end

local function triggerAlert(modelName,model)
    if #selectedBrainrots==0 then return end
    applyHighlight(model)
    if teleportOnSpawn then task.spawn(function() task.wait(0.15); teleportToModel(model) end) end
    table.insert(popupQ,{name=modelName,model=model}); task.spawn(processPopupQ)
end

local function deepSearch(parent,results)
    results=results or {}
    for _,child in pairs(parent:GetChildren()) do
        if child:IsA("Model") then table.insert(results,child.Name)
        elseif child:IsA("Folder") then deepSearch(child,results) end
    end
    return results
end

local function filterDropdown(q)
    q=q:lower()
    for _,item in pairs(dropdownItems) do
        local lbl=item:FindFirstChildWhichIsA("TextLabel")
        if lbl then item.Visible=q=="" or (lbl.Text:lower():find(q,1,true)~=nil) end
    end
    DropList.CanvasSize=UDim2.new(0,0,0,dropLL.AbsoluteContentSize.Y+16)
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() filterDropdown(SearchBox.Text) end)

local function loadBrainrots()
    local folder=ReplicatedStorage:FindFirstChild("Brainrots")
    if not folder then warn("[ProjectCrafted] ReplicatedStorage.Brainrots not found"); return end
    local raw=deepSearch(folder); local seen,unique={},{}
    for _,n in ipairs(raw) do if not seen[n] then seen[n]=true; table.insert(unique,n) end end
    table.sort(unique,function(a,b) return a:lower()<b:lower() end)
    allBrainrots=unique
    for _,it in pairs(dropdownItems) do it:Destroy() end; dropdownItems={}
    for i,name in ipairs(allBrainrots) do
        local item=Instance.new("TextButton"); item.Size=UDim2.new(1,0,0,32)
        item.BackgroundColor3=C.Surface; item.BorderSizePixel=0; item.Text=""; item.LayoutOrder=i; item.ZIndex=15; item.Parent=DropList
        table.insert(dropdownItems,item); corner(item,UDim.new(0,7))
        local cbox=Instance.new("Frame"); cbox.Size=UDim2.new(0,15,0,15); cbox.Position=UDim2.new(0,9,0.5,-7.5)
        cbox.BackgroundColor3=C.Bg; cbox.BorderSizePixel=0; cbox.ZIndex=16; cbox.Parent=item; corner(cbox,UDim.new(0,4))
        local cStr=mkStroke(cbox,C.Border,1.5)
        local cFill=Instance.new("Frame"); cFill.Size=UDim2.new(0,7,0,7); cFill.Position=UDim2.new(0.5,-3.5,0.5,-3.5)
        cFill.BackgroundColor3=C.Text; cFill.BorderSizePixel=0; cFill.Visible=false; cFill.ZIndex=17; cFill.Parent=cbox; corner(cFill,UDim.new(0,2))
        local iLbl=Instance.new("TextLabel"); iLbl.Size=UDim2.new(1,-34,1,0); iLbl.Position=UDim2.new(0,30,0,0)
        iLbl.BackgroundTransparency=1; iLbl.Text=name; iLbl.TextColor3=C.Text; iLbl.TextSize=12
        iLbl.Font=Enum.Font.Gotham; iLbl.TextXAlignment=Enum.TextXAlignment.Left; iLbl.ZIndex=16; iLbl.Parent=item
        local iSel=false
        item.MouseButton1Click:Connect(function()
            iSel=not iSel
            if iSel then
                table.insert(selectedBrainrots,name); cFill.Visible=true; cbox.BackgroundColor3=C.Accent; cStr.Color=C.Accent; tw(item,{BackgroundColor3=C.AccentDeep},0.15)
            else
                for j,n in ipairs(selectedBrainrots) do if n==name then table.remove(selectedBrainrots,j); break end end
                cFill.Visible=false; cbox.BackgroundColor3=C.Bg; cStr.Color=C.Border; tw(item,{BackgroundColor3=C.Surface},0.15)
            end
            local cnt=#selectedBrainrots
            DropBtnTxt.Text=cnt==0 and "Select brainrots to monitor..." or (cnt.." brainrot"..(cnt>1 and "s" or "").." selected")
            DropBtnTxt.TextColor3=cnt==0 and C.TextDim or C.Text; updateActiveList()
        end)
        item.MouseEnter:Connect(function() if not iSel then tw(item,{BackgroundColor3=C.SurfaceC},0.1) end end)
        item.MouseLeave:Connect(function() if not iSel then tw(item,{BackgroundColor3=C.Surface},0.1)  end end)
    end
    dropLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropList.CanvasSize=UDim2.new(0,0,0,dropLL.AbsoluteContentSize.Y+16)
        if dropOpen then DropPanel.Size=UDim2.new(1,0,0,math.min(dropLL.AbsoluteContentSize.Y+16+37,210)) end
    end)
end

local function monitorGameFolder()
    for _,c in pairs(monConns) do c:Disconnect() end; monConns={}
    local gf=workspace:FindFirstChild("GameFolder"); if not gf then return end
    local bf=gf:FindFirstChild("Brainrots"); if not bf then return end
    local function watchFolder(folder)
        table.insert(monConns,folder.ChildAdded:Connect(function(child)
            if not child:IsA("Model") then return end
            for _,sel in ipairs(selectedBrainrots) do if child.Name==sel then triggerAlert(child.Name,child); break end end
        end))
    end
    table.insert(monConns,bf.ChildAdded:Connect(function(child) if child:IsA("Folder") then watchFolder(child) end end))
    for _,ch in pairs(bf:GetChildren()) do if ch:IsA("Folder") then watchFolder(ch) end end
end

DropBtn.MouseButton1Click:Connect(function()
    dropOpen=not dropOpen
    if dropOpen then
        SearchBox.Text=""; filterDropdown(""); DropPanel.Visible=true; DropPanel.Size=UDim2.new(1,0,0,0)
        local h=math.min(dropLL.AbsoluteContentSize.Y+16+37,210)
        tw(DropPanel,{Size=UDim2.new(1,0,0,h)},0.3,Enum.EasingStyle.Back); tw(DropArrow,{Rotation=180},0.25); dropBtnStr.Color=C.Accent
    else
        tw(DropPanel,{Size=UDim2.new(1,0,0,0)},0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        tw(DropArrow,{Rotation=0},0.22); dropBtnStr.Color=C.Border; task.delay(0.23,function() DropPanel.Visible=false end)
    end
end)

local function setOpen(open)
    guiOpen=open
    if open then
        Main.Visible=true; Main.Size=UDim2.new(0,0,0,0); Main.Position=UDim2.new(0.5,0,0.5,0)
        tw(Main,{Size=UDim2.new(0,MAIN_W,0,MAIN_H),Position=UDim2.new(0.5,-MAIN_W/2,0.5,-MAIN_H/2)},0.38,Enum.EasingStyle.Back)
    else
        tw(Main,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        task.delay(0.3,function() Main.Visible=false end)
    end
end

TogglePill.MouseButton1Click:Connect(function()
    setOpen(not guiOpen); tw(TogglePill,{BackgroundColor3=C.AccentDim},0.1)
    task.delay(0.15,function() tw(TogglePill,{BackgroundColor3=C.Accent},0.2) end)
end)
CloseBtn.MouseButton1Click:Connect(function() setOpen(false) end)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn,{BackgroundColor3=Color3.fromRGB(240,70,70)},0.15) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn,{BackgroundColor3=C.Close},0.15) end)

local dragging,dragStart,startPos=false,nil,nil
Header.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=inp.Position; startPos=Main.Position
    end
end)
Header.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local d=inp.Position-dragStart; local s=uiScale.Scale
        Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X/s,startPos.Y.Scale,startPos.Y.Offset+d.Y/s)
    end
end)

switchTab("Home")
task.spawn(function()
    loadBrainrots(); updateActiveList(); monitorGameFolder()
    task.wait(1)
    if not speedOverride then startSpeedSync() end
    if not jumpOverride  then startJumpSync()  end
end)

print("[ProjectCrafted] Loaded successfully!")