module compilers

import geometry
import arrays

pub struct Port {
	id         string
	fqname     string
	name       string
	definition string
}

pub interface Compiler {
mut:
	id string
	get_file_name(path []geometry.MetadataRecord) string
	get_fq_name(path []geometry.MetadataRecord) string
	get_compiled_content(em geometry.MetadataRecord, index map[string]geometry.MetadataRecord) string
}

pub fn get_local_hierarchy(em geometry.MetadataRecord, index map[string]geometry.MetadataRecord) []geometry.MetadataRecord {
	mut local_hierarchy := em.hierarchy.map(fn [index] (id string) geometry.MetadataRecord {
		return index[id]
	})
	local_hierarchy.reverse_in_place()
	return local_hierarchy
}

pub fn get_partial_file_name(path []geometry.MetadataRecord) string {
	return path.map(it.drawable.name).join('/')
}

pub fn get_partial_fq_name(path []geometry.MetadataRecord) string {
	return path.map(it.drawable.name).join('.')
}

pub fn get_ports(link_em geometry.MetadataRecord, index map[string]geometry.MetadataRecord) []Port {
	ports := arrays.concat(link_em.drawable.incoming_links, ...link_em.drawable.outgoing_links).map(fn [index] (linkref geometry.Ref) Port {
		link := index[linkref.ref]
		port_hierarchy := get_local_hierarchy(link, index)
		return Port{
			id: linkref.ref
			fqname: get_partial_fq_name(port_hierarchy)
			name: link.drawable.name
			definition: link.metadata.text
		}
	})
	return ports
}
