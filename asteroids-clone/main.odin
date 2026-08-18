package main

import "core:math"
import "core:fmt"

import rl "vendor:raylib"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

Player :: struct {
	pos:  rl.Vector2,
	angle: f32,
	local: [3][2]f32
}

rotate_point :: proc(vector: [2]f32, angle: f32) -> [2]f32 {
	sin := math.sin(angle)
	cos := math.cos(angle)

	temp: [2]f32 = {vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos}

	return temp
}

draw_player :: proc(player: Player) {
	points: [3][2]f32

	for v, i in player.local {
		points[i] = player.pos + rotate_point(v, player.angle)
	}

	rl.DrawTriangleLines(points[0],
		points[1],
		points[2],
		rl.GREEN)
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Asteroids clone")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	player := Player {
		pos  = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2},
		local = {{0, -60}, {-40, 40}, {40, 40}}
	}

	acceleration: f32 = 0
	velocity: f32 = 50
	spin_speed: f32 = f32(math.PI)

	for !rl.WindowShouldClose() {
		frame_time := rl.GetFrameTime()

		// TODO: Adjust player movement ease in
		if rl.IsKeyDown(.LEFT) {
			player.angle -= spin_speed * frame_time
			fmt.println(player.angle)
		} else if rl.IsKeyDown(.RIGHT) {
			player.angle += spin_speed * frame_time
		} else if rl.IsKeyDown(.UP) {
			acceleration += 5

			if acceleration >= 200 {
				acceleration = 200
			}

			fmt.println(acceleration)
		} else if rl.IsKeyDown(.DOWN) {
			acceleration -= 7.5

			if acceleration <= 0 {
				acceleration = 0
			}
		} else {
			acceleration -= 5

			if acceleration <= 0 {
				acceleration = 0
			}
		}

		player.pos.x += acceleration * frame_time

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)
		draw_player(player)
	}
}
