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
	s.mysql_exec('
		CREATE TABLE IF NOT EXISTS BOXES(
			id VARCHAR(40) PRIMARY KEY UNIQUE NOT NULL,
			ent_type VARCHAR(40),
			json VARCHAR(4000),
			x0 DOUBLE,
			y0 DOUBLE,
			x1 DOUBLE,
			y1 DOUBLE,
			visible_size DOUBLE
		)
	'.trim_indent()) or {
		panic(err)
	}
	s.mysql_exec('
		CREATE TABLE IF NOT EXISTS METADATA(
			id VARCHAR(40) PRIMARY KEY UNIQUE NOT NULL,
			json VARCHAR(4000)
		)
	'.trim_indent()) or {
		panic(err)
	}
	s.mysql_exec('
		create TABLE IF NOT EXISTS TECHNOLANG(
			technoid VARCHAR(40),
			langid VARCHAR(40)
		);
	'.trim_indent()) or {
		panic(err)
	}
	s.mysql_exec('
		create or replace function box_contains_point(
			px decimal(15),py decimal(15),
			bx0 decimal(15), by0 decimal(15), bx1 decimal(15), by1 decimal(15)
		) returns tinyint(1)
		BEGIN
			return px>=bx0 and px<=bx1 AND py>=by0 and py<=by1;
		END;
	'.trim_indent()) or {
		panic(err)
	}
	s.mysql_exec("
		create or replace function get_box(
			ax NUMERIC(15),
			ay NUMERIC(15),
			szx NUMERIC(15),
			szy NUMERIC(15)
		) RETURNS GEOMETRY
		BEGIN
			return ST_POLYGONFROMTEXT(CONCAT(
					'POLYGON((',
					ax,' ',ay,',',
					ax+szx,' ',ay,',',
					ax+szx,' ',ay+szy,',',
					ax,' ',ay+szy,',',
					ax,' ',ay,'',
					'))'));
		END;
	".trim_indent()) or {
		panic(err)
	}
	s.mysql_exec('
		create or replace function box_intersects_box(
			ax0 decimal(15), ay0 decimal(15), ax1 decimal(15), ay1 decimal(15),
			bx0 decimal(15), by0 decimal(15), bx1 decimal(15), by1 decimal(15)
		) returns tinyint(1)
		BEGIN
			return box_contains_point(ax0,ay0, bx0,by0,bx1,by1)
				OR box_contains_point(ax0,ay1, bx0,by0,bx1,by1)
				OR box_contains_point(ax1,ay1, bx0,by0,bx1,by1)
				OR box_contains_point(ax1,ay0, bx0,by0,bx1,by1)
				OR box_contains_point(bx0,by0, ax0,ay0,ax1,ay1)
				OR box_contains_point(bx0,by1, ax0,ay0,ax1,ay1)
				OR box_contains_point(bx1,by1, ax0,ay0,ax1,ay1)
				OR box_contains_point(bx1,by0, ax0,ay0,ax1,ay1)
				or (
					ax0<=bx0 AND ax1 >=bx1 AND (
						ay0 >= by0 AND ay0<=by1
						or
						ay1 >= by0 AND ay1<=by1
					)
				)
				or (
					   ay0<=by0 AND ay1 >=by1 AND (
							   ax0 >= bx0 AND ax0<=bx1
					   or
							   ax1 >= bx0 AND ax1<=bx1
				   )
			   );
		END;
	'.trim_indent()) or {
		panic(err)
	}
	s.mysql_exec("
		create or replace function get_box_from_json(
			json VARCHAR(4000))
			RETURNS GEOMETRY
		BEGIN
			DECLARE ax NUMERIC(15);
			DECLARE ay NUMERIC(15);
			DECLARE szx NUMERIC(15);
			DECLARE szy NUMERIC(15);
			DECLARE boxtype VARCHAR(50);
			SELECT JSON_VALUE(json,'$.ent_type') INTO boxtype;
			SELECT JSON_VALUE(json,'$.anchor.x') INTO ax;
			SELECT JSON_VALUE(json,'$.anchor.y') INTO ay;
			SELECT JSON_VALUE(json,'$.size.x') INTO szx;
			SELECT JSON_VALUE(json,'$.size.y') INTO szy;
			return get_box(ax,ay,szx,szy);
		END;
	".trim_indent()) or {
		panic(err)
	}
	s.mysql_exec('
		create or replace procedure store_box(
			ent_id VARCHAR(40),
			ent_ent_type VARCHAR(40),
			ent_json VARCHAR(4000),
			ent_x0 DOUBLE,
			ent_y0 DOUBLE,
			ent_x1 DOUBLE,
			ent_y1 DOUBLE,
			ent_visible_size DOUBLE
		)
		BEGIN
			DELETE FROM BOXES WHERE ID=ent_id;
			COMMIT;
			INSERT INTO BOXES(id,ent_type,json,x0,y0,x1,y1,visible_size)
				VALUES (ent_id,ent_ent_type,ent_json,ent_x0,ent_y0,ent_x1,ent_y1,ent_visible_size);
			COMMIT;
		end;
	'.trim_indent()) or {
		panic(err)
	}
}

pub fn (mut s DbPool) disconnect() ! {
	println('closed database ${s}')
}

struct GenericRow {
	vals []string
}

fn (mut s DbPool) mysql_exec(q string) ! {
	mut con := mysql.Connection{
		username: s.username
		dbname: s.dbname
		password: s.password
	}
	con.connect() or { panic('could not connect to ${s} ') }
	con.query(q) or { panic(err) }
	con.close()
}

fn (mut s DbPool) mysql_query(q string) !SelectResult[GenericRow] {
	mut con := mysql.Connection{
		username: s.username
		dbname: s.dbname
		password: s.password
	}
	con.connect() or { panic('could not connect to ${s} ') }
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
