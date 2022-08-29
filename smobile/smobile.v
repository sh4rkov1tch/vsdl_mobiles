module smobile

import sdl
import rand

pub struct SMobile {
mut:
	frame sdl.Rect
	speed sdl.Point
	col   sdl.Color
}

pub fn new(width int, height int, window_res sdl.Point) SMobile {
	start_pos_x := rand.int_in_range(window_res.x / 20, window_res.x) or { 4 }
	start_pos_y := rand.int_in_range(window_res.y / 20, window_res.y) or { 4 }

	rect := sdl.Rect{
		x: start_pos_x - width
		y: start_pos_y - height
		w: width
		h: height
	}

	mut speed_x := 0
	mut speed_y := 0
	for speed_x == 0 || speed_y == 0 {
		speed_x = rand.int_in_range(-3, 3) or { 3 }
		speed_y = rand.int_in_range(-3, 3) or { 3 }
	}

	point := sdl.Point{
		x: speed_x
		y: speed_y
	}

	c := sdl.Color{
		r: 100 + rand.u8() % 155
		g: 100 + rand.u8() % 155
		b: 100 + rand.u8() % 155
		a: 255
	}

	sm := SMobile{
		frame: rect
		speed: point
		col: c
	}

	return sm
}

pub fn (mut sm SMobile) move(window_res sdl.Point) {
	map_cond := {
		'left':  sm.frame.x + sm.frame.w > window_res.x
		'right': sm.frame.x < 0
		'up':    sm.frame.y + sm.frame.h > window_res.y
		'down':  sm.frame.y < 0
	}

	if map_cond['left'] || map_cond['right'] {
		sm.speed.x *= -1
	}

	if map_cond['up'] || map_cond['down'] {
		sm.speed.y *= -1
	}

	sm.frame.x += sm.speed.x
	sm.frame.y += sm.speed.y
}

pub fn (sm SMobile) draw(renderer &sdl.Renderer) {
	sdl.set_render_draw_color(renderer, sm.col.r, sm.col.g, sm.col.b, sm.col.a)
	sdl.render_fill_rect(renderer, &sm.frame)
}
