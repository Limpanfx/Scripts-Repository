## How it works

This script tween-teleports your character along a fixed path of CFrame waypoints using `TweenService`, while constantly disabling collisions so the map geometry cannot block you. It runs the path every time your character spawns, making it suitable for simple autofarm routes. 

## Changing the speed

Movement speed is controlled by the `duration` values passed into `tweenTo(hrp, targetCFrame, duration)` for each waypoint. Lower values make that segment faster, higher values make it slower; for example, change `20` to `10` to move twice as fast on the long middle segment. [

```lua
-- Example: number represents time in seconds per tween
tweenTo(hrp, locations, 2)
tweenTo(hrp, locations, 10) -- was 20
tweenTo(hrp, locations, 2)
tweenTo(hrp, locations, 2)
```
### Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/refs/heads/main/Build%20A%20Boat%20For%20Treasure/Autofarm/Script.lua"))()
