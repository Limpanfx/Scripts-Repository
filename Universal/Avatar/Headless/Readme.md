# Headless Avatar (LocalScript)

This script makes your local character appear **headless** by hiding the Head and its face decal using transparency.

## How it works

- Gets `Players.LocalPlayer` and waits for the character to load.  
- Sets the `Head.Transparency` to `1` (fully invisible).  
- Finds the `face` decal inside the head and sets its `Transparency` to `1` as well.  
- Reapplies the effect whenever the character respawns via `CharacterAdded`.

## Usage

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Limpanfx/Scripts-Repository/refs/heads/main/Universal/Avatar/Headless/Script.lua"))()
