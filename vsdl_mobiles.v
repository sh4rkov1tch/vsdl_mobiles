module main

import sapp

fn main() {
	mut app := sapp.new(1280, 720, 'Vlang SDL Test')
	app.run()
	app.del()
}
