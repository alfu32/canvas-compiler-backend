module entities

import json
import time

fn test_from_json_array_01(){
	json_string:='
	[
		{"id":"1180","ent_type":"Drawable","json":"{\\"id\\":\\"1180\\"}"},
		{"id":"2180","ent_type":"Drawable","json":"{\\"id\\":\\"2180\\"}"},
		{"id":"3180","ent_type":"Drawable","json":"{\\"id\\":\\"3180\\"}"},
		{"id":"4180","ent_type":"Drawable","json":"{\\"id\\":\\"4180\\"}"}
	]
	'.trim_indent()
	arr:=json.decode([]map[string]string,json_string) or {
		panic("could not decode $json_string")
	}
	println(arr)
}
fn test_from_json_array_02(){
	json_string:='
	[
		{"id":"1180","ent_type":"Drawable","json":"{\\"id\\":\\"1180\\",\\"anchor\\":{\\"x\\":100,\\"y\\":300,\\"z\\":0,\\"t\\":0}}"},
		{"id":"2180","ent_type":"Drawable","json":"{\\"id\\":\\"2180\\",\\"anchor\\":{\\"x\\":100,\\"y\\":300,\\"z\\":0,\\"t\\":0}}"},
		{"id":"3180","ent_type":"Drawable","json":"{\\"id\\":\\"3180\\",\\"anchor\\":{\\"x\\":100,\\"y\\":300,\\"z\\":0,\\"t\\":0}}"},
		{"id":"4180","ent_type":"Drawable","json":"{\\"id\\":\\"4180\\",\\"anchor\\":{\\"x\\":100,\\"y\\":300,\\"z\\":0,\\"t\\":0}}"}
	]
	'.trim_indent()
	arr:=json.decode([]map[string]string,json_string) or {
		panic("could not decode $json_string")
	}
	println(json_string)
}
pub type AnyJson =  string | time.Time | bool | f64 | map[string]string | []AnyJson
fn test_from_json_array_03(){
	json_string:='
	[
		{"id":"1180","ent_type":"Drawable","anchor":{"x":1100,"y":1300,"z":10,"t":1,"tag":"p10"},"size":{"x":1200,"y":1160,"z":10,"t":10,"tag":"sz1"},"parent":null,"children":[],"outgoingLinks":[{"ref":"1390"},{"ref":"1644"},{"ref":"1038"},{"ref":"1228"}],"incomingLinks":[{"ref":"1390"},{"ref":"1644"},{"ref":"1038"},{"ref":"1228"}],"ent_type":"Drawable"},
		{"id":"2180","ent_type":"Drawable","anchor":{"x":2100,"y":2300,"z":20,"t":2,"tag":"p20"},"size":{"x":2200,"y":2160,"z":20,"t":20,"tag":"sz2"},"parent":null,"children":[],"outgoingLinks":[{"ref":"2390"},{"ref":"2644"},{"ref":"2038"},{"ref":"2228"}],"incomingLinks":[{"ref":"2390"},{"ref":"2644"},{"ref":"2038"},{"ref":"2228"}],"ent_type":"Drawable"},
		{"id":"3180","ent_type":"Drawable","anchor":{"x":3100,"y":3300,"z":30,"t":3,"tag":"p30"},"size":{"x":3200,"y":3160,"z":30,"t":30,"tag":"sz3"},"parent":null,"children":[],"outgoingLinks":[{"ref":"3390"},{"ref":"3644"},{"ref":"3038"},{"ref":"3228"}],"incomingLinks":[{"ref":"3390"},{"ref":"3644"},{"ref":"3038"},{"ref":"3228"}],"ent_type":"Drawable"},
		{"id":"4180","ent_type":"Drawable","anchor":{"x":4100,"y":4300,"z":40,"t":4,"tag":"p40"},"size":{"x":4200,"y":4160,"z":40,"t":40,"tag":"sz4"},"parent":null,"children":[],"outgoingLinks":[{"ref":"4390"},{"ref":"4644"},{"ref":"4038"},{"ref":"4228"}],"incomingLinks":[{"ref":"4390"},{"ref":"4644"},{"ref":"4038"},{"ref":"4228"}],"ent_type":"Drawable"}
	]
	'.trim_indent()
	println(json_string)
	entities:=json.decode([]map[string]AnyJson,json_string) or {
		panic("could not decode $json_string")
	}
	.map[map[string]AnyJson,Entity](
		fn(js map[string]AnyJson) Entity {
			return Entity{
				id: json.encode(js['id'] or {''})
				ent_type: json.encode(js['ent_type'] or {''})
				json: json.encode(js)
			}
		}
	)
	println(entities)
}
