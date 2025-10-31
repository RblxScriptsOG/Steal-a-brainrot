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

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local StarterGui   = game:GetService("StarterGui")
local CoreGui      = game:GetService("CoreGui")
local LocalPlayer  = Players.LocalPlayer

local frozenStates = {}

----------------------------------------------------------------
-- 1. GUI‑KILL (runs every frame – survives respawns / re‑enables)
----------------------------------------------------------------
local function killAllGui()
    -- CORE GUI (official Roblox UI)
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)   -- disables EVERYTHING
        StarterGui:SetCore("TopbarEnabled", false)                 -- top‑bar & ESC menu
    end)

    -- PLAYER‑GUI (custom game UI, inventory, etc.)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
        for _, obj in ipairs(pg:GetDescendants()) do
            if obj:IsA("GuiObject") then
                obj.Visible = false
                obj.Enabled = false
            elseif obj:IsA("ScreenGui") then
                obj.Enabled = false
                obj.ResetOnSpawn = false
            end
        end
    end

    -- DIRECT CORE‑GUI wipe (some games rebuild it)
    for _, core in ipairs(CoreGui:GetChildren()) do
        if core:IsA("ScreenGui") or core:IsA("Frame") then
            core.Enabled = false
            core.Visible = false
        end
    end
end

----------------------------------------------------------------
-- 2. FREEZE FUNCTION (skip your character completely)
----------------------------------------------------------------
local function freezeInstance(inst)
    if not inst or not inst.Parent then return end

    if inst:IsA("BasePart") then
        if not frozenStates[inst] then
            frozenStates[inst] = {
                CFrame      = inst.CFrame,
                Velocity    = inst.Velocity,
                RotVelocity = inst.RotVelocity,
                Anchored    = inst.Anchored
            }
        end
        inst.CFrame       = frozenStates[inst].CFrame
        inst.Velocity     = Vector3.new()
        inst.RotVelocity  = Vector3.new()
        inst.Anchored     = true
    elseif inst:IsA("Humanoid") then
        if not frozenStates[inst] then
            frozenStates[inst] = { WalkSpeed = inst.WalkSpeed, JumpPower = inst.JumpPower }
        end
        inst.WalkSpeed = 0
        inst.JumpPower = 0
    end
end

----------------------------------------------------------------
-- 3. MAIN LOOP (Stepped = pre‑physics → overrides server)
----------------------------------------------------------------
RunService.Stepped:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end

    -- KEEP YOURSELF FULLY MOVABLE
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
    local root = myChar:FindFirstChild("HumanoidRootPart")
    if root then root.Anchored = false end

    -- FREEZE EVERYTHING ELSE
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Parent ~= myChar then freezeInstance(obj) end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                freezeInstance(part)
            end
        end
    end

    -- GUI KILL (run every frame)
    killAllGui()
end)

----------------------------------------------------------------
-- 4. INITIAL GUI KILL (in case script loads after UI)
----------------------------------------------------------------
spawn(function()
    wait(0.2)      -- give the game a moment to build UI
    killAllGui()
end)
