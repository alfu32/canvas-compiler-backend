module main

import dbpool
import os
import time
import adapter

[heap]
struct ServiceLayer {
pub mut:
	pool dbpool.DbPool
	///// compilers map[string]compilers.Compiler = {
	///// 	"jsc" : compilers.JsNodeCompiler{}
	///// }
}

fn new_service_layer() ServiceLayer {
	mut pool := dbpool.init('admin','geodb','password') or {
		panic(err)
	}
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
	mut running:=true
	for running{
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
		/// for em in records {
		/// 	println('${em.drawable.ent_type} ${em.drawable.name} ${em.metadata.technology}')
		/// 	println(em)
		/// 	record_index[em.id] = em
		/// }
		os.rmdir_all("compiled")or{}
		os.mkdir("compiled")or{}
		for em in records {
			match em.drawable.ent_type {
				'Drawable' {
					mut local_hierarchy := em.hierarchy.map(fn [record_index] (id string) adapter.MetadataRecord {
						return record_index[id]
					})
					local_hierarchy.reverse_in_place()
					/// println(local_hierarchy.map(it.drawable.name).join('/'))
					/// fq_name:=jsc.get_fq_name(local_hierarchy)
					/// file_name:=jsc.get_file_name(local_hierarchy)
					/// compiled_content:=jsc.get_compiled_content(em,record_index)

					/// os.write_file("compiled/${file_name}",compiled_content)or{
					/// 	println(err)
					/// }

					/// println(fq_name)
					/// println(file_name)
					/// println(compiled_content)
				}
				else {}
			}
		}
		running=false
		sl.pool.db.close()

		println("finished")

	}
}
