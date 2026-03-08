--[[
    ╔══════════════════════════════════════╗
    ║         Project Crafted V2           ║
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

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ══════════════════════════════════
-- PLATFORM DETECT
-- ══════════════════════════════════
local isPC = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled

-- ══════════════════════════════════
-- GAME ID CHECK
-- ══════════════════════════════════
local TARGET_GAME_ID = 119987266683883
if game.PlaceId ~= TARGET_GAME_ID then
    local sg = Instance.new("ScreenGui")
    sg.Name = "PC_Bad"; sg.ResetOnSpawn = false
    sg.DisplayOrder = 9999; sg.IgnoreGuiInset = true; sg.Parent = CoreGui
    local fr = Instance.new("Frame", sg)
    fr.AnchorPoint = Vector2.new(0.5,0.5); fr.Position = UDim2.new(0.5,0,0.5,0)
    fr.Size = UDim2.new(0,0,0,0); fr.BackgroundColor3 = Color3.fromRGB(10,10,10); fr.BorderSizePixel=0
    local fc = Instance.new("UICorner",fr); fc.CornerRadius = UDim.new(0,6)
    local fs = Instance.new("UIStroke",fr); fs.Color=Color3.fromRGB(200,50,50); fs.Thickness=1
    local fl = Instance.new("TextLabel",fr)
    fl.Size=UDim2.new(1,-24,1,0); fl.Position=UDim2.new(0,12,0,0)
    fl.BackgroundTransparency=1; fl.Font=Enum.Font.GothamBold; fl.TextScaled=true
    fl.TextColor3=Color3.fromRGB(220,70,70)
    local gn="This Game"; pcall(function() gn=MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    fl.Text = gn.." Is Not Supported"
    TweenService:Create(fr,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0.42,0,0.07,0)}):Play()
    task.delay(3,function()
        TweenService:Create(fr,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
        task.delay(0.4,function() sg:Destroy() end)
    end)
    return
end

-- ══════════════════════════════════
-- FILE SYSTEM
-- ══════════════════════════════════
local CFG_ROOT  = "ProjectCrafted"
local CFG_DIR   = CFG_ROOT.."/configs"
local SAVE_DIR  = CFG_ROOT.."/saves"
local THEME_F   = CFG_DIR.."/theme.txt"
local COUNT_F   = CFG_DIR.."/execcount.txt"
local CUST_F    = CFG_DIR.."/customtheme.txt"

local function rf(p)
    local ok,r=pcall(function() if isfile and isfile(p) then return readfile(p) end end)
    return ok and r or nil
end
local function wf(p,v) pcall(function() if writefile then writefile(p,tostring(v)) end end) end
local function ensureDirs()
    pcall(function()
        if isfolder then
            if not isfolder(CFG_ROOT) then makefolder(CFG_ROOT) end
            if not isfolder(CFG_DIR)  then makefolder(CFG_DIR)  end
            if not isfolder(SAVE_DIR) then makefolder(SAVE_DIR) end
        end
    end)
end
ensureDirs()

local execCount = 1
local ec = tonumber(rf(COUNT_F))
if ec then execCount = ec+1 end
wf(COUNT_F, execCount)
local execStart = tick()

-- ══════════════════════════════════
-- THEMES  (full 20-key tables)
-- ══════════════════════════════════
local BASE = {
    Background  = Color3.fromRGB(12,12,12),
    SecondaryBg = Color3.fromRGB(18,18,18),
    CardBg      = Color3.fromRGB(22,22,22),
    Accent      = Color3.fromRGB(75,195,95),
    AccentDark  = Color3.fromRGB(45,130,60),
    Text        = Color3.fromRGB(218,218,218),
    TextDim     = Color3.fromRGB(110,110,110),
    TabBg       = Color3.fromRGB(18,18,18),
    TabActive   = Color3.fromRGB(75,195,95),
    ToggleOn    = Color3.fromRGB(75,195,95),
    ToggleOff   = Color3.fromRGB(38,38,38),
    SliderFill  = Color3.fromRGB(75,195,95),
    SliderBg    = Color3.fromRGB(32,32,32),
    Stroke      = Color3.fromRGB(38,38,38),
    AccentStroke= Color3.fromRGB(75,195,95),
    GradStart   = Color3.fromRGB(12,12,12),
    GradEnd     = Color3.fromRGB(18,18,18),
    ButtonBg    = Color3.fromRGB(26,26,26),
    DropdownBg  = Color3.fromRGB(16,16,16),
    OpenCloseBg = Color3.fromRGB(22,22,22),
    ScrollBar   = Color3.fromRGB(55,55,55),
    SectionText = Color3.fromRGB(80,80,80),
}

local Themes = {
    Original = {
        Background  = Color3.fromRGB(10,14,10),
        SecondaryBg = Color3.fromRGB(15,20,15),
        CardBg      = Color3.fromRGB(18,25,18),
        Accent      = Color3.fromRGB(75,195,95),
        AccentDark  = Color3.fromRGB(45,130,60),
        Text        = Color3.fromRGB(210,235,210),
        TextDim     = Color3.fromRGB(100,130,100),
        TabBg       = Color3.fromRGB(15,20,15),
        TabActive   = Color3.fromRGB(75,195,95),
        ToggleOn    = Color3.fromRGB(75,195,95),
        ToggleOff   = Color3.fromRGB(32,42,32),
        SliderFill  = Color3.fromRGB(75,195,95),
        SliderBg    = Color3.fromRGB(28,38,28),
        Stroke      = Color3.fromRGB(32,45,32),
        AccentStroke= Color3.fromRGB(75,195,95),
        GradStart   = Color3.fromRGB(10,14,10),
        GradEnd     = Color3.fromRGB(16,24,16),
        ButtonBg    = Color3.fromRGB(20,32,20),
        DropdownBg  = Color3.fromRGB(13,18,13),
        OpenCloseBg = Color3.fromRGB(18,28,18),
        ScrollBar   = Color3.fromRGB(55,80,55),
        SectionText = Color3.fromRGB(65,100,65),
    },
    Sky = {
        Background  = Color3.fromRGB(10,12,18),
        SecondaryBg = Color3.fromRGB(15,18,28),
        CardBg      = Color3.fromRGB(18,22,34),
        Accent      = Color3.fromRGB(80,165,245),
        AccentDark  = Color3.fromRGB(45,110,195),
        Text        = Color3.fromRGB(205,220,245),
        TextDim     = Color3.fromRGB(90,110,150),
        TabBg       = Color3.fromRGB(15,18,28),
        TabActive   = Color3.fromRGB(80,165,245),
        ToggleOn    = Color3.fromRGB(80,165,245),
        ToggleOff   = Color3.fromRGB(28,35,52),
        SliderFill  = Color3.fromRGB(80,165,245),
        SliderBg    = Color3.fromRGB(24,32,50),
        Stroke      = Color3.fromRGB(28,38,60),
        AccentStroke= Color3.fromRGB(80,165,245),
        GradStart   = Color3.fromRGB(10,12,20),
        GradEnd     = Color3.fromRGB(16,20,36),
        ButtonBg    = Color3.fromRGB(18,24,42),
        DropdownBg  = Color3.fromRGB(12,16,26),
        OpenCloseBg = Color3.fromRGB(18,26,46),
        ScrollBar   = Color3.fromRGB(55,80,130),
        SectionText = Color3.fromRGB(60,90,140),
    },
    Lava = {
        Background  = Color3.fromRGB(16,8,6),
        SecondaryBg = Color3.fromRGB(22,12,8),
        CardBg      = Color3.fromRGB(26,14,10),
        Accent      = Color3.fromRGB(240,100,30),
        AccentDark  = Color3.fromRGB(175,55,10),
        Text        = Color3.fromRGB(245,215,200),
        TextDim     = Color3.fromRGB(130,90,75),
        TabBg       = Color3.fromRGB(22,12,8),
        TabActive   = Color3.fromRGB(240,100,30),
        ToggleOn    = Color3.fromRGB(240,100,30),
        ToggleOff   = Color3.fromRGB(48,24,16),
        SliderFill  = Color3.fromRGB(240,100,30),
        SliderBg    = Color3.fromRGB(40,20,12),
        Stroke      = Color3.fromRGB(50,26,16),
        AccentStroke= Color3.fromRGB(240,100,30),
        GradStart   = Color3.fromRGB(16,8,6),
        GradEnd     = Color3.fromRGB(24,14,8),
        ButtonBg    = Color3.fromRGB(30,16,10),
        DropdownBg  = Color3.fromRGB(14,8,5),
        OpenCloseBg = Color3.fromRGB(28,16,10),
        ScrollBar   = Color3.fromRGB(120,55,25),
        SectionText = Color3.fromRGB(120,60,30),
    },
}

local currentThemeName = "Original"
local savedTheme = rf(THEME_F)
if savedTheme and (Themes[savedTheme] or savedTheme=="Custom") then
    currentThemeName = savedTheme
end

-- Build Custom from file
local savedCustomRaw = rf(CUST_F)
if savedCustomRaw then
    pcall(function()
        local raw = HttpService:JSONDecode(savedCustomRaw)
        local merged = {}
        for k,v in pairs(Themes["Original"]) do merged[k]=v end
        for k,v in pairs(raw) do
            if type(v)=="table" and v.r~=nil then
                merged[k]=Color3.new(math.clamp(v.r,0,1),math.clamp(v.g,0,1),math.clamp(v.b,0,1))
            end
        end
        Themes["Custom"] = merged
    end)
end

-- Live theme table T (mutated in-place so all closures always see latest)
local T = {}
local function rebuildT()
    local src = Themes[currentThemeName] or Themes["Original"]
    for k in pairs(T) do T[k]=nil end
    for k,v in pairs(Themes["Original"]) do T[k]=v end
    for k,v in pairs(src) do T[k]=v end
end
rebuildT()

-- Safe color accessor – never returns nil
local function tc(k)
    local v = T[k]
    if typeof(v)=="Color3" then return v end
    local fb = Themes["Original"][k]
    return typeof(fb)=="Color3" and fb or Color3.fromRGB(100,100,100)
end

local themeCallbacks = {}
local function onThemeUpdate(fn) table.insert(themeCallbacks,fn) end
local function fireThemeUpdate()
    rebuildT()
    for _,fn in ipairs(themeCallbacks) do pcall(fn) end
end

local function setTheme(name, customData)
    if customData then
        local merged = {}
        for k,v in pairs(Themes["Original"]) do merged[k]=v end
        local stored = {}
        for k,v in pairs(customData) do
            if typeof(v)=="Color3" then
                merged[k]=v
                stored[k]={r=v.R,g=v.G,b=v.B}
            end
        end
        wf(CUST_F, HttpService:JSONEncode(stored))
        Themes["Custom"]  = merged
        currentThemeName  = "Custom"
        wf(THEME_F,"Custom")
    elseif Themes[name] then
        currentThemeName = name
        wf(THEME_F, name)
    end
    fireThemeUpdate()
end

-- ══════════════════════════════════
-- FEATURE / TOGGLE STATE
-- ══════════════════════════════════
local state = {
    speedEnabled    = false,
    jumpEnabled     = false,
    godmodeEnabled  = false,
    flyEnabled      = false,
    cheeseEnabled   = false,
    teleportEnabled = false,
    brainHighlight  = false,
    playerHighlight = false,
    autoCollect     = false,
    playerWarnOk    = false,
    speedValue      = 16,
    jumpValue       = 30,
    flySpeed        = 50,
    speedMaxValue   = 100,
}

-- toggle setValue functions registered here for hotkeys + configs
local toggleSetters = {}   -- name -> fn(bool)
local sliderGetters = {}   -- name -> fn() -> number
local sliderSetters = {}   -- name -> fn(number)

-- hotkeys: PC only
local hotkeys = {}         -- featureName -> Enum.KeyCode
local hotkeyRebindMode = false
local hotkeyRebindTarget = nil
local hotkeyRebindCallback = nil

-- ══════════════════════════════════
-- HELPERS
-- ══════════════════════════════════
local function ac(p, r)
    local c = Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 4); return c
end
local function as(p, col, th)
    local s = Instance.new("UIStroke",p)
    s.Color           = typeof(col)=="Color3" and col or tc("Stroke")
    s.Thickness       = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end
local function ag(p, c0, c1, rot)
    local g = Instance.new("UIGradient",p)
    g.Color    = ColorSequence.new(typeof(c0)=="Color3" and c0 or tc("GradStart"), typeof(c1)=="Color3" and c1 or tc("GradEnd"))
    g.Rotation = rot or 90
    return g
end
local function tw(obj,props,t,style,dir)
    local sp={}; for k,v in pairs(props) do if v~=nil then sp[k]=v end end
    TweenService:Create(obj,TweenInfo.new(t or 0.22,style or Enum.EasingStyle.Quad,dir or Enum.EasingDirection.Out),sp):Play()
end
local function fmtTime(s)
    return string.format("%d:%02d",math.floor(s/60),math.floor(s%60))
end
local function getChar()
    local c=LocalPlayer.Character
    if not c then return nil,nil,nil end
    return c,c:FindFirstChildOfClass("Humanoid"),c:FindFirstChild("HumanoidRootPart")
end

-- ══════════════════════════════════
-- NOTIFICATIONS
-- ══════════════════════════════════
local notifOffset = 0
local function showNotif(text, accentColor, dur)
    local vp = Camera.ViewportSize
    local nW = math.clamp(vp.X*0.34, 210, 380)
    local nH = math.clamp(vp.Y*0.058, 40, 56)
    local col = typeof(accentColor)=="Color3" and accentColor or tc("Accent")

    local sg = Instance.new("ScreenGui")
    sg.Name="PC_Notif"; sg.ResetOnSpawn=false; sg.DisplayOrder=500
    sg.IgnoreGuiInset=true; sg.Parent=CoreGui

    local fr = Instance.new("Frame",sg)
    fr.Size=UDim2.new(0,nW,0,nH)
    fr.AnchorPoint=Vector2.new(0.5,0)
    fr.Position=UDim2.new(0.5,0,0,-nH-4)
    fr.BackgroundColor3=tc("SecondaryBg")
    fr.BorderSizePixel=0
    ac(fr,4); as(fr,col,1)

    -- accent bar on left
    local bar=Instance.new("Frame",fr)
    bar.Size=UDim2.new(0,3,1,0); bar.BackgroundColor3=col; bar.BorderSizePixel=0
    ac(bar,2)

    local lbl=Instance.new("TextLabel",fr)
    lbl.Size=UDim2.new(1,-18,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text
    lbl.TextColor3=tc("Text"); lbl.Font=Enum.Font.GothamMedium
    lbl.TextSize=12; lbl.TextWrapped=true; lbl.TextXAlignment=Enum.TextXAlignment.Left

    tw(fr,{Position=UDim2.new(0.5,0,0,8)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.delay(dur or 2.4,function()
        tw(fr,{Position=UDim2.new(0.5,0,0,-nH-4)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.delay(0.3,function() sg:Destroy() end)
    end)
end

-- ══════════════════════════════════
-- DESTROY OLD INSTANCE
-- ══════════════════════════════════
pcall(function()
    local old=CoreGui:FindFirstChild("ProjectCraftedV2")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name="ProjectCraftedV2"; ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset=true; ScreenGui.DisplayOrder=10
ScreenGui.Parent=CoreGui

-- ══════════════════════════════════
-- OC BUTTON
-- ══════════════════════════════════
local OcBtn = Instance.new("ImageButton",ScreenGui)
OcBtn.Name="OCBtn"; OcBtn.BackgroundColor3=tc("OpenCloseBg")
OcBtn.BorderSizePixel=0; OcBtn.AutoButtonColor=false; OcBtn.ZIndex=100
ac(OcBtn,5)
local ocStroke = as(OcBtn,tc("AccentStroke"),1)

local OcLogo=Instance.new("ImageLabel",OcBtn)
OcLogo.BackgroundTransparency=1; OcLogo.Image="rbxassetid://85816937697749"
OcLogo.ScaleType=Enum.ScaleType.Fit; OcLogo.ZIndex=101

local OcText=Instance.new("TextLabel",OcBtn)
OcText.BackgroundTransparency=1; OcText.Text="Project Crafted"
OcText.TextColor3=tc("Text"); OcText.Font=Enum.Font.GothamBold
OcText.TextScaled=true; OcText.ZIndex=101

local function updOcSize()
    local vp=Camera.ViewportSize
    local bH=math.clamp(vp.Y*0.048,32,46)
    local bW=math.clamp(vp.X*0.155,122,182)
    OcBtn.Size=UDim2.new(0,bW,0,bH)
    OcLogo.Size=UDim2.new(0,bH-10,0,bH-10)
    OcLogo.Position=UDim2.new(0,5,0.5,-(bH-10)/2)
    OcText.Size=UDim2.new(0,bW-bH-8,0,bH-12)
    OcText.Position=UDim2.new(0,bH+4,0.5,-(bH-12)/2)
end

local function posOcBtn()
    local vp=Camera.ViewportSize
    local bW,bH=OcBtn.AbsoluteSize.X,OcBtn.AbsoluteSize.Y
    local function rects()
        local r={}
        local pg=LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _,g in ipairs(pg:GetDescendants()) do
                if g:IsA("GuiObject") and g.Visible then
                    local p2,s2=g.AbsolutePosition,g.AbsoluteSize
                    if s2.Magnitude>20 then table.insert(r,{x1=p2.X,y1=p2.Y,x2=p2.X+s2.X,y2=p2.Y+s2.Y}) end
                end
            end
        end
        return r
    end
    local function ov(rs,ax,ay)
        for _,r in ipairs(rs) do
            if not(ax+bW<=r.x1 or ax>=r.x2 or ay+bH<=r.y1 or ay>=r.y2) then return true end
        end
    end
    local rs=rects()
    local cands={{x=vp.X-bW-8,y=8},{x=8,y=8},{x=vp.X-bW-8,y=vp.Y-bH-8},{x=8,y=vp.Y-bH-8}}
    for _,c in ipairs(cands) do
        if not ov(rs,c.x,c.y) then
            OcBtn.AnchorPoint=Vector2.new(0,0); OcBtn.Position=UDim2.new(0,c.x,0,c.y); return
        end
    end
    OcBtn.AnchorPoint=Vector2.new(1,0); OcBtn.Position=UDim2.new(1,-8,0,8)
end

updOcSize(); task.defer(posOcBtn)

-- ══════════════════════════════════
-- MAIN FRAME
-- ══════════════════════════════════
local MainFrame=Instance.new("Frame",ScreenGui)
MainFrame.Name="MainFrame"; MainFrame.AnchorPoint=Vector2.new(0.5,0.5)
MainFrame.Position=UDim2.new(0.5,0,0.5,0)
MainFrame.BackgroundColor3=tc("Background"); MainFrame.BorderSizePixel=0
MainFrame.ClipsDescendants=true; MainFrame.ZIndex=50
ac(MainFrame,8)
local mfStroke=as(MainFrame,tc("AccentStroke"),1)

local function updMainSize()
    local vp=Camera.ViewportSize
    local w=math.clamp(vp.X*0.55,300,660)
    local h=math.clamp(vp.Y*0.50,280,420)
    MainFrame.Size=UDim2.new(0,w,0,h)
end
updMainSize()

-- Title Bar
local TitleBar=Instance.new("Frame",MainFrame)
TitleBar.Name="TitleBar"; TitleBar.Size=UDim2.new(1,0,0,38)
TitleBar.BackgroundColor3=tc("SecondaryBg"); TitleBar.BorderSizePixel=0; TitleBar.ZIndex=51
ac(TitleBar,8)
local tbGrad=ag(TitleBar,tc("AccentDark"),tc("SecondaryBg"),180)

local TitleLogo=Instance.new("ImageLabel",TitleBar)
TitleLogo.Size=UDim2.new(0,22,0,22); TitleLogo.Position=UDim2.new(0,8,0.5,-11)
TitleLogo.BackgroundTransparency=1; TitleLogo.Image="rbxassetid://85816937697749"
TitleLogo.ScaleType=Enum.ScaleType.Fit; TitleLogo.ZIndex=52

local TitleLbl=Instance.new("TextLabel",TitleBar)
TitleLbl.Size=UDim2.new(1,-115,1,0); TitleLbl.Position=UDim2.new(0,36,0,0)
TitleLbl.BackgroundTransparency=1; TitleLbl.Text="Project Crafted V2"
TitleLbl.TextColor3=tc("Text"); TitleLbl.Font=Enum.Font.GothamBold
TitleLbl.TextSize=14; TitleLbl.TextXAlignment=Enum.TextXAlignment.Left; TitleLbl.ZIndex=52

local function mkWinBtn(parent,col,lbl,xOff)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,24,0,24); b.Position=UDim2.new(1,xOff,0.5,-12)
    b.BackgroundColor3=col; b.Text=lbl; b.TextColor3=Color3.fromRGB(255,255,255)
    b.Font=Enum.Font.GothamBold; b.TextSize=12; b.AutoButtonColor=false; b.ZIndex=52
    ac(b,4); return b
end
local TitleClose = mkWinBtn(TitleBar,Color3.fromRGB(180,50,50),"X",-30)
local TitleMin   = mkWinBtn(TitleBar,Color3.fromRGB(170,135,30),"-",-58)

-- Separator line under title
local titleSep=Instance.new("Frame",TitleBar)
titleSep.Size=UDim2.new(1,0,0,1); titleSep.Position=UDim2.new(0,0,1,-1)
titleSep.BackgroundColor3=tc("AccentStroke"); titleSep.BorderSizePixel=0; titleSep.ZIndex=52

-- Content Area
local ContentArea=Instance.new("Frame",MainFrame)
ContentArea.Name="Content"; ContentArea.Size=UDim2.new(1,0,1,-38)
ContentArea.Position=UDim2.new(0,0,0,38)
ContentArea.BackgroundTransparency=1; ContentArea.ClipsDescendants=true; ContentArea.ZIndex=51

-- Tab Bar
local TabBar=Instance.new("Frame",ContentArea)
TabBar.Name="TabBar"; TabBar.Size=UDim2.new(1,0,0,32)
TabBar.BackgroundColor3=tc("SecondaryBg"); TabBar.BorderSizePixel=0; TabBar.ZIndex=52

local tabLyt=Instance.new("UIListLayout",TabBar)
tabLyt.FillDirection=Enum.FillDirection.Horizontal
tabLyt.VerticalAlignment=Enum.VerticalAlignment.Center
tabLyt.Padding=UDim.new(0,1)

local tabPad=Instance.new("UIPadding",TabBar)
tabPad.PaddingLeft=UDim.new(0,4); tabPad.PaddingRight=UDim.new(0,4)
tabPad.PaddingTop=UDim.new(0,4); tabPad.PaddingBottom=UDim.new(0,4)

local tabSep=Instance.new("Frame",TabBar)
tabSep.Size=UDim2.new(1,0,0,1); tabSep.Position=UDim2.new(0,0,1,-1)
tabSep.BackgroundColor3=tc("Stroke"); tabSep.BorderSizePixel=0; tabSep.ZIndex=53

-- Tab Content
local TabContent=Instance.new("Frame",ContentArea)
TabContent.Name="TabContent"; TabContent.Size=UDim2.new(1,0,1,-32)
TabContent.Position=UDim2.new(0,0,0,32)
TabContent.BackgroundTransparency=1; TabContent.ClipsDescendants=true; TabContent.ZIndex=51

-- ══════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════
local TAB_NAMES={"Home","Main","Player","Visual","Settings"}
local tabBtns={}; local tabPages={}; local activeTab=nil
local playerWarnOverlay=nil

local function mkTabBtn(name)
    local btn=Instance.new("TextButton",TabBar)
    btn.Name=name.."_T"; btn.Size=UDim2.new(0,0,1,0)
    btn.AutomaticSize=Enum.AutomaticSize.X
    btn.BackgroundColor3=tc("TabBg"); btn.BorderSizePixel=0
    btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=53
    local tp=Instance.new("UIPadding",btn)
    tp.PaddingLeft=UDim.new(0,10); tp.PaddingRight=UDim.new(0,10)
    local tl=Instance.new("TextLabel",btn)
    tl.Name="Lbl"; tl.Size=UDim2.new(0,0,1,0); tl.AutomaticSize=Enum.AutomaticSize.X
    tl.BackgroundTransparency=1; tl.Text=name; tl.TextColor3=tc("TextDim")
    tl.Font=Enum.Font.GothamMedium; tl.TextSize=11; tl.ZIndex=54
    -- active indicator bar at bottom
    local ind=Instance.new("Frame",btn)
    ind.Name="Ind"; ind.Size=UDim2.new(1,0,0,2); ind.Position=UDim2.new(0,0,1,-2)
    ind.BackgroundColor3=tc("Accent"); ind.BorderSizePixel=0
    ind.BackgroundTransparency=1; ind.ZIndex=54
    return btn
end

local function mkTabPage(name)
    local sf=Instance.new("ScrollingFrame",TabContent)
    sf.Name=name.."_P"; sf.Size=UDim2.new(1,0,1,0)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=tc("ScrollBar")
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.Visible=false; sf.ZIndex=52
    local lyt=Instance.new("UIListLayout",sf)
    lyt.FillDirection=Enum.FillDirection.Vertical
    lyt.Padding=UDim.new(0,5); lyt.SortOrder=Enum.SortOrder.LayoutOrder
    local pad=Instance.new("UIPadding",sf)
    pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,12)
    pad.PaddingTop=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,10)
    return sf
end

for _,n in ipairs(TAB_NAMES) do
    tabBtns[n]=mkTabBtn(n); tabPages[n]=mkTabPage(n)
end

local function switchTab(name)
    if activeTab==name then return end
    if activeTab then
        local ob=tabBtns[activeTab]; local op=tabPages[activeTab]
        ob.BackgroundColor3=tc("TabBg"); ob.Lbl.TextColor3=tc("TextDim")
        ob.Lbl.Font=Enum.Font.GothamMedium; ob.Ind.BackgroundTransparency=1
        op.Visible=false
    end
    activeTab=name
    local nb=tabBtns[name]; local np=tabPages[name]
    nb.BackgroundColor3=tc("TabBg"); nb.Lbl.TextColor3=tc("Text")
    nb.Lbl.Font=Enum.Font.GothamBold; nb.Ind.BackgroundTransparency=0
    tw(nb.Ind,{BackgroundColor3=tc("Accent")},0)
    np.Visible=true
    np.Position=UDim2.new(0,0,0,10)
    tw(np,{Position=UDim2.new(0,0,0,0)},0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    if playerWarnOverlay then
        playerWarnOverlay.Visible=(name=="Player") and not state.playerWarnOk
    end
end

for _,n in ipairs(TAB_NAMES) do
    tabBtns[n].MouseButton1Click:Connect(function() switchTab(n) end)
end

-- ══════════════════════════════════
-- DRAG
-- ══════════════════════════════════
do
    local dragging,dragStart,startPos=false
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-dragStart
            MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

-- ══════════════════════════════════
-- OPEN / CLOSE
-- ══════════════════════════════════
local isOpen=true; local lastSz=MainFrame.Size
local function toggleGui()
    isOpen=not isOpen
    if isOpen then
        MainFrame.Visible=true
        tw(MainFrame,{Size=lastSz},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    else
        lastSz=MainFrame.Size
        tw(MainFrame,{Size=UDim2.new(lastSz.X.Scale,lastSz.X.Offset,0,0)},0.24,Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.delay(0.28,function() MainFrame.Visible=false end)
    end
end
OcBtn.MouseButton1Click:Connect(toggleGui)
TitleClose.MouseButton1Click:Connect(toggleGui)
TitleMin.MouseButton1Click:Connect(function() if isOpen then toggleGui() end end)

-- ══════════════════════════════════
-- UI BUILDERS
-- ══════════════════════════════════
local function secLabel(page, txt, order)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,18); f.BackgroundTransparency=1; f.LayoutOrder=order
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.Text=txt:upper(); l.TextColor3=tc("SectionText")
    l.Font=Enum.Font.GothamBold; l.TextSize=9
    l.TextXAlignment=Enum.TextXAlignment.Left
    onThemeUpdate(function() l.TextColor3=tc("SectionText") end)
    return f,l
end

local function infoRow(page, lTxt, vTxt, order)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,26); f.BackgroundColor3=tc("CardBg")
    f.BorderSizePixel=0; f.LayoutOrder=order; ac(f,4)
    local fs=as(f,tc("Stroke"),1)
    local kl=Instance.new("TextLabel",f)
    kl.Size=UDim2.new(0.44,0,1,0); kl.Position=UDim2.new(0,8,0,0)
    kl.BackgroundTransparency=1; kl.Text=lTxt; kl.TextColor3=tc("TextDim")
    kl.Font=Enum.Font.GothamMedium; kl.TextSize=11; kl.TextXAlignment=Enum.TextXAlignment.Left
    local vl=Instance.new("TextLabel",f)
    vl.Name="Val"; vl.Size=UDim2.new(0.55,0,1,0); vl.Position=UDim2.new(0.44,0,0,0)
    vl.BackgroundTransparency=1; vl.Text=vTxt or "—"; vl.TextColor3=tc("Text")
    vl.Font=Enum.Font.Gotham; vl.TextSize=11; vl.TextXAlignment=Enum.TextXAlignment.Left
    onThemeUpdate(function()
        f.BackgroundColor3=tc("CardBg"); fs.Color=tc("Stroke")
        kl.TextColor3=tc("TextDim"); vl.TextColor3=tc("Text")
    end)
    return f,vl,kl
end

local function buildToggle(page, labelTxt, order, onFn)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,36); f.BackgroundColor3=tc("CardBg")
    f.BorderSizePixel=0; f.LayoutOrder=order; ac(f,4)
    local fs=as(f,tc("Stroke"),1)

    local ll=Instance.new("TextLabel",f)
    ll.Size=UDim2.new(1,-60,1,0); ll.Position=UDim2.new(0,10,0,0)
    ll.BackgroundTransparency=1; ll.Text=labelTxt; ll.TextColor3=tc("Text")
    ll.Font=Enum.Font.GothamMedium; ll.TextSize=12
    ll.TextXAlignment=Enum.TextXAlignment.Left; ll.TextWrapped=true

    local sbg=Instance.new("Frame",f)
    sbg.Size=UDim2.new(0,38,0,20); sbg.Position=UDim2.new(1,-48,0.5,-10)
    sbg.BackgroundColor3=tc("ToggleOff"); sbg.BorderSizePixel=0; ac(sbg,10)

    local knob=Instance.new("Frame",sbg)
    knob.Size=UDim2.new(0,14,0,14); knob.Position=UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3=Color3.fromRGB(220,220,220); knob.BorderSizePixel=0; ac(knob,7)

    local togOn=false

    local ca=Instance.new("TextButton",f)
    ca.Size=UDim2.new(1,0,1,0); ca.BackgroundTransparency=1; ca.Text=""; ca.ZIndex=f.ZIndex+1

    local function setVal(val, silent)
        togOn=val
        if val then
            tw(sbg,{BackgroundColor3=tc("ToggleOn")},0.14)
            tw(knob,{Position=UDim2.new(0,21,0.5,-7)},0.14)
            tw(f,{BackgroundColor3=tc("CardBg")},0.14)
            fs.Color=tc("AccentStroke")
        else
            tw(sbg,{BackgroundColor3=tc("ToggleOff")},0.14)
            tw(knob,{Position=UDim2.new(0,3,0.5,-7)},0.14)
            tw(f,{BackgroundColor3=tc("CardBg")},0.14)
            fs.Color=tc("Stroke")
        end
        if not silent and onFn then onFn(togOn) end
    end

    ca.MouseButton1Click:Connect(function() setVal(not togOn) end)

    onThemeUpdate(function()
        f.BackgroundColor3=tc("CardBg")
        fs.Color=togOn and tc("AccentStroke") or tc("Stroke")
        ll.TextColor3=tc("Text")
        sbg.BackgroundColor3=togOn and tc("ToggleOn") or tc("ToggleOff")
    end)

    return f, setVal, function() return togOn end
end

local function buildSlider(page, labelTxt, minV, maxV, defV, order, onChangeFn)
    local f=Instance.new("Frame",page)
    f.Size=UDim2.new(1,0,0,52); f.BackgroundColor3=tc("CardBg")
    f.BorderSizePixel=0; f.LayoutOrder=order; ac(f,4)
    local fs=as(f,tc("Stroke"),1)

    local nl=Instance.new("TextLabel",f)
    nl.Size=UDim2.new(0.65,0,0,18); nl.Position=UDim2.new(0,10,0,5)
    nl.BackgroundTransparency=1; nl.Text=labelTxt; nl.TextColor3=tc("Text")
    nl.Font=Enum.Font.GothamMedium; nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left

    local vl=Instance.new("TextLabel",f)
    vl.Size=UDim2.new(0.32,0,0,18); vl.Position=UDim2.new(0.66,0,0,5)
    vl.BackgroundTransparency=1; vl.Text=tostring(defV); vl.TextColor3=tc("Accent")
    vl.Font=Enum.Font.GothamBold; vl.TextSize=12; vl.TextXAlignment=Enum.TextXAlignment.Right

    local rail=Instance.new("Frame",f)
    rail.Size=UDim2.new(1,-20,0,5); rail.Position=UDim2.new(0,10,0,33)
    rail.BackgroundColor3=tc("SliderBg"); rail.BorderSizePixel=0; ac(rail,3)

    local initT=(defV-minV)/math.max(maxV-minV,1)
    local fill=Instance.new("Frame",rail)
    fill.Size=UDim2.new(initT,0,1,0); fill.BackgroundColor3=tc("SliderFill")
    fill.BorderSizePixel=0; ac(fill,3)

    local kn=Instance.new("Frame",rail)
    kn.Size=UDim2.new(0,12,0,12); kn.AnchorPoint=Vector2.new(0.5,0.5)
    kn.Position=UDim2.new(initT,0,0.5,0)
    kn.BackgroundColor3=Color3.fromRGB(225,225,225); kn.BorderSizePixel=0; ac(kn,6)

    local curVal=defV; local sliding=false
    local function updX(x)
        local rp=rail.AbsolutePosition; local rs=rail.AbsoluteSize
        local t=math.clamp((x-rp.X)/rs.X,0,1)
        curVal=math.round(minV+t*(maxV-minV))
        vl.Text=tostring(curVal); fill.Size=UDim2.new(t,0,1,0); kn.Position=UDim2.new(t,0,0.5,0)
        if onChangeFn then onChangeFn(curVal) end
    end

    local ha=Instance.new("TextButton",f)
    ha.Size=UDim2.new(1,0,0,24); ha.Position=UDim2.new(0,0,0,24)
    ha.BackgroundTransparency=1; ha.Text=""; ha.ZIndex=f.ZIndex+1
    ha.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            sliding=true; updX(inp.Position.X)
        end
    end)
    ha.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            sliding=false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sliding and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            updX(inp.Position.X)
        end
    end)

    onThemeUpdate(function()
        f.BackgroundColor3=tc("CardBg"); fs.Color=tc("Stroke")
        nl.TextColor3=tc("Text"); vl.TextColor3=tc("Accent")
        rail.BackgroundColor3=tc("SliderBg"); fill.BackgroundColor3=tc("SliderFill")
    end)

    local function setRange(mn,mx)
        minV=mn; maxV=mx; curVal=math.clamp(curVal,minV,maxV)
        local t2=(curVal-minV)/math.max(maxV-minV,1)
        vl.Text=tostring(curVal); fill.Size=UDim2.new(t2,0,1,0); kn.Position=UDim2.new(t2,0,0.5,0)
    end
    local function setVal(v)
        curVal=math.clamp(v,minV,maxV)
        local t2=(curVal-minV)/math.max(maxV-minV,1)
        vl.Text=tostring(curVal); fill.Size=UDim2.new(t2,0,1,0); kn.Position=UDim2.new(t2,0,0.5,0)
    end
    local function getVal() return curVal end
    return f, getVal, setRange, setVal
end

-- ══════════════════════════════════
-- BRAINROT WATCHER
-- ══════════════════════════════════
local selBrainrots={}; local spawnTracked={}; local brainHLs={}
local watchFolder=nil

local function onBrainrotFound(model, name)
    if spawnTracked[model] then return end
    spawnTracked[model]=true
    showNotif("A "..name.." Has Spawned!", tc("Accent"), 3)
    if state.teleportEnabled then
        task.spawn(function()
            task.wait(0.05)
            pcall(function()
                local _,_,hrp=getChar()
                if hrp then hrp.CFrame=model:GetPivot()*CFrame.new(0,5,0) end
            end)
        end)
    end
    if state.brainHighlight then
        pcall(function()
            if brainHLs[model] then brainHLs[model]:Destroy() end
            local hl=Instance.new("Highlight",model)
            hl.FillColor=tc("Accent"); hl.OutlineColor=tc("Accent")
            hl.FillTransparency=0.48; hl.OutlineTransparency=0
            brainHLs[model]=hl
        end)
    end
end

task.spawn(function()
    pcall(function()
        watchFolder=workspace:WaitForChild("GameFolder",15):WaitForChild("Brainrots",15)
    end)
end)
task.spawn(function()
    while true do
        task.wait(0.8)
        if watchFolder then
            pcall(function()
                for _,obj in ipairs(watchFolder:GetDescendants()) do
                    if obj:IsA("Model") and selBrainrots[obj.Name] then
                        onBrainrotFound(obj,obj.Name)
                    end
                end
                for m in pairs(spawnTracked) do
                    if not m.Parent then
                        spawnTracked[m]=nil
                        if brainHLs[m] then pcall(function() brainHLs[m]:Destroy() end); brainHLs[m]=nil end
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
    local pg=tabPages["Home"]; local lo=0
    local function nlo() lo+=1; return lo end

    secLabel(pg,"Player Info",nlo())
    local pfCard=Instance.new("Frame",pg)
    pfCard.Size=UDim2.new(1,0,0,68); pfCard.BackgroundColor3=tc("CardBg")
    pfCard.BorderSizePixel=0; pfCard.LayoutOrder=nlo(); ac(pfCard,6)
    local pfStr=as(pfCard,tc("AccentStroke"),1)

    local pfImg=Instance.new("ImageLabel",pfCard)
    pfImg.Size=UDim2.new(0,50,0,50); pfImg.Position=UDim2.new(0,9,0.5,-25)
    pfImg.BackgroundColor3=tc("TabBg")
    pfImg.Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
    pfImg.BorderSizePixel=0; ac(pfImg,25)

    local pfInfo=Instance.new("Frame",pfCard)
    pfInfo.Size=UDim2.new(1,-70,1,0); pfInfo.Position=UDim2.new(0,64,0,0)
    pfInfo.BackgroundTransparency=1
    local pfl=Instance.new("UIListLayout",pfInfo)
    pfl.FillDirection=Enum.FillDirection.Vertical
    pfl.VerticalAlignment=Enum.VerticalAlignment.Center; pfl.Padding=UDim.new(0,2)

    local pfRows={}
    local function pfR(txt,ck)
        local l=Instance.new("TextLabel",pfInfo)
        l.Size=UDim2.new(1,0,0,14); l.BackgroundTransparency=1
        l.Text=txt; l.Font=Enum.Font.Gotham; l.TextSize=11
        l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true
        l.TextColor3=ck and tc(ck) or tc("Text")
        table.insert(pfRows,{l=l,ck=ck}); return l
    end

    pfR(LocalPlayer.DisplayName,"Accent")
    pfR("@"..LocalPlayer.Name)
    pfR("ID: "..LocalPlayer.UserId,"TextDim")
    pfR("Account Age: "..LocalPlayer.AccountAge.." days","TextDim")

    onThemeUpdate(function()
        pfCard.BackgroundColor3=tc("CardBg"); pfStr.Color=tc("AccentStroke")
        pfImg.BackgroundColor3=tc("TabBg")
        for _,r in ipairs(pfRows) do r.l.TextColor3=tc(r.ck or "Text") end
    end)

    secLabel(pg,"Game",nlo())
    local gName="Unknown"; pcall(function() gName=MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    local _,gnV=infoRow(pg,"Game Name",gName,nlo())
    local _,giV=infoRow(pg,"Game ID",tostring(game.PlaceId),nlo())
    local _,pcV=infoRow(pg,"Players","...",nlo())
    local _,siV=infoRow(pg,"Server ID",game.JobId~="" and game.JobId:sub(1,12).."…" or "N/A",nlo())
    local _,upV=infoRow(pg,"Server Uptime","0:00",nlo())

    secLabel(pg,"Session",nlo())
    local _,ecV=infoRow(pg,"Executed",tostring(execCount).." time(s)",nlo())
    local _,etV=infoRow(pg,"Duration","0:00",nlo())

    task.spawn(function()
        while true do task.wait(1); pcall(function()
            pcV.Text=#Players:GetPlayers().."/"..Players.MaxPlayers
            local e=tick()-execStart; upV.Text=fmtTime(e); etV.Text=fmtTime(e)
        end) end
    end)
end

-- ══════════════════════════════════
-- MAIN TAB
-- ══════════════════════════════════
local brainrotNames={}
local buildDropdown  -- forward declare so X-chip can call it

do
    local pg=tabPages["Main"]; local lo=0
    local function nlo() lo+=1; return lo end

    secLabel(pg,"Brainrot Selector",nlo())

    local dropCtr=Instance.new("Frame",pg)
    dropCtr.Size=UDim2.new(1,0,0,174); dropCtr.BackgroundColor3=tc("DropdownBg")
    dropCtr.BorderSizePixel=0; dropCtr.LayoutOrder=nlo(); dropCtr.ClipsDescendants=true
    ac(dropCtr,6); local dcStr=as(dropCtr,tc("Stroke"),1)

    local sBox=Instance.new("TextBox",dropCtr)
    sBox.Size=UDim2.new(1,-12,0,26); sBox.Position=UDim2.new(0,6,0,6)
    sBox.BackgroundColor3=tc("CardBg"); sBox.BorderSizePixel=0
    sBox.PlaceholderText="  Search..."; sBox.Text=""
    sBox.TextColor3=tc("Text"); sBox.PlaceholderColor3=tc("TextDim")
    sBox.Font=Enum.Font.Gotham; sBox.TextSize=12; sBox.ClearTextOnFocus=false
    ac(sBox,4); as(sBox,tc("Stroke"),1)
    local sbPad=Instance.new("UIPadding",sBox); sbPad.PaddingLeft=UDim.new(0,7)

    local dList=Instance.new("ScrollingFrame",dropCtr)
    dList.Size=UDim2.new(1,-8,0,132); dList.Position=UDim2.new(0,4,0,37)
    dList.BackgroundTransparency=1; dList.BorderSizePixel=0
    dList.ScrollBarThickness=3; dList.ScrollBarImageColor3=tc("Accent")
    dList.CanvasSize=UDim2.new(0,0,0,0); dList.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local dlLyt=Instance.new("UIListLayout",dList)
    dlLyt.FillDirection=Enum.FillDirection.Vertical; dlLyt.Padding=UDim.new(0,2)
    local dlPad=Instance.new("UIPadding",dList); dlPad.PaddingTop=UDim.new(0,2); dlPad.PaddingBottom=UDim.new(0,2)

    secLabel(pg,"Selected",nlo())
    local selBox=Instance.new("Frame",pg)
    selBox.Size=UDim2.new(1,0,0,44); selBox.BackgroundColor3=tc("CardBg")
    selBox.BorderSizePixel=0; selBox.LayoutOrder=nlo(); selBox.ClipsDescendants=true
    ac(selBox,4); local sbStr=as(selBox,tc("Stroke"),1)

    local selSF=Instance.new("ScrollingFrame",selBox)
    selSF.Size=UDim2.new(1,-6,1,-6); selSF.Position=UDim2.new(0,3,0,3)
    selSF.BackgroundTransparency=1; selSF.BorderSizePixel=0
    selSF.ScrollBarThickness=2; selSF.ScrollBarImageColor3=tc("Accent")
    selSF.CanvasSize=UDim2.new(0,0,0,0); selSF.AutomaticCanvasSize=Enum.AutomaticSize.X
    selSF.ScrollingDirection=Enum.ScrollingDirection.X
    local ssLyt=Instance.new("UIListLayout",selSF)
    ssLyt.FillDirection=Enum.FillDirection.Horizontal
    ssLyt.VerticalAlignment=Enum.VerticalAlignment.Center; ssLyt.Padding=UDim.new(0,4)
    local ssPad=Instance.new("UIPadding",selSF)
    ssPad.PaddingLeft=UDim.new(0,4); ssPad.PaddingRight=UDim.new(0,4)

    local function refreshSelBox()
        for _,c in ipairs(selSF:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for nm in pairs(selBrainrots) do
            local chip=Instance.new("Frame",selSF)
            chip.Size=UDim2.new(0,0,0,26); chip.AutomaticSize=Enum.AutomaticSize.X
            chip.BackgroundColor3=tc("ButtonBg"); chip.BorderSizePixel=0; ac(chip,4)
            as(chip,tc("AccentStroke"),1)
            local cpPad=Instance.new("UIPadding",chip)
            cpPad.PaddingLeft=UDim.new(0,6); cpPad.PaddingRight=UDim.new(0,4)
            local cpLyt=Instance.new("UIListLayout",chip)
            cpLyt.FillDirection=Enum.FillDirection.Horizontal
            cpLyt.VerticalAlignment=Enum.VerticalAlignment.Center; cpLyt.Padding=UDim.new(0,4)
            local cpLbl=Instance.new("TextLabel",chip)
            cpLbl.Size=UDim2.new(0,0,0,18); cpLbl.AutomaticSize=Enum.AutomaticSize.X
            cpLbl.BackgroundTransparency=1; cpLbl.Text=nm; cpLbl.TextColor3=tc("Text")
            cpLbl.Font=Enum.Font.Gotham; cpLbl.TextSize=10
            local xb=Instance.new("TextButton",chip)
            xb.Size=UDim2.new(0,14,0,14); xb.BackgroundColor3=Color3.fromRGB(160,45,45)
            xb.Text="x"; xb.TextColor3=Color3.fromRGB(255,255,255)
            xb.Font=Enum.Font.GothamBold; xb.TextSize=9; xb.AutoButtonColor=false
            ac(xb,3)
            local capNm=nm
            xb.MouseButton1Click:Connect(function()
                selBrainrots[capNm]=nil; refreshSelBox(); buildDropdown(sBox.Text)
            end)
        end
    end

    buildDropdown=function(filter)
        for _,c in ipairs(dList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _,nm in ipairs(brainrotNames) do
            if filter=="" or nm:lower():find(filter:lower(),1,true) then
                local sel=selBrainrots[nm]
                local item=Instance.new("TextButton",dList)
                item.Size=UDim2.new(1,0,0,22); item.BorderSizePixel=0
                item.BackgroundColor3=sel and tc("AccentDark") or tc("CardBg")
                item.Text="  "..nm; item.Font=Enum.Font.Gotham; item.TextSize=11
                item.TextColor3=sel and tc("Text") or tc("TextDim")
                item.TextXAlignment=Enum.TextXAlignment.Left; item.AutoButtonColor=false
                ac(item,3)
                local capNm=nm
                item.MouseButton1Click:Connect(function()
                    selBrainrots[capNm]=selBrainrots[capNm]==nil and true or nil
                    buildDropdown(sBox.Text); refreshSelBox()
                end)
            end
        end
    end

    sBox:GetPropertyChangedSignal("Text"):Connect(function() buildDropdown(sBox.Text) end)

    task.spawn(function()
        pcall(function()
            local bf=ReplicatedStorage:WaitForChild("Brainrots",10)
            if not bf then return end
            local seen={}
            local function cm(m)
                if m:IsA("Model") and m.Name~="" and not seen[m.Name] then
                    seen[m.Name]=true; table.insert(brainrotNames,m.Name)
                end
            end
            for _,ch in ipairs(bf:GetChildren()) do
                if ch:IsA("Folder") then for _,m in ipairs(ch:GetChildren()) do cm(m) end
                else cm(ch) end
            end
            table.sort(brainrotNames); buildDropdown("")
        end)
    end)

    secLabel(pg,"Features",nlo())

    -- Auto Collect Cash (FIXED)
    local autoActive=false; local autoThread=nil

    local _,autoSet=buildToggle(pg,"Auto Collect Cash",nlo(),function(enabled)
        autoActive=enabled; state.autoCollect=enabled
        showNotif("Auto Collect Cash "..(enabled and "Enabled!" or "Disabled!"),
            enabled and tc("Accent") or Color3.fromRGB(200,70,70))
        if enabled then
            -- kill any old thread
            autoThread=task.spawn(function()
                while autoActive do
                    -- search immediately, no initial wait
                    pcall(function()
                        local gf=workspace:FindFirstChild("GameFolder")
                        if not gf then return end
                        local plots=gf:FindFirstChild("Plots")
                        if not plots then return end
                        local _,_,hrp=getChar()
                        if not hrp then return end
                        -- deep search for YourBaseAtt
                        for _,att in ipairs(plots:GetDescendants()) do
                            if att:IsA("Attachment") and att.Name=="YourBaseAtt" then
                                -- walk up to Model
                                local mdl=att.Parent
                                while mdl and not mdl:IsA("Model") do mdl=mdl.Parent end
                                if not mdl then return end
                                -- check title
                                local isMyBase=false
                                for _,d in ipairs(mdl:GetDescendants()) do
                                    if d:IsA("TextLabel") and d.Name=="Title" and d.Text=="YOUR BASE" then
                                        isMyBase=true; break
                                    end
                                end
                                if not isMyBase then return end
                                -- find Places folder
                                local places=nil
                                for _,d in ipairs(mdl:GetDescendants()) do
                                    if d:IsA("Folder") and d.Name=="Places" then places=d; break end
                                end
                                if not places then return end
                                -- fire all touch interests
                                for _,part in ipairs(places:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        pcall(function()
                                            if firetouchinterest then
                                                firetouchinterest(part,hrp,0)
                                                firetouchinterest(part,hrp,1)
                                            end
                                        end)
                                    end
                                end
                                -- processed our base, done for this tick
                                return
                            end
                        end
                    end)
                    -- only wait AFTER doing work, so first run is instant
                    task.wait(0.35)
                end
            end)
        end
    end)
    toggleSetters["Auto Collect Cash"]=autoSet

    onThemeUpdate(function()
        dropCtr.BackgroundColor3=tc("DropdownBg"); dcStr.Color=tc("Stroke")
        sBox.BackgroundColor3=tc("CardBg"); sBox.TextColor3=tc("Text"); sBox.PlaceholderColor3=tc("TextDim")
        dList.ScrollBarImageColor3=tc("Accent")
        selBox.BackgroundColor3=tc("CardBg"); sbStr.Color=tc("Stroke")
        selSF.ScrollBarImageColor3=tc("Accent")
        buildDropdown(sBox.Text); refreshSelBox()
    end)
end

-- ══════════════════════════════════
-- PLAYER WARNING OVERLAY
-- ══════════════════════════════════
do
    local ov=Instance.new("Frame",TabContent)
    playerWarnOverlay=ov
    ov.Name="WarnOv"; ov.Size=UDim2.new(1,0,1,0)
    ov.BackgroundColor3=Color3.fromRGB(0,0,0); ov.BackgroundTransparency=0.3
    ov.BorderSizePixel=0; ov.ZIndex=200; ov.Visible=false

    local wCard=Instance.new("Frame",ov)
    wCard.Size=UDim2.new(0.86,0,0,0); wCard.AutomaticSize=Enum.AutomaticSize.Y
    wCard.AnchorPoint=Vector2.new(0.5,0.5); wCard.Position=UDim2.new(0.5,0,0.5,0)
    wCard.BackgroundColor3=Color3.fromRGB(22,14,6); wCard.BorderSizePixel=0; wCard.ZIndex=201
    ac(wCard,6); as(wCard,Color3.fromRGB(220,140,30),1)
    local wLyt=Instance.new("UIListLayout",wCard)
    wLyt.FillDirection=Enum.FillDirection.Vertical
    wLyt.HorizontalAlignment=Enum.HorizontalAlignment.Center; wLyt.Padding=UDim.new(0,8)
    local wPad=Instance.new("UIPadding",wCard)
    wPad.PaddingTop=UDim.new(0,14); wPad.PaddingBottom=UDim.new(0,14)
    wPad.PaddingLeft=UDim.new(0,14); wPad.PaddingRight=UDim.new(0,14)

    local wT=Instance.new("TextLabel",wCard)
    wT.Size=UDim2.new(1,0,0,28); wT.BackgroundTransparency=1
    wT.Text="⚠️ Warning ⚠️"; wT.TextColor3=Color3.fromRGB(230,150,30)
    wT.Font=Enum.Font.GothamBold; wT.TextSize=18; wT.ZIndex=202

    local wD=Instance.new("TextLabel",wCard)
    wD.Size=UDim2.new(1,0,0,44); wD.BackgroundTransparency=1
    wD.Text="Using These Features Could Get You Banned, Use At Your Own Risk."
    wD.TextColor3=Color3.fromRGB(210,165,110); wD.Font=Enum.Font.GothamMedium
    wD.TextSize=12; wD.TextWrapped=true; wD.ZIndex=202

    local wRow=Instance.new("Frame",wCard)
    wRow.Size=UDim2.new(1,0,0,34); wRow.BackgroundTransparency=1; wRow.ZIndex=202
    local wRL=Instance.new("UIListLayout",wRow)
    wRL.FillDirection=Enum.FillDirection.Horizontal
    wRL.HorizontalAlignment=Enum.HorizontalAlignment.Center
    wRL.VerticalAlignment=Enum.VerticalAlignment.Center; wRL.Padding=UDim.new(0,10)

    local function mkWBtn(col,txt)
        local b=Instance.new("TextButton",wRow)
        b.Size=UDim2.new(0,112,0,30); b.BackgroundColor3=col
        b.Text=txt; b.TextColor3=Color3.fromRGB(255,255,255)
        b.Font=Enum.Font.GothamBold; b.TextSize=12; b.AutoButtonColor=false; b.ZIndex=203
        ac(b,4); return b
    end
    local okB=mkWBtn(Color3.fromRGB(35,140,55),"✓  OK")
    local gbB=mkWBtn(Color3.fromRGB(160,35,35),"✕  Go Back")
    okB.MouseButton1Click:Connect(function() state.playerWarnOk=true; ov.Visible=false end)
    gbB.MouseButton1Click:Connect(function() switchTab("Home") end)
end

-- ══════════════════════════════════
-- MOBILE FLIGHT BUTTONS
-- ══════════════════════════════════
local mobileFly=Instance.new("Frame",ScreenGui)
mobileFly.Name="MobileFly"; mobileFly.BackgroundTransparency=1
mobileFly.Size=UDim2.new(0,104,0,50); mobileFly.ZIndex=150; mobileFly.Visible=false

local flyUpHeld=false; local flyDownHeld=false

local function mkFlyBtn(lbl,xOff)
    local b=Instance.new("TextButton",mobileFly)
    b.Size=UDim2.new(0,46,0,46); b.Position=UDim2.new(0,xOff,0,0)
    b.BackgroundColor3=tc("OpenCloseBg"); b.BackgroundTransparency=0.15
    b.Text=lbl; b.TextColor3=Color3.fromRGB(230,230,230)
    b.Font=Enum.Font.GothamBold; b.TextSize=18; b.AutoButtonColor=false; b.ZIndex=151
    ac(b,23); as(b,tc("AccentStroke"),1); return b
end
local fuB=mkFlyBtn("▲",0); local fdB=mkFlyBtn("▼",52)

fuB.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then flyUpHeld=true end end)
fuB.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then flyUpHeld=false end end)
fdB.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then flyDownHeld=true end end)
fdB.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then flyDownHeld=false end end)

local function updMobPos()
    local vp=Camera.ViewportSize
    mobileFly.Position=UDim2.new(0,vp.X-114,0,vp.Y-88)
end

onThemeUpdate(function()
    fuB.BackgroundColor3=tc("OpenCloseBg"); fdB.BackgroundColor3=tc("OpenCloseBg")
    for _,b in ipairs({fuB,fdB}) do
        for _,c in ipairs(b:GetChildren()) do if c:IsA("UIStroke") then c.Color=tc("AccentStroke") end end
    end
end)

-- ══════════════════════════════════
-- PLAYER TAB
-- ══════════════════════════════════
do
    local pg=tabPages["Player"]; local lo=0
    local function nlo() lo+=1; return lo end

    secLabel(pg,"Speed",nlo())

    -- Speed max input
    local smR=Instance.new("Frame",pg)
    smR.Size=UDim2.new(1,0,0,30); smR.BackgroundColor3=tc("CardBg")
    smR.BorderSizePixel=0; smR.LayoutOrder=nlo(); ac(smR,4)
    local smRS=as(smR,tc("Stroke"),1)
    local smL=Instance.new("TextLabel",smR)
    smL.Size=UDim2.new(0.55,0,1,0); smL.Position=UDim2.new(0,8,0,0)
    smL.BackgroundTransparency=1; smL.Text="Slider Max:"; smL.TextColor3=tc("TextDim")
    smL.Font=Enum.Font.GothamMedium; smL.TextSize=11; smL.TextXAlignment=Enum.TextXAlignment.Left
    local smB=Instance.new("TextBox",smR)
    smB.Size=UDim2.new(0.36,0,0,22); smB.Position=UDim2.new(0.62,0,0.5,-11)
    smB.BackgroundColor3=tc("DropdownBg"); smB.BorderSizePixel=0
    smB.Text="100"; smB.TextColor3=tc("Text"); smB.Font=Enum.Font.Gotham
    smB.TextSize=12; smB.ClearTextOnFocus=false; ac(smB,4); as(smB,tc("Stroke"),1)
    onThemeUpdate(function()
        smR.BackgroundColor3=tc("CardBg"); smRS.Color=tc("Stroke")
        smL.TextColor3=tc("TextDim"); smB.BackgroundColor3=tc("DropdownBg"); smB.TextColor3=tc("Text")
    end)

    local _,getSpdV,setSpdRange,setSpdV=buildSlider(pg,"Walk Speed",16,100,16,nlo(),function(v)
        state.speedValue=v
        if state.speedEnabled then pcall(function() local _,h=getChar(); if h then h.WalkSpeed=v end end) end
    end)
    sliderGetters["speed"]=getSpdV; sliderSetters["speed"]=setSpdV

    smB:GetPropertyChangedSignal("Text"):Connect(function()
        local n=tonumber(smB.Text); if n and n>16 then state.speedMaxValue=n; setSpdRange(16,n) end
    end)

    local _,spdTogSet=buildToggle(pg,"Speed Boost",nlo(),function(en)
        state.speedEnabled=en
        showNotif("Speed Boost "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        local _,h=getChar(); if not h then return end
        if en then h.WalkSpeed=getSpdV()
        else pcall(function()
            local lbl=LocalPlayer.PlayerGui.HUD.Speed
            local n=lbl.Text:match("%d+%.?%d*"); if n then h.WalkSpeed=tonumber(n) end
        end) end
    end)
    toggleSetters["Speed Boost"]=spdTogSet

    secLabel(pg,"Jump",nlo())

    local _,getJmpV,_,setJmpV=buildSlider(pg,"Jump Power",30,200,30,nlo(),function(v)
        state.jumpValue=v
        if state.jumpEnabled then pcall(function() local _,h=getChar(); if h then h.JumpPower=v end end) end
    end)
    sliderGetters["jump"]=getJmpV; sliderSetters["jump"]=setJmpV

    local _,jmpTogSet=buildToggle(pg,"Jump Boost",nlo(),function(en)
        state.jumpEnabled=en
        showNotif("Jump Boost "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        local _,h=getChar(); if not h then return end
        if en then h.JumpPower=getJmpV()
        else pcall(function()
            local lbl=LocalPlayer.PlayerGui.HUD.Jump
            local n=lbl.Text:match("%d+%.?%d*"); if n then h.JumpPower=30+tonumber(n)*(10/3) end
        end) end
    end)
    toggleSetters["Jump Boost"]=jmpTogSet

    secLabel(pg,"Survival",nlo())

    local lavaOff={}
    local _,godTogSet=buildToggle(pg,"Godmode (Disable Lava)",nlo(),function(en)
        state.godmodeEnabled=en
        showNotif("Godmode "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        if en then
            pcall(function()
                for _,p in ipairs(workspace.GameFolder.Lavas:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanTouch then p.CanTouch=false; table.insert(lavaOff,p) end
                end
            end)
        else
            for _,p in ipairs(lavaOff) do pcall(function() p.CanTouch=true end) end; lavaOff={}
        end
    end)
    toggleSetters["Godmode"]=godTogSet

    secLabel(pg,"Movement",nlo())

    -- Flight
    local flyConn=nil; local flyEnabled=false

    local _,getFlySpd,_,setFlySpd=buildSlider(pg,"Flight Speed",10,200,50,nlo(),function(v)
        state.flySpeed=v
    end)
    sliderGetters["flySpeed"]=getFlySpd; sliderSetters["flySpeed"]=setFlySpd

    local function doStartFlight()
        local _,hum,hrp=getChar()
        if not (hum and hrp) then return end
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)

        flyConn=RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            local ch=LocalPlayer.Character
            if not ch then return end
            local h=ch:FindFirstChildOfClass("Humanoid")
            local r=ch:FindFirstChild("HumanoidRootPart")
            if not (h and r) then return end

            -- Keep in physics state
            pcall(function()
                if h:GetState()~=Enum.HumanoidStateType.Physics then
                    h:ChangeState(Enum.HumanoidStateType.Physics)
                end
            end)

            -- READ CAMERA FRESH THIS FRAME
            local camCF=workspace.CurrentCamera.CFrame
            local spd=getFlySpd()
            local mv=Vector3.zero

            -- Keyboard (PC)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv+=camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv-=camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv-=camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv+=camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then mv+=Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv-=Vector3.yAxis end

            -- Mobile thumbstick (horizontal plane mapped to camera)
            local md=h.MoveDirection
            if md.Magnitude>0.05 then
                local fwd=Vector3.new(camCF.LookVector.X,0,camCF.LookVector.Z)
                local rgt=Vector3.new(camCF.RightVector.X,0,camCF.RightVector.Z)
                if fwd.Magnitude>0.001 then fwd=fwd.Unit end
                if rgt.Magnitude>0.001 then rgt=rgt.Unit end
                local fl=Vector3.new(md.X,0,md.Z)
                if fl.Magnitude>0.001 then
                    fl=fl.Unit; mv+=fwd*(-fl.Z)+rgt*fl.X
                end
            end

            -- Mobile up/down buttons
            if flyUpHeld   then mv+=Vector3.yAxis end
            if flyDownHeld then mv-=Vector3.yAxis end

            -- Apply velocity – zero means hover (cancels gravity by overriding every frame)
            if mv.Magnitude>0.001 then
                r.AssemblyLinearVelocity=mv.Unit*spd
            else
                r.AssemblyLinearVelocity=Vector3.zero
            end
        end)
    end

    local function doStopFlight()
        if flyConn then flyConn:Disconnect(); flyConn=nil end
        local _,h,r=getChar()
        if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
        if r then r.AssemblyLinearVelocity=Vector3.zero end
        mobileFly.Visible=false; flyUpHeld=false; flyDownHeld=false
    end

    local _,flyTogSet=buildToggle(pg,"Flight",nlo(),function(en)
        flyEnabled=en; state.flyEnabled=en
        showNotif("Flight "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        if en then mobileFly.Visible=true; updMobPos(); doStartFlight()
        else doStopFlight() end
    end)
    toggleSetters["Flight"]=flyTogSet

    -- Cheese Teleporter
    local cheeseActive=false
    local _,cheeseTogSet=buildToggle(pg,"Cheese Teleporter",nlo(),function(en)
        cheeseActive=en; state.cheeseEnabled=en
        showNotif("Cheese Teleporter "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        if en then
            task.spawn(function()
                while cheeseActive do
                    pcall(function()
                        local cf=workspace:FindFirstChild("GameFolder")
                        if not cf then return end
                        local chf=cf:FindFirstChild("CheeseFolder")
                        if not chf then return end
                        local ch=LocalPlayer.Character
                        if not ch then return end
                        local hrp=ch:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end
                        for _,model in ipairs(chf:GetChildren()) do
                            if not cheeseActive then break end
                            if model:IsA("Model") then
                                local tp=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                                if tp then
                                    hrp.CFrame=CFrame.new(tp.Position+Vector3.new(0,3,0))
                                    for _,part in ipairs(model:GetDescendants()) do
                                        if part:IsA("BasePart") and part:FindFirstChildOfClass("TouchInterest") then
                                            pcall(function()
                                                firetouchinterest(hrp,part,0)
                                                firetouchinterest(hrp,part,1)
                                            end)
                                        end
                                    end
                                    task.wait(0.5)
                                end
                            end
                        end
                    end)
                    if cheeseActive then task.wait(0.1) end
                end
            end)
        end
    end)
    toggleSetters["Cheese Teleporter"]=cheeseTogSet

    -- Teleport to Brainrots
    local _,tpTogSet=buildToggle(pg,"Teleport to Brainrots",nlo(),function(en)
        state.teleportEnabled=en
        showNotif("Teleport to Brainrots "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
    end)
    toggleSetters["Teleport to Brainrots"]=tpTogSet

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.8)
        local h=char:WaitForChild("Humanoid",5); if not h then return end
        if state.speedEnabled then pcall(function() h.WalkSpeed=getSpdV() end) end
        if state.jumpEnabled  then pcall(function() h.JumpPower=getJmpV() end) end
        if state.flyEnabled   then flyEnabled=true; task.wait(0.3); doStartFlight() end
    end)
end

-- ══════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════
do
    local pg=tabPages["Visual"]; local lo=0
    local function nlo() lo+=1; return lo end

    secLabel(pg,"Brainrot Visuals",nlo())
    local _,brainHLSet=buildToggle(pg,"Highlight Selected Brainrots",nlo(),function(en)
        state.brainHighlight=en
        showNotif("Brainrot Highlight "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        if not en then for _,hl in pairs(brainHLs) do pcall(function() hl:Destroy() end) end; brainHLs={} end
    end)
    toggleSetters["Brainrot Highlight"]=brainHLSet

    secLabel(pg,"Player Visuals",nlo())
    local plHLActive=false; local plHLs={}; local plBBs={}
    local plHLC=nil; local plAC=nil

    local function addPlVis(p)
        if p==LocalPlayer then return end
        local c=p.Character; if not c then return end
        if plHLs[p] then pcall(function() plHLs[p]:Destroy() end) end
        if plBBs[p] then pcall(function() plBBs[p].gui:Destroy() end) end
        local hl=Instance.new("Highlight",c)
        hl.FillColor=Color3.fromRGB(100,175,245); hl.OutlineColor=Color3.fromRGB(200,220,255)
        hl.FillTransparency=0.45; hl.OutlineTransparency=0; plHLs[p]=hl
        local hd=c:FindFirstChild("Head")
        if hd then
            local bb=Instance.new("BillboardGui",hd)
            bb.Name="PC_BB"; bb.Size=UDim2.new(0,115,0,36); bb.StudsOffset=Vector3.new(0,2.5,0); bb.AlwaysOnTop=true
            local il=Instance.new("TextLabel",bb)
            il.Size=UDim2.new(1,0,1,0); il.BackgroundTransparency=1
            il.Text=p.DisplayName.."\n..."; il.TextColor3=Color3.fromRGB(240,240,240)
            il.Font=Enum.Font.GothamBold; il.TextSize=11
            il.TextStrokeTransparency=0.3; il.TextStrokeColor3=Color3.fromRGB(0,0,0)
            plBBs[p]={gui=bb,lbl=il}
        end
    end

    local function clearPlVis()
        if plHLC then plHLC:Disconnect(); plHLC=nil end
        for _,h in pairs(plHLs) do pcall(function() h:Destroy() end) end
        for _,d in pairs(plBBs) do pcall(function() d.gui:Destroy() end) end
        plHLs={}; plBBs={}
    end

    local _,plHLSet=buildToggle(pg,"Highlight Other Players",nlo(),function(en)
        plHLActive=en; state.playerHighlight=en
        showNotif("Player Highlight "..(en and "Enabled!" or "Disabled!"),en and tc("Accent") or Color3.fromRGB(200,70,70))
        if en then
            for _,p in ipairs(Players:GetPlayers()) do addPlVis(p) end
            plAC=Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function() task.wait(0.5); if plHLActive then addPlVis(p) end end)
            end)
            for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then
                p.CharacterAdded:Connect(function() task.wait(0.5); if plHLActive then addPlVis(p) end end)
            end end
            plHLC=RunService.Heartbeat:Connect(function()
                local lc=LocalPlayer.Character; local lr=lc and lc:FindFirstChild("HumanoidRootPart")
                for p,d in pairs(plBBs) do pcall(function()
                    local pc=p.Character; local pr=pc and pc:FindFirstChild("HumanoidRootPart")
                    if pr and lr then d.lbl.Text=p.DisplayName.."\n"..math.floor((pr.Position-lr.Position).Magnitude).." studs" end
                end) end
            end)
        else
            clearPlVis()
            if plAC then plAC:Disconnect(); plAC=nil end
        end
    end)
    toggleSetters["Player Highlight"]=plHLSet
end

-- ══════════════════════════════════
-- SETTINGS TAB
-- ══════════════════════════════════
do
    local pg=tabPages["Settings"]; local lo=0
    local function nlo() lo+=1; return lo end

    -- ── Theme Picker ──
    secLabel(pg,"Theme",nlo())

    local thHdr=Instance.new("Frame",pg)
    thHdr.Size=UDim2.new(1,0,0,32); thHdr.BackgroundColor3=tc("CardBg")
    thHdr.BorderSizePixel=0; thHdr.LayoutOrder=nlo(); ac(thHdr,4)
    local thHdrS=as(thHdr,tc("Stroke"),1)

    local thCurL=Instance.new("TextLabel",thHdr)
    thCurL.Size=UDim2.new(0.62,0,1,0); thCurL.Position=UDim2.new(0,10,0,0)
    thCurL.BackgroundTransparency=1; thCurL.Text="Theme: "..currentThemeName
    thCurL.TextColor3=tc("Text"); thCurL.Font=Enum.Font.GothamMedium
    thCurL.TextSize=12; thCurL.TextXAlignment=Enum.TextXAlignment.Left

    local thChgB=Instance.new("TextButton",thHdr)
    thChgB.Size=UDim2.new(0,72,0,22); thChgB.Position=UDim2.new(1,-80,0.5,-11)
    thChgB.BackgroundColor3=tc("ButtonBg"); thChgB.Text="Change"
    thChgB.TextColor3=tc("Text"); thChgB.Font=Enum.Font.GothamBold
    thChgB.TextSize=11; thChgB.AutoButtonColor=false; ac(thChgB,4); as(thChgB,tc("Stroke"),1)

    local thOpts=Instance.new("Frame",pg)
    thOpts.Size=UDim2.new(1,0,0,0); thOpts.BackgroundColor3=tc("DropdownBg")
    thOpts.BorderSizePixel=0; thOpts.LayoutOrder=nlo(); thOpts.ClipsDescendants=true
    ac(thOpts,4); local thOptsS=as(thOpts,tc("Stroke"),1)
    local thOptsL=Instance.new("UIListLayout",thOpts)
    thOptsL.FillDirection=Enum.FillDirection.Vertical; thOptsL.Padding=UDim.new(0,1)
    local thOptsPad=Instance.new("UIPadding",thOpts)
    thOptsPad.PaddingTop=UDim.new(0,3); thOptsPad.PaddingBottom=UDim.new(0,3)
    thOptsPad.PaddingLeft=UDim.new(0,4); thOptsPad.PaddingRight=UDim.new(0,4)

    local THEME_LIST={"Original","Sky","Lava"}
    local thOptB={}

    local function refreshThOptColors()
        for _,nm in ipairs(THEME_LIST) do
            local b=thOptB[nm]; if not b then continue end
            if currentThemeName==nm then
                b.BackgroundColor3=tc("AccentDark"); b.TextColor3=tc("Text")
                b.Font=Enum.Font.GothamBold
            else
                b.BackgroundColor3=tc("CardBg"); b.TextColor3=tc("TextDim")
                b.Font=Enum.Font.GothamMedium
            end
        end
    end

    for _,nm in ipairs(THEME_LIST) do
        local b=Instance.new("TextButton",thOpts)
        b.Size=UDim2.new(1,0,0,28); b.BorderSizePixel=0
        b.BackgroundColor3=(nm==currentThemeName) and tc("AccentDark") or tc("CardBg")
        b.Text=nm; b.Font=(nm==currentThemeName) and Enum.Font.GothamBold or Enum.Font.GothamMedium
        b.TextColor3=(nm==currentThemeName) and tc("Text") or tc("TextDim")
        b.TextSize=12; b.AutoButtonColor=false; ac(b,3)
        thOptB[nm]=b
        b.MouseButton1Click:Connect(function()
            setTheme(nm); thCurL.Text="Theme: "..nm
            refreshThOptColors()
            tw(thOpts,{Size=UDim2.new(1,0,0,0)},0.15)
        end)
    end

    local thExp=false; local thH=#THEME_LIST*30+8
    thChgB.MouseButton1Click:Connect(function()
        thExp=not thExp; tw(thOpts,{Size=UDim2.new(1,0,0,thExp and thH or 0)},0.18)
    end)

    -- Custom theme button
    local custBtnF=Instance.new("Frame",pg)
    custBtnF.Size=UDim2.new(1,0,0,48); custBtnF.BackgroundColor3=tc("CardBg")
    custBtnF.BorderSizePixel=0; custBtnF.LayoutOrder=nlo(); ac(custBtnF,4)
    local custBtnFS=as(custBtnF,tc("AccentStroke"),1)
    local custBtnL=Instance.new("TextLabel",custBtnF)
    custBtnL.Size=UDim2.new(1,-16,1,0); custBtnL.Position=UDim2.new(0,8,0,0)
    custBtnL.BackgroundTransparency=1
    custBtnL.Text="Can't find your theme?\nClick here to customise the UI colours"
    custBtnL.TextColor3=tc("Text"); custBtnL.Font=Enum.Font.GothamMedium
    custBtnL.TextSize=11; custBtnL.TextWrapped=true
    custBtnL.TextXAlignment=Enum.TextXAlignment.Left
    local custBtnClick=Instance.new("TextButton",custBtnF)
    custBtnClick.Size=UDim2.new(1,0,1,0); custBtnClick.BackgroundTransparency=1; custBtnClick.Text=""

    local custEd=Instance.new("Frame",pg)
    custEd.Size=UDim2.new(1,0,0,0); custEd.BackgroundColor3=tc("CardBg")
    custEd.BorderSizePixel=0; custEd.LayoutOrder=nlo(); custEd.ClipsDescendants=true
    ac(custEd,4); local custEdS=as(custEd,tc("Stroke"),1)

    local custSF=Instance.new("ScrollingFrame",custEd)
    custSF.Size=UDim2.new(1,0,1,0); custSF.BackgroundTransparency=1; custSF.BorderSizePixel=0
    custSF.ScrollBarThickness=3; custSF.ScrollBarImageColor3=tc("Accent")
    custSF.CanvasSize=UDim2.new(0,0,0,0); custSF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local custSFL=Instance.new("UIListLayout",custSF)
    custSFL.FillDirection=Enum.FillDirection.Vertical; custSFL.Padding=UDim.new(0,4)
    local custSFP=Instance.new("UIPadding",custSF)
    custSFP.PaddingTop=UDim.new(0,8); custSFP.PaddingBottom=UDim.new(0,8)
    custSFP.PaddingLeft=UDim.new(0,8); custSFP.PaddingRight=UDim.new(0,8)

    local CUST_PARTS={"Background","SecondaryBg","CardBg","Accent","AccentDark","Text","TextDim",
        "TabBg","TabActive","ToggleOn","ToggleOff","SliderFill","SliderBg","Stroke","AccentStroke",
        "ButtonBg","DropdownBg","OpenCloseBg","ScrollBar","SectionText","GradStart","GradEnd"}

    local custColors={}
    for _,k in ipairs(CUST_PARTS) do custColors[k]=tc(k) end

    local function c3hex(c)
        if typeof(c)~="Color3" then return "#808080" end
        return string.format("#%02X%02X%02X",math.round(c.R*255),math.round(c.G*255),math.round(c.B*255))
    end
    local function hex3(h)
        h=h:gsub("#",""); if #h~=6 then return nil end
        local r,g,b=tonumber(h:sub(1,2),16),tonumber(h:sub(3,4),16),tonumber(h:sub(5,6),16)
        if r and g and b then return Color3.fromRGB(r,g,b) end
    end

    for _,pn in ipairs(CUST_PARTS) do
        local row=Instance.new("Frame",custSF)
        row.Size=UDim2.new(1,0,0,26); row.BackgroundTransparency=1
        local rl=Instance.new("UIListLayout",row)
        rl.FillDirection=Enum.FillDirection.Horizontal; rl.VerticalAlignment=Enum.VerticalAlignment.Center; rl.Padding=UDim.new(0,6)
        local lbl=Instance.new("TextLabel",row)
        lbl.Size=UDim2.new(0.44,0,1,0); lbl.BackgroundTransparency=1
        lbl.Text=pn; lbl.TextColor3=tc("TextDim"); lbl.Font=Enum.Font.Gotham
        lbl.TextSize=10; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextWrapped=true
        local box=Instance.new("TextBox",row)
        box.Size=UDim2.new(0.37,0,0,20); box.BackgroundColor3=tc("DropdownBg"); box.BorderSizePixel=0
        box.Text=c3hex(custColors[pn]); box.TextColor3=tc("Text"); box.Font=Enum.Font.Code
        box.TextSize=10; box.ClearTextOnFocus=false; ac(box,3); as(box,tc("Stroke"),1)
        local prev=Instance.new("Frame",row)
        prev.Size=UDim2.new(0,18,0,18); prev.BackgroundColor3=custColors[pn]; prev.BorderSizePixel=0; ac(prev,3)
        local capPn=pn
        box:GetPropertyChangedSignal("Text"):Connect(function()
            local c=hex3(box.Text); if c then custColors[capPn]=c; prev.BackgroundColor3=c end
        end)
        onThemeUpdate(function()
            lbl.TextColor3=tc("TextDim"); box.BackgroundColor3=tc("DropdownBg"); box.TextColor3=tc("Text")
            custColors[capPn]=tc(capPn); box.Text=c3hex(custColors[capPn]); prev.BackgroundColor3=custColors[capPn]
        end)
    end

    local applyB=Instance.new("TextButton",custSF)
    applyB.Size=UDim2.new(1,0,0,30); applyB.BackgroundColor3=tc("AccentDark"); applyB.Text="Apply Custom Theme"
    applyB.TextColor3=tc("Text"); applyB.Font=Enum.Font.GothamBold; applyB.TextSize=12
    applyB.AutoButtonColor=false; ac(applyB,4); as(applyB,tc("AccentStroke"),1)
    applyB.MouseButton1Click:Connect(function()
        setTheme("Custom",custColors); thCurL.Text="Theme: Custom"
        showNotif("Custom Theme Applied!",tc("Accent"))
    end)

    local ceExp=false; local ceH=#CUST_PARTS*30+52
    custBtnClick.MouseButton1Click:Connect(function()
        ceExp=not ceExp; tw(custEd,{Size=UDim2.new(1,0,0,ceExp and ceH or 0)},0.24)
    end)

    onThemeUpdate(function()
        thHdr.BackgroundColor3=tc("CardBg"); thHdrS.Color=tc("Stroke")
        thCurL.TextColor3=tc("Text"); thChgB.BackgroundColor3=tc("ButtonBg"); thChgB.TextColor3=tc("Text")
        thOpts.BackgroundColor3=tc("DropdownBg"); thOptsS.Color=tc("Stroke")
        refreshThOptColors()
        custBtnF.BackgroundColor3=tc("CardBg"); custBtnFS.Color=tc("AccentStroke"); custBtnL.TextColor3=tc("Text")
        custEd.BackgroundColor3=tc("CardBg"); custEdS.Color=tc("Stroke")
        custSF.ScrollBarImageColor3=tc("Accent")
        applyB.BackgroundColor3=tc("AccentDark"); applyB.TextColor3=tc("Text")
    end)

    -- ── PC Hotkeys ──
    if isPC then
        secLabel(pg,"Hotkeys (PC Only)",nlo())

        local hkInfo=Instance.new("Frame",pg)
        hkInfo.Size=UDim2.new(1,0,0,22); hkInfo.BackgroundColor3=tc("CardBg")
        hkInfo.BorderSizePixel=0; hkInfo.LayoutOrder=nlo(); ac(hkInfo,4)
        local hkInfoL=Instance.new("TextLabel",hkInfo)
        hkInfoL.Size=UDim2.new(1,-10,1,0); hkInfoL.Position=UDim2.new(0,8,0,0)
        hkInfoL.BackgroundTransparency=1; hkInfoL.TextXAlignment=Enum.TextXAlignment.Left
        hkInfoL.Text="Click Bind then press a key to assign"; hkInfoL.Font=Enum.Font.Gotham
        hkInfoL.TextSize=10; hkInfoL.TextColor3=tc("TextDim"); ac(hkInfo,4)
        onThemeUpdate(function()
            hkInfo.BackgroundColor3=tc("CardBg"); hkInfoL.TextColor3=tc("TextDim")
        end)

        local HK_FEATURES={"Speed Boost","Jump Boost","Godmode","Flight","Cheese Teleporter",
            "Teleport to Brainrots","Brainrot Highlight","Player Highlight","Auto Collect Cash"}

        local hkBtns={}
        for _,fn in ipairs(HK_FEATURES) do
            local row=Instance.new("Frame",pg)
            row.Size=UDim2.new(1,0,0,28); row.BackgroundColor3=tc("CardBg")
            row.BorderSizePixel=0; row.LayoutOrder=nlo(); ac(row,4)
            local rowS=as(row,tc("Stroke"),1)
            local nameL=Instance.new("TextLabel",row)
            nameL.Size=UDim2.new(0.55,0,1,0); nameL.Position=UDim2.new(0,8,0,0)
            nameL.BackgroundTransparency=1; nameL.Text=fn; nameL.TextColor3=tc("Text")
            nameL.Font=Enum.Font.GothamMedium; nameL.TextSize=11; nameL.TextXAlignment=Enum.TextXAlignment.Left
            nameL.TextWrapped=true
            local hkL=Instance.new("TextLabel",row)
            hkL.Size=UDim2.new(0.2,0,1,0); hkL.Position=UDim2.new(0.55,0,0,0)
            hkL.BackgroundTransparency=1; hkL.Text=hotkeys[fn] and tostring(hotkeys[fn].Name) or "None"
            hkL.TextColor3=tc("Accent"); hkL.Font=Enum.Font.GothamMedium; hkL.TextSize=11
            local bindB=Instance.new("TextButton",row)
            bindB.Size=UDim2.new(0,46,0,20); bindB.Position=UDim2.new(1,-54,0.5,-10)
            bindB.BackgroundColor3=tc("ButtonBg"); bindB.Text="Bind"
            bindB.TextColor3=tc("Text"); bindB.Font=Enum.Font.GothamBold
            bindB.TextSize=10; bindB.AutoButtonColor=false; ac(bindB,4)
            hkBtns[fn]={btn=bindB,lbl=hkL,row=row,rowS=rowS,nameL=nameL}
            local capFn=fn
            bindB.MouseButton1Click:Connect(function()
                bindB.Text="..."; bindB.BackgroundColor3=tc("AccentDark")
                hotkeyRebindMode=true; hotkeyRebindTarget=capFn
                hotkeyRebindCallback=function(kc)
                    hotkeys[capFn]=kc
                    hkL.Text=kc.Name
                    bindB.Text="Bind"; bindB.BackgroundColor3=tc("ButtonBg")
                    hotkeyRebindMode=false; hotkeyRebindTarget=nil; hotkeyRebindCallback=nil
                end
            end)
            onThemeUpdate(function()
                row.BackgroundColor3=tc("CardBg"); rowS.Color=tc("Stroke")
                nameL.TextColor3=tc("Text"); hkL.TextColor3=tc("Accent")
                bindB.BackgroundColor3=tc("ButtonBg"); bindB.TextColor3=tc("Text")
            end)
        end
    end

    -- ── Config Save/Load ──
    secLabel(pg,"Configs",nlo())

    local cfgRow=Instance.new("Frame",pg)
    cfgRow.Size=UDim2.new(1,0,0,30); cfgRow.BackgroundColor3=tc("CardBg")
    cfgRow.BorderSizePixel=0; cfgRow.LayoutOrder=nlo(); ac(cfgRow,4)
    local cfgRowS=as(cfgRow,tc("Stroke"),1)

    local cfgNameBox=Instance.new("TextBox",cfgRow)
    cfgNameBox.Size=UDim2.new(1,-92,0,22); cfgNameBox.Position=UDim2.new(0,6,0.5,-11)
    cfgNameBox.BackgroundColor3=tc("DropdownBg"); cfgNameBox.BorderSizePixel=0
    cfgNameBox.PlaceholderText="Config name..."; cfgNameBox.Text=""
    cfgNameBox.TextColor3=tc("Text"); cfgNameBox.PlaceholderColor3=tc("TextDim")
    cfgNameBox.Font=Enum.Font.Gotham; cfgNameBox.TextSize=11; cfgNameBox.ClearTextOnFocus=false
    ac(cfgNameBox,4); as(cfgNameBox,tc("Stroke"),1)
    local cnbPad=Instance.new("UIPadding",cfgNameBox); cnbPad.PaddingLeft=UDim.new(0,6)

    local saveB=Instance.new("TextButton",cfgRow)
    saveB.Size=UDim2.new(0,80,0,22); saveB.Position=UDim2.new(1,-86,0.5,-11)
    saveB.BackgroundColor3=tc("AccentDark"); saveB.Text="Save Config"
    saveB.TextColor3=tc("Text"); saveB.Font=Enum.Font.GothamBold
    saveB.TextSize=10; saveB.AutoButtonColor=false; ac(saveB,4)

    -- Config list
    local cfgListFrame=Instance.new("Frame",pg)
    cfgListFrame.Size=UDim2.new(1,0,0,0); cfgListFrame.BackgroundColor3=tc("DropdownBg")
    cfgListFrame.BorderSizePixel=0; cfgListFrame.LayoutOrder=nlo(); cfgListFrame.ClipsDescendants=true
    ac(cfgListFrame,4); local cfgListS=as(cfgListFrame,tc("Stroke"),1)
    local cfgSF=Instance.new("ScrollingFrame",cfgListFrame)
    cfgSF.Size=UDim2.new(1,0,1,0); cfgSF.BackgroundTransparency=1; cfgSF.BorderSizePixel=0
    cfgSF.ScrollBarThickness=3; cfgSF.ScrollBarImageColor3=tc("Accent")
    cfgSF.CanvasSize=UDim2.new(0,0,0,0); cfgSF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local cfgSFL=Instance.new("UIListLayout",cfgSF)
    cfgSFL.FillDirection=Enum.FillDirection.Vertical; cfgSFL.Padding=UDim.new(0,2)
    local cfgSFP=Instance.new("UIPadding",cfgSF)
    cfgSFP.PaddingTop=UDim.new(0,4); cfgSFP.PaddingBottom=UDim.new(0,4)
    cfgSFP.PaddingLeft=UDim.new(0,4); cfgSFP.PaddingRight=UDim.new(0,4)

    local function buildConfigEntry(name)
        local row=Instance.new("Frame",cfgSF)
        row.Size=UDim2.new(1,0,0,26); row.BackgroundColor3=tc("CardBg")
        row.BorderSizePixel=0; ac(row,4); as(row,tc("Stroke"),1)
        local nl=Instance.new("TextLabel",row)
        nl.Size=UDim2.new(1,-86,1,0); nl.Position=UDim2.new(0,8,0,0)
        nl.BackgroundTransparency=1; nl.Text=name; nl.TextColor3=tc("Text")
        nl.Font=Enum.Font.Gotham; nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left

        local function mkCBtn(col,txt,xOff)
            local b=Instance.new("TextButton",row)
            b.Size=UDim2.new(0,36,0,18); b.Position=UDim2.new(1,xOff,0.5,-9)
            b.BackgroundColor3=col; b.Text=txt; b.TextColor3=Color3.fromRGB(255,255,255)
            b.Font=Enum.Font.GothamBold; b.TextSize=9; b.AutoButtonColor=false; ac(b,3); return b
        end
        local loadB=mkCBtn(tc("AccentDark"),"Load",-42)
        local delB =mkCBtn(Color3.fromRGB(140,35,35),"Del",-82)

        loadB.MouseButton1Click:Connect(function()
            local raw=rf(SAVE_DIR.."/"..name..".json")
            if not raw then showNotif("Config not found",Color3.fromRGB(200,70,70)); return end
            pcall(function()
                local cfg=HttpService:JSONDecode(raw)
                -- apply theme
                if cfg.theme then setTheme(cfg.theme); thCurL.Text="Theme: "..cfg.theme end
                -- apply toggles
                if cfg.toggles then
                    for tname,val in pairs(cfg.toggles) do
                        if toggleSetters[tname] then toggleSetters[tname](val,false) end
                    end
                end
                -- apply sliders
                if cfg.sliders then
                    if cfg.sliders.speed and sliderSetters.speed then sliderSetters.speed(cfg.sliders.speed) end
                    if cfg.sliders.jump  and sliderSetters.jump  then sliderSetters.jump(cfg.sliders.jump)   end
                    if cfg.sliders.flySpeed and sliderSetters.flySpeed then sliderSetters.flySpeed(cfg.sliders.flySpeed) end
                end
                -- apply hotkeys
                if cfg.hotkeys and isPC then
                    for fn,kname in pairs(cfg.hotkeys) do
                        pcall(function() hotkeys[fn]=Enum.KeyCode[kname] end)
                    end
                end
            end)
            showNotif("Loaded: "..name,tc("Accent"))
        end)
        delB.MouseButton1Click:Connect(function()
            pcall(function() if delfile then delfile(SAVE_DIR.."/"..name..".json") end end)
            row:Destroy()
            -- resize list
            local ch=cfgSFL:GetChildren(); local h=math.max(0,#ch*28)
            cfgListFrame.Size=UDim2.new(1,0,0,math.min(h+8,120))
        end)
        onThemeUpdate(function()
            row.BackgroundColor3=tc("CardBg"); nl.TextColor3=tc("Text"); loadB.BackgroundColor3=tc("AccentDark")
        end)
    end

    local function refreshConfigList()
        for _,c in ipairs(cfgSF:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        pcall(function()
            if isfolder and isfolder(SAVE_DIR) then
                for _,f in ipairs(listfiles and listfiles(SAVE_DIR) or {}) do
                    local nm=f:match("([^/\\]+)%.json$")
                    if nm then buildConfigEntry(nm) end
                end
            end
        end)
        local cnt=#cfgSFL:GetChildren()
        cfgListFrame.Size=UDim2.new(1,0,0,math.min(cnt*28+8,120))
    end
    refreshConfigList()

    saveB.MouseButton1Click:Connect(function()
        local nm=cfgNameBox.Text:gsub("[^%w_%-]","")
        if nm=="" then showNotif("Enter a config name",Color3.fromRGB(200,70,70)); return end
        local toggleStates={}
        for tname,fn in pairs(toggleSetters) do
            -- get state from global state table (we mirror it)
            local v=false
            if tname=="Speed Boost"        then v=state.speedEnabled
            elseif tname=="Jump Boost"     then v=state.jumpEnabled
            elseif tname=="Godmode"        then v=state.godmodeEnabled
            elseif tname=="Flight"         then v=state.flyEnabled
            elseif tname=="Cheese Teleporter" then v=state.cheeseEnabled
            elseif tname=="Teleport to Brainrots" then v=state.teleportEnabled
            elseif tname=="Brainrot Highlight" then v=state.brainHighlight
            elseif tname=="Player Highlight"   then v=state.playerHighlight
            elseif tname=="Auto Collect Cash"  then v=state.autoCollect
            end
            toggleStates[tname]=v
        end
        local hkSave={}
        for fn,kc in pairs(hotkeys) do hkSave[fn]=kc.Name end
        local cfg={
            theme=currentThemeName,
            toggles=toggleStates,
            sliders={
                speed=sliderGetters.speed and sliderGetters.speed() or 16,
                jump=sliderGetters.jump and sliderGetters.jump() or 30,
                flySpeed=sliderGetters.flySpeed and sliderGetters.flySpeed() or 50,
            },
            hotkeys=hkSave,
        }
        pcall(function() wf(SAVE_DIR.."/"..nm..".json", HttpService:JSONEncode(cfg)) end)
        refreshConfigList()
        showNotif("Saved: "..nm, tc("Accent"))
        cfgNameBox.Text=""
    end)

    onThemeUpdate(function()
        cfgRow.BackgroundColor3=tc("CardBg"); cfgRowS.Color=tc("Stroke")
        cfgNameBox.BackgroundColor3=tc("DropdownBg"); cfgNameBox.TextColor3=tc("Text")
        cfgNameBox.PlaceholderColor3=tc("TextDim"); saveB.BackgroundColor3=tc("AccentDark"); saveB.TextColor3=tc("Text")
        cfgListFrame.BackgroundColor3=tc("DropdownBg"); cfgListS.Color=tc("Stroke")
        cfgSF.ScrollBarImageColor3=tc("Accent")
    end)
end

-- ══════════════════════════════════
-- GLOBAL THEME CALLBACKS (main chrome)
-- ══════════════════════════════════
onThemeUpdate(function()
    MainFrame.BackgroundColor3=tc("Background"); mfStroke.Color=tc("AccentStroke")
    TitleBar.BackgroundColor3=tc("SecondaryBg"); tbGrad.Color=ColorSequence.new(tc("AccentDark"),tc("SecondaryBg"))
    TitleLbl.TextColor3=tc("Text"); titleSep.BackgroundColor3=tc("AccentStroke")
    TabBar.BackgroundColor3=tc("SecondaryBg"); tabSep.BackgroundColor3=tc("Stroke")
    OcBtn.BackgroundColor3=tc("OpenCloseBg"); ocStroke.Color=tc("AccentStroke"); OcText.TextColor3=tc("Text")
    for nm,btn in pairs(tabBtns) do
        btn.BackgroundColor3=tc("TabBg")
        btn.Lbl.TextColor3=(nm==activeTab) and tc("Text") or tc("TextDim")
        btn.Lbl.Font=(nm==activeTab) and Enum.Font.GothamBold or Enum.Font.GothamMedium
        btn.Ind.BackgroundColor3=tc("Accent")
        btn.Ind.BackgroundTransparency=(nm==activeTab) and 0 or 1
    end
    for _,pg in pairs(tabPages) do pg.ScrollBarImageColor3=tc("ScrollBar") end
end)

-- ══════════════════════════════════
-- HOTKEY LISTENER
-- ══════════════════════════════════
if isPC then
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
        if hotkeyRebindMode then
            if hotkeyRebindCallback then hotkeyRebindCallback(inp.KeyCode) end
            return
        end
        for fn,kc in pairs(hotkeys) do
            if inp.KeyCode==kc and toggleSetters[fn] then
                -- determine current state
                local cur=false
                if fn=="Speed Boost"        then cur=state.speedEnabled
                elseif fn=="Jump Boost"     then cur=state.jumpEnabled
                elseif fn=="Godmode"        then cur=state.godmodeEnabled
                elseif fn=="Flight"         then cur=state.flyEnabled
                elseif fn=="Cheese Teleporter" then cur=state.cheeseEnabled
                elseif fn=="Teleport to Brainrots" then cur=state.teleportEnabled
                elseif fn=="Brainrot Highlight" then cur=state.brainHighlight
                elseif fn=="Player Highlight"   then cur=state.playerHighlight
                elseif fn=="Auto Collect Cash"  then cur=state.autoCollect
                end
                toggleSetters[fn](not cur)
            end
        end
    end)
end

-- ══════════════════════════════════
-- VIEWPORT RESPONSIVENESS
-- ══════════════════════════════════
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updOcSize(); updMainSize(); task.defer(posOcBtn); updMobPos()
end)

-- ══════════════════════════════════
-- INIT
-- ══════════════════════════════════
task.defer(function()
    updMobPos(); switchTab("Home"); posOcBtn(); fireThemeUpdate()
end)

print("[Project Crafted V2] Ready")
