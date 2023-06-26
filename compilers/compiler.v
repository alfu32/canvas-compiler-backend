module compilers

import entities
import utils

pub struct Port {
	id         string
	kind       string
	fqname     string
	name       string
	definition string
}

pub struct Compiler {
mut:
	id string
}

pub fn get_local_hierarchy(em entities.MetadataRecord, index map[string]entities.MetadataRecord) []entities.MetadataRecord {
	mut local_hierarchy := em.hierarchy.map(fn [index] (id string) entities.MetadataRecord {
		return index[id]
	})
	local_hierarchy.reverse_in_place()
	return local_hierarchy
}

pub fn get_partial_file_name(path []entities.MetadataRecord) string {
	return path.map(fn(mr entities.MetadataRecord) string {return mr.drawable.name}).join('/')
}

pub fn get_partial_fq_name(path []entities.MetadataRecord) string {
	return path.map(fn(mr entities.MetadataRecord) string {return mr.drawable.name}).join('.')
}

pub fn get_ports(link_em entities.MetadataRecord, index map[string]entities.MetadataRecord) []Port {
	mut links := []map[string]string{}
	links << link_em.drawable.incoming_links.map(fn(r utils.Ref) map[string]string {
		mut mm := map[string]string{}
			mm["ref"]=r.ref
			mm["dir"]="in"
		return mm
	})
	links << link_em.drawable.outgoing_links.map(fn(r utils.Ref) map[string]string {
		mut mm := map[string]string{}
		mm["ref"]=r.ref
		mm["dir"]="out"
		return mm
	})
	ports := links.map(fn [index] (link_ref map[string]string) Port {
		link := index[link_ref["ref"]]
		kind := link_ref["dir"]
		port_hierarchy := get_local_hierarchy(link, index)
		return Port{
			id: link_ref["ref"]
			kind: link_ref["kind"]
			fqname: "port_${kind}__${get_partial_fq_name(port_hierarchy).to_lower()}"
			name: "port_${kind}__${link.drawable.name.to_lower()}"
			definition: link.metadata.text
		}
	})
	return ports
}
