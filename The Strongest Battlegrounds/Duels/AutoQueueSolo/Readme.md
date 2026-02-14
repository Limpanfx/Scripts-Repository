# Project Title

Short description of what this script does.

## Features

- Feature one
- Feature two

## Usage

1. Step one
2. Step two

## Code

```lua
local queueteleport =
    (queue_on_teleport)
    or (syn and syn.queue_on_teleport)
    or (fluxus and fluxus.queue_on_teleport)

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
