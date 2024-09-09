
local Utils = {}

function Utils.getDistance(object1, object2)
    local pos1 = object1.Position
    local pos2 = object2.Position
    return (pos1 - pos2).Magnitude
end

function Utils.canParry(ball, player, parryDistance, parryCooldown, lastParryTime)
    local distance = Utils.getDistance(ball, player)
    local timeElapsed = tick() - lastParryTime
    
    return distance <= parryDistance and timeElapsed >= parryCooldown
end

function Utils.performParry(player)
    print(player.Name .. " parried the ball!")
    return tick()
end

return Utils
