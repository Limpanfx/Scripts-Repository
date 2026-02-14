# The Strongest Battlegrounds – Duels AutoQueue Solo

Simple script that teleports you into a random spot in the solo duel queue area in The Strongest Battlegrounds (duels lobby).

## Features

- Only runs in the correct duels place (checks `game.PlaceId`).
- Waits for your character and `HumanoidRootPart`.
- Teleports you to a random position inside a defined region near the solo queue.

## Loadstring
- This version of the loadstring is on autoexecute per default.
```lua
local executorInfo = identifyexecutor and identifyexecutor() or {}

local queueteleport =
    (queue_on_teleport)
    or (syn and syn.queue_on_teleport)
    or (fluxus and fluxus.queue_on_teleport)
    or (queueonteleport)

if not queueteleport and string.find((executorInfo.name or "").lower(), "xeno") then
    queueteleport = function() end
end

if not queueteleport then
    warn("queue_on_teleport not supported by this executor")
end

local LOCAL_SCRIPT_CODE = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/refs/heads/main/The%20Strongest%20Battlegrounds/Duels/AutoQueueSolo/Script.lua", true))()
]]

loadstring(LOCAL_SCRIPT_CODE)()

if queueteleport then
    queueteleport(LOCAL_SCRIPT_CODE)
end
