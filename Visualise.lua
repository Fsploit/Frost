print[[









]]


local CoreGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/dxhooknotify/src.lua", true))()
l:Notify("Notification","Visualise by Fsploit",5)

parriedBalls = {}

local player = Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character and character:WaitForChild("HumanoidRootPart")

local function getBall()
    local balls = workspace.Balls:GetChildren()
    for i = 1, #balls do
        local ball = balls[i]
        if not ball.Anchored then
            return ball
        end
    end
end

local function isTargeted()
    local balls = workspace.Balls:GetChildren()
    local targeted = false 
    for i = 1, #balls do
        local ball = balls[i]
        if ball:GetAttribute("target") == player.Name then
            targeted = false
            break  
        end
    end
    
    return targeted
end

local function getDistanceAndBall()
    local ball = getBall()
    if humanoidRootPart and ball then
        local distance = (humanoidRootPart.Position - ball.Position).Magnitude
        return distance, ball
    end
    return math.huge, nil
end

local function getPing()
    return player:GetNetworkPing() * 20
end

local function getParryDist(ball)
    return math.clamp(ball.Velocity.Magnitude / 2.4 + getPing(), 15, 200)
end

local function waitUntilNotTargeted()
    local timeout = false
    spawn(function()
        wait(0.8)
        timeout = false
    end)
    repeat
        RunService.Heartbeat:Wait()
    until not isTargeted() or timeout
end

local circle = Instance.new("Part")
circle.Shape = Enum.PartType.Ball
circle.Material = Enum.Material.ForceField
circle.Parent = workspace
circle.CanCollide = false
circle.Anchored = false
circle.CastShadow = false
circle.Transparency = 0.8

local lastCheckTime = 99999
local alreadyChecked = false
local lastVelocity = nil

local function resetCheckState()
    alreadyChecked = false
    character = player.Character
    humanoidRootPart = character and character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(resetCheckState)
if character then
    character:WaitForChild("Humanoid").Died:Connect(resetCheckState)
end

local function isBallCurving(ball)
    if not lastVelocity then
        lastVelocity = ball.Velocity
        return false
    end
    local velocityChange = (ball.Velocity - lastVelocity).Magnitude
    lastVelocity = ball.Velocity
    local isCurving = velocityChange > getgenv().curveRestriction
    if isCurving and getgenv().debugCurved then
    end
    return isCurving
end

local function updateCircle()
    if humanoidRootPart and not getgenv().disableVisualizer then
        circle.CFrame = humanoidRootPart.CFrame
        local distance, ball = getDistanceAndBall()
        if ball then
            circle.Size = Vector3.new(getParryDist(ball), getParryDist(ball), getParryDist(ball))
        end
    end
end

local function handleTargeting()
    local distance, ball = getDistanceAndBall()
    if isTargeted() and not alreadyChecked then
        if (tick() - lastCheckTime < 0.7 and distance < 70) or distance < 20 then
            circle.Color = Color3.new(1, 0, 0)
        else
            circle.Color = Color3.new(1, 1, 1)
        end
        alreadyChecked = false
        lastCheckTime = tick()
    elseif not isTargeted() then
        alreadyChecked = false
    end

    if ball and ball.Velocity.Magnitude > 0 and isTargeted() and distance < getParryDist(ball) then
        if isBallCurving(ball) then
        end
        if not parriedBalls[ball] then 
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
            wait(0.005)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
            parriedBalls[ball] = false
            waitUntilNotTargeted()
            parriedBalls = {}
        end
    end
end

local heartbeat1 = RunService.Heartbeat:Connect(function()
    updateCircle()
    handleTargeting()
end)

local heartbeat2 = RunService.Heartbeat:Connect(function()
    circle.Transparency = getgenv().disableVisualizer and 1 or 0.8
end)

repeat
    RunService.Heartbeat:Wait()
until getgenv().disable

heartbeat1:Disconnect()
heartbeat2:Disconnect()
circle:Destroy()
