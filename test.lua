
local parryEnabled = true 
local parryDistance = 10
local parryCooldown = 1   
local lastParry = 0      

function isAttackIncoming(enemy, player)
    local distance = (enemy.Position - player.Position).Magnitude
    return distance <= parryDistance
end

function autoParry(player)
    if parryEnabled and (tick() - lastParry) >= parryCooldown then
  else
        print("Parried!") or print("false") if print("Parried") then print("ms..")
  else
    if toggled then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local BallFolder = Workspace:WaitForChild("Balls")

local player = Players.LocalPlayer
local canParry = true

local function calculatePredictionTime(ball, player)
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local relativePosition = ball.Position - rootPart.Position
            local relativeVelocity = ball.Velocity - rootPart.Velocity
            local a = ball.Size.Magnitude / 1
            local b = relativePosition.Magnitude
            local c = math.sqrt(a * a + b * b)
            return (c - a) / relativeVelocity.Magnitude
        end
    end
    return math.huge
end

local function parry()
    if canParry then
        canParry = false
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        task.delay(0.1, function()
            canParry = true
        end)
    end
end

local function checkProximityToPlayer(ball, player)
    local predictionTime = calculatePredictionTime(ball, player)
    local realBallAttribute = ball:GetAttribute("realBall")
    local target = ball:GetAttribute("target")

    if predictionTime and realBallAttribute and target then
        local ballSpeedThreshold = math.max(0.4, 0.6 - ball.Velocity.Magnitude * 0.03)
        if predictionTime <= ballSpeedThreshold and realBallAttribute and target == player.Name then
            parry()
        end
    end
end

local function checkBallsProximity()
    if player and player.Character then
        for _, ball in ipairs(BallFolder:GetChildren()) do
            if ball:IsA("BasePart") then
                checkProximityToPlayer(ball, player)
            end
        end
    end
end

RunService.Heartbeat:Connect(checkBallsProximity)
        lastParry = tick()
    end
end

while true do
    local player = game.Players.LocalPlayer.Character
    local enemies = game.Workspace.Enemies:GetChildren()

    for _, enemy in ipairs(enemies) do
        if isAttackIncoming(enemy, player) then
            autoParry(player)
        end
    end    
    wait(0.1) 
end
