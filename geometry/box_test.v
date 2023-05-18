module geometry

import json
import time
import x.json2

fn test_box_create() {
	b := Box{Point{10, 20}, Point{100, 75}}
	println(b.string())
	assert b.anchor.x == 10
	assert b.anchor.y == 20
}

fn test_box_clone() {
	b := Box{Point{10, 20}, Point{100, 75}}
	mut g := b.clone()
	println(b.string())
	println(g.string())
	assert b.anchor.x == g.anchor.x
	assert b.anchor.y == g.anchor.y
}

fn test_box_corner() {
	b := Box{Point{10, 20}, Point{100, 75}}
	c := b.corner()
	println(b.string())
	println(c.string())
	assert b.anchor.x + b.size.x == c.x
	assert b.anchor.y + b.size.y == c.y
}

fn test_box_contains_point() {
	b := Box{Point{10, 20}, Point{100, 75}}
	a := b.anchor
	c := b.corner()
	pin := Point{11, 21}
	pout := Point{9, 19}
	assert b.contains_point(a)
	assert b.contains_point(c)
	assert b.contains_point(pin)
	assert !b.contains_point(pout)
}

fn test_box_contains_box() {
	b := Box{Point{10, 20}, Point{100, 75}}
	b2 := Box{Point{20, 20}, Point{10, 10}}
	assert b.contains_box(b2)
}

fn test_box_intersects_box() {
	b := Box{Point{10, 20}, Point{100, 75}}
	b2 := Box{Point{20, 20}, Point{10, 10}}
	b3 := Box{Point{0, 0}, Point{40, 50}}
	assert b.intersects_box(b2)
	assert b.intersects_box(b3)
}

fn test_box_corners() {
	b := Box{Point{10, 20}, Point{100, 75}}
	c := b.corners()
	assert c.len == 4
	println(c[0].string())
	println(c[1].string())
	println(c[2].string())
	println(c[3].string())
	assert c[0] == b.anchor
	assert c[1] == Point{10, 95}
	assert c[2] == b.corner()
	assert c[3] == Point{110, 20}
}

fn test_box_for_each_slice() {
	b := Box{Point{10, 20}, Point{100, 75}}
	println(b.string())
	mut count := 0

	for value in b.slices(20) {
		println('iter[]=[${value}]')
		count++
	}

	println(count)

	assert count == 40
}

fn test_box_all_slices() {
	bx := Box{Point{10, 20}, Point{100, 75}}
	println(bx.string())
	slices := bx.all_slices(20)

	println(slices)

	assert slices.len == 40
}

fn test_box_iterator() {
	bi := BoxIterator{
		start: Point{10, 20}
		end: Point{100, 75}
		step: Point{20, 20}
	}
	mut count := 0

	for value in bi {
		// println("iter[]=[${value}]")
		count++
	}

	println(count)

	assert count == 25
}

fn test_from_json_array_01() {
	json_string := '
	[
		{"id":"1180","ent_type":"Drawable","json":"{"id":"1180"}"},
		{"id":"2180","ent_type":"Drawable","json":"{"id":"2180"}"},
		{"id":"3180","ent_type":"Drawable","json":"{"id":"3180"}"},
		{"id":"4180","ent_type":"Drawable","json":"{"id":"4180"}"}
	]
	'.trim_indent()
	arr := json.decode([]map[string]string, json_string) or {
		panic('could not decode ${json_string}')
	}
	println(arr)
}

fn test_from_json_array_02() {
	json_string := '
	[
		{"id":"1180","ent_type":"Drawable","json":"{"id":"1180","anchor":{"x":100,"y":300,"z":0,"t":0}}"},
		{"id":"2180","ent_type":"Drawable","json":"{"id":"2180","anchor":{"x":100,"y":300,"z":0,"t":0}}"},
		{"id":"3180","ent_type":"Drawable","json":"{"id":"3180","anchor":{"x":100,"y":300,"z":0,"t":0}}"},
		{"id":"4180","ent_type":"Drawable","json":"{"id":"4180","anchor":{"x":100,"y":300,"z":0,"t":0}}"}
	]
	'.trim_indent()
	arr := json.decode([]map[string]string, json_string) or {
		panic('could not decode ${json_string}')
	}
	println(json_string)
}

pub type AnyJson = []AnyJson | bool | f64 | map[string]string | string | time.Time

fn test_from_json_array_03() {
	json_string := '
	[
		{"id":"1180","ent_type":"Drawable","anchor":{"x":1100,"y":1300,"z":10,"t":1,"tag":"p10"},"size":{"x":1200,"y":1160,"z":10,"t":10,"tag":"sz1"},"parent":null,"children":[],"outgoingLinks":[{"ref":"1390"},{"ref":"1644"},{"ref":"1038"},{"ref":"1228"}],"incomingLinks":[{"ref":"1390"},{"ref":"1644"},{"ref":"1038"},{"ref":"1228"}],"ent_type":"Drawable"},
		{"id":"2180","ent_type":"Drawable","anchor":{"x":2100,"y":2300,"z":20,"t":2,"tag":"p20"},"size":{"x":2200,"y":2160,"z":20,"t":20,"tag":"sz2"},"parent":null,"children":[],"outgoingLinks":[{"ref":"2390"},{"ref":"2644"},{"ref":"2038"},{"ref":"2228"}],"incomingLinks":[{"ref":"2390"},{"ref":"2644"},{"ref":"2038"},{"ref":"2228"}],"ent_type":"Drawable"},
		{"id":"3180","ent_type":"Drawable","anchor":{"x":3100,"y":3300,"z":30,"t":3,"tag":"p30"},"size":{"x":3200,"y":3160,"z":30,"t":30,"tag":"sz3"},"parent":null,"children":[],"outgoingLinks":[{"ref":"3390"},{"ref":"3644"},{"ref":"3038"},{"ref":"3228"}],"incomingLinks":[{"ref":"3390"},{"ref":"3644"},{"ref":"3038"},{"ref":"3228"}],"ent_type":"Drawable"},
		{"id":"4180","ent_type":"Drawable","anchor":{"x":4100,"y":4300,"z":40,"t":4,"tag":"p40"},"size":{"x":4200,"y":4160,"z":40,"t":40,"tag":"sz4"},"parent":null,"children":[],"outgoingLinks":[{"ref":"4390"},{"ref":"4644"},{"ref":"4038"},{"ref":"4228"}],"incomingLinks":[{"ref":"4390"},{"ref":"4644"},{"ref":"4038"},{"ref":"4228"}],"ent_type":"Drawable"}
	]
	'.trim_indent()
	println(json_string)
	entities := json.decode([]map[string]AnyJson, json_string) or {
		panic('could not decode ${json_string}')
	}
		.map[map[string]AnyJson, Entity](fn (js map[string]AnyJson) Entity {
			return Entity{
				id: json.encode(js['id'] or { '' })
				ent_type: json.encode(js['ent_type'] or { '' })
				json: json.encode(js)
			}
		})
	println(entities)
}
