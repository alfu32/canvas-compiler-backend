module adapter

import entities

pub struct PrecompiledEntity {
pub mut:
	ent_type    string
	entity_id   string
	internal_id string
	name        string
	path        []MetadataRecord
	link 		?MetadataRecord
	content     string
	kind        entities.EntityStereotype
	tech        entities.TechnoLang
}

pub fn (pce PrecompiledEntity) fully_qualified_name(delim string) string {
	return '${pce.path.map(it.drawable.name).join(delim)}${delim}${pce.name}'
}
