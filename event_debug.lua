local EventDebug = {}
local font = Renderer.LoadFont("Tahoma", 20, Enum.FontWeight.EXTRABOLD)
EventDebug.EntityList = {}


-- const
EventDebug.DEBUG_NPC = 1
EventDebug.DEBUG_HEALTH = 2
EventDebug.DEBUG_LAST_DAMAGE = 3
EventDebug.DEBUG_ALIVE = 4
EventDebug.DEBUG_LAST_DAMAGE_AT = 5
EventDebug.DEBUG_TARGET = 6
EventDebug.DEBUG_IN_ATTACK = 7
EventDebug.DEBUG_IN_ATTACK_OUT = 8


function EventDebug.OnDraw()

    if not Event.InGame then
        return
    end

    local size = 30
    for i, item in pairs(EventDebug.EntityList) do
        local npc = item[EventDebug.DEBUG_NPC]
        local origin = Entity.GetAbsOrigin(npc)
        local x, y, visible = Renderer.WorldToScreen(origin)
        if item[EventDebug.DEBUG_ALIVE] then
            Renderer.SetDrawColor(0, 255, 0, 55)
        else
            Renderer.SetDrawColor(255, 0, 0, 55)
        end
        Renderer.DrawFilledRect(x-size, y-size, 2 * size, 2 * size)
        Renderer.SetDrawColor(255, 255, 255, 255)
        if item[EventDebug.DEBUG_LAST_DAMAGE_AT] > os.time() then
            Renderer.DrawText(font, x-size, y-size, item[EventDebug.DEBUG_LAST_DAMAGE], 1)
        end
        if item[EventDebug.DEBUG_IN_ATTACK] then
            Renderer.DrawText(font, x-size, y-size-20, 'ATTACK', 1)
        end
        if item[EventDebug.DEBUG_IN_ATTACK_OUT] and item[EventDebug.DEBUG_IN_ATTACK_OUT] < os.time() then
            item[EventDebug.DEBUG_IN_ATTACK] = false
            item[EventDebug.DEBUG_IN_ATTACK_OUT] = 0
        end
    end

end


Event:on('reset', function()
    Log.Write('on reset')
    EventDebug.EntityList = {}
end)


Event:on('invalid', function(ent)
    local i = Entity.GetIndex(ent)
    Log.Write('on invalid #'..i)
        if EventDebug.EntityList[i] ~= nil then
        EventDebug.EntityList[i] = nil
    end
end)


Event:on('death', function(ent)
    -- Log.Write('on death')
    local i = Entity.GetIndex(ent)
    if EventDebug.EntityList[i] ~= nil then
        EventDebug.EntityList[i][EventDebug.DEBUG_HEALTH] = 0
        EventDebug.EntityList[i][EventDebug.DEBUG_ALIVE] = false
    end
end)


Event:on('trace_damage', function(ent, damage)
    local i = Entity.GetIndex(ent)
    -- Log.Write('on damage #'..i..' got '..damage..'dmg')
    if EventDebug.EntityList[i] ~= nil then
        EventDebug.EntityList[i][EventDebug.DEBUG_LAST_DAMAGE] = damage
        EventDebug.EntityList[i][EventDebug.DEBUG_LAST_DAMAGE_AT] = os.time() + 0.3
    end
end)


Event:on('trace_attack', function(ent, target, predicted_damage, predicted_time)
    local i = Entity.GetIndex(ent)

    if EventDebug.EntityList[i] ~= nil then
        EventDebug.EntityList[i][EventDebug.DEBUG_IN_ATTACK] = true
        EventDebug.EntityList[i][EventDebug.DEBUG_IN_ATTACK_OUT] = predicted_time
        EventDebug.EntityList[i][EventDebug.DEBUG_TARGET] = target
    end
end)


Event:on('spawn', function(ent)

    local i = Entity.GetIndex(ent)
    local health = Entity.GetHealth(ent)
    Log.Write('on spawn #'..i..' with health '..health)

    EventDebug.EntityList[i] = {}
    EventDebug.EntityList[i][EventDebug.DEBUG_NPC] = ent
    EventDebug.EntityList[i][EventDebug.DEBUG_HEALTH] = health
    EventDebug.EntityList[i][EventDebug.DEBUG_LAST_DAMAGE] = 0
    EventDebug.EntityList[i][EventDebug.DEBUG_ALIVE] = true
    EventDebug.EntityList[i][EventDebug.DEBUG_LAST_DAMAGE_AT] = 0
    EventDebug.EntityList[i][EventDebug.DEBUG_IN_ATTACK] = 0
    EventDebug.EntityList[i][EventDebug.DEBUG_IN_ATTACK_OUT] = 0
    EventDebug.EntityList[i][EventDebug.DEBUG_TARGET] = nil

end)


return EventDebug