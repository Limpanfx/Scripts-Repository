# Murder Mystery 2 – Limpans GUI

A feature-packed **utility** script for Murder Mystery 2, built around Kavo UI and focused on visuals, mobility, ESP, aimbot and QoL tools.

---

## ⭐ Features

- Visual:
  - Fullbright toggle for better visibility.
  - XRay (LocalTransparencyModifier) style wallhack.
  - Role avatars for Murderer and Sheriff using live headshot thumbnails.
- Local character:
  - Infinite jump, noclip.
  - Walkspeed and jumppower sliders (with original values preserved).
  - Optional no-animations and teleport-to-spawn.
- ESP:
  - Highlight-based ESP for Innocent, Sheriff, and Murderer, each with its own color.
- Aimbot:
  - RMB hold aimbot with FOV circle, prediction, and customizable radius/color.
- Hitboxes:
  - Expand enemy HumanoidRootPart size with adjustable hitbox size and visibility.
- Misc / Obvious:
  - Swim/fly-like movement mode using gravity manipulation and humanoid state tweaks.
- UI:
  - Tabs for Main, ESP, Aimbot, Hitboxes, Obvious, Settings.
  - Color pickers for scheme/text color and a keybind to toggle the UI (default R).

---

## 🧠 Dependencies

- Roblox executor that supports:
  - `loadstring` and `game:HttpGet`.
  - Drawing API (`Drawing.new("Circle")`) for the FOV circle.
- Kavo-UI Library (fetched at runtime):  
  `https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua`.

---

## 🚀 How to execute

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/main/Murder%20Mystery%202/Script.lua", true))()
```
