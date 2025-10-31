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

--[[  CLIENT-SIDE FREEZE EXECUTER
      • World stuck on last server snapshot
      • No new GUI except sm_notif / sm_main
      • Camera locked
      • Connection stays alive
--]]

local Players      = game:GetService("Players")
local Player       = Players.LocalPlayer
local PlayerGui    = Player:WaitForChild("PlayerGui")
local CoreGui      = game:GetService("CoreGui")
local RunService   = game:GetService("RunService")
local Workspace    = game:GetService("Workspace")
local StarterGui   = game:GetService("StarterGui")

-------------------------------------------------
-- 1. DISABLE ALL CORE GUI OFFICIALLY
-------------------------------------------------
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

-------------------------------------------------
-- 2. LOCK CAMERA TO CURRENT POSITION
-------------------------------------------------
local Camera = Workspace.CurrentCamera
local frozenCFrame = Camera.CFrame
Camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function()
    Camera.CFrame = frozenCFrame
end)

-------------------------------------------------
-- 3. FREEZE EVERY PART'S REPLICATION (visual only)
-------------------------------------------------
-- Store the last known state of every BasePart
local frozenParts = {}

for _, part in ipairs(Workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        frozenParts[part] = {
            CFrame       = part.CFrame,
            Size         = part.Size,
            Transparency = part.Transparency,
            Color        = part.Color,
            Material     = part.Material,
            CanCollide   = part.CanCollide,
        }
    end
end

-- Apply frozen state every frame (prevents any visual update)
RunService.Stepped:Connect(function()
    for part, data in pairs(frozenParts) do
        if part and part.Parent then
            part.CFrame       = data.CFrame
            part.Size         = data.Size
            part.Transparency = data.Transparency
            part.Color        = data.Color
            part.Material     = data.Material
            part.CanCollide   = data.CanCollide
        end
    end
end)

-- Also freeze any new parts that appear after script start
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") then
        frozenParts[obj] = {
            CFrame       = obj.CFrame,
            Size         = obj.Size,
            Transparency = obj.Transparency,
            Color        = obj.Color,
            Material     = obj.Material,
            CanCollide   = obj.CanCollide,
        }
    end
end)

-------------------------------------------------
-- 4. DELETE ALL GUI EXCEPT sm_notif & sm_main
-------------------------------------------------
local function clearGui()
    -- PlayerGui
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("GuiObject") then
            local n = gui.Name
            if n ~= "sm_notif" and n ~= "sm_main" then
                pcall(gui.Destroy, gui)
            end
        end
    end
    -- CoreGui (everything)
    for _, gui in ipairs(CoreGui:GetChildren()) do
        pcall(gui.Destroy, gui)
    end
end

-- Initial clear
clearGui()

-- Continuous clear (catches respawns)
spawn(function()
    while wait(0.03) do
        clearGui()
    end
end)

-------------------------------------------------
-- 5. OPTIONAL: LOCK CHARACTER MOVEMENT (local only)
-------------------------------------------------
local function lockChar(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 0
        hum.JumpPower = 0
    end
end
if Player.Character then lockChar(Player.Character) end
Player.CharacterAdded:Connect(lockChar)

-------------------------------------------------
print("[Script.SM] Lefting May Cause Data Lose ")
