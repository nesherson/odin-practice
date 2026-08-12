package main

import rl "vendor:raylib"

main :: proc() {
	screen_width: i32 = 1280
	screen_height: i32 = 720

	rl.InitWindow(1280, 720, "Test title")
	defer rl.CloseWindow()

	player_texture: rl.Texture2D = rl.LoadTexture("player.png")
	player_pos: [2]f32
	player_vel: [2]f32
	player_grounded: bool

	for !rl.WindowShouldClose() {
		input: [2]f32

		if rl.IsKeyDown(.UP) {
			input.y -= 1
		} else if rl.IsKeyDown(.DOWN) {
			input.y += 1
		} else if rl.IsKeyDown(.LEFT) {
			player_vel.x = -400
		} else if rl.IsKeyDown(.RIGHT) {
			player_vel.x = 400
		} else {
			player_vel.x = 0
		}

		player_vel.y += 2000 * rl.GetFrameTime()

		if player_grounded && rl.IsKeyPressed(.SPACE) {
			player_vel.y = -600
			player_grounded = false
		}

		player_pos += player_vel * rl.GetFrameTime()

		if player_pos.y > f32(rl.GetScreenHeight()) - f32(player_texture.height) {
			player_pos.y = f32(rl.GetScreenHeight()) - f32(player_texture.height)
			player_grounded = true
		}

		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		rl.DrawTextureV(player_texture, player_pos, rl.WHITE)
		rl.EndDrawing()
	}
}
