package temp

import "core:fmt"
import "core:math"

import rl "vendor:raylib"

SCREEN_WIDTH :: 1280
SCREEN_HEIGHT :: 720

rotate_point :: proc(vector: [2]f32, angle: f32) -> [2]f32 {
	sin := math.sin(angle)
	cos := math.cos(angle)

	// return {vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos}

	return {vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos}
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Test title")
	defer rl.CloseWindow()

	angle: f32 = 0.0
	line_start_pos := rl.Vector2 {500, 500}
	line_end_pos := rl.Vector2 {500, 600}

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.T) {
			angle += 0.1
			fmt.println(math.sin(angle))

		}

		if rl.IsKeyPressed(.R) {
			angle = 0
		}




		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawLine(i32(line_start_pos.x), i32(line_start_pos.y), i32(line_end_pos.x), i32(line_end_pos.y), rl.GREEN)
		defer rl.EndDrawing()
	}
}
