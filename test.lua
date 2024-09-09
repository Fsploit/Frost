
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
    if
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
