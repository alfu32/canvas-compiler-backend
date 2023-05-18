module geometry

import json

pub struct Entity {
pub mut:
	id       string
	ent_type string
	json     string
}

pub struct EntityMetadata {
	id           string
	ent_type     string
	technology   TechnoLang = new_technolang()
	content_type string     = 'application/javascript'
	text         string     = ''
	tag          string     = 'code'
}

pub fn new_metadata(id string) EntityMetadata {
	return EntityMetadata{
		id: id
	}
}

pub fn from_json(j string) !Entity {
	mut e := json.decode(Entity, j) or { panic(err) }
	e.json = j
	return e
}

pub fn entity_from_json_array(json_string string) ![]Entity {
	if json_string == '' {
		return []
	}
	entities := json.decode([]Entity, json_string) or {
		panic('could not decode (((${json_string})))')
	}
	return entities
}

pub fn (e Entity) get_box() !Box {
	return json.decode(Box, e.json)
}
