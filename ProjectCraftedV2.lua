-- ============================================================
--  PROJECT CRAFTED V2  |  by ProjectCrafted
--  Roblox Executor Script - Full Release
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local CoreGui          = game:GetService("CoreGui")
local MarketplaceService=game:GetService("MarketplaceService")
local HttpService      = game:GetService("HttpService")

local LP     = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- GAME CHECK
-- ============================================================
if game.PlaceId ~= 119987266683883 then
    local sg = Instance.new("ScreenGui")
    sg.Name = "PC_Unsupported"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = CoreGui end)
    local bg = Instance.new("Frame")
    bg.AnchorPoint = Vector2.new(0.5, 0.5)
    bg.Position    = UDim2.fromScale(0.5, 0.5)
    bg.Size        = UDim2.new(0,0,0,0)
    bg.BackgroundColor3 = Color3.fromRGB(10,12,11); bg.BorderSizePixel=0; bg.Parent=sg
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0,14)
    local bs = Instance.new("UIStroke", bg); bs.Color=Color3.fromRGB(255,70,70); bs.Thickness=2
    local gn = "This Game"
    pcall(function() gn=MarketplaceService:GetProductInfo(game.PlaceId,Enum.InfoType.Asset).Name end)
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-24,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.fromRGB(255,100,100)
    lbl.Font=Enum.Font.SourceSansBold; lbl.TextScaled=true
    lbl.Text=gn.." Is Not Supported!"; lbl.Parent=bg
    TweenService:Create(bg,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=UDim2.new(0.42,0,0.09,0)}):Play()
    task.delay(3.5,function()
        TweenService:Create(bg,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),
            {Size=UDim2.new(0,0,0,0)}):Play()
        task.wait(0.5); sg:Destroy()
    end)
    return
end

-- ============================================================
-- CONFIG HELPERS
-- ============================================================
local function safeRead(p)  local ok,r=pcall(readfile,p); return ok and r or nil end
local function safeWrite(p,d) pcall(writefile,p,tostring(d)) end
local function safeMkdir(p) pcall(makefolder,p) end

safeMkdir("ProjectCrafted")
safeMkdir("ProjectCrafted/configs")

local execCount = (tonumber(safeRead("ProjectCrafted/configs/executions.txt")) or 0)+1
safeWrite("ProjectCrafted/configs/executions.txt", execCount)
local execStart  = tick()
local savedTheme = safeRead("ProjectCrafted/configs/theme.txt") or "Original"

-- ============================================================
-- THEME SYSTEM
-- ============================================================
local function C(r,g,b) return Color3.fromRGB(r,g,b) end

local Themes = {
    Original = {
        Bg=C(10,16,12),   BgS=C(15,25,18),
        Panel=C(20,33,24),Sidebar=C(13,22,16),
        Primary=C(0,200,100), PrimaryDk=C(0,145,65),
        Text=C(215,255,228),  TextDim=C(120,185,145),
        Stroke=C(0,170,75),
        TogOn=C(0,205,100),   TogOff=C(38,62,45),
        SlFill=C(0,200,100),  SlBg=C(26,46,32),
        DdBg=C(14,25,18),     TabSel=C(0,185,88), TabUns=C(18,34,22),
        GStart=C(0,230,112),  GEnd=C(0,148,66),
        TogBtn=C(0,200,100),  CloseC=C(255,75,75),
        WarnBg=C(8,12,10),    CardBg=C(16,28,20),
    },
    Sky = {
        Bg=C(8,16,30),    BgS=C(12,23,46),
        Panel=C(18,34,60),Sidebar=C(10,20,40),
        Primary=C(100,185,255), PrimaryDk=C(62,138,220),
        Text=C(198,224,255),    TextDim=C(128,172,218),
        Stroke=C(72,156,238),
        TogOn=C(100,185,255),   TogOff=C(26,48,82),
        SlFill=C(100,185,255),  SlBg=C(20,42,74),
        DdBg=C(12,26,50),       TabSel=C(100,185,255), TabUns=C(17,36,64),
        GStart=C(132,208,255),  GEnd=C(62,138,220),
        TogBtn=C(100,185,255),  CloseC=C(255,75,75),
        WarnBg=C(8,12,22),      CardBg=C(14,30,56),
    },
    Lava = {
        Bg=C(18,9,4),     BgS=C(28,14,7),
        Panel=C(40,18,7), Sidebar=C(24,11,4),
        Primary=C(255,118,28),  PrimaryDk=C(198,68,8),
        Text=C(255,218,182),    TextDim=C(198,152,100),
        Stroke=C(218,78,20),
        TogOn=C(255,120,30),    TogOff=C(70,30,14),
        SlFill=C(255,120,30),   SlBg=C(60,25,10),
        DdBg=C(26,13,5),        TabSel=C(255,118,28), TabUns=C(40,18,7),
        GStart=C(255,152,52),   GEnd=C(198,62,8),
        TogBtn=C(255,118,28),   CloseC=C(255,75,75),
        WarnBg=C(16,7,3),       CardBg=C(34,15,6),
    },
}

-- Load custom theme if saved
local customRaw = safeRead("ProjectCrafted/configs/customtheme.txt")
if customRaw then
    pcall(function()
        local d=HttpService:JSONDecode(customRaw)
        if d then
            local t={}
            for k,v in pairs(d) do t[k]=C(v[1],v[2],v[3]) end
            -- fill missing keys from Original
            for k,v in pairs(Themes.Original) do if not t[k] then t[k]=v end end
            Themes.Custom=t
        end
    end)
end

local CT  = Themes[savedTheme] or Themes.Original
local CTN = (Themes[savedTheme] and savedTheme) or "Original"
local themeListeners = {}

local function onTheme(fn) table.insert(themeListeners,fn) end
local function applyTheme(name)
    local t=Themes[name]; if not t then return end
    CT=t; CTN=name
    safeWrite("ProjectCrafted/configs/theme.txt", name)
    for _,fn in ipairs(themeListeners) do pcall(fn,t) end
end

-- ============================================================
-- GLOBAL STATE
-- ============================================================
local playerWarningAck     = false
local selectedBrainrots    = {}
local selectedBrainrotOrder= {}
local brainrotUIRefresh    = nil  -- callback to refresh selected chips

local speedEnabled   = false; local speedVal = 16;  local speedMax = 100
local jumpEnabled    = false; local jumpVal  = 50
local godmodeEnabled = false; local godmodeConns = {}
local flightEnabled  = false; local flightConn = nil; local flightVel = Vector3.zero
local teleportEnabled    = false
local hlBrainrotsEnabled = false; local brainrotHighlights = {}
local hlPlayersEnabled   = false; local playerBillboards   = {}; local playerBillConn = nil
local autoCollectEnabled = false; local autoCollectThread  = nil
local spawnWatchConn     = nil;   local spawnWatchConn2    = nil

-- ============================================================
-- CLEAN OLD GUIS
-- ============================================================
pcall(function()
    for _,n in ipairs({"ProjectCraftedV2","PC_ToggleGui","PC_Notif","PC_FlightMobile","PC_Unsupported"}) do
        local g=CoreGui:FindFirstChild(n); if g then g:Destroy() end
    end
end)

-- ============================================================
-- MAIN SCREENGUI
-- ============================================================
local MG = Instance.new("ScreenGui")
MG.Name="ProjectCraftedV2"; MG.ResetOnSpawn=false
MG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; MG.IgnoreGuiInset=true
pcall(function() MG.Parent=CoreGui end)

-- ============================================================
-- NOTIFICATION SYSTEM (top middle, stacking)
-- ============================================================
local NH = Instance.new("Frame")
NH.Name="NH"; NH.AnchorPoint=Vector2.new(.5,0); NH.Position=UDim2.fromScale(.5,.01)
NH.Size=UDim2.fromScale(.34,0); NH.AutomaticSize=Enum.AutomaticSize.Y
NH.BackgroundTransparency=1; NH.ZIndex=900; NH.Parent=MG
local NHL=Instance.new("UIListLayout",NH); NHL.Padding=UDim.new(0,4)
NHL.HorizontalAlignment=Enum.HorizontalAlignment.Center

local nOrd=0
local function notify(text, color, dur)
    color=color or CT.Primary; dur=dur or 2.5; nOrd=nOrd+1
    local card=Instance.new("Frame")
    card.LayoutOrder=nOrd; card.Size=UDim2.new(1,0,0,48); card.BackgroundColor3=CT.Bg
    card.BackgroundTransparency=0.05; card.ZIndex=901; card.Parent=NH
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,10)
    local cs=Instance.new("UIStroke",card); cs.Color=color; cs.Thickness=1.5
    local acc=Instance.new("Frame"); acc.Size=UDim2.new(0,3,0.8,0); acc.Position=UDim2.new(0,5,0.1,0)
    acc.BackgroundColor3=color; acc.BorderSizePixel=0; acc.ZIndex=902; acc.Parent=card
    Instance.new("UICorner",acc).CornerRadius=UDim.new(1,0)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-18,1,0); l.Position=UDim2.new(0,14,0,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=C(220,255,235)
    l.Font=Enum.Font.SourceSansBold; l.TextSize=13; l.TextWrapped=true
    l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=902; l.Parent=card
    card.Position=UDim2.new(0,-card.AbsoluteSize.X-50,0,0)
    TweenService:Create(card,TweenInfo.new(.3,Enum.EasingStyle.Back),{Position=UDim2.new(0,0,0,0)}):Play()
    task.delay(dur, function()
        TweenService:Create(card,TweenInfo.new(.35,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {BackgroundTransparency=1}):Play()
        TweenService:Create(l,TweenInfo.new(.35),{TextTransparency=1}):Play()
        TweenService:Create(cs,TweenInfo.new(.35),{Transparency=1}):Play()
        task.wait(.4); card:Destroy()
    end)
end

-- ============================================================
-- BRAINROT SPAWN NOTIFIER (top middle large card)
-- ============================================================
local spawnNotifGui=Instance.new("ScreenGui")
spawnNotifGui.Name="PC_Notif"; spawnNotifGui.IgnoreGuiInset=true; spawnNotifGui.ResetOnSpawn=false
pcall(function() spawnNotifGui.Parent=CoreGui end)

local function showSpawnNotif(name)
    local frame=Instance.new("Frame")
    frame.AnchorPoint=Vector2.new(.5,0); frame.Position=UDim2.fromScale(.5,-0.15)
    frame.Size=UDim2.new(.44,0,0,54); frame.BackgroundColor3=CT.Panel; frame.BorderSizePixel=0
    frame.ZIndex=950; frame.Parent=spawnNotifGui
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,12)
    local st=Instance.new("UIStroke",frame); st.Color=CT.Primary; st.Thickness=2
    local grd=Instance.new("UIGradient",frame)
    grd.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CT.GStart),ColorSequenceKeypoint.new(1,CT.GEnd)})
    grd.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.78),NumberSequenceKeypoint.new(1,.92)})
    grd.Rotation=135
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-16,1,0); l.Position=UDim2.new(0,8,0,0)
    l.BackgroundTransparency=1; l.TextColor3=CT.Text; l.Font=Enum.Font.SourceSansBold
    l.TextSize=14; l.Text="A "..name.." Has Spawned!"; l.TextWrapped=true
    l.TextXAlignment=Enum.TextXAlignment.Center; l.ZIndex=951; l.Parent=frame
    TweenService:Create(frame,TweenInfo.new(.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.fromScale(.5,.015)}):Play()
    task.delay(3.5,function()
        TweenService:Create(frame,TweenInfo.new(.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),
            {Position=UDim2.fromScale(.5,-.15)}):Play()
        task.wait(.45); frame:Destroy()
    end)
end

-- ============================================================
-- MAIN FRAME
-- ============================================================
local guiOpen=true
local MFSIZE=UDim2.fromScale(.60,.64)

local MF=Instance.new("Frame")
MF.Name="MF"; MF.AnchorPoint=Vector2.new(.5,.5); MF.Position=UDim2.fromScale(.5,.52)
MF.Size=MFSIZE; MF.BackgroundColor3=CT.Bg; MF.BorderSizePixel=0
MF.ClipsDescendants=true; MF.ZIndex=10; MF.Parent=MG
local mfSC=Instance.new("UISizeConstraint",MF)
mfSC.MaxSize=Vector2.new(780,570); mfSC.MinSize=Vector2.new(300,270)
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)
local mfs=Instance.new("UIStroke",MF); mfs.Color=CT.Stroke; mfs.Thickness=2
local mfg=Instance.new("UIGradient",MF); mfg.Rotation=135
mfg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CT.Bg),ColorSequenceKeypoint.new(1,CT.BgS)})
onTheme(function(t)
    MF.BackgroundColor3=t.Bg; mfs.Color=t.Stroke
    mfg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,t.Bg),ColorSequenceKeypoint.new(1,t.BgS)})
end)

-- TITLE BAR
local TB=Instance.new("Frame")
TB.Name="TitleBar"; TB.Size=UDim2.new(1,0,0,48); TB.BackgroundColor3=CT.Panel
TB.BorderSizePixel=0; TB.ZIndex=15; TB.Parent=MF
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,14)
local tbCov=Instance.new("Frame"); tbCov.Size=UDim2.new(1,0,.5,0); tbCov.Position=UDim2.new(0,0,.5,0)
tbCov.BackgroundColor3=CT.Panel; tbCov.BorderSizePixel=0; tbCov.ZIndex=14; tbCov.Parent=TB
local tbg=Instance.new("UIGradient",TB); tbg.Rotation=90
tbg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CT.GStart),ColorSequenceKeypoint.new(1,CT.GEnd)})
tbg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.62),NumberSequenceKeypoint.new(1,.86)})
onTheme(function(t)
    TB.BackgroundColor3=t.Panel; tbCov.BackgroundColor3=t.Panel
    tbg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,t.GStart),ColorSequenceKeypoint.new(1,t.GEnd)})
end)

local logo=Instance.new("ImageLabel"); logo.Size=UDim2.new(0,34,0,34)
logo.Position=UDim2.new(0,8,.5,-17); logo.BackgroundTransparency=1
logo.Image="rbxassetid://85816937697749"; logo.ZIndex=16; logo.Parent=TB
Instance.new("UICorner",logo).CornerRadius=UDim.new(0,6)

local ttl=Instance.new("TextLabel"); ttl.Size=UDim2.new(1,-130,1,0); ttl.Position=UDim2.new(0,50,0,0)
ttl.BackgroundTransparency=1; ttl.Text="Project Crafted V2"; ttl.TextColor3=CT.Text
ttl.Font=Enum.Font.SourceSansBold; ttl.TextSize=17; ttl.TextXAlignment=Enum.TextXAlignment.Left
ttl.ZIndex=16; ttl.Parent=TB
onTheme(function(t) ttl.TextColor3=t.Text end)

local closeMini=Instance.new("TextButton"); closeMini.Size=UDim2.new(0,30,0,30)
closeMini.AnchorPoint=Vector2.new(1,.5); closeMini.Position=UDim2.new(1,-8,.5,0)
closeMini.BackgroundColor3=CT.CloseC; closeMini.Text="X"; closeMini.TextColor3=C(255,255,255)
closeMini.Font=Enum.Font.SourceSansBold; closeMini.TextSize=14; closeMini.ZIndex=17; closeMini.Parent=TB
Instance.new("UICorner",closeMini).CornerRadius=UDim.new(0,8)

-- DRAG
do
    local drag=false; local ds, sp
    TB.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; ds=i.Position; sp=MF.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            local d=i.Position-ds
            MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
end

-- CONTENT AREA
local CA=Instance.new("Frame"); CA.Position=UDim2.new(0,0,0,48); CA.Size=UDim2.new(1,0,1,-48)
CA.BackgroundTransparency=1; CA.ZIndex=10; CA.Parent=MF; CA.ClipsDescendants=false

-- SIDEBAR
local SB=Instance.new("Frame"); SB.Size=UDim2.new(.22,0,1,0); SB.BackgroundColor3=CT.Sidebar
SB.BorderSizePixel=0; SB.ZIndex=11; SB.Parent=CA
onTheme(function(t) SB.BackgroundColor3=t.Sidebar end)
local sbll=Instance.new("UIListLayout",SB); sbll.Padding=UDim.new(0,5); sbll.SortOrder=Enum.SortOrder.LayoutOrder
local sbp=Instance.new("UIPadding",SB); sbp.PaddingTop=UDim.new(0,10); sbp.PaddingLeft=UDim.new(0,6)
sbp.PaddingRight=UDim.new(0,6); sbp.PaddingBottom=UDim.new(0,8)

-- PAGE CONTAINER
local PC=Instance.new("Frame"); PC.Position=UDim2.new(.22,0,0,0); PC.Size=UDim2.new(.78,0,1,0)
PC.BackgroundTransparency=1; PC.ClipsDescendants=true; PC.ZIndex=10; PC.Parent=CA

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local tabs={}; local tabBtns={}; local curTab=nil

local function makeTabBtn(name, order)
    local b=Instance.new("TextButton"); b.Name="TB_"..name; b.LayoutOrder=order
    b.Size=UDim2.new(1,0,0,38); b.BackgroundColor3=CT.TabUns; b.Text=name
    b.TextColor3=CT.TextDim; b.Font=Enum.Font.SourceSansBold; b.TextSize=13
    b.BorderSizePixel=0; b.ZIndex=12; b.Parent=SB
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    local s=Instance.new("UIStroke",b); s.Color=CT.Stroke; s.Thickness=0; s.Transparency=1
    onTheme(function(t)
        if curTab==name then
            b.BackgroundColor3=t.TabSel; b.TextColor3=t.Text; s.Color=t.Stroke; s.Thickness=1.5; s.Transparency=0
        else
            b.BackgroundColor3=t.TabUns; b.TextColor3=t.TextDim; s.Thickness=0; s.Transparency=1
        end
    end)
    return b, s
end

local function makePage(name)
    local p=Instance.new("ScrollingFrame"); p.Name="P_"..name; p.Size=UDim2.fromScale(1,1)
    p.BackgroundTransparency=1; p.BorderSizePixel=0; p.ScrollBarThickness=5
    p.ScrollBarImageColor3=CT.Primary; p.CanvasSize=UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y; p.Visible=false; p.ZIndex=11; p.Parent=PC
    p.ElasticBehavior=Enum.ElasticBehavior.Never
    local l=Instance.new("UIListLayout",p); l.Padding=UDim.new(0,8); l.SortOrder=Enum.SortOrder.LayoutOrder
    local pad=Instance.new("UIPadding",p); pad.PaddingTop=UDim.new(0,10); pad.PaddingLeft=UDim.new(0,10)
    pad.PaddingRight=UDim.new(0,14); pad.PaddingBottom=UDim.new(0,10)
    onTheme(function(t) p.ScrollBarImageColor3=t.Primary end)
    return p
end

local TABS={"Home","Main","Player","Visual","Settings"}
local tabStrokes={}
for i,n in ipairs(TABS) do
    local b, s = makeTabBtn(n,i)
    tabBtns[n]=b; tabStrokes[n]=s; tabs[n]=makePage(n)
end

-- Player warning overlay
local pwFrame=Instance.new("Frame"); pwFrame.Name="PlayerWarning"
pwFrame.Size=UDim2.fromScale(1,1); pwFrame.BackgroundColor3=CT.WarnBg
pwFrame.BackgroundTransparency=.10; pwFrame.Visible=false; pwFrame.ZIndex=80; pwFrame.Parent=PC
onTheme(function(t) pwFrame.BackgroundColor3=t.WarnBg end)
local pwInner=Instance.new("Frame"); pwInner.AnchorPoint=Vector2.new(.5,.5)
pwInner.Position=UDim2.fromScale(.5,.5); pwInner.Size=UDim2.new(.9,0,0,0)
pwInner.AutomaticSize=Enum.AutomaticSize.Y; pwInner.BackgroundColor3=CT.Panel
pwInner.BorderSizePixel=0; pwInner.ZIndex=81; pwInner.Parent=pwFrame
Instance.new("UICorner",pwInner).CornerRadius=UDim.new(0,14)
local pwcs=Instance.new("UIStroke",pwInner); pwcs.Color=C(255,165,0); pwcs.Thickness=2
local pwll=Instance.new("UIListLayout",pwInner); pwll.Padding=UDim.new(0,10)
pwll.HorizontalAlignment=Enum.HorizontalAlignment.Center
local pwpad=Instance.new("UIPadding",pwInner); pwpad.PaddingLeft=UDim.new(0,14)
pwpad.PaddingRight=UDim.new(0,14); pwpad.PaddingTop=UDim.new(0,16); pwpad.PaddingBottom=UDim.new(0,16)
onTheme(function(t) pwInner.BackgroundColor3=t.Panel end)
local pwLbl=Instance.new("TextLabel"); pwLbl.Size=UDim2.new(1,0,0,0)
pwLbl.AutomaticSize=Enum.AutomaticSize.Y; pwLbl.BackgroundTransparency=1
pwLbl.Text="⚠️ Warning: Using These Features Could Get You Banned, Use At Your Own Risk. ⚠️"
pwLbl.TextColor3=C(255,200,60); pwLbl.Font=Enum.Font.SourceSansBold
pwLbl.TextSize=14; pwLbl.TextWrapped=true; pwLbl.ZIndex=82
pwLbl.TextXAlignment=Enum.TextXAlignment.Center; pwLbl.Parent=pwInner
local pwBtnRow=Instance.new("Frame"); pwBtnRow.Size=UDim2.new(1,0,0,38)
pwBtnRow.BackgroundTransparency=1; pwBtnRow.ZIndex=82; pwBtnRow.Parent=pwInner
local pwBll=Instance.new("UIListLayout",pwBtnRow); pwBll.FillDirection=Enum.FillDirection.Horizontal
pwBll.Padding=UDim.new(0,10); pwBll.HorizontalAlignment=Enum.HorizontalAlignment.Center
pwBll.VerticalAlignment=Enum.VerticalAlignment.Center
local pwOkBtn=Instance.new("TextButton"); pwOkBtn.Size=UDim2.new(0,110,0,34)
pwOkBtn.BackgroundColor3=C(0,180,80); pwOkBtn.Text="✓  Ok"
pwOkBtn.TextColor3=C(255,255,255); pwOkBtn.Font=Enum.Font.SourceSansBold
pwOkBtn.TextSize=13; pwOkBtn.BorderSizePixel=0; pwOkBtn.ZIndex=83; pwOkBtn.Parent=pwBtnRow
Instance.new("UICorner",pwOkBtn).CornerRadius=UDim.new(0,8)
local pwBackBtn=Instance.new("TextButton"); pwBackBtn.Size=UDim2.new(0,110,0,34)
pwBackBtn.BackgroundColor3=C(200,50,50); pwBackBtn.Text="✕  Go Back"
pwBackBtn.TextColor3=C(255,255,255); pwBackBtn.Font=Enum.Font.SourceSansBold
pwBackBtn.TextSize=13; pwBackBtn.BorderSizePixel=0; pwBackBtn.ZIndex=83; pwBackBtn.Parent=pwBtnRow
Instance.new("UICorner",pwBackBtn).CornerRadius=UDim.new(0,8)

local function switchTab(name)
    if curTab==name then return end
    if curTab then
        local op=tabs[curTab]; local ob=tabBtns[curTab]
        TweenService:Create(op,TweenInfo.new(.18),{GroupTransparency=1}):Play()
        task.delay(.19,function() if curTab~=name then op.Visible=false end end)
        TweenService:Create(ob,TweenInfo.new(.2),{BackgroundColor3=CT.TabUns,TextColor3=CT.TextDim}):Play()
        local s=tabStrokes[curTab]; if s then TweenService:Create(s,TweenInfo.new(.2),{Transparency=1,Thickness=0}):Play() end
    end
    curTab=name
    local np=tabs[name]; local nb=tabBtns[name]
    np.GroupTransparency=1; np.Visible=true
    TweenService:Create(np,TweenInfo.new(.22,Enum.EasingStyle.Quad),{GroupTransparency=0}):Play()
    TweenService:Create(nb,TweenInfo.new(.2),{BackgroundColor3=CT.TabSel,TextColor3=CT.Text}):Play()
    local s=tabStrokes[name]
    if s then TweenService:Create(s,TweenInfo.new(.2),{Transparency=0,Thickness=1.5}):Play() end
    if name=="Player" and not playerWarningAck then
        pwFrame.Visible=true
    else
        pwFrame.Visible=false
    end
end

for _,n in ipairs(TABS) do
    local name=n
    tabBtns[n].MouseButton1Click:Connect(function() switchTab(name) end)
end

pwOkBtn.MouseButton1Click:Connect(function()
    playerWarningAck=true; pwFrame.Visible=false
end)
pwBackBtn.MouseButton1Click:Connect(function()
    pwFrame.Visible=false; switchTab("Home"); pwFrame.Visible=false
end)

-- ============================================================
-- HELPER UI COMPONENTS
-- ============================================================
local function mkCard(parent, order)
    local c=Instance.new("Frame"); c.LayoutOrder=order or 0; c.Size=UDim2.new(1,0,0,0)
    c.AutomaticSize=Enum.AutomaticSize.Y; c.BackgroundColor3=CT.CardBg; c.BorderSizePixel=0; c.Parent=parent
    Instance.new("UICorner",c).CornerRadius=UDim.new(0,10)
    local s=Instance.new("UIStroke",c); s.Color=CT.Stroke; s.Thickness=1; s.Transparency=.4
    local p=Instance.new("UIPadding",c); p.PaddingLeft=UDim.new(0,10); p.PaddingRight=UDim.new(0,10)
    p.PaddingTop=UDim.new(0,8); p.PaddingBottom=UDim.new(0,8)
    local l=Instance.new("UIListLayout",c); l.Padding=UDim.new(0,6); l.SortOrder=Enum.SortOrder.LayoutOrder
    onTheme(function(t) c.BackgroundColor3=t.CardBg; s.Color=t.Stroke end)
    return c, l
end

local function mkLabel(parent, text, size, color, order, wrap)
    local l=Instance.new("TextLabel"); l.LayoutOrder=order or 0; l.Size=UDim2.new(1,0,0,size or 20)
    if wrap then l.AutomaticSize=Enum.AutomaticSize.Y; l.Size=UDim2.new(1,0,0,0) end
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=color or CT.Text
    l.Font=Enum.Font.SourceSans; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextWrapped=true; l.Parent=parent
    onTheme(function(t) if color==nil then l.TextColor3=t.Text end end)
    return l
end

local function mkSectionLbl(parent, text, order)
    local l=Instance.new("TextLabel"); l.LayoutOrder=order or 0; l.Size=UDim2.new(1,0,0,20)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=CT.Primary
    l.Font=Enum.Font.SourceSansBold; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=parent
    onTheme(function(t) l.TextColor3=t.Primary end); return l
end

local function mkInfoRow(parent, labelText, valText, order)
    local r=Instance.new("Frame"); r.LayoutOrder=order or 0; r.Size=UDim2.new(1,0,0,22)
    r.BackgroundTransparency=1; r.Parent=parent
    local a=Instance.new("TextLabel"); a.Size=UDim2.new(.5,0,1,0); a.BackgroundTransparency=1
    a.Text=labelText; a.TextColor3=CT.TextDim; a.Font=Enum.Font.SourceSans; a.TextSize=12
    a.TextXAlignment=Enum.TextXAlignment.Left; a.Parent=r
    onTheme(function(t) a.TextColor3=t.TextDim end)
    local b=Instance.new("TextLabel"); b.Size=UDim2.new(.5,0,1,0); b.Position=UDim2.new(.5,0,0,0)
    b.BackgroundTransparency=1; b.Text=tostring(valText); b.TextColor3=CT.Text
    b.Font=Enum.Font.SourceSansBold; b.TextSize=12; b.TextXAlignment=Enum.TextXAlignment.Right
    b.TextTruncate=Enum.TextTruncate.AtEnd; b.Parent=r
    onTheme(function(t) b.TextColor3=t.Text end)
    return r, b
end

local function mkDivider(parent, order)
    local d=Instance.new("Frame"); d.LayoutOrder=order or 0; d.Size=UDim2.new(1,0,0,1)
    d.BackgroundColor3=CT.Stroke; d.BackgroundTransparency=.5; d.BorderSizePixel=0; d.Parent=parent
    onTheme(function(t) d.BackgroundColor3=t.Stroke end); return d
end

local function mkToggle(parent, label, order, default, cb)
    local row=Instance.new("Frame"); row.LayoutOrder=order or 0; row.Size=UDim2.new(1,0,0,32)
    row.BackgroundTransparency=1; row.Parent=parent
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-56,1,0); l.BackgroundTransparency=1
    l.Text=label; l.TextColor3=CT.Text; l.Font=Enum.Font.SourceSans; l.TextSize=13
    l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true; l.Parent=row
    onTheme(function(t) l.TextColor3=t.Text end)
    local bg=Instance.new("Frame"); bg.AnchorPoint=Vector2.new(1,.5); bg.Position=UDim2.new(1,0,.5,0)
    bg.Size=UDim2.new(0,46,0,24); bg.BackgroundColor3=(default and CT.TogOn or CT.TogOff)
    bg.BorderSizePixel=0; bg.Parent=row
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local s=Instance.new("UIStroke",bg); s.Color=CT.Stroke; s.Thickness=1
    local dot=Instance.new("Frame"); dot.AnchorPoint=Vector2.new(0,.5)
    dot.Position=(default and UDim2.new(0,24,.5,0) or UDim2.new(0,2,.5,0))
    dot.Size=UDim2.new(0,20,0,20); dot.BackgroundColor3=C(255,255,255); dot.BorderSizePixel=0; dot.Parent=bg
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local isOn=default or false
    onTheme(function(t) bg.BackgroundColor3=isOn and t.TogOn or t.TogOff; s.Color=t.Stroke end)
    local btn=Instance.new("TextButton"); btn.Size=UDim2.fromScale(1,1); btn.BackgroundTransparency=1
    btn.Text=""; btn.ZIndex=2; btn.Parent=bg
    btn.MouseButton1Click:Connect(function()
        isOn=not isOn
        TweenService:Create(bg,TweenInfo.new(.25),{BackgroundColor3=isOn and CT.TogOn or CT.TogOff}):Play()
        TweenService:Create(dot,TweenInfo.new(.22,Enum.EasingStyle.Back),
            {Position=isOn and UDim2.new(0,24,.5,0) or UDim2.new(0,2,.5,0)}):Play()
        cb(isOn)
    end)
    local function setVal(v)
        isOn=v; bg.BackgroundColor3=v and CT.TogOn or CT.TogOff
        dot.Position=v and UDim2.new(0,24,.5,0) or UDim2.new(0,2,.5,0)
    end
    return row, setVal, function() return isOn end
end

local function mkSlider(parent, label, minV, maxV, def, order, cb)
    local con=Instance.new("Frame"); con.LayoutOrder=order or 0; con.Size=UDim2.new(1,0,0,0)
    con.AutomaticSize=Enum.AutomaticSize.Y; con.BackgroundTransparency=1; con.Parent=parent
    local cl=Instance.new("UIListLayout",con); cl.Padding=UDim.new(0,4)
    local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,18); top.BackgroundTransparency=1; top.Parent=con
    local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(.7,0,1,0); nl.BackgroundTransparency=1
    nl.Text=label; nl.TextColor3=CT.TextDim; nl.Font=Enum.Font.SourceSans; nl.TextSize=12
    nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=top
    onTheme(function(t) nl.TextColor3=t.TextDim end)
    local vl=Instance.new("TextLabel"); vl.Size=UDim2.new(.3,0,1,0); vl.Position=UDim2.new(.7,0,0,0)
    vl.BackgroundTransparency=1; vl.Text=tostring(def); vl.TextColor3=CT.Primary
    vl.Font=Enum.Font.SourceSansBold; vl.TextSize=12; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=top
    onTheme(function(t) vl.TextColor3=t.Primary end)
    local sbg=Instance.new("Frame"); sbg.Size=UDim2.new(1,0,0,12); sbg.BackgroundColor3=CT.SlBg
    sbg.BorderSizePixel=0; sbg.Parent=con
    Instance.new("UICorner",sbg).CornerRadius=UDim.new(1,0)
    onTheme(function(t) sbg.BackgroundColor3=t.SlBg end)
    local initR=math.clamp((def-minV)/math.max(maxV-minV,1),0,1)
    local sf=Instance.new("Frame"); sf.Size=UDim2.new(initR,0,1,0); sf.BackgroundColor3=CT.SlFill
    sf.BorderSizePixel=0; sf.Parent=sbg
    Instance.new("UICorner",sf).CornerRadius=UDim.new(1,0)
    local sfg=Instance.new("UIGradient",sf)
    sfg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CT.GStart),ColorSequenceKeypoint.new(1,CT.GEnd)})
    onTheme(function(t) sf.BackgroundColor3=t.SlFill
        sfg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,t.GStart),ColorSequenceKeypoint.new(1,t.GEnd)}) end)
    local sk=Instance.new("Frame"); sk.AnchorPoint=Vector2.new(.5,.5)
    sk.Position=UDim2.new(initR,0,.5,0); sk.Size=UDim2.new(0,18,0,18)
    sk.BackgroundColor3=C(255,255,255); sk.BorderSizePixel=0; sk.ZIndex=2; sk.Parent=sbg
    Instance.new("UICorner",sk).CornerRadius=UDim.new(1,0)
    local sks=Instance.new("UIStroke",sk); sks.Color=CT.Primary; sks.Thickness=2
    onTheme(function(t) sks.Color=t.Primary end)
    local curV=def; local dSl=false; local curMin=minV; local curMax=maxV
    local function upd(pos)
        local ap=sbg.AbsolutePosition; local as_=sbg.AbsoluteSize
        if as_.X<=0 then return end
        local r=math.clamp((pos.X-ap.X)/as_.X,0,1)
        local nv=math.floor(curMin+(curMax-curMin)*r+.5)
        curV=nv; sf.Size=UDim2.new(r,0,1,0); sk.Position=UDim2.new(r,0,.5,0)
        vl.Text=tostring(nv); cb(nv)
    end
    local sib=Instance.new("TextButton"); sib.Size=UDim2.fromScale(1,1); sib.BackgroundTransparency=1
    sib.Text=""; sib.ZIndex=3; sib.Parent=sbg
    sib.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dSl=true; upd(i.Position)
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dSl=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dSl then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then upd(i.Position) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dSl=false end
    end)
    local function setV(v)
        local r=math.clamp((v-curMin)/math.max(curMax-curMin,1),0,1)
        sf.Size=UDim2.new(r,0,1,0); sk.Position=UDim2.new(r,0,.5,0); vl.Text=tostring(v); curV=v
    end
    local function setMax(m) curMax=m; setV(math.clamp(curV,curMin,curMax)) end
    return con, setV, function() return curV end, setMax
end

local function mkInputBox(parent, placeholder, order, cb)
    local bg=Instance.new("Frame"); bg.LayoutOrder=order or 0; bg.Size=UDim2.new(1,0,0,30)
    bg.BackgroundColor3=CT.DdBg; bg.BorderSizePixel=0; bg.Parent=parent
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,8)
    local s=Instance.new("UIStroke",bg); s.Color=CT.Stroke; s.Thickness=1
    onTheme(function(t) bg.BackgroundColor3=t.DdBg; s.Color=t.Stroke end)
    local inp=Instance.new("TextBox"); inp.Size=UDim2.new(1,-16,1,0); inp.Position=UDim2.new(0,8,0,0)
    inp.BackgroundTransparency=1; inp.PlaceholderText=placeholder or ""; inp.Text=""
    inp.TextColor3=CT.Text; inp.PlaceholderColor3=CT.TextDim; inp.Font=Enum.Font.SourceSans
    inp.TextSize=13; inp.ClearTextOnFocus=false; inp.Parent=bg
    onTheme(function(t) inp.TextColor3=t.Text; inp.PlaceholderColor3=t.TextDim end)
    if cb then inp.FocusLost:Connect(function() cb(inp.Text) end) end
    return bg, inp
end

-- ============================================================
-- HOME TAB
-- ============================================================
local hp=tabs["Home"]

-- Profile card
local profCard=mkCard(hp,1)
mkSectionLbl(profCard,"Player Profile",1)
mkDivider(profCard,2)
local pfpFrame=Instance.new("Frame"); pfpFrame.LayoutOrder=3; pfpFrame.Size=UDim2.new(1,0,0,70)
pfpFrame.BackgroundTransparency=1; pfpFrame.Parent=profCard
local pfpImg=Instance.new("ImageLabel"); pfpImg.AnchorPoint=Vector2.new(.5,.5)
pfpImg.Position=UDim2.fromScale(.5,.5); pfpImg.Size=UDim2.new(0,60,0,60)
pfpImg.BackgroundColor3=CT.Panel; pfpImg.Image=""; pfpImg.ZIndex=2; pfpImg.Parent=pfpFrame
Instance.new("UICorner",pfpImg).CornerRadius=UDim.new(1,0)
local pfps=Instance.new("UIStroke",pfpImg); pfps.Color=CT.Primary; pfps.Thickness=2.5
onTheme(function(t) pfps.Color=t.Primary; pfpImg.BackgroundColor3=t.Panel end)
task.spawn(function()
    local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
    if ok and img then pfpImg.Image=img end
end)
mkDivider(profCard,4)
local _,unLbl=mkInfoRow(profCard,"Username",LP.Name,5)
local _,dnLbl=mkInfoRow(profCard,"Display Name",LP.DisplayName,6)
local _,idLbl=mkInfoRow(profCard,"User ID",LP.UserId,7)
local _,ageLbl=mkInfoRow(profCard,"Account Age",LP.AccountAge.." days",8)

-- Game card
local gameCard=mkCard(hp,2)
mkSectionLbl(gameCard,"Game Info",1)
mkDivider(gameCard,2)
local gameName2="Loading..."
task.spawn(function()
    local ok,info=pcall(MarketplaceService.GetProductInfo,MarketplaceService,game.PlaceId,Enum.InfoType.Asset)
    if ok then gameName2=info.Name end
end)
local _,gnLbl=mkInfoRow(gameCard,"Game Name",gameName2,3)
local _,giLbl=mkInfoRow(gameCard,"Game ID",game.PlaceId,4)

-- Server card
local srvCard=mkCard(hp,3)
mkSectionLbl(srvCard,"Server Info",1)
mkDivider(srvCard,2)
local plrCount=0; local maxPlrs=0
pcall(function() plrCount=#Players:GetPlayers(); maxPlrs=Players.MaxPlayers end)
local _,popLbl=mkInfoRow(srvCard,"Population",plrCount.." / "..maxPlrs,3)
local _,sidLbl=mkInfoRow(srvCard,"Server ID",game.JobId~="" and game.JobId:sub(1,20).."..." or "N/A",4)
local srvUp=0
local _,sutLbl=mkInfoRow(srvCard,"Uptime","0s",5)
task.spawn(function()
    while task.wait(1) do
        srvUp=srvUp+1
        local h=math.floor(srvUp/3600); local m=math.floor((srvUp%3600)/60); local s=srvUp%60
        local str=h>0 and string.format("%dh %dm %ds",h,m,s) or m>0 and string.format("%dm %ds",m,s) or s.."s"
        sutLbl.Text=str
    end
end)
task.spawn(function() while task.wait(5) do
    pcall(function() plrCount=#Players:GetPlayers(); popLbl.Text=plrCount.." / "..maxPlrs end)
end end)

-- Execution card
local execCard=mkCard(hp,4)
mkSectionLbl(execCard,"Script Stats",1)
mkDivider(execCard,2)
local _,exCntLbl=mkInfoRow(execCard,"Times Executed",execCount,3)
local _,exDurLbl=mkInfoRow(execCard,"Execution Duration","0s",4)
task.spawn(function()
    while task.wait(1) do
        local dur=math.floor(tick()-execStart)
        local h=math.floor(dur/3600); local m=math.floor((dur%3600)/60); local s=dur%60
        exDurLbl.Text=h>0 and string.format("%dh %dm %ds",h,m,s) or m>0 and string.format("%dm %ds",m,s) or s.."s"
    end
end)

-- Update game name when loaded
task.spawn(function()
    task.wait(2)
    gnLbl.Text=gameName2
end)

-- ============================================================
-- MAIN TAB
-- ============================================================
local mp=tabs["Main"]

-- Get brainrot names from ReplicatedStorage.Brainrots
local brainrotNames={}
local function refreshBrainrotList()
    brainrotNames={}
    pcall(function()
        local root=ReplicatedStorage:WaitForChild("Brainrots",5)
        if not root then return end
        for _,folder in ipairs(root:GetChildren()) do
            if folder:IsA("Folder") then
                for _,model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") then
                        table.insert(brainrotNames, model.Name)
                    end
                end
            end
        end
    end)
    table.sort(brainrotNames, function(a,b) return a:lower()<b:lower() end)
end
task.spawn(refreshBrainrotList)

-- Dropdown card
local ddCard=mkCard(mp,1)
mkSectionLbl(ddCard,"Select Brainrots",1)

-- Search box
local _,searchInp=mkInputBox(ddCard,"Search brainrots...",2)

-- Dropdown list (scrollable)
local ddScroll=Instance.new("ScrollingFrame"); ddScroll.LayoutOrder=3; ddScroll.Size=UDim2.new(1,0,0,160)
ddScroll.BackgroundColor3=CT.DdBg; ddScroll.BorderSizePixel=0; ddScroll.ScrollBarThickness=4
ddScroll.ScrollBarImageColor3=CT.Primary; ddScroll.CanvasSize=UDim2.new(0,0,0,0)
ddScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; ddScroll.Parent=ddCard
Instance.new("UICorner",ddScroll).CornerRadius=UDim.new(0,8)
local ddStroke=Instance.new("UIStroke",ddScroll); ddStroke.Color=CT.Stroke; ddStroke.Thickness=1
local ddLL=Instance.new("UIListLayout",ddScroll); ddLL.Padding=UDim.new(0,2)
local ddPad=Instance.new("UIPadding",ddScroll); ddPad.PaddingLeft=UDim.new(0,5)
ddPad.PaddingRight=UDim.new(0,5); ddPad.PaddingTop=UDim.new(0,4); ddPad.PaddingBottom=UDim.new(0,4)
onTheme(function(t) ddScroll.BackgroundColor3=t.DdBg; ddStroke.Color=t.Stroke; ddScroll.ScrollBarImageColor3=t.Primary end)

-- Selected chips area
mkDivider(ddCard,4)
mkSectionLbl(ddCard,"Selected:",5)
local chipsScroll=Instance.new("ScrollingFrame"); chipsScroll.LayoutOrder=6
chipsScroll.Size=UDim2.new(1,0,0,60); chipsScroll.BackgroundColor3=CT.DdBg; chipsScroll.BorderSizePixel=0
chipsScroll.ScrollBarThickness=3; chipsScroll.ScrollBarImageColor3=CT.Primary
chipsScroll.CanvasSize=UDim2.new(0,0,0,0); chipsScroll.AutomaticCanvasSize=Enum.AutomaticSize.X
chipsScroll.ScrollingDirection=Enum.ScrollingDirection.X; chipsScroll.Parent=ddCard
Instance.new("UICorner",chipsScroll).CornerRadius=UDim.new(0,8)
local chipsStroke=Instance.new("UIStroke",chipsScroll); chipsStroke.Color=CT.Stroke; chipsStroke.Thickness=1
local chipLL=Instance.new("UIListLayout",chipsScroll); chipLL.FillDirection=Enum.FillDirection.Horizontal
chipLL.Padding=UDim.new(0,4); chipLL.VerticalAlignment=Enum.VerticalAlignment.Center
local chipPad=Instance.new("UIPadding",chipsScroll); chipPad.PaddingLeft=UDim.new(0,4)
chipPad.PaddingRight=UDim.new(0,4); chipPad.PaddingTop=UDim.new(0,4); chipPad.PaddingBottom=UDim.new(0,4)
onTheme(function(t) chipsScroll.BackgroundColor3=t.DdBg; chipsStroke.Color=t.Stroke; chipsScroll.ScrollBarImageColor3=t.Primary end)

local function refreshChips()
    for _,c in ipairs(chipsScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for _,name in ipairs(selectedBrainrotOrder) do
        local chip=Instance.new("Frame"); chip.Size=UDim2.new(0,0,0,28); chip.AutomaticSize=Enum.AutomaticSize.X
        chip.BackgroundColor3=CT.Panel; chip.BorderSizePixel=0; chip.Parent=chipsScroll
        Instance.new("UICorner",chip).CornerRadius=UDim.new(0,6)
        local cs2=Instance.new("UIStroke",chip); cs2.Color=CT.Primary; cs2.Thickness=1
        onTheme(function(t) chip.BackgroundColor3=t.Panel; cs2.Color=t.Primary end)
        local chipLL2=Instance.new("UIListLayout",chip); chipLL2.FillDirection=Enum.FillDirection.Horizontal
        chipLL2.VerticalAlignment=Enum.VerticalAlignment.Center; chipLL2.Padding=UDim.new(0,2)
        local cp2=Instance.new("UIPadding",chip); cp2.PaddingLeft=UDim.new(0,6); cp2.PaddingRight=UDim.new(0,4)
        local nl2=Instance.new("TextLabel"); nl2.Size=UDim2.new(0,0,1,0); nl2.AutomaticSize=Enum.AutomaticSize.X
        nl2.BackgroundTransparency=1; nl2.Text=name; nl2.TextColor3=CT.Text
        nl2.Font=Enum.Font.SourceSans; nl2.TextSize=11; nl2.Parent=chip
        onTheme(function(t) nl2.TextColor3=t.Text end)
        local xb=Instance.new("TextButton"); xb.Size=UDim2.new(0,16,1,0); xb.BackgroundTransparency=1
        xb.Text="x"; xb.TextColor3=CT.CloseC; xb.Font=Enum.Font.SourceSansBold; xb.TextSize=11; xb.Parent=chip
        local n2=name
        xb.MouseButton1Click:Connect(function()
            selectedBrainrots[n2]=nil
            for i,v in ipairs(selectedBrainrotOrder) do
                if v==n2 then table.remove(selectedBrainrotOrder,i); break end
            end
            refreshChips()
            -- refresh dd row highlight
            for _,r in ipairs(ddScroll:GetChildren()) do
                if r:IsA("TextButton") and r.Text==n2 then
                    r.BackgroundColor3=CT.DdBg
                    local rl=r:FindFirstChildOfClass("TextLabel"); if rl then rl.TextColor3=CT.TextDim end
                end
            end
        end)
    end
end

local ddRows={}
local function buildDDRows(filter)
    for _,c in ipairs(ddScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    ddRows={}
    for _,name in ipairs(brainrotNames) do
        if filter=="" or name:lower():find(filter:lower(),1,true) then
            local row=Instance.new("TextButton"); row.Size=UDim2.new(1,-4,0,26)
            local sel=selectedBrainrots[name]
            row.BackgroundColor3=sel and CT.TabSel or CT.DdBg; row.Text=""; row.BorderSizePixel=0; row.Parent=ddScroll
            Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
            local lbl2=Instance.new("TextLabel"); lbl2.Size=UDim2.new(1,-8,1,0); lbl2.Position=UDim2.new(0,8,0,0)
            lbl2.BackgroundTransparency=1; lbl2.Text=name
            lbl2.TextColor3=sel and CT.Text or CT.TextDim; lbl2.Font=Enum.Font.SourceSans
            lbl2.TextSize=12; lbl2.TextXAlignment=Enum.TextXAlignment.Left; lbl2.Parent=row
            onTheme(function(t)
                if selectedBrainrots[name] then row.BackgroundColor3=t.TabSel; lbl2.TextColor3=t.Text
                else row.BackgroundColor3=t.DdBg; lbl2.TextColor3=t.TextDim end
            end)
            local rn=name
            row.MouseButton1Click:Connect(function()
                if selectedBrainrots[rn] then
                    selectedBrainrots[rn]=nil
                    for i,v in ipairs(selectedBrainrotOrder) do
                        if v==rn then table.remove(selectedBrainrotOrder,i); break end
                    end
                    TweenService:Create(row,TweenInfo.new(.15),{BackgroundColor3=CT.DdBg}):Play()
                    TweenService:Create(lbl2,TweenInfo.new(.15),{TextColor3=CT.TextDim}):Play()
                else
                    selectedBrainrots[rn]=true
                    table.insert(selectedBrainrotOrder, rn)
                    TweenService:Create(row,TweenInfo.new(.15),{BackgroundColor3=CT.TabSel}):Play()
                    TweenService:Create(lbl2,TweenInfo.new(.15),{TextColor3=CT.Text}):Play()
                end
                refreshChips()
            end)
            table.insert(ddRows,{row=row,lbl=lbl2,name=rn})
        end
    end
end

task.spawn(function() task.wait(.5); buildDDRows("") end)
searchInp:GetPropertyChangedSignal("Text"):Connect(function() buildDDRows(searchInp.Text) end)

-- ============================================================
-- SPAWN DETECTOR & HIGHLIGHT & TELEPORT LOGIC
-- ============================================================
local function cleanBrainrotHighlights()
    for _,h in pairs(brainrotHighlights) do pcall(function() h:Destroy() end) end
    brainrotHighlights={}
end

local function addHighlight(model, name)
    if brainrotHighlights[name] then return end
    local h=Instance.new("SelectionBox"); h.Adornee=model
    h.Color3=CT.Primary; h.LineThickness=0.06; h.SurfaceTransparency=0.7
    h.SurfaceColor3=CT.Primary; h.Parent=workspace
    brainrotHighlights[name]=h
    onTheme(function(t) h.Color3=t.Primary; h.SurfaceColor3=t.Primary end)
end

local function setupSpawnDetector()
    if spawnWatchConn then spawnWatchConn:Disconnect(); spawnWatchConn=nil end
    if spawnWatchConn2 then spawnWatchConn2:Disconnect(); spawnWatchConn2=nil end
    local function onModelAdded(m)
        if not selectedBrainrots[m.Name] then return end
        showSpawnNotif(m.Name)
        if hlBrainrotsEnabled then addHighlight(m, m.Name) end
        if teleportEnabled then
            local char=LP.Character
            if char then
                local hrp=char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos=m:GetBoundingBox()
                    hrp.CFrame=pos*CFrame.new(0,4,0)
                end
            end
        end
    end
    local ok,bfolder=pcall(function()
        return workspace:WaitForChild("GameFolder",5):WaitForChild("Brainrots",5)
    end)
    if ok and bfolder then
        spawnWatchConn=bfolder.ChildAdded:Connect(onModelAdded)
        spawnWatchConn2=bfolder.DescendantAdded:Connect(function(d)
            if d:IsA("Model") then onModelAdded(d) end
        end)
        -- check already existing
        for _,m in ipairs(bfolder:GetDescendants()) do
            if m:IsA("Model") and selectedBrainrots[m.Name] then
                if hlBrainrotsEnabled then addHighlight(m, m.Name) end
            end
        end
    end
end
task.spawn(setupSpawnDetector)

-- Auto Collect Cash toggle
mkDivider(mp,7)
local function doAutoCollect(enabled)
    if autoCollectThread then
        task.cancel(autoCollectThread)
        autoCollectThread=nil
    end
    if not enabled then return end
    autoCollectThread=task.spawn(function()
        while autoCollectEnabled do
            pcall(function()
                local char=LP.Character
                local hrp=char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then task.wait(1); return end
                local plotsFolder=workspace:FindFirstChild("GameFolder")
                if not plotsFolder then task.wait(1); return end
                local plots=plotsFolder:FindFirstChild("Plots")
                if not plots then task.wait(1); return end
                local function deepSearch(inst, className, results)
                    results=results or {}
                    for _,c in ipairs(inst:GetChildren()) do
                        if c:IsA(className) then table.insert(results,c)
                        elseif c:IsA("Instance") then deepSearch(c,className,results) end
                    end
                    return results
                end
                -- Find YourBaseAtt attachment
                local atts=deepSearch(plots,"Attachment")
                for _,att in ipairs(atts) do
                    if att.Name=="YourBaseAtt" then
                        -- Find Title textlabel
                        local titles=deepSearch(att,"TextLabel")
                        for _,tl in ipairs(titles) do
                            if tl.Name=="Title" and tl.Text=="YOUR BASE" then
                                -- Go to att's model ancestor
                                local model=att
                                while model and not model:IsA("Model") do model=model.Parent end
                                if model then
                                    local placesFolder=model:FindFirstChild("Places")
                                    if placesFolder then
                                        local tis=deepSearch(placesFolder,"TouchTransmitter")
                                        for _,ti in ipairs(tis) do
                                            pcall(firetouchinterest, ti.Parent, hrp, 0)
                                            pcall(firetouchinterest, ti.Parent, hrp, 1)
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

local acRow,_,acGet=mkToggle(mp,"Auto Collect Cash",8,false,function(on)
    autoCollectEnabled=on
    doAutoCollect(on)
    notify("Auto Collect Cash "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)

-- ============================================================
-- PLAYER TAB
-- ============================================================
local pp=tabs["Player"]

-- Speed boost
local spCard=mkCard(pp,1)
mkSectionLbl(spCard,"Speed",1)
local spRow,spSet,spGet=mkToggle(spCard,"Speed Boost",2,false,function(on)
    speedEnabled=on
    if on then
        local char=LP.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        hum.WalkSpeed=speedVal
    else
        pcall(function()
            local sl=LP.PlayerGui:WaitForChild("HUD",2):WaitForChild("Speed",2)
            local digits=tonumber(sl.Text:match("%d+%.?%d*")) or 16
            local char=LP.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            hum.WalkSpeed=digits
        end)
    end
    notify("Speed Boost "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)
local maxSpeedBg,maxSpeedInp=mkInputBox(spCard,"Max speed (default 100)",3)
local _,spSlSet,spSlGet,spSlSetMax=mkSlider(spCard,"Speed Value",16,100,16,4,function(v)
    speedVal=v
    if speedEnabled then
        pcall(function()
            local char=LP.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            hum.WalkSpeed=v
        end)
    end
end)
maxSpeedInp.FocusLost:Connect(function()
    local n=tonumber(maxSpeedInp.Text)
    if n and n>=16 then speedMax=n; spSlSetMax(n) end
end)

-- Jump boost
mkDivider(pp,2)
local jpCard=mkCard(pp,3)
mkSectionLbl(jpCard,"Jump",1)
local jpRow,jpSet,jpGet=mkToggle(jpCard,"Jump Boost",2,false,function(on)
    jumpEnabled=on
    if on then
        local char=LP.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        hum.JumpPower=jumpVal
    else
        pcall(function()
            local sl=LP.PlayerGui:WaitForChild("HUD",2):WaitForChild("Jump",2)
            local digits=tonumber(sl.Text:match("%d+%.?%d*")) or 0
            local val=30+(digits*(10/3))
            local char=LP.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            hum.JumpPower=val
        end)
    end
    notify("Jump Boost "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)
local _,jpSlSet,jpSlGet=mkSlider(jpCard,"Jump Power",30,200,50,3,function(v)
    jumpVal=v
    if jumpEnabled then
        pcall(function()
            local char=LP.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            hum.JumpPower=v
        end)
    end
end)

-- Godmode
mkDivider(pp,4)
local gmCard=mkCard(pp,5)
mkSectionLbl(gmCard,"Godmode",1)
local gmRow,gmSet,gmGet=mkToggle(gmCard,"Godmode (Lava)",2,false,function(on)
    godmodeEnabled=on
    pcall(function()
        local lavas=workspace:FindFirstChild("GameFolder"):FindFirstChild("Lavas")
        if not lavas then return end
        for _,part in ipairs(lavas:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanTouch=not on end)
            end
        end
    end)
    notify("Godmode "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)

-- Flight
mkDivider(pp,6)
local flCard=mkCard(pp,7)
mkSectionLbl(flCard,"Flight",1)

-- Mobile flight controls (on-screen arrows)
local flMobileGui=Instance.new("ScreenGui")
flMobileGui.Name="PC_FlightMobile"; flMobileGui.IgnoreGuiInset=true; flMobileGui.ResetOnSpawn=false
pcall(function() flMobileGui.Parent=CoreGui end)
local flMobileFrame=Instance.new("Frame")
flMobileFrame.Size=UDim2.new(0,130,0,130); flMobileFrame.AnchorPoint=Vector2.new(1,1)
flMobileFrame.Position=UDim2.new(1,-20,1,-20); flMobileFrame.BackgroundTransparency=1
flMobileFrame.Visible=false; flMobileFrame.Parent=flMobileGui

local flDir={up=false,down=false}
local function mkFlBtn(pos,lbl,onDown,onUp)
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,44,0,44)
    b.Position=pos; b.BackgroundColor3=CT.Panel; b.Text=lbl
    b.TextColor3=CT.Text; b.Font=Enum.Font.SourceSansBold; b.TextSize=14
    b.BackgroundTransparency=0.2; b.ZIndex=200; b.Parent=flMobileFrame
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    local s2=Instance.new("UIStroke",b); s2.Color=CT.Primary; s2.Thickness=1.5
    onTheme(function(t) b.BackgroundColor3=t.Panel; s2.Color=t.Primary; b.TextColor3=t.Text end)
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then onDown() end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then onUp() end
    end)
    return b
end
mkFlBtn(UDim2.new(0,43,0,0),"▲",function() flDir.up=true end,function() flDir.up=false end)
mkFlBtn(UDim2.new(0,43,0,86),"▼",function() flDir.down=true end,function() flDir.down=false end)

local flightSpeed=60
local flConn=nil
local flRow,flSet,flGet=mkToggle(flCard,"Flight",2,false,function(on)
    flightEnabled=on
    if flConn then flConn:Disconnect(); flConn=nil end
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if on then
        flMobileFrame.Visible=true
        if hum then hum.PlatformStand=true end
        flConn=RunService.RenderStepped:Connect(function(dt)
            local ch=LP.Character
            local hrp2=ch and ch:FindFirstChild("HumanoidRootPart")
            local hum2=ch and ch:FindFirstChildOfClass("Humanoid")
            if not hrp2 or not hum2 then return end
            hum2.PlatformStand=true
            local camCF=Camera.CFrame
            local fwd=camCF.LookVector
            local right=camCF.RightVector
            local inp=Vector3.zero
            -- Keyboard WASD
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then inp=inp+fwd end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then inp=inp-fwd end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then inp=inp-right end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then inp=inp+right end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or flDir.up then inp=inp+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or flDir.down then inp=inp-Vector3.new(0,1,0) end
            if inp.Magnitude>0 then inp=inp.Unit end
            hrp2.AssemblyLinearVelocity=inp*flightSpeed
            hrp2.CFrame=CFrame.new(hrp2.Position,hrp2.Position+Vector3.new(fwd.X,0,fwd.Z))
        end)
    else
        flMobileFrame.Visible=false
        if flConn then flConn:Disconnect(); flConn=nil end
        if hum then hum.PlatformStand=false end
        if hrp then hrp.AssemblyLinearVelocity=Vector3.zero end
    end
    notify("Flight "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)

-- Re-apply on character respawn
LP.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    if speedEnabled then
        local hum=char:WaitForChild("Humanoid",5)
        if hum then hum.WalkSpeed=speedVal end
    end
    if jumpEnabled then
        local hum=char:WaitForChild("Humanoid",5)
        if hum then hum.JumpPower=jumpVal end
    end
    if flightEnabled then
        local hum=char:WaitForChild("Humanoid",5)
        if hum then hum.PlatformStand=true end
    end
    if godmodeEnabled then
        pcall(function()
            local lavas=workspace:FindFirstChild("GameFolder"):FindFirstChild("Lavas")
            if lavas then
                for _,part in ipairs(lavas:GetDescendants()) do
                    if part:IsA("BasePart") then pcall(function() part.CanTouch=false end) end
                end
            end
        end)
    end
end)

-- Teleport toggle
mkDivider(pp,8)
local tpCard=mkCard(pp,9)
mkSectionLbl(tpCard,"Teleport",1)
local tpRow,tpSet,tpGet=mkToggle(tpCard,"Teleport to Spawned Brainrot",2,false,function(on)
    teleportEnabled=on
    notify("Brainrot Teleport "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)

-- ============================================================
-- VISUAL TAB
-- ============================================================
local vp=tabs["Visual"]

-- Highlight brainrots
local hlCard=mkCard(vp,1)
mkSectionLbl(hlCard,"Brainrot Highlight",1)
local hlRow,hlSet,hlGet=mkToggle(hlCard,"Highlight Selected Brainrots",2,false,function(on)
    hlBrainrotsEnabled=on
    if not on then cleanBrainrotHighlights()
    else
        pcall(function()
            local bf=workspace:FindFirstChild("GameFolder"):FindFirstChild("Brainrots")
            if bf then
                for _,m in ipairs(bf:GetDescendants()) do
                    if m:IsA("Model") and selectedBrainrots[m.Name] then addHighlight(m,m.Name) end
                end
            end
        end)
    end
    notify("Brainrot Highlight "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)

-- Highlight players
mkDivider(vp,2)
local hlpCard=mkCard(vp,3)
mkSectionLbl(hlpCard,"Player Highlight",1)

local function cleanPlayerBillboards()
    for _,g in pairs(playerBillboards) do pcall(function() g:Destroy() end) end
    playerBillboards={}
end

local function setupPlayerBillboards()
    cleanPlayerBillboards()
    if not hlPlayersEnabled then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local function addBB()
                pcall(function()
                    local char=plr.Character; if not char then return end
                    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                    local existing=char:FindFirstChild("PC_PlayerBB"); if existing then existing:Destroy() end
                    local bb=Instance.new("BillboardGui"); bb.Name="PC_PlayerBB"
                    bb.Size=UDim2.new(0,140,0,44); bb.StudsOffset=Vector3.new(0,3,0)
                    bb.Adornee=hrp; bb.AlwaysOnTop=true; bb.Parent=char
                    local bg2=Instance.new("Frame"); bg2.Size=UDim2.fromScale(1,1)
                    bg2.BackgroundColor3=CT.Panel; bg2.BackgroundTransparency=0.15
                    bg2.BorderSizePixel=0; bg2.Parent=bb
                    Instance.new("UICorner",bg2).CornerRadius=UDim.new(0,8)
                    local s3=Instance.new("UIStroke",bg2); s3.Color=CT.Primary; s3.Thickness=1.5
                    onTheme(function(t) bg2.BackgroundColor3=t.Panel; s3.Color=t.Primary end)
                    local nl3=Instance.new("TextLabel"); nl3.Size=UDim2.new(1,0,.5,0)
                    nl3.BackgroundTransparency=1; nl3.Text=plr.DisplayName; nl3.TextColor3=CT.Text
                    nl3.Font=Enum.Font.SourceSansBold; nl3.TextSize=12; nl3.Parent=bg2
                    onTheme(function(t) nl3.TextColor3=t.Text end)
                    local dl=Instance.new("TextLabel"); dl.Size=UDim2.new(1,0,.5,0); dl.Position=UDim2.new(0,0,.5,0)
                    dl.BackgroundTransparency=1; dl.Text="? studs"; dl.TextColor3=CT.TextDim
                    dl.Font=Enum.Font.SourceSans; dl.TextSize=11; dl.Parent=bg2
                    onTheme(function(t) dl.TextColor3=t.TextDim end)
                    playerBillboards[plr]=bb
                    RunService.RenderStepped:Connect(function()
                        if not hlPlayersEnabled or not char or not char.Parent then return end
                        local myChar=LP.Character
                        local myHrp=myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myHrp and hrp then
                            local dist=math.floor((hrp.Position-myHrp.Position).Magnitude)
                            dl.Text=dist.." studs"
                        end
                    end)
                end)
            end
            addBB()
            plr.CharacterAdded:Connect(function() task.wait(.5); addBB() end)
        end
    end
end

local hlpRow,hlpSet,hlpGet=mkToggle(hlpCard,"Highlight Other Players",2,false,function(on)
    hlPlayersEnabled=on
    if on then setupPlayerBillboards()
    else cleanPlayerBillboards() end
    notify("Player Highlight "..(on and "Enabled!" or "Disabled!"), on and CT.Primary or CT.TextDim)
end)

Players.PlayerAdded:Connect(function(plr)
    if not hlPlayersEnabled then return end
    plr.CharacterAdded:Connect(function() task.wait(.5); setupPlayerBillboards() end)
end)
Players.PlayerRemoving:Connect(function(plr)
    if playerBillboards[plr] then pcall(function() playerBillboards[plr]:Destroy() end); playerBillboards[plr]=nil end
end)

-- ============================================================
-- SETTINGS TAB
-- ============================================================
local sep=tabs["Settings"]

-- Theme dropdown
local thCard=mkCard(sep,1)
mkSectionLbl(thCard,"UI Theme",1)

local themeNames={"Original","Sky","Lava"}
if Themes.Custom then table.insert(themeNames,"Custom") end
local thSelected=CTN

local thDdContainer=Instance.new("Frame"); thDdContainer.LayoutOrder=2; thDdContainer.Size=UDim2.new(1,0,0,0)
thDdContainer.AutomaticSize=Enum.AutomaticSize.Y; thDdContainer.BackgroundTransparency=1; thDdContainer.Parent=thCard
local thDdLL=Instance.new("UIListLayout",thDdContainer); thDdLL.Padding=UDim.new(0,4)

local thDdBtn=Instance.new("TextButton"); thDdBtn.Size=UDim2.new(1,0,0,32)
thDdBtn.BackgroundColor3=CT.DdBg; thDdBtn.BorderSizePixel=0; thDdBtn.Text=""
thDdBtn.ZIndex=5; thDdBtn.Parent=thDdContainer
Instance.new("UICorner",thDdBtn).CornerRadius=UDim.new(0,8)
local thDdStroke=Instance.new("UIStroke",thDdBtn); thDdStroke.Color=CT.Stroke; thDdStroke.Thickness=1
onTheme(function(t) thDdBtn.BackgroundColor3=t.DdBg; thDdStroke.Color=t.Stroke end)
local thDdLbl=Instance.new("TextLabel"); thDdLbl.Size=UDim2.new(1,-30,1,0); thDdLbl.Position=UDim2.new(0,10,0,0)
thDdLbl.BackgroundTransparency=1; thDdLbl.Text=thSelected; thDdLbl.TextColor3=CT.Text
thDdLbl.Font=Enum.Font.SourceSansBold; thDdLbl.TextSize=13; thDdLbl.TextXAlignment=Enum.TextXAlignment.Left
thDdLbl.ZIndex=6; thDdLbl.Parent=thDdBtn
onTheme(function(t) thDdLbl.TextColor3=t.Text end)
local thDdArrow=Instance.new("TextLabel"); thDdArrow.Size=UDim2.new(0,24,1,0); thDdArrow.AnchorPoint=Vector2.new(1,.5)
thDdArrow.Position=UDim2.new(1,-4,.5,0); thDdArrow.BackgroundTransparency=1; thDdArrow.Text="v"
thDdArrow.TextColor3=CT.TextDim; thDdArrow.Font=Enum.Font.SourceSansBold; thDdArrow.TextSize=12
thDdArrow.ZIndex=6; thDdArrow.Parent=thDdBtn
onTheme(function(t) thDdArrow.TextColor3=t.TextDim end)

local thList=Instance.new("Frame"); thList.Size=UDim2.new(1,0,0,0); thList.AutomaticSize=Enum.AutomaticSize.Y
thList.BackgroundColor3=CT.DdBg; thList.BorderSizePixel=0; thList.Visible=false; thList.ZIndex=20
thList.Parent=thDdContainer
Instance.new("UICorner",thList).CornerRadius=UDim.new(0,8)
local thListStroke=Instance.new("UIStroke",thList); thListStroke.Color=CT.Stroke; thListStroke.Thickness=1
local thListLL=Instance.new("UIListLayout",thList); thListLL.Padding=UDim.new(0,2)
local thListPad=Instance.new("UIPadding",thList); thListPad.PaddingAll=UDim.new(0,4)
onTheme(function(t) thList.BackgroundColor3=t.DdBg; thListStroke.Color=t.Stroke end)

local thListOpen=false
thDdBtn.MouseButton1Click:Connect(function()
    thListOpen=not thListOpen; thList.Visible=thListOpen
    TweenService:Create(thDdArrow,TweenInfo.new(.15),{Rotation=thListOpen and 180 or 0}):Play()
end)

local function buildThemeList()
    for _,c in ipairs(thList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _,tn in ipairs(themeNames) do
        local r=Instance.new("TextButton"); r.Size=UDim2.new(1,0,0,28)
        r.BackgroundColor3=thSelected==tn and CT.TabSel or CT.DdBg; r.BorderSizePixel=0; r.Text=""
        r.ZIndex=21; r.Parent=thList
        Instance.new("UICorner",r).CornerRadius=UDim.new(0,6)
        local rl=Instance.new("TextLabel"); rl.Size=UDim2.new(1,-8,1,0); rl.Position=UDim2.new(0,8,0,0)
        rl.BackgroundTransparency=1; rl.Text=tn; rl.TextColor3=thSelected==tn and CT.Text or CT.TextDim
        rl.Font=Enum.Font.SourceSans; rl.TextSize=12; rl.TextXAlignment=Enum.TextXAlignment.Left; rl.ZIndex=22; rl.Parent=r
        local tname=tn
        onTheme(function(t)
            r.BackgroundColor3=thSelected==tname and t.TabSel or t.DdBg
            rl.TextColor3=thSelected==tname and t.Text or t.TextDim
        end)
        r.MouseButton1Click:Connect(function()
            thSelected=tname; thDdLbl.Text=tname
            applyTheme(tname)
            thList.Visible=false; thListOpen=false
            TweenService:Create(thDdArrow,TweenInfo.new(.15),{Rotation=0}):Play()
            buildThemeList()
            notify("Theme changed to "..tname.."!", CT.Primary)
        end)
    end
end
buildThemeList()

-- Custom theme button
mkDivider(thCard,3)
local customHintLbl=Instance.new("TextLabel"); customHintLbl.LayoutOrder=4; customHintLbl.Size=UDim2.new(1,0,0,0)
customHintLbl.AutomaticSize=Enum.AutomaticSize.Y; customHintLbl.BackgroundTransparency=1
customHintLbl.Text="Can't Find The Theme You Want? Click below to Customise the UI to your liking!"
customHintLbl.TextColor3=CT.TextDim; customHintLbl.Font=Enum.Font.SourceSans; customHintLbl.TextSize=12
customHintLbl.TextWrapped=true; customHintLbl.TextXAlignment=Enum.TextXAlignment.Left; customHintLbl.Parent=thCard
onTheme(function(t) customHintLbl.TextColor3=t.TextDim end)

local customBtn=Instance.new("TextButton"); customBtn.LayoutOrder=5; customBtn.Size=UDim2.new(1,0,0,32)
customBtn.BackgroundColor3=CT.Primary; customBtn.Text="Customise UI Colors"
customBtn.TextColor3=C(255,255,255); customBtn.Font=Enum.Font.SourceSansBold; customBtn.TextSize=13
customBtn.BorderSizePixel=0; customBtn.Parent=thCard
Instance.new("UICorner",customBtn).CornerRadius=UDim.new(0,8)
onTheme(function(t) customBtn.BackgroundColor3=t.Primary end)

-- Custom Color Picker Dialog
local customPickerOpen=false
local colorPickerGui=nil
local colorKeys={"Bg","BgS","Panel","Sidebar","Primary","Text","TextDim","Stroke","TogOn","TogOff","SlFill","SlBg","DdBg","TabSel","TabUns","GStart","GEnd","TogBtn","CardBg"}
local selectedColorKey="Primary"
local pickerRGB={r=0,g=200,b=100}
local tempCustomTheme={}

customBtn.MouseButton1Click:Connect(function()
    if customPickerOpen then return end
    customPickerOpen=true
    -- init temp from current CT
    for _,k in ipairs(colorKeys) do
        local c2=CT[k] or C(0,0,0)
        tempCustomTheme[k]={math.floor(c2.R*255),math.floor(c2.G*255),math.floor(c2.B*255)}
    end
    -- Build picker UI
    local pickerBg=Instance.new("Frame"); pickerBg.Size=UDim2.fromScale(1,1)
    pickerBg.BackgroundColor3=C(0,0,0); pickerBg.BackgroundTransparency=.45; pickerBg.ZIndex=300; pickerBg.Parent=MG
    local pickerPanel=Instance.new("Frame"); pickerPanel.AnchorPoint=Vector2.new(.5,.5)
    pickerPanel.Position=UDim2.fromScale(.5,.5); pickerPanel.Size=UDim2.new(.88,0,.85,0)
    pickerPanel.BackgroundColor3=CT.Panel; pickerPanel.BorderSizePixel=0; pickerPanel.ZIndex=301; pickerPanel.Parent=pickerBg
    Instance.new("UICorner",pickerPanel).CornerRadius=UDim.new(0,14)
    local ps=Instance.new("UIStroke",pickerPanel); ps.Color=CT.Stroke; ps.Thickness=2
    onTheme(function(t) pickerPanel.BackgroundColor3=t.Panel; ps.Color=t.Stroke end)
    local pll=Instance.new("UIListLayout",pickerPanel); pll.Padding=UDim.new(0,8)
    local pp2=Instance.new("UIPadding",pickerPanel); pp2.PaddingAll=UDim.new(0,12)
    -- Title row
    local ptRow=Instance.new("Frame"); ptRow.Size=UDim2.new(1,0,0,28); ptRow.BackgroundTransparency=1; ptRow.ZIndex=302; ptRow.Parent=pickerPanel
    local ptl=Instance.new("TextLabel"); ptl.Size=UDim2.new(1,-32,1,0); ptl.BackgroundTransparency=1
    ptl.Text="Customise UI Colors"; ptl.TextColor3=CT.Text; ptl.Font=Enum.Font.SourceSansBold
    ptl.TextSize=15; ptl.TextXAlignment=Enum.TextXAlignment.Left; ptl.ZIndex=303; ptl.Parent=ptRow
    onTheme(function(t) ptl.TextColor3=t.Text end)
    local pClose=Instance.new("TextButton"); pClose.Size=UDim2.new(0,26,0,26); pClose.AnchorPoint=Vector2.new(1,.5)
    pClose.Position=UDim2.new(1,0,.5,0); pClose.BackgroundColor3=CT.CloseC; pClose.Text="X"
    pClose.TextColor3=C(255,255,255); pClose.Font=Enum.Font.SourceSansBold; pClose.TextSize=13
    pClose.BorderSizePixel=0; pClose.ZIndex=303; pClose.Parent=ptRow
    Instance.new("UICorner",pClose).CornerRadius=UDim.new(0,6)
    pClose.MouseButton1Click:Connect(function() customPickerOpen=false; pickerBg:Destroy() end)
    -- Content row (key list + color input)
    local contentRow=Instance.new("Frame"); contentRow.Size=UDim2.new(1,0,1,-100); contentRow.BackgroundTransparency=1
    contentRow.ZIndex=302; contentRow.Parent=pickerPanel
    -- Key list
    local keyScroll=Instance.new("ScrollingFrame"); keyScroll.Size=UDim2.new(.4,0,1,0)
    keyScroll.BackgroundColor3=CT.DdBg; keyScroll.BorderSizePixel=0; keyScroll.ScrollBarThickness=3
    keyScroll.ScrollBarImageColor3=CT.Primary; keyScroll.CanvasSize=UDim2.new(0,0,0,0)
    keyScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; keyScroll.ZIndex=303; keyScroll.Parent=contentRow
    Instance.new("UICorner",keyScroll).CornerRadius=UDim.new(0,8)
    local ksLL=Instance.new("UIListLayout",keyScroll); ksLL.Padding=UDim.new(0,3)
    local ksPad=Instance.new("UIPadding",keyScroll); ksPad.PaddingAll=UDim.new(0,4)
    onTheme(function(t) keyScroll.BackgroundColor3=t.DdBg; keyScroll.ScrollBarImageColor3=t.Primary end)
    -- Color input side
    local colorSide=Instance.new("Frame"); colorSide.Size=UDim2.new(.58,-8,1,0); colorSide.Position=UDim2.new(.42,8,0,0)
    colorSide.BackgroundTransparency=1; colorSide.ZIndex=303; colorSide.Parent=contentRow
    local csLL=Instance.new("UIListLayout",colorSide); csLL.Padding=UDim.new(0,6)
    -- Preview swatch
    local swatchFrame=Instance.new("Frame"); swatchFrame.Size=UDim2.new(1,0,0,40); swatchFrame.BackgroundTransparency=1; swatchFrame.ZIndex=304; swatchFrame.Parent=colorSide
    local swatch=Instance.new("Frame"); swatch.Size=UDim2.new(1,0,1,0)
    swatch.BackgroundColor3=C(0,200,100); swatch.BorderSizePixel=0; swatch.ZIndex=305; swatch.Parent=swatchFrame
    Instance.new("UICorner",swatch).CornerRadius=UDim.new(0,8)
    local swatchLbl=Instance.new("TextLabel"); swatchLbl.Size=UDim2.fromScale(1,1)
    swatchLbl.BackgroundTransparency=1; swatchLbl.Text="Preview"; swatchLbl.TextColor3=C(255,255,255)
    swatchLbl.Font=Enum.Font.SourceSansBold; swatchLbl.TextSize=12; swatchLbl.ZIndex=306; swatchLbl.Parent=swatch
    -- Hex input
    local function mkColorInput(lbl3, ph, sz, ord)
        local rw=Instance.new("Frame"); rw.Size=UDim2.new(1,0,0,24); rw.BackgroundTransparency=1; rw.ZIndex=304; rw.Parent=colorSide; rw.LayoutOrder=ord
        local la=Instance.new("TextLabel"); la.Size=UDim2.new(.35,0,1,0); la.BackgroundTransparency=1
        la.Text=lbl3; la.TextColor3=CT.TextDim; la.Font=Enum.Font.SourceSans; la.TextSize=11
        la.TextXAlignment=Enum.TextXAlignment.Left; la.ZIndex=305; la.Parent=rw
        onTheme(function(t) la.TextColor3=t.TextDim end)
        local inpBg=Instance.new("Frame"); inpBg.Size=UDim2.new(.65,-4,1,0); inpBg.Position=UDim2.new(.35,4,0,0)
        inpBg.BackgroundColor3=CT.DdBg; inpBg.BorderSizePixel=0; inpBg.ZIndex=305; inpBg.Parent=rw
        Instance.new("UICorner",inpBg).CornerRadius=UDim.new(0,6)
        local ib=Instance.new("UIStroke",inpBg); ib.Color=CT.Stroke; ib.Thickness=1
        onTheme(function(t) inpBg.BackgroundColor3=t.DdBg; ib.Color=t.Stroke end)
        local inp2=Instance.new("TextBox"); inp2.Size=UDim2.new(1,-8,1,0); inp2.Position=UDim2.new(0,4,0,0)
        inp2.BackgroundTransparency=1; inp2.PlaceholderText=ph; inp2.Text=tostring(sz)
        inp2.TextColor3=CT.Text; inp2.PlaceholderColor3=CT.TextDim; inp2.Font=Enum.Font.SourceSans
        inp2.TextSize=12; inp2.ZIndex=306; inp2.Parent=inpBg
        onTheme(function(t) inp2.TextColor3=t.Text; inp2.PlaceholderColor3=t.TextDim end)
        return inp2
    end
    local inpR=mkColorInput("R","0-255",0,2)
    local inpG=mkColorInput("G","0-255",0,3)
    local inpB=mkColorInput("B","0-255",0,4)
    -- Hex
    local inpHex=mkColorInput("#HEX","e.g. 00C864",0,5)
    local function updateSwatch()
        local r2=math.clamp(pickerRGB.r,0,255); local g2=math.clamp(pickerRGB.g,0,255); local b2=math.clamp(pickerRGB.b,0,255)
        swatch.BackgroundColor3=C(r2,g2,b2)
        inpR.Text=tostring(r2); inpG.Text=tostring(g2); inpB.Text=tostring(b2)
        inpHex.Text=string.format("%02X%02X%02X",r2,g2,b2)
    end
    local function setFromRGB(r2,g2,b2)
        pickerRGB.r=r2; pickerRGB.g=g2; pickerRGB.b=b2; updateSwatch()
    end
    inpR.FocusLost:Connect(function() local n=tonumber(inpR.Text); if n then pickerRGB.r=math.clamp(n,0,255); updateSwatch() end end)
    inpG.FocusLost:Connect(function() local n=tonumber(inpG.Text); if n then pickerRGB.g=math.clamp(n,0,255); updateSwatch() end end)
    inpB.FocusLost:Connect(function() local n=tonumber(inpB.Text); if n then pickerRGB.b=math.clamp(n,0,255); updateSwatch() end end)
    inpHex.FocusLost:Connect(function()
        local h=inpHex.Text:gsub("#","")
        if #h>=6 then
            local r2=tonumber(h:sub(1,2),16); local g2=tonumber(h:sub(3,4),16); local b2=tonumber(h:sub(5,6),16)
            if r2 and g2 and b2 then setFromRGB(r2,g2,b2) end
        end
    end)
    -- Apply button
    local applyColorBtn=Instance.new("TextButton"); applyColorBtn.Size=UDim2.new(1,0,0,28); applyColorBtn.LayoutOrder=6
    applyColorBtn.BackgroundColor3=CT.Primary; applyColorBtn.Text="Apply to "..selectedColorKey
    applyColorBtn.TextColor3=C(255,255,255); applyColorBtn.Font=Enum.Font.SourceSansBold; applyColorBtn.TextSize=12
    applyColorBtn.BorderSizePixel=0; applyColorBtn.ZIndex=304; applyColorBtn.Parent=colorSide
    Instance.new("UICorner",applyColorBtn).CornerRadius=UDim.new(0,8)
    onTheme(function(t) applyColorBtn.BackgroundColor3=t.Primary end)
    applyColorBtn.MouseButton1Click:Connect(function()
        tempCustomTheme[selectedColorKey]={pickerRGB.r,pickerRGB.g,pickerRGB.b}
    end)
    -- Save button
    local saveColorBtn=Instance.new("TextButton"); saveColorBtn.Size=UDim2.new(1,0,0,28); saveColorBtn.LayoutOrder=7
    saveColorBtn.BackgroundColor3=C(0,180,80); saveColorBtn.Text="Save & Apply Custom Theme"
    saveColorBtn.TextColor3=C(255,255,255); saveColorBtn.Font=Enum.Font.SourceSansBold; saveColorBtn.TextSize=12
    saveColorBtn.BorderSizePixel=0; saveColorBtn.ZIndex=304; saveColorBtn.Parent=colorSide
    Instance.new("UICorner",saveColorBtn).CornerRadius=UDim.new(0,8)
    saveColorBtn.MouseButton1Click:Connect(function()
        local customT={}
        for k,v in pairs(tempCustomTheme) do customT[k]=C(v[1],v[2],v[3]) end
        for k,v in pairs(Themes.Original) do if not customT[k] then customT[k]=v end end
        Themes.Custom=customT
        -- Save to file
        local saveData={}
        for k,v in pairs(tempCustomTheme) do saveData[k]=v end
        pcall(function() safeWrite("ProjectCrafted/configs/customtheme.txt", HttpService:JSONEncode(saveData)) end)
        -- Add to dropdown if not present
        local found=false
        for _,tn in ipairs(themeNames) do if tn=="Custom" then found=true; break end end
        if not found then table.insert(themeNames,"Custom") end
        thSelected="Custom"; thDdLbl.Text="Custom"
        applyTheme("Custom")
        buildThemeList()
        customPickerOpen=false; pickerBg:Destroy()
        notify("Custom theme saved & applied!", CT.Primary)
    end)
    -- Build key list
    local function buildKeyList()
        for _,c2 in ipairs(keyScroll:GetChildren()) do if c2:IsA("TextButton") then c2:Destroy() end end
        for _,k in ipairs(colorKeys) do
            local kr=Instance.new("TextButton"); kr.Size=UDim2.new(1,0,0,24)
            kr.BackgroundColor3=selectedColorKey==k and CT.TabSel or CT.DdBg
            kr.BorderSizePixel=0; kr.Text=""; kr.ZIndex=305; kr.Parent=keyScroll
            Instance.new("UICorner",kr).CornerRadius=UDim.new(0,6)
            local colorDot=Instance.new("Frame"); colorDot.Size=UDim2.new(0,14,0,14)
            colorDot.AnchorPoint=Vector2.new(0,.5); colorDot.Position=UDim2.new(0,4,.5,0)
            colorDot.BorderSizePixel=0; colorDot.ZIndex=306; colorDot.Parent=kr
            Instance.new("UICorner",colorDot).CornerRadius=UDim.new(1,0)
            local kv=tempCustomTheme[k] or {0,200,100}
            colorDot.BackgroundColor3=C(kv[1],kv[2],kv[3])
            local kl=Instance.new("TextLabel"); kl.Size=UDim2.new(1,-22,1,0); kl.Position=UDim2.new(0,22,0,0)
            kl.BackgroundTransparency=1; kl.Text=k; kl.TextColor3=selectedColorKey==k and CT.Text or CT.TextDim
            kl.Font=Enum.Font.SourceSans; kl.TextSize=11; kl.TextXAlignment=Enum.TextXAlignment.Left; kl.ZIndex=306; kl.Parent=kr
            local kname=k
            kr.MouseButton1Click:Connect(function()
                selectedColorKey=kname
                local kv2=tempCustomTheme[kname] or {0,200,100}
                setFromRGB(kv2[1],kv2[2],kv2[3])
                applyColorBtn.Text="Apply to "..kname
                buildKeyList()
            end)
        end
    end
    buildKeyList()
    -- init swatch
    local initKV=tempCustomTheme[selectedColorKey] or {0,200,100}
    setFromRGB(initKV[1],initKV[2],initKV[3])
end)

-- ============================================================
-- TOGGLE BUTTON (Open/Close, avoids other GUI)
-- ============================================================
local togGui=Instance.new("ScreenGui")
togGui.Name="PC_ToggleGui"; togGui.ResetOnSpawn=false; togGui.IgnoreGuiInset=true
togGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() togGui.Parent=CoreGui end)

local togBtn=Instance.new("TextButton")
togBtn.Size=UDim2.new(0,120,0,34); togBtn.AnchorPoint=Vector2.new(.5,0)
togBtn.BackgroundColor3=CT.TogBtn; togBtn.Text="Project Crafted"
togBtn.TextColor3=C(255,255,255); togBtn.Font=Enum.Font.SourceSansBold; togBtn.TextSize=12
togBtn.BorderSizePixel=0; togBtn.ZIndex=1000
Instance.new("UICorner",togBtn).CornerRadius=UDim.new(0,8)
local togBtnGrd=Instance.new("UIGradient",togBtn)
togBtnGrd.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CT.GStart),ColorSequenceKeypoint.new(1,CT.GEnd)})
togBtnGrd.Rotation=135
local togBtnStr=Instance.new("UIStroke",togBtn); togBtnStr.Color=C(255,255,255); togBtnStr.Thickness=1.5
togBtnStr.Transparency=0.6
onTheme(function(t)
    togBtn.BackgroundColor3=t.TogBtn
    togBtnGrd.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,t.GStart),ColorSequenceKeypoint.new(1,t.GEnd)})
end)
togBtn.Parent=togGui

-- Find safe Y position (avoid other gui elements)
local function findSafeToggleY()
    local safeY=8
    local function checkGui(gui)
        if not gui or not gui.Enabled then return end
        for _,obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("GuiObject") and obj.Visible then
                local ok,ap=pcall(function() return obj.AbsolutePosition end)
                local ok2,as=pcall(function() return obj.AbsoluteSize end)
                if ok and ok2 then
                    if ap.Y < 60 and as.X > 20 then
                        safeY=math.max(safeY, ap.Y+as.Y+8)
                    end
                end
            end
        end
    end
    pcall(function()
        for _,plrGui in ipairs({LP.PlayerGui, LP.PlayerGui.parent}) do
            pcall(function()
                for _,g in ipairs(LP.PlayerGui:GetChildren()) do
                    if g~=MG and g~=togGui and g~=spawnNotifGui and g~=flMobileGui and g~=NH.Parent then
                        checkGui(g)
                    end
                end
            end)
        end
    end)
    return math.clamp(safeY, 8, 200)
end

local function repositionTogBtn()
    local vp=Camera.ViewportSize
    local safeY=findSafeToggleY()
    togBtn.Position=UDim2.new(.5,0,0,safeY)
end

repositionTogBtn()
task.spawn(function()
    while task.wait(2) do repositionTogBtn() end
end)

closeMini.MouseButton1Click:Connect(function()
    guiOpen=not guiOpen
    if guiOpen then
        MF.Visible=true
        TweenService:Create(MF,TweenInfo.new(.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=MFSIZE}):Play()
    else
        TweenService:Create(MF,TweenInfo.new(.25,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
        task.delay(.28,function() MF.Visible=false end)
    end
end)

togBtn.MouseButton1Click:Connect(function()
    guiOpen=not guiOpen
    if guiOpen then
        MF.Visible=true
        TweenService:Create(MF,TweenInfo.new(.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=MFSIZE}):Play()
    else
        TweenService:Create(MF,TweenInfo.new(.28,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
        task.delay(.3,function() MF.Visible=false end)
    end
end)

-- ============================================================
-- INITIAL TAB
-- ============================================================
switchTab("Home")

-- ============================================================
-- DONE
-- ============================================================
notify("Project Crafted V2 Loaded!", CT.Primary, 3)
