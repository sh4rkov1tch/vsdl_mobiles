module sapp

import time
import sdl
import smobile

struct SApp {
mut:
	w        int
	h        int
	window   &sdl.Window
	renderer &sdl.Renderer
	mobiles  []smobile.SMobile
}

pub fn new(width int, height int, window_title string) SApp {
	win := sdl.create_window(window_title.str, sdl.windowpos_centered, sdl.windowpos_centered,
		width, height, u32(sdl.WindowFlags.shown))
	rend := sdl.create_renderer(win, -1, u32(sdl.RendererFlags.accelerated))

	mut sp := SApp{
		w: width
		h: height
		window: win
		renderer: rend
	}

	mut i := 0
	for i < 100 {
		sp.mobiles.prepend(smobile.new(25, 25, sdl.Point{width, height}))
		i++
	}

	return sp
}

pub fn (sp SApp) del() {
	sdl.destroy_renderer(sp.renderer)
	sdl.destroy_window(sp.window)
	sdl.quit()
}

pub fn (mut sp SApp) run() {
	mut quit := false
	mut sw := time.new_stopwatch()
	frametime := 20

	sw.start()
	for {
		if sw.elapsed().milliseconds() > frametime {
			sw.pause()
			event := sdl.Event{}

			for 0 < sdl.poll_event(&event) {
				match event.@type {
					.quit { quit = true }
					else {}
				}
			}

			if quit {
				break
			}

			sdl.set_render_draw_color(sp.renderer, 0, 0, 0, 255)
			sdl.render_clear(sp.renderer)

			mut i := 0
			for i < sp.mobiles.len {
				sp.mobiles[i].move(sdl.Point{sp.w, sp.h})
				sp.mobiles[i].draw(sp.renderer)
				i++
			}

			sdl.render_present(sp.renderer)
			sw.restart()
		}
	}
}
