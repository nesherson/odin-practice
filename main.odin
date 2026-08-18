package main

import rl "vendor:raylib"

Animation_Name :: enum {
	Idle,
	Run
}

Animation :: struct {
	name: Animation_Name,
	texture: rl.Texture2D,
	num_frames: int,
	frame_timer: f32,
	current_frame: int,
	frame_length: f32
}

update_animation :: proc(animation: ^Animation) {
	animation.frame_timer += rl.GetFrameTime()

	if animation.frame_timer > animation.frame_length {
		animation.current_frame += 1
		animation.frame_timer = 0

		if animation.current_frame == animation.num_frames {
			animation.current_frame = 0
		}
	}
}

draw_animation :: proc(animation: Animation, position: rl.Vector2, texture_scale: f32, flip: bool) {
	width: f32 = f32(animation.texture.width)
	heigh: f32 = f32(animation.texture.height)

	draw_source: rl.Rectangle = rl.Rectangle {
		x      = f32(animation.current_frame) * width / f32(animation.num_frames),
		y      = 0,
		width  = width / f32(animation.num_frames),
		height = heigh,
	}

	if flip {
		draw_source.width = -draw_source.width
	}

	draw_dest: rl.Rectangle = {
		x      = position.x,
		y      = position.y,
		width  = draw_source.width * texture_scale,
		height = draw_source.height * texture_scale,
	}

	rl.DrawTexturePro(animation.texture, draw_source, draw_dest, 0, 0, rl.WHITE)
}

main :: proc() {
	screen_width: i32 = 1280
	screen_height: i32 = 720

	rl.InitWindow(1280, 720, "Test title")
	defer rl.CloseWindow()

	player_texture_scale: f32 = 4
	player_pos: [2]f32
	player_vel: [2]f32
	player_grounded: bool
	player_flip: bool

	player_idle_anim := Animation {
		name = .Idle,
		texture = rl.LoadTexture("cat_idle.png"),
		num_frames = 2,
		frame_length = 0.5
	}
	player_run_anim := Animation {
		name = .Run,
		texture = rl.LoadTexture("cat_run.png"),
		num_frames = 4,
		frame_length = 0.1
	}

	player_current_anim := player_idle_anim

	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(.LEFT) {
			player_vel.x = -400
			player_flip = true

			if player_current_anim.name != .Run {
				player_current_anim = player_run_anim
			}
		} else if rl.IsKeyDown(.RIGHT) {
			player_vel.x = 400
			player_flip = false

			if player_current_anim.name != .Run {
				player_current_anim = player_run_anim
			}
		} else {
			player_vel.x = 0

			if player_current_anim.name != .Idle {
				player_current_anim = player_idle_anim
			}
		}

		player_vel.y += 2000 * rl.GetFrameTime()

		if player_grounded && rl.IsKeyPressed(.SPACE) {
			player_vel.y = -600
			player_grounded = false
		}

		player_pos += player_vel * rl.GetFrameTime()

		if player_pos.y >
		   f32(rl.GetScreenHeight()) - f32(player_current_anim.texture.height * i32(player_texture_scale)) {
			player_pos.y =
				f32(rl.GetScreenHeight()) -
				f32(player_current_anim.texture.height * i32(player_texture_scale))
			player_grounded = true
		}

		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		update_animation(&player_current_anim)
		draw_animation(player_current_anim, player_pos, player_texture_scale, player_flip)


		rl.EndDrawing()
	}
}
