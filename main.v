module main

import dbpool
import os
import time
import json
import geometry

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

struct EntMetadata {
pub mut:
	ent  geometry.Drawable
	meta geometry.EntityMetadata
	mr   geometry.MetadataRecord
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
		mut all_entities := app.pool.get_all_entities()
		mut all_entites_metadata := app.pool.get_all_metadatas()
		mut entities_with_metadata := all_entities.map(fn [all_entites_metadata] (ent geometry.Entity) EntMetadata {
			md := all_entites_metadata.filter(fn [ent] (em geometry.MetadataRecord) bool {
				return em.id == ent.id
			})
			if md.len > 0 {
				em := md[0]
				return EntMetadata{
					ent: json.decode(geometry.Drawable, ent.json) or {
						// panic("could not decode drawable ${ent.json}")
						geometry.Drawable{}
					}
					meta: json.decode(geometry.EntityMetadata, em.json) or {
						// panic("could not decode metadata ${em.json}")
						geometry.EntityMetadata{}
					}
					mr: em
				}
			} else {
				return EntMetadata{
					ent: json.decode(geometry.Drawable, ent.json) or {
						// panic("could not decode ${ent.json}")
						geometry.Drawable{}
					}
					meta: geometry.EntityMetadata{}
					mr: geometry.MetadataRecord{}
				}
			}
		})
		for em in entities_with_metadata {
			println('${em.ent.ent_type} ${em.ent.name} ${em.meta.technology}')
			match em.ent.ent_type {
				'Drawable' {
					println(em)
				}
				else {}
			}
		}
	}
}
