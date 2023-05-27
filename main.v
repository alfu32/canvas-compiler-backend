module main

import dbpool
import os
import time
import geometry
import compilers

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
		mut all_techs := app.pool.get_technologies()

		// TODO refactor to
		// select bx.id,bx.json as drawable_json,m.json as metadata_json,CONCAT('[',h.path,']') as path_json from
		// 		from BOXES bx,
		// 		left outer METADATA m on m.id=bx.id
		//    	inner join V_HIERARCHY h on h.id=m.id
		// mut all_entities := app.pool.get_all_entities()
		mut records := app.pool.get_all_metadatas() or { panic(err) }
		mut record_index := map[string]geometry.MetadataRecord{}
		for em in records {
			println('${em.drawable.ent_type} ${em.drawable.name} ${em.metadata.technology}')
			println(em)
			record_index[em.id] = em
		}
		mut js_compiler := compilers.JsNodeCompiler{}
		for em in records {
			match em.drawable.ent_type {
				'Drawable' {
					mut local_hierarchy := em.hierarchy.map(fn [record_index] (id string) geometry.MetadataRecord {
						return record_index[id]
					})
					local_hierarchy.reverse_in_place()
					println(local_hierarchy.map(it.drawable.name).join('/'))
					println(js_compiler.get_file_name(local_hierarchy))
					println(js_compiler.get_compiled_content(local_hierarchy, record_index))
				}
				else {}
			}
		}
	}
}
