module dbpool

import geometry
import json
import math
import db.mysql

pub struct SqliteResultCode {
	code  i64
	short string
	long  string
}

struct SelectResult[K] {
	rows        []K
	result_code SqliteResultCode
}

pub struct DbPool {
pub mut:
	username string = 'admin'
	dbname   string = 'geodb'
	password string = 'password'
}

pub fn (mut s DbPool) init_mysql() ! {
	println('init database ${s}')
}

pub fn (mut s DbPool) disconnect() ! {
	println('closed database ${s}')
}

struct GenericRow {
	vals []string
}

fn (mut s DbPool) mysql_exec(q string) ! {
	mut con := mysql.connect(mysql.Config{
		username: s.username
		dbname: s.dbname
		password: s.password
	}) or { panic('could not connect to ${s} ') }
	con.query(q) or { panic(err) }
	con.close()
}

fn (mut s DbPool) mysql_query(q string) !SelectResult[GenericRow] {
	mut con := mysql.connect(mysql.Config{
		username: s.username
		dbname: s.dbname
		password: s.password
	}) or { panic('could not connect to ${s} ') }
	rv := con.query(q) or { panic(err) }
	mut rows := []GenericRow{}
	for r in rv.rows() {
		rows << GenericRow{
			vals: r.vals.map(it.str())
		}
	}
	con.close()
	return SelectResult[GenericRow]{rows, SqliteResultCode{
		code: 101
		short: 'dummy mysql result'
		long: 'dummy mysql result'
	}}
}

pub fn (mut s DbPool) get_all_entities() []geometry.Entity {
	q := '
		SELECT id,ent_type,json,x0,y0,x1,y1,visible_size
		FROM BOXES
	'.trim_indent()
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) geometry.Entity {
		return geometry.Entity{
			id: r.vals[0]
			ent_type: r.vals[1]
			json: r.vals[2]
		}
	})
}

pub fn (mut s DbPool) get_all_metadatas() []geometry.MetadataRecord {
	// TODO refactor to
	// select bx.id,bx.json as drawable_json,m.json as metadata_json,CONCAT('[',h.path,']') as path_json from
	// 		from BOXES bx,
	// 		left outer METADATA m on m.id=bx.id
	//    	inner join V_HIERARCHY h on h.id=m.id
	q := "
		select m.id,m.json,CONCAT('[',h.path,']') as path_json from METADATA m
		inner join V_HIERARCHY h on h.id=m.id
	".trim_indent()
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) geometry.MetadataRecord {
		return geometry.MetadataRecord{
			id: r.vals[0]
			json: r.vals[1]
			path: json.decode([]string, r.vals[2]) or { []string{} }
		}
	})
}

pub fn (mut s DbPool) get_entities_inside_box(box geometry.Box) []geometry.Entity {
	x0 := box.anchor.x
	x1 := box.corner().x
	y0 := box.anchor.y
	y1 := box.corner().y
	szx := box.size.x
	szy := box.size.y
	q := "
		WITH DRAWABLES AS (
			SELECT
				id,
				ent_type,
				json,
				x0,
				y0,
				x1,
				y1,
				visible_size
			from BOXES
			WHERE ST_INTERSECTS(get_box(${x0},${y0},${szx},${szy}),get_box_from_json(json))
			OR ST_CONTAINS(get_box(${x0},${y0},${szx},${szy}),get_box_from_json(json))
			or box_intersects_box(x0,y0,x1,y1,${x0},${y0},${x1},${y1})
			AND ent_type!='Link'
		)
		SELECT * from drawables
		UNION ALL
		SELECT
			id,
			ent_type,
			json,
			x0,
			y0,
			x1,
			y1,
			visible_size

		from BOXES
		WHERE ent_type='Link'
		AND (
			JSON_VALUE(json,'$.source.ref') IN (SELECT ID FROM DRAWABLES)
			or
			JSON_VALUE(json,'$.destination.ref') IN (SELECT ID FROM DRAWABLES)
		)
	".trim_indent()
	println(q)
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) geometry.Entity {
		return geometry.Entity{
			id: r.vals[0]
			ent_type: r.vals[1]
			json: r.vals[2]
		}
	})
}

pub fn (mut s DbPool) store_entities(es []geometry.Entity) ! {
	for ent in es {
		bx := json.decode(geometry.Box, ent.json) or {
			eprintln('could not decode ${ent.json}')
			panic(err)
		}
		x0 := bx.anchor.x
		y0 := bx.anchor.y
		x1 := bx.corner().x
		y1 := bx.corner().y
		vs := math.max[f64](x1 - x0, y1 - y0)
		q := "
	INSERT INTO BOXES(id,ent_type,json,x0,y0,x1,y1,visible_size)
		VALUES ('${ent.id}','${ent.ent_type}','${ent.json}',${x0},${y0},${x1},${y1},${vs})
	ON DUPLICATE KEY UPDATE
	    ent_type=VALUES(ent_type),
		json=VALUES(json),
		x0=VALUES(x0),
		y0=VALUES(y0),
		x1=VALUES(x1),
		y1=VALUES(y1),
		visible_size=VALUES(visible_size)
			".trim_indent()
		println(q)
		s.mysql_exec(q) or {
			eprint(q)
			panic(err)
		}
	}
}

pub fn (mut s DbPool) get_metadatas_by_ids(id_list []string) []geometry.Entity {
	placeholder_id := '########-####-####-####-############'
	placeholder_ent_type := '$$$$$$$$-$$$$-$$$$-$$$$-$$$$$$$$$$$$'
	default_metadata := json.encode(geometry.EntityMetadata{
		id: placeholder_id
		ent_type: placeholder_ent_type
	})
	ids := id_list.map("'${it}'").join(',')
	q := "
		SELECT
		    bx.id,
		    bx.ent_type,
		    NVL(
		    	REPLACE(mdt.json,'\n','\\\\n'),
		    	REPLACE(
		    		REPLACE(
		    			'${default_metadata}',
		    			'${placeholder_id}',
		    			bx.id
		    		),
		    		'${placeholder_ent_type}',
		    		bx.ent_type
		    	)
		    ) as json
		FROM BOXES bx
		LEFT JOIN METADATA mdt on bx.id=mdt.id
		WHERE bx.id in (${ids})
	".trim_indent()
	println(q)
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) geometry.Entity {
		return geometry.Entity{
			id: r.vals[0]
			ent_type: r.vals[1]
			json: r.vals[2]
		}
	})
}

pub fn (mut s DbPool) get_languages() []string {
	q := '
		SELECT
		    distinct langid
		FROM TECHNOLANG
	'.trim_indent()
	println(q)
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) string {
		return r.vals[0]
	})
}

pub fn (mut s DbPool) get_technologies_for_language(lang string) []geometry.TechnoLang {
	q := "
		SELECT
		    technoid,langid
		FROM TECHNOLANG
		WHERE langid = '${lang}'
	".trim_indent()
	println(q)
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) geometry.TechnoLang {
		return geometry.TechnoLang{
			technoid: r.vals[0]
			langid: r.vals[1]
		}
	})
}

pub fn (mut s DbPool) get_technologies() []geometry.TechnoLang {
	q := '
		SELECT
		    technoid,langid
		FROM TECHNOLANG
	'.trim_indent()
	println(q)
	r := s.mysql_query(q) or { panic(err) }
	return r.rows.map(fn (r GenericRow) geometry.TechnoLang {
		return geometry.TechnoLang{
			technoid: r.vals[0]
			langid: r.vals[1]
		}
	})
}

pub fn (mut s DbPool) remove_entities(id_list []string) []string {
	ids := id_list.map("'${it}'").join(',')
	mut q := '
		DELETE FROM BOXES WHERE id in (${ids})
	'.trim_indent()
	s.mysql_exec(q) or {
		println(q)
		panic(err)
	}
	q = '
		DELETE FROM METADATA WHERE id in (${ids})
	'.trim_indent()
	s.mysql_exec(q) or {
		println(q)
		panic(err)
	}
	return id_list
}

pub fn (mut s DbPool) store_metadatas(id string, data string) ! {
	escaped_data := data.replace("'", "''")
	mut q := "
		INSERT INTO METADATA(id,json)
		VALUES (
			'${id}',
			'${escaped_data}'
		)
		ON DUPLICATE KEY UPDATE
		json=VALUES(json)
	".trim_indent()
	println('Storing metadata using query \n ${q}')
	s.mysql_exec(q) or { panic(err) }
}
