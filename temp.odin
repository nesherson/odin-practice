package temp

import "core:fmt"
import la "core:math/linalg"

import rl "vendor:raylib"

Rect :: struct {
	pos:   [2]f32,
	color: rl.Color,
	size:  f32,
}

rectangle_hit_test :: proc(rectangle: ^Rect, mouse_pos: rl.Vector2) -> bool {
	if mouse_pos.x >= rectangle.pos.x &&
	   mouse_pos.x <= rectangle.pos.x + rectangle.size &&
	   mouse_pos.y >= rectangle.pos.y &&
	   mouse_pos.y <= rectangle.pos.y + rectangle.size {
		return true
	}

	return false
}

main :: proc() {
	screen_width: i32 = 1280
	screen_height: i32 = 720

	rl.InitWindow(1280, 720, "Test title")
	defer rl.CloseWindow()

	rectangles: [5]Rect
	selected_rectangle: ^Rect = nil
	drag_delta: [2]f32

	for i := 0; i < len(rectangles); i += 1 {
		x: f32 = cast(f32)(i) * 0.2 * cast(f32)screen_width
		y: f32 = cast(f32)(i) * 0.2 * cast(f32)screen_height
		rectangles[i] = Rect {
			pos   = {x, y},
			color = rl.GREEN,
			size  = 50,
		}
	}

	for !rl.WindowShouldClose() {
		if rl.IsMouseButtonPressed(.LEFT) {
			mouse_position: rl.Vector2 = rl.GetMousePosition()
			for i := 0; i < len(rectangles); i += 1 {
				if rectangle_hit_test(&rectangles[i], mouse_position) {
					selected_rectangle = &rectangles[i]
					selected_rectangle.color = rl.RED
					drag_delta = selected_rectangle.pos

				}
			}
		}

		if rl.IsMouseButtonReleased(.LEFT) {
			selected_rectangle.color = rl.GREEN
			selected_rectangle = nil
		}

		if rl.IsMouseButtonDown(.LEFT) && selected_rectangle != nil {
			mouse_position: rl.Vector2 = rl.GetMousePosition()
			new_pos: [2]f32 = {}
			drag_delta.x = mouse_position.x - drag_delta.x
			drag_delta.y = mouse_position.y - drag_delta.y
			selected_rectangle.pos.x += drag_delta.x
			selected_rectangle.pos.y += drag_delta.y

			fmt.println(drag_delta)
		}

		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		for i := 0; i < len(rectangles); i += 1 {
			rectangle: Rect = rectangles[i]
			rl.DrawRectangleV(rectangle.pos, {rectangle.size, rectangle.size}, rectangle.color)
		}
		rl.EndDrawing()
	}
}
