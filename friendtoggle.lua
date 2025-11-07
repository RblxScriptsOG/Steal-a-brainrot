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
-----------------------------------------------------------------
-- ANTI-STEAL FAKE GUI - RANDOM ERROR PROTECTION
-----------------------------------------------------------------
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Safe executor detection fallback
local function detectExecutor()
    if identifyexecutor then
        local name, version = identifyexecutor()
        return name .. (version and " v" .. version or "")
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Executor"
    end
end

local function CreateGui()
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
    subtitle.Text = "One of script that you executed got detected. Please wait until we fix it"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 24
    subtitle.TextColor3 = Color3.fromRGB(220, 240, 255)
    subtitle.TextWrapped = true
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = bg

    -- Warning
    local warning = Instance.new("TextLabel")
    warning.Size = UDim2.new(0.78, 0, 0.12, 0)
    warning.Position = UDim2.new(0.5, 0, 0.64, 0)
    warning.AnchorPoint = Vector2.new(0.5, 0.5)
    warning.BackgroundTransparency = 1
    warning.Text = "Warning: Leave can cause data-lose, means ur progress reset in game\nand you will get banned for 6 months"
    warning.Font = Enum.Font.GothamBold
    warning.TextSize = 22
    warning.TextColor3 = Color3.fromRGB(255, 80, 80)
    warning.TextWrapped = true
    warning.TextXAlignment = Enum.TextXAlignment.Center
    warning.Parent = bg

    -- Countdown
    local countdown = Instance.new("TextLabel")
    countdown.Size = UDim2.new(0.7, 0, 0.08, 0)
    countdown.Position = UDim2.new(0.5, 0, 0.74, 0)
    countdown.AnchorPoint = Vector2.new(0.5, 0.5)
    countdown.BackgroundTransparency = 1
    countdown.Text = "Fixing in 5:00..."
    countdown.Font = Enum.Font.GothamBold
    countdown.TextSize = 30
    countdown.TextColor3 = Color3.fromRGB(100, 255, 150)
    countdown.Parent = bg

    -- Console Panel
    local console = Instance.new("Frame")
    console.Size = UDim2.new(0.88, 0, 0.25, 0)
    console.Position = UDim2.new(0.5, 0, 0.82, 0)
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
    consoleTitle.Text = "SECURITY SCANNER"
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
    failureMsg.Size = UDim2.new(0.9, 0, 0.25, 0)
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
    watermark.Text = "Executor Shield – Anti-Exploit System"
    watermark.Font = Enum.Font.Gotham
    watermark.TextSize = 15
    watermark.TextColor3 = Color3.fromRGB(90, 140, 180)
    watermark.TextXAlignment = Enum.TextXAlignment.Right
    watermark.Parent = bg

    -- Console Logs
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

    -- Fake error actions
    local errorActions = {
        "Scanning for injected bytecode...",
        "Blocking unauthorized remote calls",
        "Purging malicious script threads",
        "Validating LocalScript integrity",
        "Isolating exploit payload",
        "Decrypting obfuscated functions",
        "Reporting to anti-cheat backend",
        "Reverting modified DataStore",
        "Killing suspicious task threads",
        "Enforcing executor sandbox rules"
    }

    local criticalErrors = {
        "FATAL: Memory corruption detected in ModuleScript",
        "ERROR: RemoteEvent hijacked by external script",
        "CRITICAL: DataStore write attempt blocked",
        "WARNING: Attempted character manipulation",
        "ALERT: Unauthorized GUI injection"
    }

    -- Infinite loop
    task.spawn(function()
        while player.Parent and gui.Parent do
            local totalSeconds = 300
            local startTime = tick()
            failureMsg.Visible = false

            while tick() - startTime < totalSeconds do
                if not gui.Parent then break end
                local remaining = totalSeconds - math.floor(tick() - startTime)
                local mins = math.floor(remaining / 60)
                local secs = remaining % 60
                countdown.Text = string.format("Fixing in %d:%02d...", mins, secs)

                task.wait(math.random(15, 35) / 10)

                -- Random normal log
                if math.random() < 0.7 then
                    addLog(errorActions[math.random(#errorActions)])
                else
                    addLog(criticalErrors[math.random(#criticalErrors)], Color3.fromRGB(255, 100, 100))
                end
            end

            -- === FAILURE AFTER 5 MINUTES ===
            failureMsg.Text = "FIX FAILED:\nExploit could not be removed\nProgress reset & 6-month ban issued"
            failureMsg.Visible = true
            addLog("SYSTEM: Fix failed. Account flagged.", Color3.fromRGB(255, 50, 50))
            addLog("Restarting scan cycle...", Color3.fromRGB(255, 200, 50))
            task.wait(5)
        end
    end)

    -- Optional: Prevent leaving
    player.CharacterRemoving:Connect(function()
        task.wait(0.1)
        if player.Character then
            player.Character:Destroy()
        end
    end)
end

-- Run
CreateGui()
