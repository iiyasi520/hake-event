## Event API


Event driven hacke.me

## Variables

`Event.InGame` - Returns `true` if you're playing a match now.

```
function HitMaster.OnUpdate()

    if not Event.InGame then return end

end
```

## Functions

`Event.GetHitDamage(attacker, target)`  - Returns the damage `attacker` entity can do to `target`.

`Event.HitDelay(attacker, target, full)` - Returns time to complete attack. If `full` is true returns time to complete attack with backswing.

## Events

`Event:on('reset')` - Called as soon as player is not in match. (to reset your script's data)

```
Events:on('reset', function ()
   Player.Reset()
end)
```


`Event:on('spawn')` - Called on entity spawn.

```
Event:on('spawn', function(ent)
    local i = Entity.GetIndex(ent)
    local health = Entity.GetHealth(ent)
    Log.Write('on spawn #'..i..' with health '..health)
end)
```


`Event:on('death')` - Called on death fact.

```
Event:on('death', function(ent)
    Log.Write('on death #'..Entity.GetIndex(ent))
end)
```


`Event:on('invalid')` - Called when entity is no longer exists.

```
Event:on('invalid', function(ent)
    local i = Entity.GetIndex(ent)
    Log.Write('on invalid #'..i)
end)
```


`Event:on('trace_attack')` - Called on attack. **target can be nil for ranged units before a projective exists**

```
Event:on('trace_attack', function(attacker, target, predicted_damage, predicted_time)
    local i = Entity.GetIndex(attacker)
    local ti = Entity.GetIndex(target)

    Log.Write('Entity #i'..' is attacking #'..ti..' and will hit for '..predicted_damage..' in '..predicted_time )
end)
```


`Event:on('trace_damage')` - Called when entity takes damage.

```
Event:on('trace_damage', function(ent, damage)
    local i = Entity.GetIndex(ent)
    Log.Write('on damage #'..i..' got '..damage..'dmg')
end)
```


## Planned todo

`Event:on('summoned_creature')` - Called on entity summon (broodmother's spiders, naga's illusions, illusion runes, necromonicons, etc). Called AFTER `spawn` event.

`Event:on('before_damage')` - Called after each `trace_attack` and predicts health in time.

`Event:on('trace_move')` - Called when entity tries to move. Returns direction.

`Event:on('event_visible')` - Called when entity is friendly entity is visible to enemy.
