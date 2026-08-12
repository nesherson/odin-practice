package main

import rl "vendor:raylib"

main :: proc() {
	screen_width: i32 = 1280
	screen_height: i32 = 720

	rl.InitWindow(1280, 720, "Test title")
	defer rl.CloseWindow()

	player_run_texture: rl.Texture2D = rl.LoadTexture("cat_run.png")
	player_texture_scale: f32 = 4
	player_run_num_frames: i32 = 4
	player_run_frame_timer: f32
	player_run_current_frame: i32
	player_run_frame_length: f32 = 0.1
	player_pos: [2]f32
	player_vel: [2]f32
	player_grounded: bool
	player_flip: bool

	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(.LEFT) {
			player_vel.x = -400
			player_flip = true
		} else if rl.IsKeyDown(.RIGHT) {
			player_vel.x = 400
			player_flip = false
		} else {
			player_vel.x = 0
		}

		player_vel.y += 2000 * rl.GetFrameTime()

		if player_grounded && rl.IsKeyPressed(.SPACE) {
			player_vel.y = -600
			player_grounded = false
		}

		player_pos += player_vel * rl.GetFrameTime()

		if player_pos.y >
		   f32(rl.GetScreenHeight()) - f32(player_run_texture.height * i32(player_texture_scale)) {
			player_pos.y =
				f32(rl.GetScreenHeight()) -
				f32(player_run_texture.height * i32(player_texture_scale))
			player_grounded = true
		}

		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})

		player_run_width: f32 = f32(player_run_texture.width)
		player_run_heigh: f32 = f32(player_run_texture.height)

		player_run_frame_timer += rl.GetFrameTime()

		if player_run_frame_timer > player_run_frame_length {
			player_run_current_frame += 1
			player_run_frame_timer = 0

			if player_run_current_frame == player_run_num_frames {
				player_run_current_frame = 0
			}
		}

		draw_player_source: rl.Rectangle = rl.Rectangle {
			x      = f32(player_run_current_frame) * player_run_width / f32(player_run_num_frames),
			y      = 0,
			width  = player_run_width / f32(player_run_num_frames),
			height = player_run_heigh,
		}

		if player_flip {
			draw_player_source.width = -draw_player_source.width
		}

		if player_vel.x == 0 {
			draw_player_source.x = f32(3) * player_run_width / f32(player_run_num_frames)
		}

		draw_player_dest: rl.Rectangle = {
			x      = player_pos.x,
			y      = player_pos.y,
			width  = draw_player_source.width * player_texture_scale,
			height = draw_player_source.height * player_texture_scale,
		}

		rl.DrawTexturePro(player_run_texture, draw_player_source, draw_player_dest, 0, 0, rl.WHITE)
		rl.EndDrawing()
	}
}
