module main

import vweb
import dbpool
import os
import time

[heap]
struct App {
mut:
	pool dbpool.DbPool
}

fn new_app() App {
	mut pool := dbpool.DbPool{}
	pool.init_mysql() or { panic(err) }
	mut app := App{
		pool: pool
	}
	return app
}

pub fn (mut app App) destroy_handler(sig os.Signal) {
	println('shutting down ...')
	app.pool.disconnect() or { panic(err) }
	println('done!')
	exit(0)
}

fn main() {
	println('Hello World!')
	mut app := new_app()
	os.signal_opt(os.Signal.term, app.destroy_handler)!
	os.signal_opt(os.Signal.int, app.destroy_handler)!
	for {
		time.sleep(1 * time.second)
		println('-------------------------------------------------------------------------')
		for ent in app.pool.get_all_entities() {
			println('${ent.ent_type} ${ent.id}')
		}
	}
}
