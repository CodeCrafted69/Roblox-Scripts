-- ============================================================
-- PROJECT CRAFTED V2
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- GAME CHECK
-- ============================================================
if game.PlaceId ~= 119987266683883 then
    local sGui = Instance.new("ScreenGui")
    sGui.Name = "PCUnsupported"
    sGui.IgnoreGuiInset = true
    sGui.ResetOnSpawn = false
    pcall(function() sGui.Parent = CoreGui end)
    local f = Instance.new("Frame", sGui)
    f.Size = UDim2.new(0.5, 0, 0.12, 0)
    f.Position = UDim2.new(0.25, 0, -0.15, 0)
    f.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    f.BorderSizePixel = 0
    local c = Instance.new("UICorner", f); c.CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(220, 50, 50); s.Thickness = 2
    local gn = "This Game"
    pcall(function() gn = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -20, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = gn .. " Is Not Supported!"
    lbl.TextColor3 = Color3.fromRGB(255, 80, 80); lbl.Font = Enum.Font.GothamBold; lbl.TextScaled = true
    TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.25, 0, 0.44, 0)}):Play()
    task.delay(3.5, function()
        TweenService:Create(f, TweenInfo.new(0.35), {Position = UDim2.new(0.25, 0, -0.15, 0)}):Play()
        task.delay(0.35, function() sGui:Destroy() end)
    end)
    return
end

-- ============================================================
-- CONFIG SYSTEM
-- ============================================================
pcall(function()
    if not isfolder("ProjectCrafted") then makefolder("ProjectCrafted") end
    if not isfolder("ProjectCrafted/configs") then makefolder("ProjectCrafted/configs") end
end)

local function saveCfg(k, v)
    pcall(function() if writefile then writefile("ProjectCrafted/configs/"..k..".txt", tostring(v)) end end)
end
local function loadCfg(k, d)
    local r = d
    pcall(function()
        if readfile and isfile and isfile("ProjectCrafted/configs/"..k..".txt") then
            r = readfile("ProjectCrafted/configs/"..k..".txt")
        end
    end)
    return r
end

local execCount = (tonumber(loadCfg("execCount","0")) or 0) + 1
saveCfg("execCount", execCount)
local execStart = os.time()

-- ============================================================
-- THEMES
-- ============================================================
local Themes = {
    Original = {
        BG  = Color3.fromRGB(11,18,11),  BG2 = Color3.fromRGB(18,32,18),  BG3 = Color3.fromRGB(26,45,26),
        Acc = Color3.fromRGB(0,210,90),  Acc2= Color3.fromRGB(0,145,58),
        Txt = Color3.fromRGB(215,255,215),TxtD= Color3.fromRGB(130,175,130),
        TOn = Color3.fromRGB(0,210,90),  TOff= Color3.fromRGB(42,62,42),
        TbOn= Color3.fromRGB(0,210,90),  TbOf= Color3.fromRGB(22,40,22),
        Strk= Color3.fromRGB(0,175,65),  Btn = Color3.fromRGB(0,160,60),   BtnT= Color3.fromRGB(255,255,255),
    },
    Sky = {
        BG  = Color3.fromRGB(8,16,28),   BG2 = Color3.fromRGB(13,26,48),  BG3 = Color3.fromRGB(20,38,68),
        Acc = Color3.fromRGB(0,185,255), Acc2= Color3.fromRGB(0,125,210),
        Txt = Color3.fromRGB(205,232,255),TxtD= Color3.fromRGB(120,165,208),
        TOn = Color3.fromRGB(0,185,255), TOff= Color3.fromRGB(25,50,78),
        TbOn= Color3.fromRGB(0,185,255), TbOf= Color3.fromRGB(15,30,58),
        Strk= Color3.fromRGB(0,155,225), Btn = Color3.fromRGB(0,140,220),  BtnT= Color3.fromRGB(255,255,255),
    },
    Lava = {
        BG  = Color3.fromRGB(22,8,4),    BG2 = Color3.fromRGB(36,13,6),   BG3 = Color3.fromRGB(52,20,8),
        Acc = Color3.fromRGB(255,95,25), Acc2= Color3.fromRGB(195,55,8),
        Txt = Color3.fromRGB(255,218,195),TxtD= Color3.fromRGB(195,145,115),
        TOn = Color3.fromRGB(255,95,25), TOff= Color3.fromRGB(65,28,12),
        TbOn= Color3.fromRGB(255,95,25), TbOf= Color3.fromRGB(42,15,8),
        Strk= Color3.fromRGB(220,75,18), Btn = Color3.fromRGB(200,65,12),  BtnT= Color3.fromRGB(255,255,255),
    },
}

local curThemeName = loadCfg("theme","Original")
if not Themes[curThemeName] then curThemeName = "Original" end
local customTheme = nil

local function T()
    if curThemeName == "Custom" and customTheme then return customTheme end
    return Themes[curThemeName] or Themes.Original
end

-- ============================================================
-- STATE
-- ============================================================
local isOpen       = true
local activeTab    = ""
local warnAccepted = false

local speedOn, jumpOn, godOn, flyOn, tpOn, hlBrainOn, hlPlayOn, autoCollOn =
      false, false, false, false, false, false, false, false

local speedVal  = 16
local jumpVal   = 50
local selectedNames = {}
local allNames      = {}
local brainHL       = {}
local plrHLConns    = {}
local flyConn       = nil
local godCache      = {}
local autoCollTask  = nil

-- ============================================================
-- FORWARD DECLARATIONS
-- ============================================================
local updateSelDisplay
local startFlight, stopFlight
local startGodmode, stopGodmode
local startPlayerHL, stopPlayerHL
local startAutoCollect, stopAutoCollect
local addBrainHL

-- ============================================================
-- UTILITIES
-- ============================================================
local function mkCorner(p, r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 8); return c end
local function mkStroke(p,cl,th) local s=Instance.new("UIStroke",p); s.Color=cl or T().Strk; s.Thickness=th or 1.5; return s end
local function mkGrad(p,c0,c1,rot)
    local g=Instance.new("UIGradient",p)
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c0),ColorSequenceKeypoint.new(1,c1)})
    g.Rotation=rot or 90; return g
end
local function extractNum(s) return tonumber((s or ""):match("%-?%d+%.?%d*")) or 0 end

-- ============================================================
-- NOTIFICATION SYSTEM
-- ============================================================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "PCNotifs"; notifGui.ResetOnSpawn = false
notifGui.IgnoreGuiInset = true; notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() notifGui.Parent = CoreGui end)

local activeNotifs = {}

local function showNotif(txt, col)
    local t = T(); col = col or t.Acc
    local yOff = #activeNotifs * 0.09
    local f = Instance.new("Frame", notifGui)
    f.Size = UDim2.new(0.32, 0, 0.075, 0)
    f.Position = UDim2.new(0.34, 0, -0.12, 0)
    f.BackgroundColor3 = t.BG2; f.BorderSizePixel = 0; f.ZIndex = 200
    mkCorner(f, 10)
    local st = mkStroke(f, col, 2)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -12, 1, 0); l.Position = UDim2.new(0, 6, 0, 0)
    l.BackgroundTransparency = 1; l.Text = txt
    l.TextColor3 = t.Txt; l.Font = Enum.Font.GothamBold; l.TextScaled = true; l.ZIndex = 201
    table.insert(activeNotifs, f)
    local ty = 0.04 + yOff
    TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.34, 0, ty, 0)}):Play()
    task.delay(3, function()
        TweenService:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(0.34, 0, -0.12, 0)}):Play()
        task.delay(0.3, function()
            local idx = table.find(activeNotifs, f)
            if idx then table.remove(activeNotifs, idx) end
            pcall(function() f:Destroy() end)
        end)
    end)
end

local function showSpawnNotif(name)
    local t = T()
    local ng = Instance.new("ScreenGui")
    ng.Name = "PCSpawn_"..name; ng.IgnoreGuiInset = true
    ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; ng.ResetOnSpawn = false
    pcall(function() ng.Parent = CoreGui end)
    local f = Instance.new("Frame", ng)
    f.Size = UDim2.new(0.38, 0, 0.09, 0)
    f.Position = UDim2.new(0.31, 0, -0.13, 0)
    f.BackgroundColor3 = t.BG2; f.BorderSizePixel = 0; f.ZIndex = 300
    mkCorner(f, 12); mkStroke(f, t.Acc, 2.5)
    mkGrad(f, t.BG2, t.BG3, 90)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -16, 1, 0); l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1; l.Text = "A "..name.." Has Spawned!"
    l.TextColor3 = t.Txt; l.Font = Enum.Font.GothamBold; l.TextScaled = true; l.ZIndex = 301
    TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.31, 0, 0.02, 0)}):Play()
    task.delay(4, function()
        TweenService:Create(f, TweenInfo.new(0.35), {Position = UDim2.new(0.31, 0, -0.13, 0)}):Play()
        task.delay(0.35, function() pcall(function() ng:Destroy() end) end)
    end)
end

-- ============================================================
-- FEATURE IMPLEMENTATIONS
-- ============================================================
startFlight = function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    pcall(function() hum.PlatformStand = true end)
    if flyConn then flyConn:Disconnect() end
    flyConn = RunService.Heartbeat:Connect(function()
        if not flyOn then return end
        local c = LocalPlayer.Character; if not c then return end
        local h = c:FindFirstChild("Humanoid"); local r = c:FindFirstChild("HumanoidRootPart")
        if not h or not r then return end
        local camCF = Camera.CFrame
        local lv = camCF.LookVector; local rv = camCF.RightVector
        local md = h.MoveDirection; local spd = 55
        local vel = Vector3.zero
        if md.Magnitude > 0.05 then
            local fwd = Vector3.new(lv.X, 0, lv.Z)
            local rgt = Vector3.new(rv.X, 0, rv.Z)
            if fwd.Magnitude > 0.01 then fwd = fwd.Unit end
            if rgt.Magnitude > 0.01 then rgt = rgt.Unit end
            vel = (-fwd * md.Z + rgt * md.X) * spd
        end
        vel = vel + Vector3.new(0, lv.Y * spd, 0)
        pcall(function() r.AssemblyLinearVelocity = vel end)
        if vel.Magnitude > 2 then
            pcall(function() r.CFrame = CFrame.new(r.Position, r.Position + Vector3.new(lv.X, lv.Y, lv.Z)) end)
        end
    end)
end

stopFlight = function()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChild("Humanoid")
        local r = c:FindFirstChild("HumanoidRootPart")
        pcall(function() if h then h.PlatformStand = false end end)
        pcall(function() if r then r.AssemblyLinearVelocity = Vector3.zero end end)
    end
end

startGodmode = function()
    local gf = workspace:FindFirstChild("GameFolder")
    local lf = gf and gf:FindFirstChild("Lavas")
    if not lf then return end
    for _, p in ipairs(lf:GetDescendants()) do
        if p:IsA("BasePart") then
            godCache[p] = p.CanTouch
            pcall(function() p.CanTouch = false end)
        end
    end
end

stopGodmode = function()
    for p, v in pairs(godCache) do
        pcall(function() if p and p.Parent then p.CanTouch = v end end)
    end
    godCache = {}
end

addBrainHL = function(model)
    if brainHL[model] then return end
    local h = Instance.new("SelectionBox")
    h.Adornee = model; h.Color3 = T().Acc
    h.LineThickness = 0.04; h.SurfaceTransparency = 0.85; h.SurfaceColor3 = T().Acc
    pcall(function() h.Parent = CoreGui end)
    brainHL[model] = h
    local conn; conn = model.AncestryChanged:Connect(function()
        if not model:IsDescendantOf(workspace) then
            pcall(function() h:Destroy() end)
            brainHL[model] = nil; conn:Disconnect()
        end
    end)
end

startPlayerHL = function()
    local function doPlayer(plr)
        if plr == LocalPlayer then return end
        task.spawn(function()
            local char = plr.Character or plr.CharacterAdded:Wait()
            if not char then return end
            if not char:FindFirstChild("PCHighlight") then
                local hl = Instance.new("Highlight", char)
                hl.Name = "PCHighlight"; hl.FillColor = Color3.fromRGB(255,200,0)
                hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.5
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp:FindFirstChild("PCBillboard") then
                local bb = Instance.new("BillboardGui", hrp)
                bb.Name = "PCBillboard"; bb.Size = UDim2.new(0, 140, 0, 44)
                bb.StudsOffset = Vector3.new(0, 3.5, 0); bb.AlwaysOnTop = true
                local nm = Instance.new("TextLabel", bb)
                nm.Size = UDim2.new(1, 0, 0.52, 0); nm.BackgroundTransparency = 1
                nm.Text = plr.DisplayName; nm.TextColor3 = Color3.fromRGB(255,255,255)
                nm.Font = Enum.Font.GothamBold; nm.TextScaled = true; nm.TextStrokeTransparency = 0
                local dl = Instance.new("TextLabel", bb)
                dl.Size = UDim2.new(1, 0, 0.48, 0); dl.Position = UDim2.new(0, 0, 0.52, 0)
                dl.BackgroundTransparency = 1; dl.Text = "? studs"
                dl.TextColor3 = Color3.fromRGB(200,225,255); dl.Font = Enum.Font.Gotham
                dl.TextScaled = true; dl.TextStrokeTransparency = 0
                local cn = RunService.Heartbeat:Connect(function()
                    if not hlPlayOn then return end
                    local lc = LocalPlayer.Character
                    if lc and lc:FindFirstChild("HumanoidRootPart") and hrp and hrp.Parent then
                        dl.Text = math.floor((hrp.Position - lc.HumanoidRootPart.Position).Magnitude) .. " studs"
                    end
                end)
                table.insert(plrHLConns, cn)
            end
        end)
    end
    for _, p in ipairs(Players:GetPlayers()) do doPlayer(p) end
local ca = Players.PlayerAdded:Connect(doPlayer)
table.insert(plrHLConns, ca)
local cb = Players.PlayerRemoving:Connect(function(plr)
local char = plr.Character
if char then
local hl = char:FindFirstChild("PCHighlight")
local bb = char:FindFirstChildOfClass("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("PCBillboard")
pcall(function() if hl then hl:Destroy() end end)
pcall(function() if bb then bb:Destroy() end end)
end
end)
table.insert(plrHLConns, cb)
end
stopPlayerHL = function()
for _, c in ipairs(plrHLConns) do pcall(function() c:Disconnect() end) end
plrHLConns = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local hl = p.Character:FindFirstChild("PCHighlight")
if hl then pcall(function() hl:Destroy() end) end
local hrp = p.Character:FindFirstChild("HumanoidRootPart")
if hrp then
local bb = hrp:FindFirstChild("PCBillboard")
if bb then pcall(function() bb:Destroy() end) end
end
end
end
end
startAutoCollect = function()
autoCollTask = task.spawn(function()
while autoCollOn do
local gf = workspace:FindFirstChild("GameFolder")
local plots = gf and gf:FindFirstChild("Plots")
if plots then
for _, desc in ipairs(plots:GetDescendants()) do
if desc:IsA("Attachment") and desc.Name == "YourBaseAtt" then
for _, tl in ipairs(desc:GetDescendants()) do
if tl:IsA("TextLabel") and tl.Name == "Title" and tl.Text == "YOUR BASE" then
local model = desc:FindFirstAncestorWhichIsA("Model")
if model then
local places = model:FindFirstChild("Places", true)
if places then
for _, ti in ipairs(places:GetDescendants()) do
if ti:IsA("TouchInterest") then
local part = ti.Parent
if part and part:IsA("BasePart") then
local lc = LocalPlayer.Character
local hrp = lc and lc:FindFirstChild("HumanoidRootPart")
if hrp then
pcall(function()
firetouchinterest(hrp, part, 0)
firetouchinterest(hrp, part, 1)
end)
end
end
end
end
end
end
break
end
end
end
end
end
task.wait(0.5)
end
end)
end
stopAutoCollect = function()
autoCollOn = false
if autoCollTask then task.cancel(autoCollTask); autoCollTask = nil end
end
-- ============================================================
-- BRAINROT MONITORING
-- ============================================================
local monitoredNames = {}
local monitorConns = {}
local function updateMonitoring()
for _, c in ipairs(monitorConns) do pcall(function() c:Disconnect() end) end
monitorConns = {}
monitoredNames = {}
for _, name in ipairs(selectedNames) do
if not monitoredNames[name] then
monitoredNames[name] = true
local gf = workspace:FindFirstChild("GameFolder")
local bf = gf and gf:FindFirstChild("Brainrots")
if bf then
local function checkModel(m)
if m:IsA("Model") and m.Name == name then
if hlBrainOn then addBrainHL(m) end
if tpOn then
local lc = LocalPlayer.Character
local cf = m:GetPivot()
if lc then
pcall(function()
lc:PivotTo(cf * CFrame.new(0, 4, 0))
end)
end
end
showSpawnNotif(name)
end
end
for _, ch in ipairs(bf:GetDescendants()) do checkModel(ch) end
local cn = bf.DescendantAdded:Connect(checkModel)
table.insert(monitorConns, cn)
end
end
end
end
-- ============================================================
-- MAIN GUI
-- ============================================================
local OldGui = CoreGui:FindFirstChild("ProjectCraftedV2")
if OldGui then OldGui:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProjectCraftedV2"; ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
local themeListeners = {}
local function onTheme(fn) table.insert(themeListeners, fn) end
local function applyTheme()
for _, fn in ipairs(themeListeners) do pcall(fn) end
for m, h in pairs(brainHL) do
if h and h.Parent then h.Color3 = T().Acc; h.SurfaceColor3 = T().Acc end
end
end
-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"; Main.Size = UDim2.new(0.55, 0, 0.7, 0)
Main.Position = UDim2.new(0.22, 0, 0.15, 0)
Main.BackgroundColor3 = T().BG; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
local mainCorner = mkCorner(Main, 14)
local mainStroke = mkStroke(Main, T().Strk, 2)
local mainGrad = mkGrad(Main, T().BG, T().BG2, 145)
onTheme(function() Main.BackgroundColor3 = T().BG; mainStroke.Color = T().Strk
mainGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,T().BG),ColorSequenceKeypoint.new(1,T().BG2)}) end)
-- DRAGGING
do
local dragging, dragStart, startPos = false, nil, nil
Main.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging = true; dragStart = i.Position; startPos = Main.Position
end
end)
Main.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
UserInputService.InputChanged:Connect(function(i)
if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
local d = i.Position - dragStart
Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end
end)
end
-- TOP BAR
local TopBar = Instance.new("Frame", Main)
TopBar.Name = "TopBar"; TopBar.Size = UDim2.new(1, 0, 0.09, 0)
TopBar.BackgroundColor3 = T().BG3; TopBar.BorderSizePixel = 0
mkCorner(TopBar, 14)
local topGrad = mkGrad(TopBar, T().BG3, T().BG2, 90)
onTheme(function() TopBar.BackgroundColor3 = T().BG3
topGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,T().BG3),ColorSequenceKeypoint.new(1,T().BG2)}) end)
-- Logo
local Logo = Instance.new("ImageLabel", TopBar)
Logo.Size = UDim2.new(0, 0, 0.8, 0); Logo.SizeConstraint = Enum.SizeConstraint.RelativeYY
Logo.Position = UDim2.new(0, 8, 0.1, 0); Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://85816937697749"
-- Title
local TitleLbl = Instance.new("TextLabel", TopBar)
TitleLbl.Size = UDim2.new(0.55, 0, 1, 0); TitleLbl.Position = UDim2.new(0.1, 0, 0, 0)
TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "Project Crafted V2"
TitleLbl.TextColor3 = T().Acc; TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextScaled = true; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
onTheme(function() TitleLbl.TextColor3 = T().Acc end)
-- Close button in topbar
local ClosBtn = Instance.new("TextButton", TopBar)
ClosBtn.Size = UDim2.new(0, 0, 0.7, 0); ClosBtn.SizeConstraint = Enum.SizeConstraint.RelativeYY
ClosBtn.Position = UDim2.new(1, -5, 0.15, 0); ClosBtn.AnchorPoint = Vector2.new(1, 0)
ClosBtn.BackgroundColor3 = Color3.fromRGB(200,55,55); ClosBtn.Text = "X"
ClosBtn.TextColor3 = Color3.fromRGB(255,255,255); ClosBtn.Font = Enum.Font.GothamBold; ClosBtn.TextScaled = true
mkCorner(ClosBtn, 6)
-- TAB BAR
local TabBar = Instance.new("Frame", Main)
TabBar.Name = "TabBar"; TabBar.Size = UDim2.new(1, 0, 0.08, 0)
TabBar.Position = UDim2.new(0, 0, 0.09, 0); TabBar.BackgroundColor3 = T().BG2; TabBar.BorderSizePixel = 0
local tabBarGrad = mkGrad(TabBar, T().BG2, T().BG3, 90)
onTheme(function() TabBar.BackgroundColor3 = T().BG2
tabBarGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,T().BG2),ColorSequenceKeypoint.new(1,T().BG3)}) end)
local tabList = Instance.new("UIListLayout", TabBar)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.VerticalAlignment = Enum.VerticalAlignment.Center
tabList.Padding = UDim.new(0.005, 0)
-- CONTENT AREA
local ContentArea = Instance.new("Frame", Main)
ContentArea.Name = "Content"; ContentArea.Size = UDim2.new(1, 0, 0.83, 0)
ContentArea.Position = UDim2.new(0, 0, 0.17, 0); ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
local tabButtons = {}
local tabFrames  = {}
local function makeScrollFrame(parent)
local sf = Instance.new("ScrollingFrame", parent)
sf.Size = UDim2.new(1, 0, 1, 0); sf.Position = UDim2.new(0, 0, 0, 0)
sf.BackgroundTransparency = 1; sf.ScrollBarThickness = 4
sf.ScrollBarImageColor3 = T().Acc; sf.BorderSizePixel = 0
sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.CanvasSize = UDim2.new(0, 0, 0, 0)
sf.ClipsDescendants = true; sf.Visible = false
onTheme(function() sf.ScrollBarImageColor3 = T().Acc end)
local ul = Instance.new("UIListLayout", sf)
ul.FillDirection = Enum.FillDirection.Vertical
ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
ul.Padding = UDim.new(0, 6)
local up = Instance.new("UIPadding", sf)
up.PaddingTop = UDim.new(0, 8); up.PaddingBottom = UDim.new(0, 8)
up.PaddingLeft = UDim.new(0, 8); up.PaddingRight = UDim.new(0, 8)
return sf
end
local function makeTabBtn(name)
local btn = Instance.new("TextButton", TabBar)
btn.Size = UDim2.new(0.19, -4, 0.85, 0); btn.BackgroundColor3 = T().TbOf
btn.Text = name; btn.TextColor3 = T().TxtD; btn.Font = Enum.Font.GothamBold
btn.TextScaled = true; btn.BorderSizePixel = 0
mkCorner(btn, 6); mkStroke(btn, T().Strk, 1)
onTheme(function()
if activeTab == name then
btn.BackgroundColor3 = T().TbOn; btn.TextColor3 = T().BtnT
else
btn.BackgroundColor3 = T().TbOf; btn.TextColor3 = T().TxtD
end
end)
return btn
end
local TABS = {"Home","Main","Player","Visual","Settings"}
for _, name in ipairs(TABS) do
tabButtons[name] = makeTabBtn(name)
tabFrames[name]  = makeScrollFrame(ContentArea)
end
local function switchTab(name)
local prev = activeTab
if prev == name then return end
activeTab = name
for n, f in pairs(tabFrames) do
if n ~= name then
TweenService:Create(f, TweenInfo.new(0.15), {Position = UDim2.new(-1, 0, 0, 0)}):Play()
task.delay(0.15, function() f.Visible = false; f.Position = UDim2.new(0,0,0,0) end)
end
end
task.delay(0.1, function()
local f = tabFrames[name]; f.Visible = true
f.Position = UDim2.new(1, 0, 0, 0)
TweenService:Create(f, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)
for n, btn in pairs(tabButtons) do
if n == name then
TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T().TbOn, TextColor3 = T().BtnT}):Play()
else
TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T().TbOf, TextColor3 = T().TxtD}):Play()
end
end
end
for _, name in ipairs(TABS) do
tabButtons[name].MouseButton1Click:Connect(function() switchTab(name) end)
end
-- ============================================================
-- COMPONENT BUILDERS
-- ============================================================
local function makeSeparator(parent)
local l = Instance.new("Frame", parent)
l.Size = UDim2.new(0.95, 0, 0, 1); l.BackgroundColor3 = T().Strk; l.BorderSizePixel = 0
onTheme(function() l.BackgroundColor3 = T().Strk end)
return l
end
local function makeLabel(parent, text, size)
local l = Instance.new("TextLabel", parent)
l.Size = UDim2.new(1, 0, 0, size or 24); l.BackgroundTransparency = 1
l.Text = text; l.TextColor3 = T().Txt; l.Font = Enum.Font.Gotham
l.TextScaled = false; l.TextSize = size or 14; l.TextXAlignment = Enum.TextXAlignment.Left
onTheme(function() l.TextColor3 = T().Txt end)
return l
end
local function makeCard(parent, h)
local f = Instance.new("Frame", parent)
f.Size = UDim2.new(1, 0, 0, h or 42); f.BackgroundColor3 = T().BG3; f.BorderSizePixel = 0
mkCorner(f, 8); mkStroke(f, T().Strk, 1)
onTheme(function() f.BackgroundColor3 = T().BG3 end)
return f
end
local function makeToggle(parent, label, defaultOn, onChange)
local card = makeCard(parent, 42)
local lbl = Instance.new("TextLabel", card)
lbl.Size = UDim2.new(0.75, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
lbl.BackgroundTransparency = 1; lbl.Text = label
lbl.TextColor3 = T().Txt; lbl.Font = Enum.Font.GothamSemibold
lbl.TextScaled = false; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
onTheme(function() lbl.TextColor3 = T().Txt end)
local track = Instance.new("Frame", card)
track.Size = UDim2.new(0, 46, 0, 24); track.Position = UDim2.new(1, -56, 0.5, -12)
track.BorderSizePixel = 0
local state = defaultOn or false
track.BackgroundColor3 = state and T().TOn or T().TOff
mkCorner(track, 12); mkStroke(track, T().Strk, 1)
onTheme(function() track.BackgroundColor3 = state and T().TOn or T().TOff end)
local knob = Instance.new("Frame", track)
knob.Size = UDim2.new(0, 18, 0, 18); knob.Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.BorderSizePixel = 0; mkCorner(knob, 9)
local btn = Instance.new("TextButton", card)
btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 5
btn.MouseButton1Click:Connect(function()
state = not state
TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = state and T().TOn or T().TOff}):Play()
TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
if onChange then onChange(state) end
end)
local function setState(v)
state = v
TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = v and T().TOn or T().TOff}):Play()
TweenService:Create(knob, TweenInfo.new(0.2), {Position = v and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
end
return card, function() return state end, setState
end
local function makeSlider(parent, label, min_, max_, defaultVal, onChange)
local card = makeCard(parent, 60)
local top = Instance.new("Frame", card)
top.Size = UDim2.new(1, 0, 0.4, 0); top.BackgroundTransparency = 1
local lbl = Instance.new("TextLabel", top)
lbl.Size = UDim2.new(0.7, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
lbl.BackgroundTransparency = 1; lbl.Text = label
lbl.TextColor3 = T().Txt; lbl.Font = Enum.Font.GothamSemibold
lbl.TextScaled = false; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
onTheme(function() lbl.TextColor3 = T().Txt end)
local valLbl = Instance.new("TextLabel", top)
valLbl.Size = UDim2.new(0.25, 0, 1, 0); valLbl.Position = UDim2.new(0.73, 0, 0, 0)
valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(defaultVal or min_)
valLbl.TextColor3 = T().Acc; valLbl.Font = Enum.Font.GothamBold
valLbl.TextScaled = false; valLbl.TextSize = 12; valLbl.TextXAlignment = Enum.TextXAlignment.Right
onTheme(function() valLbl.TextColor3 = T().Acc end)
local track = Instance.new("Frame", card)
track.Size = UDim2.new(0.9, 0, 0, 6); track.Position = UDim2.new(0.05, 0, 0.72, 0)
track.BackgroundColor3 = T().BG2; track.BorderSizePixel = 0; mkCorner(track, 3)
onTheme(function() track.BackgroundColor3 = T().BG2 end)
local fill = Instance.new("Frame", track)
fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = T().Acc; fill.BorderSizePixel = 0; mkCorner(fill, 3)
onTheme(function() fill.BackgroundColor3 = T().Acc end)
local knob = Instance.new("Frame", fill)
knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = UDim2.new(1, -8, 0.5, -8)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.BorderSizePixel = 0; mkCorner(knob, 8); mkStroke(knob, T().Acc, 2)
onTheme(function() mkStroke(knob, T().Acc, 2) end)
local currentVal = defaultVal or min_
local function setVal(v)
v = math.clamp(v, min_, max_)
currentVal = v
local pct = (v - min_) / math.max(max_ - min_, 0.001)
TweenService:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
valLbl.Text = math.floor(v)
if onChange then onChange(v) end
end
setVal(currentVal)
local dragging = false
local function updateFromInput(i)
local absPosX = track.AbsolutePosition.X
local absSizeX = track.AbsoluteSize.X
local rel = math.clamp((i.Position.X - absPosX) / absSizeX, 0, 1)
setVal(min_ + rel * (max_ - min_))
end
track.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging = true; updateFromInput(i)
end
end)
UserInputService.InputChanged:Connect(function(i)
if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
updateFromInput(i)
end
end)
UserInputService.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
return card, function() return currentVal end, setVal, max_
end
-- ============================================================
-- HOME TAB
-- ============================================================
do
local sf = tabFrames["Home"]
-- Profile section
local profCard = makeCard(sf, 90)
local avatar = Instance.new("ImageLabel", profCard)
avatar.Size = UDim2.new(0, 72, 0, 72); avatar.Position = UDim2.new(0, 9, 0.5, -36)
avatar.BackgroundColor3 = T().BG2; avatar.BorderSizePixel = 0
mkCorner(avatar, 36)
pcall(function()
    local uid = LocalPlayer.UserId
    local thumb, _ = Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
    avatar.Image = thumb
end)
local infoF = Instance.new("Frame", profCard)
infoF.Size = UDim2.new(1, -90, 1, 0); infoF.Position = UDim2.new(0, 86, 0, 0)
infoF.BackgroundTransparency = 1
local uiLL = Instance.new("UIListLayout", infoF)
uiLL.Padding = UDim.new(0, 2); uiLL.VerticalAlignment = Enum.VerticalAlignment.Center
local function iLbl(txt)
    local l = Instance.new("TextLabel", infoF)
    l.Size = UDim2.new(1, 0, 0, 15); l.BackgroundTransparency = 1; l.Text = txt
    l.TextColor3 = T().Txt; l.Font = Enum.Font.Gotham; l.TextScaled = false
    l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    onTheme(function() l.TextColor3 = T().Txt end)
    return l
end
iLbl("Display: " .. LocalPlayer.DisplayName)
iLbl("Username: @" .. LocalPlayer.Name)
iLbl("User ID: " .. LocalPlayer.UserId)
iLbl("Acct Age: " .. LocalPlayer.AccountAge .. " days")

-- Stats
local gameName = "Unknown"
pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
local maxP = 10
pcall(function() maxP = Players.MaxPlayers end)
local curP = #Players:GetPlayers()
local servId = game.JobId

local function statCard(lbl, val)
    local c = makeCard(sf, 36)
    local ll = Instance.new("TextLabel", c)
    ll.Size = UDim2.new(0.48, 0, 1, 0); ll.Position = UDim2.new(0, 10, 0, 0)
    ll.BackgroundTransparency = 1; ll.Text = lbl
    ll.TextColor3 = T().TxtD; ll.Font = Enum.Font.GothamSemibold
    ll.TextScaled = false; ll.TextSize = 12; ll.TextXAlignment = Enum.TextXAlignment.Left
    onTheme(function() ll.TextColor3 = T().TxtD end)
    local vl = Instance.new("TextLabel", c)
    vl.Size = UDim2.new(0.5, -10, 1, 0); vl.Position = UDim2.new(0.5, 0, 0, 0)
    vl.BackgroundTransparency = 1; vl.Text = val
    vl.TextColor3 = T().Acc; vl.Font = Enum.Font.GothamBold
    vl.TextScaled = false; vl.TextSize = 12; vl.TextXAlignment = Enum.TextXAlignment.Right
    onTheme(function() vl.TextColor3 = T().Acc end)
    return c, vl
end

statCard("Game:", gameName)
statCard("Game ID:", tostring(game.PlaceId))
statCard("Players:", curP .. " / " .. maxP)
statCard("Server ID:", servId ~= "" and servId:sub(1,18).."..." or "Studio")
local _, uptimeLbl = statCard("Uptime:", "0s")
local _, execLbl = statCard("Times Executed:", tostring(execCount))
local _, activeLbl = statCard("Session Time:", "0s")

makeSeparator(sf)

RunService.Heartbeat:Connect(function()
    local up = math.floor(workspace.DistributedGameTime)
    local h2 = math.floor(up/3600); local m2 = math.floor((up%3600)/60); local s2 = up%60
    uptimeLbl.Text = (h2>0 and h2.."h " or "") .. (m2>0 and m2.."m " or "") .. s2 .. "s"
    local et = os.time() - execStart
    local eh = math.floor(et/3600); local em = math.floor((et%3600)/60); local es = et%60
    activeLbl.Text = (eh>0 and eh.."h " or "") .. (em>0 and em.."m " or "") .. es .. "s"
end)
end
-- ============================================================
-- MAIN TAB
-- ============================================================
do
local sf = tabFrames["Main"]
-- Load brainrot names
local function loadNames()
    allNames = {}
    local rs = game:GetService("ReplicatedStorage")
    local brainrots = rs:FindFirstChild("Brainrots")
    if not brainrots then return end
    for _, folder in ipairs(brainrots:GetChildren()) do
        if folder:IsA("Folder") then
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model") then
                    table.insert(allNames, model.Name)
                end
            end
        end
    end
    table.sort(allNames)
end
pcall(loadNames)

-- Search bar
local searchCard = makeCard(sf, 36)
local searchBox = Instance.new("TextBox", searchCard)
searchBox.Size = UDim2.new(1, -16, 0.8, 0); searchBox.Position = UDim2.new(0, 8, 0.1, 0)
searchBox.BackgroundTransparency = 1; searchBox.PlaceholderText = "Search brainrots..."
searchBox.Text = ""; searchBox.TextColor3 = T().Txt; searchBox.PlaceholderColor3 = T().TxtD
searchBox.Font = Enum.Font.Gotham; searchBox.TextScaled = false; searchBox.TextSize = 13
searchBox.TextXAlignment = Enum.TextXAlignment.Left; searchBox.ClearTextOnFocus = false
onTheme(function() searchBox.TextColor3 = T().Txt; searchBox.PlaceholderColor3 = T().TxtD end)

-- Dropdown list container
local dropCard = makeCard(sf, 180)
local dropScroll = Instance.new("ScrollingFrame", dropCard)
dropScroll.Size = UDim2.new(1, -4, 1, -4); dropScroll.Position = UDim2.new(0, 2, 0, 2)
dropScroll.BackgroundTransparency = 1; dropScroll.ScrollBarThickness = 4
dropScroll.ScrollBarImageColor3 = T().Acc; dropScroll.BorderSizePixel = 0
dropScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; dropScroll.CanvasSize = UDim2.new(0,0,0,0)
onTheme(function() dropScroll.ScrollBarImageColor3 = T().Acc end)
local dropList = Instance.new("UIListLayout", dropScroll)
dropList.Padding = UDim.new(0, 3); dropList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local dropPad = Instance.new("UIPadding", dropScroll)
dropPad.PaddingTop = UDim.new(0,4); dropPad.PaddingBottom = UDim.new(0,4)
dropPad.PaddingLeft = UDim.new(0,4); dropPad.PaddingRight = UDim.new(0,4)

local nameItems = {}

local function rebuildDropdown(filter)
    filter = (filter or ""):lower()
    for _, ch in ipairs(dropScroll:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end
    for _, name in ipairs(allNames) do
        if filter == "" or name:lower():find(filter, 1, true) then
            local btn = Instance.new("TextButton", dropScroll)
            btn.Size = UDim2.new(1, -8, 0, 28)
            local isSel = table.find(selectedNames, name) ~= nil
            btn.BackgroundColor3 = isSel and T().Acc or T().BG2
            btn.Text = name; btn.TextColor3 = isSel and T().BtnT or T().Txt
            btn.Font = Enum.Font.Gotham; btn.TextScaled = false; btn.TextSize = 12
            btn.BorderSizePixel = 0; mkCorner(btn, 5)
            onTheme(function()
                local s2 = table.find(selectedNames, name) ~= nil
                btn.BackgroundColor3 = s2 and T().Acc or T().BG2
                btn.TextColor3 = s2 and T().BtnT or T().Txt
            end)
            btn.MouseButton1Click:Connect(function()
                local idx = table.find(selectedNames, name)
                if idx then
                    table.remove(selectedNames, idx)
                else
                    table.insert(selectedNames, name)
                end
                rebuildDropdown(searchBox.Text)
                updateSelDisplay()
                updateMonitoring()
            end)
        end
    end
end
rebuildDropdown("")
searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildDropdown(searchBox.Text) end)

-- Selected display
local selCard = makeCard(sf, 70)
local selScroll = Instance.new("ScrollingFrame", selCard)
selScroll.Size = UDim2.new(1, -4, 1, -4); selScroll.Position = UDim2.new(0, 2, 0, 2)
selScroll.BackgroundTransparency = 1; selScroll.ScrollBarThickness = 4
selScroll.ScrollBarImageColor3 = T().Acc; selScroll.BorderSizePixel = 0
selScroll.ScrollingDirection = Enum.ScrollingDirection.X
selScroll.AutomaticCanvasSize = Enum.AutomaticSize.X; selScroll.CanvasSize = UDim2.new(0,0,0,0)
onTheme(function() selScroll.ScrollBarImageColor3 = T().Acc end)
local selList = Instance.new("UIListLayout", selScroll)
selList.FillDirection = Enum.FillDirection.Horizontal; selList.Padding = UDim.new(0, 5)
selList.VerticalAlignment = Enum.VerticalAlignment.Center
local selPad = Instance.new("UIPadding", selScroll)
selPad.PaddingLeft = UDim.new(0,4); selPad.PaddingRight = UDim.new(0,4)

updateSelDisplay = function()
    for _, ch in ipairs(selScroll:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    for _, name in ipairs(selectedNames) do
        local chip = Instance.new("Frame", selScroll)
        chip.Size = UDim2.new(0, name:len()*8+32, 0, 26)
        chip.BackgroundColor3 = T().Acc; chip.BorderSizePixel = 0; mkCorner(chip, 6)
        onTheme(function() chip.BackgroundColor3 = T().Acc end)
        local nl = Instance.new("TextLabel", chip)
        nl.Size = UDim2.new(1, -24, 1, 0); nl.Position = UDim2.new(0, 4, 0, 0)
        nl.BackgroundTransparency = 1; nl.Text = name; nl.TextColor3 = T().BtnT
        nl.Font = Enum.Font.Gotham; nl.TextScaled = false; nl.TextSize = 11; nl.TextXAlignment = Enum.TextXAlignment.Left
        onTheme(function() nl.TextColor3 = T().BtnT end)
        local xb = Instance.new("TextButton", chip)
        xb.Size = UDim2.new(0, 20, 0, 20); xb.Position = UDim2.new(1, -22, 0.5, -10)
        xb.BackgroundTransparency = 1; xb.Text = "X"; xb.TextColor3 = T().BtnT
        xb.Font = Enum.Font.GothamBold; xb.TextScaled = false; xb.TextSize = 10
        onTheme(function() xb.TextColor3 = T().BtnT end)
        xb.MouseButton1Click:Connect(function()
            local idx = table.find(selectedNames, name)
            if idx then table.remove(selectedNames, idx) end
            updateSelDisplay()
            rebuildDropdown(searchBox.Text)
            updateMonitoring()
        end)
    end
end

makeSeparator(sf)

-- Auto Collect toggle
local _, getAC, setAC = makeToggle(sf, "Auto Collect Cash", false, function(v)
    autoCollOn = v
    showNotif("Auto Collect Cash " .. (v and "Enabled!" or "Disabled!"))
    if v then startAutoCollect() else stopAutoCollect() end
end)
end
-- ============================================================
-- PLAYER TAB (with warning)
-- ============================================================
do
local sf = tabFrames["Player"]
-- Warning overlay
local warnOverlay = Instance.new("Frame", ContentArea)
warnOverlay.Name = "PlayerWarning"; warnOverlay.Size = UDim2.new(1, 0, 0.83, 0)
warnOverlay.Position = UDim2.new(0, 0, 0.17, 0); warnOverlay.ZIndex = 50
warnOverlay.BackgroundColor3 = T().BG; warnOverlay.BorderSizePixel = 0; warnOverlay.Visible = false
onTheme(function() warnOverlay.BackgroundColor3 = T().BG end)
local warnInner = Instance.new("Frame", warnOverlay)
warnInner.Size = UDim2.new(0.86, 0, 0.7, 0); warnInner.Position = UDim2.new(0.07, 0, 0.15, 0)
warnInner.BackgroundColor3 = T().BG3; warnInner.BorderSizePixel = 0; mkCorner(warnInner, 12)
mkStroke(warnInner, Color3.fromRGB(220,150,0), 2)
onTheme(function() warnInner.BackgroundColor3 = T().BG3 end)
local warnTxt = Instance.new("TextLabel", warnInner)
warnTxt.Size = UDim2.new(0.9, 0, 0.55, 0); warnTxt.Position = UDim2.new(0.05, 0, 0.05, 0)
warnTxt.BackgroundTransparency = 1
warnTxt.Text = "Warning: Using These Features Could Get You Banned, Use At Your Own Risk."
warnTxt.TextColor3 = Color3.fromRGB(255,200,0); warnTxt.Font = Enum.Font.GothamBold
warnTxt.TextScaled = true; warnTxt.TextWrapped = true; warnTxt.ZIndex = 51
local okBtn = Instance.new("TextButton", warnInner)
okBtn.Size = UDim2.new(0.38, 0, 0.2, 0); okBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
okBtn.BackgroundColor3 = Color3.fromRGB(0,180,70); okBtn.Text = "Ok"
okBtn.TextColor3 = Color3.fromRGB(255,255,255); okBtn.Font = Enum.Font.GothamBold
okBtn.TextScaled = true; okBtn.BorderSizePixel = 0; mkCorner(okBtn, 8); okBtn.ZIndex = 52
local backBtn = Instance.new("TextButton", warnInner)
backBtn.Size = UDim2.new(0.38, 0, 0.2, 0); backBtn.Position = UDim2.new(0.57, 0, 0.72, 0)
backBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); backBtn.Text = "Go Back"
backBtn.TextColor3 = Color3.fromRGB(255,255,255); backBtn.Font = Enum.Font.GothamBold
backBtn.TextScaled = true; backBtn.BorderSizePixel = 0; mkCorner(backBtn, 8); backBtn.ZIndex = 52

okBtn.MouseButton1Click:Connect(function()
    warnAccepted = true
    warnOverlay.Visible = false
end)
backBtn.MouseButton1Click:Connect(function()
    switchTab("Home")
end)

-- Speed
local speedCard, getSpd, setSpdSlider = makeSlider(sf, "Speed Value", 16, 500, 16, function(v)
    speedVal = v
end)

-- Max speed input
local maxSpdCard = makeCard(sf, 36)
local maxSpdLbl = Instance.new("TextLabel", maxSpdCard)
maxSpdLbl.Size = UDim2.new(0.5, 0, 1, 0); maxSpdLbl.Position = UDim2.new(0, 10, 0, 0)
maxSpdLbl.BackgroundTransparency = 1; maxSpdLbl.Text = "Speed Max:"
maxSpdLbl.TextColor3 = T().TxtD; maxSpdLbl.Font = Enum.Font.GothamSemibold
maxSpdLbl.TextScaled = false; maxSpdLbl.TextSize = 12; maxSpdLbl.TextXAlignment = Enum.TextXAlignment.Left
onTheme(function() maxSpdLbl.TextColor3 = T().TxtD end)
local maxSpdBox = Instance.new("TextBox", maxSpdCard)
maxSpdBox.Size = UDim2.new(0.35, 0, 0.7, 0); maxSpdBox.Position = UDim2.new(0.62, 0, 0.15, 0)
maxSpdBox.BackgroundColor3 = T().BG2; maxSpdBox.Text = "500"
maxSpdBox.TextColor3 = T().Txt; maxSpdBox.Font = Enum.Font.Gotham
maxSpdBox.TextScaled = false; maxSpdBox.TextSize = 12; maxSpdBox.BorderSizePixel = 0
mkCorner(maxSpdBox, 5); mkStroke(maxSpdBox, T().Strk, 1)
onTheme(function() maxSpdBox.BackgroundColor3 = T().BG2; maxSpdBox.TextColor3 = T().Txt end)

local _, getSpeedOn, setSpeedOn = makeToggle(sf, "Speed Boost", false, function(v)
    speedOn = v
    showNotif("Speed Boost " .. (v and "Enabled!" or "Disabled!"))
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    if v then
        hum.WalkSpeed = speedVal
    else
        local ok, txt = pcall(function()
            return LocalPlayer.PlayerGui:FindFirstChild("HUD") and
                   LocalPlayer.PlayerGui.HUD:FindFirstChild("Speed") and
                   LocalPlayer.PlayerGui.HUD.Speed.Text or "16"
        end)
        local n = extractNum(ok and txt or "16"); if n < 1 then n = 16 end
        hum.WalkSpeed = n
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    if speedOn then hum.WalkSpeed = speedVal end
    if jumpOn then hum.JumpPower = jumpVal end
    if godOn then stopGodmode(); task.delay(1, startGodmode) end
    if flyOn then task.delay(0.5, startFlight) end
end)

makeSeparator(sf)

-- Jump
local _, getJmpOn, setJmpOn = makeToggle(sf, "Jump Boost", false, function(v)
    jumpOn = v
    showNotif("Jump Boost " .. (v and "Enabled!" or "Disabled!"))
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    if v then
        hum.JumpPower = jumpVal
    else
        local ok, txt = pcall(function()
            return LocalPlayer.PlayerGui.HUD:FindFirstChild("Jump") and
                   LocalPlayer.PlayerGui.HUD.Jump.Text or "0"
        end)
        local jn = extractNum(ok and txt or "0")
        hum.JumpPower = 30 + jn * (10/3)
    end
end)
local jumpCard, getJmp, setJmpSlider = makeSlider(sf, "Jump Value", 30, 200, 50, function(v)
    jumpVal = v
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum and jumpOn then hum.JumpPower = v end
end)

makeSeparator(sf)

-- Godmode
local _, getGodOn, setGodOn = makeToggle(sf, "Godmode", false, function(v)
    godOn = v
    showNotif("Godmode " .. (v and "Enabled!" or "Disabled!"))
    if v then startGodmode() else stopGodmode() end
end)

makeSeparator(sf)

-- Flight
local _, getFlyOn, setFlyOn = makeToggle(sf, "Flight", false, function(v)
    flyOn = v
    showNotif("Flight " .. (v and "Enabled!" or "Disabled!"))
    if v then startFlight() else stopFlight() end
end)

makeSeparator(sf)

-- Teleport to brainrot
local _, getTpOn, setTpOn = makeToggle(sf, "Teleport to Brainrots", false, function(v)
    tpOn = v
    showNotif("Teleport to Brainrots " .. (v and "Enabled!" or "Disabled!"))
end)

-- Show warning when switching to Player tab
for n, btn in pairs(tabButtons) do
    if n == "Player" then
        btn.MouseButton1Click:Connect(function()
            if not warnAccepted then
                warnOverlay.Visible = true
            end
        end)
    end
end
end
-- ============================================================
-- VISUAL TAB
-- ============================================================
do
local sf = tabFrames["Visual"]
local _, getHLB, setHLB = makeToggle(sf, "Highlight Brainrots", false, function(v)
    hlBrainOn = v
    showNotif("Brainrot Highlight " .. (v and "Enabled!" or "Disabled!"))
    if not v then
        for m, h in pairs(brainHL) do
            pcall(function() h:Destroy() end)
        end
        brainHL = {}
    end
end)

makeSeparator(sf)

local _, getHLP, setHLP = makeToggle(sf, "Highlight Players", false, function(v)
    hlPlayOn = v
    showNotif("Player Highlight " .. (v and "Enabled!" or "Disabled!"))
    if v then startPlayerHL() else stopPlayerHL() end
end)
end
-- ============================================================
-- SETTINGS TAB
-- ============================================================
do
local sf = tabFrames["Settings"]
-- Theme dropdown (simple list)
local themeLbl = makeLabel(sf, "GUI Theme:", 14)
local themeNames = {"Original", "Sky", "Lava"}

local function makeThemeBtn(name)
    local btn = Instance.new("TextButton", sf)
    btn.Size = UDim2.new(1, 0, 0, 36); btn.BackgroundColor3 = T().BG3
    btn.Text = name .. (name == curThemeName and " (Active)" or "")
    btn.TextColor3 = name == curThemeName and T().Acc or T().Txt
    btn.Font = Enum.Font.GothamBold; btn.TextScaled = false; btn.TextSize = 13
    btn.BorderSizePixel = 0; mkCorner(btn, 8); mkStroke(btn, T().Strk, 1)
    onTheme(function()
        btn.BackgroundColor3 = T().BG3
        btn.Text = name .. (name == curThemeName and " (Active)" or "")
        btn.TextColor3 = name == curThemeName and T().Acc or T().Txt
    end)
    btn.MouseButton1Click:Connect(function()
        curThemeName = name; customTheme = nil
        saveCfg("theme", name)
        applyTheme()
    end)
    return btn
end

for _, tn in ipairs(themeNames) do makeThemeBtn(tn) end

makeSeparator(sf)

-- Custom theme prompt
local custLbl = makeLabel(sf, "Can't Find The Theme You Want?", 13)

local custBtn = Instance.new("TextButton", sf)
custBtn.Size = UDim2.new(1, 0, 0, 36); custBtn.BackgroundColor3 = T().Btn
custBtn.Text = "Customise the UI To Your Liking!"
custBtn.TextColor3 = Color3.fromRGB(255,255,255); custBtn.Font = Enum.Font.GothamBold
custBtn.TextScaled = false; custBtn.TextSize = 12; custBtn.BorderSizePixel = 0
mkCorner(custBtn, 8); mkStroke(custBtn, T().Strk, 1)
onTheme(function() custBtn.BackgroundColor3 = T().Btn end)

-- Custom colour editor popup
local customPanel = makeCard(sf, 0)
customPanel.AutomaticSize = Enum.AutomaticSize.Y
customPanel.Visible = false
local cpList = Instance.new("UIListLayout", customPanel)
cpList.Padding = UDim.new(0, 4); cpList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local cpPad = Instance.new("UIPadding", customPanel)
cpPad.PaddingTop = UDim.new(0,6); cpPad.PaddingBottom = UDim.new(0,6)
cpPad.PaddingLeft = UDim.new(0,6); cpPad.PaddingRight = UDim.new(0,6)

local parts = {
    {key="BG",   label="Background"},
    {key="BG2",  label="Background 2"},
    {key="Acc",  label="Accent"},
    {key="Txt",  label="Text"},
    {key="TOn",  label="Toggle On"},
    {key="TOff", label="Toggle Off"},
    {key="Btn",  label="Button"},
}

local function hexToColor(hex)
    hex = hex:gsub("#","")
    if #hex == 6 then
        local r = tonumber(hex:sub(1,2),16) or 0
        local g = tonumber(hex:sub(3,4),16) or 0
        local b = tonumber(hex:sub(5,6),16) or 0
        return Color3.fromRGB(r,g,b)
    end
    return nil
end

local function makeColorRow(part)
    local row = Instance.new("Frame", customPanel)
    row.Size = UDim2.new(1, 0, 0, 32); row.BackgroundTransparency = 1
    local nl = Instance.new("TextLabel", row)
    nl.Size = UDim2.new(0.42, 0, 1, 0); nl.Position = UDim2.new(0, 0, 0, 0)
    nl.BackgroundTransparency = 1; nl.Text = part.label
    nl.TextColor3 = T().Txt; nl.Font = Enum.Font.Gotham
    nl.TextScaled = false; nl.TextSize = 11; nl.TextXAlignment = Enum.TextXAlignment.Left
    onTheme(function() nl.TextColor3 = T().Txt end)
    local hexBox = Instance.new("TextBox", row)
    hexBox.Size = UDim2.new(0.4, 0, 0.75, 0); hexBox.Position = UDim2.new(0.43, 0, 0.125, 0)
    hexBox.BackgroundColor3 = T().BG2; hexBox.Text = "#00D25A"
    hexBox.TextColor3 = T().Txt; hexBox.Font = Enum.Font.Gotham
    hexBox.TextScaled = false; hexBox.TextSize = 11; hexBox.BorderSizePixel = 0
    mkCorner(hexBox, 4); mkStroke(hexBox, T().Strk, 1)
    onTheme(function() hexBox.BackgroundColor3 = T().BG2; hexBox.TextColor3 = T().Txt end)
    local applyB = Instance.new("TextButton", row)
    applyB.Size = UDim2.new(0.14, 0, 0.75, 0); applyB.Position = UDim2.new(0.84, 0, 0.125, 0)
    applyB.BackgroundColor3 = T().Acc; applyB.Text = "Set"
    applyB.TextColor3 = Color3.fromRGB(255,255,255); applyB.Font = Enum.Font.GothamBold
    applyB.TextScaled = false; applyB.TextSize = 10; applyB.BorderSizePixel = 0
    mkCorner(applyB, 4)
    onTheme(function() applyB.BackgroundColor3 = T().Acc end)
    applyB.MouseButton1Click:Connect(function()
        local c = hexToColor(hexBox.Text)
        if c then
            if not customTheme then
                customTheme = {}
                for k,v in pairs(T()) do customTheme[k] = v end
            end
            customTheme[part.key] = c
            curThemeName = "Custom"
            applyTheme()
        end
    end)
end

for _, p in ipairs(parts) do makeColorRow(p) end

custBtn.MouseButton1Click:Connect(function()
    customPanel.Visible = not customPanel.Visible
end)
end
-- ============================================================
-- OPEN/CLOSE BUTTON (stays on top of everything, never overlaps)
-- ============================================================
local OCGui = Instance.new("ScreenGui")
OCGui.Name = "PCToggleBtn"; OCGui.IgnoreGuiInset = true
OCGui.ResetOnSpawn = false; OCGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OCGui.DisplayOrder = 999
pcall(function() OCGui.Parent = CoreGui end)
local OCBtn = Instance.new("TextButton", OCGui)
OCBtn.Size = UDim2.new(0, 0, 0.055, 0); OCBtn.SizeConstraint = Enum.SizeConstraint.RelativeYY
OCBtn.AnchorPoint = Vector2.new(0.5, 1)
OCBtn.Position = UDim2.new(0.5, 0, 0.98, 0)
OCBtn.BackgroundColor3 = T().Btn; OCBtn.BorderSizePixel = 0
OCBtn.Text = "PC"; OCBtn.TextColor3 = Color3.fromRGB(255,255,255)
OCBtn.Font = Enum.Font.GothamBold; OCBtn.TextScaled = true
OCBtn.ZIndex = 1000
mkCorner(OCBtn, 8); mkStroke(OCBtn, T().Strk, 2)
onTheme(function() OCBtn.BackgroundColor3 = T().Btn; mainStroke.Color = T().Strk end)
-- Logo on OC button
local OCLogo = Instance.new("ImageLabel", OCBtn)
OCLogo.Size = UDim2.new(0.6, 0, 0.6, 0); OCLogo.Position = UDim2.new(0.2, 0, 0.2, 0)
OCLogo.BackgroundTransparency = 1; OCLogo.Image = "rbxassetid://85816937697749"
OCLogo.ZIndex = 1001
-- Dragging for OC button
do
local dg, ds, sp = false, nil, nil
OCBtn.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dg = true; ds = i.Position; sp = OCBtn.Position
end
end)
OCBtn.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dg = false
end
end)
UserInputService.InputChanged:Connect(function(i)
if dg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
local d = i.Position - ds
OCBtn.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
end
end)
end
OCBtn.MouseButton1Click:Connect(function()
isOpen = not isOpen
if isOpen then
Main.Visible = true
TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
Size = UDim2.new(0.55, 0, 0.7, 0)
}):Play()
else
TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
Size = UDim2.new(0, 0, 0, 0)
}):Play()
task.delay(0.25, function() Main.Visible = false end)
end
end)
ClosBtn.MouseButton1Click:Connect(function()
isOpen = false
TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
Size = UDim2.new(0, 0, 0, 0)
}):Play()
task.delay(0.25, function() Main.Visible = false end)
end)
-- ============================================================
-- STARTUP
-- ============================================================
task.spawn(function()
switchTab("Home")
-- Animate open
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Visible = true
TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back), {
Size = UDim2.new(0.55, 0, 0.7, 0)
}):Play()
task.delay(0.5, function()
showNotif("Project Crafted V2 Loaded!")
end)
end)
print("[Project Crafted V2] Loaded successfully!")
