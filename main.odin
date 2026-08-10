package main

import "core:fmt"
import la "core:math/linalg"

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "Test title")
	defer rl.CloseWindow()

	player_texture: rl.Texture2D = rl.LoadTexture("player.png")
	player_pos: [2]f32
	speed: f32 = 50

	for !rl.WindowShouldClose() {
		input: [2]f32

		if rl.IsKeyDown(.UP) {
			input.y -= 1
		} else if rl.IsKeyDown(.DOWN) {
			input.y += 1
		} else if rl.IsKeyDown(.LEFT) {
			input.x -= 1
		} else if rl.IsKeyDown(.RIGHT) {
			input.x += 1
		}

		player_pos += la.normalize0(input) * rl.GetFrameTime() * speed

		fmt.println(player_pos)

		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		rl.DrawTextureV(player_texture, player_pos, rl.WHITE)
		rl.EndDrawing()
	}
}
