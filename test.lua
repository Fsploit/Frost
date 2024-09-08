
local parryEnabled = true -- Toggle to enable/disable auto parry
local parryDistance = 10  -- Adjust this for how close the attack needs to be for auto parry
local parryCooldown = 1   -- Cooldown time between parries
local lastParry = 0       -- Timestamp for last parry

function isAttackIncoming(enemy, player)
    local distance = (enemy.Position - player.Position).Magnitude
    return distance <= parryDistance
end

function autoParry(player)
    if parryEnabled and (tick() - lastParry) >= parryCooldown then
  else
        print("Parried!")
  else
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
