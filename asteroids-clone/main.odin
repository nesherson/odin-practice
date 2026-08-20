package main

import "core:fmt"
import "core:math"

import rl "vendor:raylib"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

Player :: struct {
	pos:       rl.Vector2,
	angle:     f32,
	local:     [3]rl.Vector2,
	max_speed: f32,
	velocity:  rl.Vector2,
	speed:     f32,
}

rotate_point :: proc(vector: [2]f32, angle: f32) -> [2]f32 {
	sin := math.sin(angle)
	cos := math.cos(angle)

	return {vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos}
}

draw_player :: proc(player: Player) {
	points: [3]rl.Vector2

	for v, i in player.local {
		points[i] = player.pos + rotate_point(v, player.angle)
	}

	rl.DrawTriangleLines(points[0], points[1], points[2], rl.GREEN)
}

reset_player :: proc(player: ^Player) {
	player.pos = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}
	player.speed = 0
	player.velocity = 0
	player.angle = 0
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Asteroids clone")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	player := Player {
		pos       = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2},
		local     = {{0, -40}, {-20, 15}, {20, 15}},
		max_speed = 500,
		velocity  = 0,
	}

	spin_speed: f32 = f32(math.PI) * 2
	forward: [2]f32

	for !rl.WindowShouldClose() {
		frame_time := rl.GetFrameTime()

		if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyPressed(.R) {
			reset_player(&player)
		}

		if rl.IsKeyDown(.LEFT) {
			player.angle -= spin_speed * frame_time
		}

		if rl.IsKeyDown(.RIGHT) {
			player.angle += spin_speed * frame_time
		}

		if rl.IsKeyDown(.UP) {
			player.speed = math.clamp(player.speed + 150 * frame_time, 0, player.max_speed)
			forward = rotate_point({0, -1}, player.angle)
		} else {
			player.speed = math.clamp(player.speed - 80 * frame_time, 0, player.max_speed)
		}

		player.velocity = forward * player.speed
		player.pos += player.velocity * frame_time

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)
		draw_player(player)
	}
}
