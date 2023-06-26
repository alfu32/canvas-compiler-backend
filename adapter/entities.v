module adapter

import alfu32.geometry

pub struct CompiledFile{
	path string
	content string
}
pub struct PrecompiledEntity{
	entity_id string
	internal_id string
	name string
	full_name string
	path string[]
	id_path string[]
	content string
	kind string
	tech TechnoLang
}
