module dbpool

import geometry
import db.mysql

fn test_simple_sqlite() {
	mut s := DbPool{}
	println(s)
	s.mysql_exec('DROP table IF EXISTS test') or { panic(err) }
	s.mysql_exec('create table test(id varchar(255) primary key not null,data varchar(255))') or {
		panic(err)
	}
	s.mysql_exec("insert into test(id,data) values ('a','afdasdf asdfasdf asdfasdf ')") or {
		panic(err)
	}
	s.mysql_exec("insert into test(id,data) values ('b','afdasdf asdfasdf asdfasdf ')") or {
		panic(err)
	}
	mut rcode := s.mysql_query('select MAX(id) FROM BOXES;') or { panic(err) }
	id := rcode.rows[0].vals[0].u64()
	j := '{"id":${id + 1},"anchor":{"x":1,"y":-13},"size":{"x":10,"y":10}}'
	q := "
		INSERT INTO BOXES(id,ent_type,json,x0,y0,x1,y1,visible_size)
		VALUES ('${id + 1}','generic','${j}',1.0,-13.0,11.0,-3.0,10.0);
	"
	println('executing ${q}')
	s.mysql_exec(q)!
	println('${rcode}')
}

fn test_simple_mysql() {
	// Create connection
	mut connection := mysql.Connection{
		username: 'admin'
		dbname: 'geodb'
		password: 'password'
	}
	// Connect to server
	connection.connect() or { panic(err) }
	// Change the default database
	connection.select_db('geodb') or { panic(err) }
	// Do a query
	connection.query('drop table test') or { panic(err) }
	connection.query('create table test(id varchar(255) primary key not null,data varchar(255))') or {
		panic(err)
	}
	connection.query('DROP TABLE IF EXISTS BOXES') or { panic(err) }
	connection.query('
			CREATE TABLE IF NOT EXISTS BOXES(
				id VARCHAR(40) PRIMARY KEY NOT NULL,
				ent_type VARCHAR(40),
				json VARCHAR(4000),
				x0 DOUBLE,
				y0 DOUBLE,
				x1 DOUBLE,
				y1 DOUBLE,
				visible_size DOUBLE
			)
		') or {
		panic(err)
	}
	connection.query("insert into test(id,data) values ('a','afdasdf asdfasdf asdfasdf ')") or {
		panic(err)
	}
	connection.query("insert into test(id,data) values ('b','afdasdf asdfasdf asdfasdf ')") or {
		panic(err)
	}
	mut rcode := connection.query('select MAX(id) as mxid FROM BOXES') or { panic(err) }
	id := rcode.rows()[0].vals[0].u64()
	j := '{"id":${id + 1},"anchor":{"x":1,"y":-13},"size":{"x":10,"y":10}}'
	q := "
		INSERT INTO BOXES(id,ent_type,json,x0,y0,x1,y1,visible_size)
		VALUES ('${id + 1}','generic','${j}',1.0,-13.0,11.0,-3.0,10.0)
	"
	println('executing ${q}')
	rcode = connection.query(q) or { panic(err) }
	println('${rcode}')
	connection.close()
}

fn test_service() {
	mut s := DbPool{}
	mut rcode := s.mysql_query('select MAX(id) FROM BOXES;')!
	println('${rcode}')
	id := rcode.rows[0].vals[0].u64()
	j := '{"id":${id + 1},"anchor":{"x":1,"y":-13},"size":{"x":10,"y":10}}'
	s.store_entities([geometry.Entity{
		id: '${id + 1}'
		ent_type: 'Box'
		json: j
	}])!
}

fn test_techno_lang() {
	mut s := DbPool{}
	mut techlangs := s.get_technologies_for_language('javascript')
	println('${techlangs}')
	mut langs := s.get_languages()
	println('${langs}')
}
