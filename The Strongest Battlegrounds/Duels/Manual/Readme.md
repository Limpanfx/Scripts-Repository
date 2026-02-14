# Manual Duels Teleport GUI

This is a small **client-side** teleport GUI I put together for "Manual Duels Rank Methoding" to share with friends.  
I specifically made this as a “public” version because I do not want to leak my own main method – that one is a bit too profitable for me to release.

> Note: This script is intended for personal use with friends. Use it at your own risk and respect the game’s rules and terms of service.

## Features

- Clean, compact ScreenGui anchored on the left side of the screen. 
- Three main buttons with alternative keybinds:
  - `Queue Teleport (E)` – Teleports your character to a random position inside of the queue area, the teleportation is instant and visible to other players.
  - `Limpan's Tiny Reset (R)` – Quickly resets your character via humanoid health, works like infinite yields bypassed reset.
  - `Teleport to Lobby (T)` – Uses `TeleportService` to send you back to the duels lobby.

- Slightly styled UI (rounded corners, stroke, padding) so it doesn’t look like default Roblox UI.

## Execution
1. Copy the auto execute loadstring below or get the script [here](https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/refs/heads/main/The%20Strongest%20Battlegrounds/Duels/Manual/Script.lua).
2. Paste it into your executor.
3. Execute. The UI appears left-screen.

```lua
local url = "https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/refs/heads/main/The%20Strongest%20Battlegrounds/Duels/Manual/Script.lua"

if getgenv then
    if getgenv().TSB_DUELS_AUTOEXECED then return end
    getgenv().TSB_DUELS_AUTOEXECED = true
end

loadstring(game:HttpGet(url, true))()

local queue = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport
if queue then
    queue(([[
        -- re-run in the next server without needing your AE folder
        pcall(function() getgenv().TSB_DUELS_AUTOEXECED = nil end)
        loadstring(game:HttpGet(%q, true))()
    ]]):format(url))
end
```
