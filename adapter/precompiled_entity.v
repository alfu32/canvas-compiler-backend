module adapter

import entities

pub struct PrecompiledEntity {
pub mut:
	ent_type     string
	entity_id    string
	internal_id  string
	name         string
	path         []MetadataRecord
	link         ?MetadataRecord
	content      string
	kind         entities.EntityStereotype
	tech         entities.TechnoLang
	dependencies []PrecompiledEntity
}

pub fn (pce PrecompiledEntity) fully_qualified_name(delim string) string {
	return '${pce.path.map(it.drawable.name).join(delim)}${delim}${pce.name}'
}

pub fn (pce PrecompiledEntity) get_dependencies(fullFirstPassList []PrecompiledEntity) []PrecompiledEntity {
	if pce.kind == .input_port || pce.kind == .output_port || pce.link == none {
		return []PrecompiledEntity{} // return empty list if there is no link
	} else {
		link_id := (pce.link!).id
		mut dependencies := fullFirstPassList.filter(fn [link_id] (entity PrecompiledEntity) bool {
			return !(entity.link == none) && (entity.link!).id == link_id
		})
		return dependencies
	}
}
