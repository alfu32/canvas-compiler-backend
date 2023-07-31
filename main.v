module main

import dbpool
import os
import time
import adapter
import arrays
import utils

[heap]
struct ServiceLayer {
pub mut:
	pool dbpool.DbPool
	///// compilers map[string]compilers.Compiler = {
	///// 	"jsc" : compilers.JsNodeCompiler{}
	///// }
}

fn new_service_layer() ServiceLayer {
	mut pool := dbpool.init('admin', 'geodb', 'password') or { panic(err) }
	pool.init_mysql() or { panic(err) }
	mut service_layer := ServiceLayer{
		pool: pool
	}
	return service_layer
}

pub fn (mut sl ServiceLayer) destroy_handler(sig os.Signal) {
	println('shutting down ...')
	sl.pool.disconnect() or { panic(err) }
	println('done!')
	exit(0)
}

fn main() {
	println('Hello World!')
	mut sl := new_service_layer()
	os.signal_opt(os.Signal.term, sl.destroy_handler)!
	os.signal_opt(os.Signal.int, sl.destroy_handler)!
	mut running := true
	for running {
		time.sleep(1 * time.second)
		println('-------------------------------------------------------------------------')
		// mut all_techs := sl.pool.get_technologies()

		// TODO refactor to
		// select bx.id,bx.json as drawable_json,m.json as metadata_json,CONCAT('[',h.path,']') as path_json from
		// 		from BOXES bx,
		// 		left outer METADATA m on m.id=bx.id
		//    	inner join V_HIERARCHY h on h.id=m.id
		// mut all_entities := app.pool.get_all_entities()
		mut records := sl.pool.get_all_metadatas() or { panic(err) }
		mut record_index := map[string]adapter.MetadataRecord{}
		/// mut jsc := compilers.JsNodeCompiler{}
		/// println(jsc)
		println('--- indexing -------------------------------------------------------')
		for em in records {
			record_index[em.id] = em
			match em.drawable.ent_type {
				'Drawable' {
					println('indexing ${em.drawable.ent_type:10} ${em.drawable.name:20} ${em.metadata.technology.compiler_id():30} ${em.hierarchy}')
				}
				'Link' {
					println('indexing ${em.drawable.ent_type:10} ${em.drawable.name:20} ${em.metadata.technology.compiler_id():30} ${em.drawable.source.ref} ${em.drawable.destination.ref}')
				}
				else {
					println('unknown ent type : ${em.drawable.id}')
				}
			}
		}
		os.rmdir_all('compiled') or {}
		os.mkdir('compiled') or {}
		println('--- precompiled entities ------------------------------------------')
		mut pces := []adapter.PrecompiledEntity{}
		for em in records {
			pces << em.precompile(record_index)
		}
		utils.array_sort_by[adapter.PrecompiledEntity](mut pces, fn (x adapter.PrecompiledEntity) string {
			return x.fully_qualified_name('.')
		})
		// pces.sort(a.fully_qualified_name(".") < b.fully_qualified_name(".") )
		for pce in pces {
			println('${pce.fully_qualified_name('.'):80} ${pce.ent_type:20} ${pce.kind:20}')
		}
		running = false
		sl.pool.db.close()

		println('finished')
	}
}
