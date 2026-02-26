-- Project Crafted V2
-- Game Lock: 119987266683883
local REQUIRED_GAME_ID = 119987266683883

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Initial Game Check
if game.PlaceId ~= REQUIRED_GAME_ID then
    local sg = Instance.new("ScreenGui")
    sg.Parent = CoreGui
    local warn = Instance.new("TextLabel")
    warn.Size = UDim2.new(0, 300, 0, 50)
    warn.Position = UDim2.new(0.5, -150, 0, -50)
    warn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    warn.TextColor3 = Color3.fromRGB(255, 50, 50)
    warn.Text = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " Is Not Supported!"
    warn.Font = Enum.Font.Roboto
    warn.TextSize = 18
    warn.Parent = sg
    local corner = Instance.new("UICorner", warn)
    TweenService:Create(warn, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -150, 0, 50)}):Play()
    task.wait(4)
    TweenService:Create(warn, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -50)}):Play()
    task.wait(0.5)
    sg:Destroy()
    return
end

-- Filesystem Setup
local folderPath = "ProjectCrafted"
local configPath = folderPath .. "/configs"
local themeFile = configPath .. "/theme.txt"
local statsFile = configPath .. "/stats.json"

if makefolder and isfolder then
    if not isfolder(folderPath) then makefolder(folderPath) end
    if not isfolder(configPath) then makefolder(configPath) end
end

local function SaveFile(path, data)
    if writefile then pcall(function() writefile(path, data) end) end
end
local function LoadFile(path)
    if readfile and isfile and isfile(path) then
        local s, r = pcall(function() return readfile(path) end)
        return s and r or nil
    end
    return nil
end

-- Stats
local execCount = 1
local totalExecTime = 0
local loadedStats = LoadFile(statsFile)
if loadedStats then
    local s, data = pcall(function() return HttpService:JSONDecode(loadedStats) end)
    if s and data then
        execCount = (data.count or 0) + 1
        totalExecTime = data.time or 0
    end
end
task.spawn(function()
    while task.wait(1) do
        totalExecTime += 1
        SaveFile(statsFile, HttpService:JSONEncode({count = execCount, time = totalExecTime}))
    end
end)

-- Theme System
local Themes = {
    Original = { Bg = Color3.fromRGB(15, 25, 15), Tab = Color3.fromRGB(20, 35, 20), ToggleOn = Color3.fromRGB(40, 200, 80), ToggleOff = Color3.fromRGB(60, 60, 60), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(40, 200, 80), Stroke = Color3.fromRGB(0, 255, 100) },
    Sky = { Bg = Color3.fromRGB(15, 20, 30), Tab = Color3.fromRGB(20, 30, 45), ToggleOn = Color3.fromRGB(80, 180, 255), ToggleOff = Color3.fromRGB(60, 60, 60), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(80, 180, 255), Stroke = Color3.fromRGB(100, 200, 255) },
    Lava = { Bg = Color3.fromRGB(30, 15, 10), Tab = Color3.fromRGB(45, 20, 15), ToggleOn = Color3.fromRGB(255, 80, 40), ToggleOff = Color3.fromRGB(60, 60, 60), Text = Color3.fromRGB(255, 255, 255), Slider = Color3.fromRGB(255, 80, 40), Stroke = Color3.fromRGB(255, 120, 50) }
}
local CurrentTheme = "Original"
local savedTheme = LoadFile(themeFile)
if savedTheme and Themes[savedTheme] then CurrentTheme = savedTheme end
local activeTheme = Themes[CurrentTheme]

local ThemeElements = {}
local function RegisterTheme(instance, prop, colorKey)
    table.insert(ThemeElements, {Inst = instance, Prop = prop, Key = colorKey})
    instance[prop] = activeTheme[colorKey]
end
local function UpdateTheme(themeName)
    if Themes[themeName] then
        activeTheme = Themes[themeName]
        CurrentTheme = themeName
        SaveFile(themeFile, themeName)
        for _, el in pairs(ThemeElements) do
            if el.Inst.Parent then
                TweenService:Create(el.Inst, TweenInfo.new(0.3), {[el.Prop] = activeTheme[el.Key]}):Play()
            end
        end
    end
end

-- Core UI Creation
local UI = Instance.new("ScreenGui")
UI.Name = "ProjectCraftedV2"
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() UI.Parent = CoreGui end)
if not UI.Parent then UI.Parent = LocalPlayer.PlayerGui end

-- Open/Close Button
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -25, 0, 10)
ToggleBtn.Image = "rbxassetid://85816937697749"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local tCorner = Instance.new("UICorner", ToggleBtn)
tCorner.CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Thickness = 2
RegisterTheme(tStroke, "Color", "Stroke")
ToggleBtn.Parent = UI

-- Make button draggable
local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        dragStartBtn = input.Position
        startPosBtn = ToggleBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        local delta = input.Position - dragStartBtn
        ToggleBtn.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingBtn = false end
end)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.ClipsDescendants = true
RegisterTheme(MainFrame, "BackgroundColor3", "Bg")
local mCorner = Instance.new("UICorner", MainFrame)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Thickness = 2
RegisterTheme(mStroke, "Color", "Stroke")
local mGrad = Instance.new("UIGradient", MainFrame)
mGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(0.7,0.7,0.7))}
mGrad.Rotation = 45
MainFrame.Parent = UI

local function ToggleGUI()
    local isOpen = MainFrame.Size.X.Scale > 0.1
    if isOpen then
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.6, 0, 0.6, 0)}):Play()
    end
end
ToggleBtn.MouseButton1Click:Connect(ToggleGUI)

-- Draggable MainFrame
local dMain, iMain, sMain, pMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dMain = true
        sMain = input.Position
        pMain = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then iMain = input end
    if dMain and iMain then
        local delta = iMain.Position - sMain
        MainFrame.Position = UDim2.new(pMain.X.Scale, pMain.X.Offset + delta.X, pMain.Y.Scale, pMain.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dMain = false end
end)

-- Tabs System
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0.25, 0, 1, 0)
TabContainer.BackgroundTransparency = 1

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(0.75, 0, 1, 0)
ContentContainer.Position = UDim2.new(0.25, 0, 0, 0)
ContentContainer.BackgroundTransparency = 1

local UIListLayoutTabs = Instance.new("UIListLayout", TabContainer)
UIListLayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutTabs.Padding = UDim.new(0, 5)

local Tabs = {}
local function CreateTab(name, order)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    RegisterTheme(btn, "BackgroundColor3", "Tab")
    btn.Text = name
    btn.Font = Enum.Font.Roboto
    btn.TextSize = 18
    RegisterTheme(btn, "TextColor3", "Text")
    Instance.new("UICorner", btn)

    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.Visible = order == 1
    local list = Instance.new("UIListLayout", page)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    
    Tabs[name] = page
    btn.MouseButton1Click:Connect(function()
        for tName, tPage in pairs(Tabs) do
            if tName == name then
                tPage.Visible = true
                tPage.Position = UDim2.new(0, 5, 0, 50)
                TweenService:Create(tPage, TweenInfo.new(0.3), {Position = UDim2.new(0, 5, 0, 5)}):Play()
            else
                tPage.Visible = false
            end
        end
    end)
    return page
end

local TabHome = CreateTab("Home", 1)
local TabMain = CreateTab("Main", 2)
local TabPlayer = CreateTab("Player", 3)
local TabVisual = CreateTab("Visual", 4)
local TabSettings = CreateTab("Settings", 5)

-- Notifications System
local NotifFrame = Instance.new("Frame", UI)
NotifFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
NotifFrame.Position = UDim2.new(0.35, 0, -0.2, 0)
RegisterTheme(NotifFrame, "BackgroundColor3", "Bg")
Instance.new("UICorner", NotifFrame)
local nStroke = Instance.new("UIStroke", NotifFrame)
nStroke.Thickness = 2
RegisterTheme(nStroke, "Color", "Stroke")
local NotifText = Instance.new("TextLabel", NotifFrame)
NotifText.Size = UDim2.new(1, 0, 1, 0)
NotifText.BackgroundTransparency = 1
RegisterTheme(NotifText, "TextColor3", "Text")
NotifText.Font = Enum.Font.Roboto
NotifText.TextSize = 18
NotifText.TextWrapped = true

local function Notify(text)
    NotifText.Text = text
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.35, 0, 0.05, 0)}):Play()
    task.spawn(function()
        task.wait(3)
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.35, 0, -0.2, 0)}):Play()
    end)
end

-- Generic Component Builders
local function CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.BackgroundTransparency = 1
    RegisterTheme(lbl, "TextColor3", "Text")
    lbl.Font = Enum.Font.Roboto
    lbl.TextSize = 16
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    local lbl = CreateLabel(frame, text)
    lbl.Size = UDim2.new(0.8, 0, 1, 0)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.Text = ""
    RegisterTheme(btn, "BackgroundColor3", "ToggleOff")
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and activeTheme.ToggleOn or activeTheme.ToggleOff}):Play()
        Notify(text .. (state and " Enabled!" or " Disabled!"))
        callback(state)
    end)
    return frame
end

local function CreateSlider(parent, text, min, max, callback, hasInput)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    local lbl = CreateLabel(frame, text .. " [" .. min .. "]")
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    
    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -10, 0, 10)
    sliderBg.Position = UDim2.new(0, 5, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", sliderBg)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    RegisterTheme(sliderFill, "BackgroundColor3", "Slider")
    Instance.new("UICorner", sliderFill)

    local btn = Instance.new("TextButton", sliderBg)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local maxInput
    if hasInput then
        maxInput = Instance.new("TextBox", frame)
        maxInput.Size = UDim2.new(0, 50, 0, 20)
        maxInput.Position = UDim2.new(1, -55, 0, 0)
        maxInput.Text = tostring(max)
        RegisterTheme(maxInput, "BackgroundColor3", "Tab")
        RegisterTheme(maxInput, "TextColor3", "Text")
        Instance.new("UICorner", maxInput)
        maxInput.FocusLost:Connect(function()
            local n = tonumber(maxInput.Text)
            if n and n > min then max = n else maxInput.Text = tostring(max) end
        end)
    end

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + ((max - min) * pos))
        lbl.Text = text .. " [" .. val .. "]"
        callback(val)
    end
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- == HOME TAB ==
local function BuildHomeTab()
    local img = Instance.new("ImageLabel", TabHome)
    img.Size = UDim2.new(0, 80, 0, 80)
    img.BackgroundTransparency = 1
    pcall(function() img.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
    
    CreateLabel(TabHome, "Username: " .. LocalPlayer.Name)
    CreateLabel(TabHome, "Display: " .. LocalPlayer.DisplayName)
    CreateLabel(TabHome, "User ID: " .. LocalPlayer.UserId)
    CreateLabel(TabHome, "Account Age: " .. LocalPlayer.AccountAge .. " days")
    
    CreateLabel(TabHome, "Game Name: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    CreateLabel(TabHome, "Game ID: " .. game.PlaceId)
    local maxPlr = Players.MaxPlayers
    local plrLbl = CreateLabel(TabHome, "Players: " .. #Players:GetPlayers() .. "/" .. maxPlr)
    Players.PlayerAdded:Connect(function() plrLbl.Text = "Players: " .. #Players:GetPlayers() .. "/" .. maxPlr end)
    Players.PlayerRemoving:Connect(function() plrLbl.Text = "Players: " .. #Players:GetPlayers() .. "/" .. maxPlr end)
    CreateLabel(TabHome, "Server ID: " .. game.JobId)
    
    local upLbl = CreateLabel(TabHome, "Server Uptime: 0s")
    task.spawn(function()
        while task.wait(1) do
            local sec = math.floor(workspace.DistributedGameTime)
            local h = math.floor(sec / 3600)
            local m = math.floor((sec % 3600) / 60)
            local s = sec % 60
            upLbl.Text = string.format("Server Uptime: %02d:%02d:%02d", h, m, s)
        end
    end)

    local execLbl = CreateLabel(TabHome, "Executions: " .. execCount)
    local timeLbl = CreateLabel(TabHome, "Total Exec Time: 0s")
    task.spawn(function()
        while task.wait(1) do
            local h = math.floor(totalExecTime / 3600)
            local m = math.floor((totalExecTime % 3600) / 60)
            local s = totalExecTime % 60
            timeLbl.Text = string.format("Total Exec Time: %02d:%02d:%02d", h, m, s)
        end
    end)
end
BuildHomeTab()

-- == MAIN TAB ==
local SelectedBrainrots = {}
local BrainrotNames = {}
pcall(function()
    for _, f in pairs(ReplicatedStorage.Brainrots:GetChildren()) do
        table.insert(BrainrotNames, f.Name)
    end
end)
table.sort(BrainrotNames)

local DropdownFrame = Instance.new("Frame", TabMain)
DropdownFrame.Size = UDim2.new(1, -10, 0, 150)
RegisterTheme(DropdownFrame, "BackgroundColor3", "Bg")
Instance.new("UICorner", DropdownFrame)
Instance.new("UIStroke", DropdownFrame).Color = Color3.fromRGB(100,100,100)

local SearchBar = Instance.new("TextBox", DropdownFrame)
SearchBar.Size = UDim2.new(1, -10, 0, 30)
SearchBar.Position = UDim2.new(0, 5, 0, 5)
SearchBar.PlaceholderText = "Search Brainrots..."
SearchBar.Text = ""
RegisterTheme(SearchBar, "BackgroundColor3", "Tab")
RegisterTheme(SearchBar, "TextColor3", "Text")
Instance.new("UICorner", SearchBar)

local ListScroll = Instance.new("ScrollingFrame", DropdownFrame)
ListScroll.Size = UDim2.new(1, -10, 1, -45)
ListScroll.Position = UDim2.new(0, 5, 0, 40)
ListScroll.BackgroundTransparency = 1
local ListLayout = Instance.new("UIListLayout", ListScroll)

local SelectedBox = Instance.new("ScrollingFrame", TabMain)
SelectedBox.Size = UDim2.new(1, -10, 0, 80)
RegisterTheme(SelectedBox, "BackgroundColor3", "Tab")
Instance.new("UICorner", SelectedBox)
local SelLayout = Instance.new("UIListLayout", SelectedBox)

local function UpdateSelectedBox()
    for _, c in pairs(SelectedBox:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _, name in pairs(SelectedBrainrots) do
        local f = Instance.new("Frame", SelectedBox)
        f.Size = UDim2.new(1, -10, 0, 25)
        f.BackgroundTransparency = 1
        local lbl = CreateLabel(f, name)
        lbl.Size = UDim2.new(0.8, 0, 1, 0)
        local xBtn = Instance.new("TextButton", f)
        xBtn.Size = UDim2.new(0, 20, 0, 20)
        xBtn.Position = UDim2.new(1, -25, 0, 2)
        xBtn.Text = "X"
        xBtn.Font = Enum.Font.Arial
        xBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        xBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", xBtn)
        xBtn.MouseButton1Click:Connect(function()
            table.remove(SelectedBrainrots, table.find(SelectedBrainrots, name))
            UpdateSelectedBox()
        end)
    end
end

local function PopulateDropdown(filter)
    for _, c in pairs(ListScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, name in pairs(BrainrotNames) do
        if filter == "" or string.lower(name):match(string.lower(filter)) then
            local btn = Instance.new("TextButton", ListScroll)
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Text = name
            RegisterTheme(btn, "TextColor3", "Text")
            btn.BackgroundTransparency = 1
            btn.MouseButton1Click:Connect(function()
                if not table.find(SelectedBrainrots, name) then
                    table.insert(SelectedBrainrots, name)
                    UpdateSelectedBox()
                end
            end)
        end
    end
end
PopulateDropdown("")
SearchBar.Changed:Connect(function(prop) if prop == "Text" then PopulateDropdown(SearchBar.Text) end end)

local TpToBrainrotEnabled = false
local HighlightBrainrotEnabled = false

workspace:WaitForChild("GameFolder"):WaitForChild("Brainrots").ChildAdded:Connect(function(model)
    task.wait(0.1)
    if table.find(SelectedBrainrots, model.Name) then
        Notify("A " .. model.Name .. " Has spawned!")
        
        if TpToBrainrotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(model:GetPivot() * CFrame.new(0, 3, 0))
        end
        
        if HighlightBrainrotEnabled then
            local hl = Instance.new("Highlight")
            hl.Adornee = model
            hl.FillColor = Color3.fromRGB(0, 255, 0)
            hl.OutlineColor = Color3.new(1,1,1)
            hl.Parent = model
        end
    end
end)

local AutoCollectCash = false
CreateToggle(TabMain, "Auto Collect Cash", function(state)
    AutoCollectCash = state
    if state then
        task.spawn(function()
            while AutoCollectCash and task.wait(0.5) do
                pcall(function()
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    for _, att in pairs(workspace.GameFolder.Plots:GetDescendants()) do
                        if att.Name == "YourBaseAtt" then
                            local title = att:FindFirstChild("Title")
                            if title and title:IsA("TextLabel") and title.Text == "YOUR BASE" then
                                local mdl = att:FindFirstAncestorOfClass("Model")
                                if mdl and mdl:FindFirstChild("Places") then
                                    for _, touchInt in pairs(mdl.Places:GetDescendants()) do
                                        if touchInt:IsA("TouchTransmitter") then
                                            firetouchinterest(root, touchInt.Parent, 0)
                                            firetouchinterest(root, touchInt.Parent, 1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

-- == PLAYER TAB ==
local WarningOverlay = Instance.new("Frame", TabPlayer)
WarningOverlay.Size = UDim2.new(1, 0, 1, 0)
WarningOverlay.ZIndex = 10
RegisterTheme(WarningOverlay, "BackgroundColor3", "Bg")
local warnTxt = CreateLabel(WarningOverlay, "⚠️Warning: Using These Features Could Get You Banned, Use At Your Own Risk.⚠️")
warnTxt.TextWrapped = true
warnTxt.Size = UDim2.new(1, 0, 0.4, 0)
warnTxt.TextXAlignment = Enum.TextXAlignment.Center

local okBtn = Instance.new("TextButton", WarningOverlay)
okBtn.Size = UDim2.new(0.4, 0, 0, 40)
okBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
okBtn.Text = "Ok ✅"
okBtn.Font = Enum.Font.Arial
okBtn.TextSize = 16
okBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
Instance.new("UICorner", okBtn)

local backBtn = Instance.new("TextButton", WarningOverlay)
backBtn.Size = UDim2.new(0.4, 0, 0, 40)
backBtn.Position = UDim2.new(0.55, 0, 0.5, 0)
backBtn.Text = "Go Back ❌"
backBtn.Font = Enum.Font.Arial
backBtn.TextSize = 16
backBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Instance.new("UICorner", backBtn)

okBtn.MouseButton1Click:Connect(function() WarningOverlay.Visible = false end)
backBtn.MouseButton1Click:Connect(function()
    WarningOverlay.Visible = true
    for _, t in pairs(Tabs) do t.Visible = (t == TabHome) end
end)

local speedVal = 16
local jumpVal = 50
local speedToggle, jumpToggle

CreateToggle(TabPlayer, "Speed Boost", function(state)
    speedToggle = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        if state then
            hum.WalkSpeed = speedVal
        else
            pcall(function()
                local txt = LocalPlayer.PlayerGui.HUD.Speed.Text
                local digits = string.match(txt, "%d+")
                hum.WalkSpeed = tonumber(digits) or 16
            end)
        end
    end
end)
CreateSlider(TabPlayer, "Speed", 16, 100, function(val) speedVal = val if speedToggle then local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed = val end end end, true)

CreateToggle(TabPlayer, "Jump Boost", function(state)
    jumpToggle = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        if state then
            hum.JumpPower = jumpVal
        else
            pcall(function()
                local txt = LocalPlayer.PlayerGui.HUD.Jump.Text
                local digits = string.match(txt, "%d+")
                local base = tonumber(digits) or 0
                hum.JumpPower = 30 + (base * (10/3))
            end)
        end
    end
end)
CreateSlider(TabPlayer, "Jump", 30, 200, function(val) jumpVal = val if jumpToggle then local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") if h then h.JumpPower = val end end end, false)

local Godmode = false
CreateToggle(TabPlayer, "Godmode", function(state)
    Godmode = state
    pcall(function()
        for _, p in pairs(workspace.GameFolder.Lavas:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanTouch = not state
            end
        end
    end)
end)

local FlyToggle = false
local FlySpeed = 50
local flyConn
CreateToggle(TabPlayer, "Flight", function(state)
    FlyToggle = state
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if state then
        if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        flyConn = RunService.RenderStepped:Connect(function()
            if not root or not hum then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            
            if dir.Magnitude > 0 then
                root.AssemblyLinearVelocity = dir.Unit * FlySpeed
            else
                root.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end
            if hum:GetState() ~= Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.Physics) end
            root.CFrame = CFrame.new(root.Position, root.Position + cam.CFrame.LookVector)
        end)
    else
        if flyConn then flyConn:Disconnect() end
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)

CreateToggle(TabPlayer, "Teleport To Selected Brainrots", function(state) TpToBrainrotEnabled = state end)

-- == VISUAL TAB ==
CreateToggle(TabVisual, "Highlight Selected Brainrots", function(state) HighlightBrainrotEnabled = state end)

local ESPEnabled = false
local ESPElements = {}

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local bg = Instance.new("BillboardGui")
    bg.Name = "CustomESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 100, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.Roboto
    txt.TextSize = 14
    
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    
    local conn = RunService.RenderStepped:Connect(function()
        if not ESPEnabled then
            bg.Parent = nil hl.Parent = nil
            return
        end
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and myRoot then
            local dist = math.floor((root.Position - myRoot.Position).Magnitude)
            txt.Text = plr.Name .. "\n[" .. dist .. "s]"
            bg.Parent = char
            hl.Parent = char
            bg.Adornee = root
            hl.Adornee = char
        else
            bg.Parent = nil hl.Parent = nil
        end
    end)
    table.insert(ESPElements, {bg, hl, conn})
end

CreateToggle(TabVisual, "Player ESP", function(state)
    ESPEnabled = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
    end
end)
Players.PlayerAdded:Connect(function(p) if ESPEnabled then CreateESP(p) end end)

-- == SETTINGS TAB ==
CreateLabel(TabSettings, "Select Theme")

local ThemeDropdown = Instance.new("Frame", TabSettings)
ThemeDropdown.Size = UDim2.new(1, -10, 0, 120)
RegisterTheme(ThemeDropdown, "BackgroundColor3", "Bg")
Instance.new("UICorner", ThemeDropdown)

local tLayout = Instance.new("UIListLayout", ThemeDropdown)
for tName, _ in pairs(Themes) do
    local btn = Instance.new("TextButton", ThemeDropdown)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = tName
    RegisterTheme(btn, "TextColor3", "Text")
    btn.BackgroundTransparency = 1
    btn.MouseButton1Click:Connect(function() UpdateTheme(tName) Notify("Theme Changed to " .. tName) end)
end

local customLbl = CreateLabel(TabSettings, "Can't Find The Theme You Want? Click this button to Customise the Ui To Your Liking!")
customLbl.TextWrapped = true
customLbl.Size = UDim2.new(1, 0, 0, 60)

local customBtn = Instance.new("TextButton", TabSettings)
customBtn.Size = UDim2.new(1, -10, 0, 40)
customBtn.Text = "Customise UI"
customBtn.Font = Enum.Font.Roboto
customBtn.TextSize = 18
RegisterTheme(customBtn, "BackgroundColor3", "Tab")
RegisterTheme(customBtn, "TextColor3", "Text")
Instance.new("UICorner", customBtn)

-- Custom UI Editor Frame
local CustomUIFrame = Instance.new("Frame", UI)
CustomUIFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
CustomUIFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
CustomUIFrame.Visible = false
RegisterTheme(CustomUIFrame, "BackgroundColor3", "Bg")
Instance.new("UICorner", CustomUIFrame)
local cStroke = Instance.new("UIStroke", CustomUIFrame)
cStroke.Thickness = 2
RegisterTheme(cStroke, "Color", "Stroke")

local cClose = Instance.new("TextButton", CustomUIFrame)
cClose.Size = UDim2.new(0, 30, 0, 30)
cClose.Position = UDim2.new(1, -35, 0, 5)
cClose.Text = "X"
cClose.Font = Enum.Font.Arial
cClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
cClose.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", cClose)
cClose.MouseButton1Click:Connect(function() CustomUIFrame.Visible = false end)

local cScroll = Instance.new("ScrollingFrame", CustomUIFrame)
cScroll.Size = UDim2.new(1, -10, 1, -40)
cScroll.Position = UDim2.new(0, 5, 0, 35)
cScroll.BackgroundTransparency = 1
local cList = Instance.new("UIListLayout", cScroll)

local function CreateRGBPicker(parent, name, themeKey)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 80)
    f.BackgroundTransparency = 1
    CreateLabel(f, name).Size = UDim2.new(1,0,0,20)
    local hexIn = Instance.new("TextBox", f)
    hexIn.Size = UDim2.new(0.5, 0, 0, 25)
    hexIn.Position = UDim2.new(0, 5, 0, 30)
    hexIn.PlaceholderText = "Hex (e.g. FF0000)"
    RegisterTheme(hexIn, "BackgroundColor3", "Tab")
    RegisterTheme(hexIn, "TextColor3", "Text")
    Instance.new("UICorner", hexIn)
    
    local applyBtn = Instance.new("TextButton", f)
    applyBtn.Size = UDim2.new(0.3, 0, 0, 25)
    applyBtn.Position = UDim2.new(0.6, 0, 0, 30)
    applyBtn.Text = "Apply"
    RegisterTheme(applyBtn, "BackgroundColor3", "Tab")
    RegisterTheme(applyBtn, "TextColor3", "Text")
    Instance.new("UICorner", applyBtn)
    
    applyBtn.MouseButton1Click:Connect(function()
        local hex = hexIn.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16)
            local g = tonumber(hex:sub(3,4), 16)
            local b = tonumber(hex:sub(5,6), 16)
            if r and g and b then
                Themes.Original[themeKey] = Color3.fromRGB(r, g, b)
                UpdateTheme("Original")
                Notify(name .. " Color Updated!")
            end
        end
    end)
end

CreateRGBPicker(cScroll, "Background Color", "Bg")
CreateRGBPicker(cScroll, "Tabs/Boxes Color", "Tab")
CreateRGBPicker(cScroll, "Toggle On / Sliders", "ToggleOn")
CreateRGBPicker(cScroll, "Text Color", "Text")
CreateRGBPicker(cScroll, "Stroke / Borders", "Stroke")

customBtn.MouseButton1Click:Connect(function() CustomUIFrame.Visible = true end)

Notify("Project Crafted V2 Loaded Successfully!")
