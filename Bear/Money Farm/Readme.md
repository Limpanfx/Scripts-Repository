# Bear – Money Farm

AFK money farming helper for Bear that auto‑AFKs you, tweens you to the chest in the lobby, and shows a live money/profit overlay with stats if keybind (R) is pressed.

## Features

- Auto toggles AFK on the server when run.  
- Teleports your character to a fixed farm position and tweens them up and down.  
- Reads in‑game money from the existing MoneyDisplay label.  
- Full‑screen overlay (toggled with **R**) showing:
  - Starting money, current money, time active  
  - Profit, profit/sec, profit/min, profit/hour (with red/green coloring)  
- RightShift closes the overlay and stops tracking.

## Usage (loadstring)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/main/Bear/Money%20Farm/Script.lua"))()
```
