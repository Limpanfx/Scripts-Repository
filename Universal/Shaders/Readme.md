## What Are “Shaders”?

In normal game engines, a **shader** is a small program that runs on the GPU and decides how pixels should look. How light hits surfaces, how shiny or rough things are, how shadows, reflections and colors are drawn on screen.

You can think of shaders as **rules for rendering**. They’re responsible for things like:

- How bright or dark a surface is depending on the light angle.
- Whether a material looks metallic, glossy, or matte.
- Fake reflections, water ripples, glow, bloom, fog, outlines, and more.
- Post‑processing, like changing the overall color tone or adding blur/bloom after the scene is rendered.

On Roblox, we don’t have direct access to true GPU shader code from Lua, but we can **mimic shader-like effects** by:

- Adjusting global lighting (time of day, ambient colors, brightness).
- Using built‑in post‑processing objects (`BloomEffect`, `ColorCorrectionEffect`, `SunRaysEffect`, `BlurEffect`) to change the final image.
- Spawning extra visual parts (like thin reflective layers on the ground) to fake advanced effects such as liquid reflections or mirrors.

This sub-project treats each visual configuration (lighting + post‑processing + extra geometry tricks) as a **“shader preset”**. I will expand this with more presets over time.
