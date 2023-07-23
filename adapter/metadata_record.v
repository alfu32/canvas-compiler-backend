module adapter

import entities
import utils

pub struct Port {
	id         string
	kind       entities.EntityStereotype
	drawable   MetadataRecord
	link       MetadataRecord
	definition string
}

pub struct CompiledFile {
	path    string
	content string
}

pub struct PrecompiledEntity {
pub mut:
	ent_type    string
	entity_id   string
	internal_id string
	name        string
	path        []MetadataRecord
	content     string
	kind        entities.EntityStereotype
	tech        entities.TechnoLang
}

pub struct MetadataRecord {
pub mut:
	id          string
	drawable    entities.Drawable
	metadata    entities.EntityMetadata
	compiler_id string
	hierarchy   []string
}

pub fn (em MetadataRecord) get_local_hierarchy(index map[string]MetadataRecord) []MetadataRecord {
	mut local_hierarchy := em.hierarchy.map(fn [index] (id string) MetadataRecord {
		return index[id]
	})
	local_hierarchy.reverse_in_place()
	return local_hierarchy
}

pub fn (em MetadataRecord) get_partial_file_name(index map[string]MetadataRecord) string {
	return em.get_local_hierarchy(index).map(fn (mr MetadataRecord) string {
		return mr.drawable.name
	}).join('/')
}

pub fn (em MetadataRecord) get_partial_fq_name(index map[string]MetadataRecord) string {
	return em.get_local_hierarchy(index).map(fn (mr MetadataRecord) string {
		return mr.drawable.name
	}).join('../geometry')
}

pub fn (em MetadataRecord) precompile(index map[string]MetadataRecord) []PrecompiledEntity {
	match em.drawable.ent_type {
		'Link' {
			lnk := em.drawable
			source := index[lnk.source.ref]
			destination := index[lnk.destination.ref]

			path_nodes := path_between_nodes(index, source, destination)
			path_nodes_outgoing := path_nodes.filter(it.direction == .outgoing).map(index[it.mr.id])
			path_nodes_incoming := path_nodes.filter(it.direction == .incoming).map(index[it.mr.id])
			return [
				PrecompiledEntity{
					ent_type: em.drawable.ent_type
					entity_id: em.drawable.id
					internal_id: em.drawable.id
					name: em.drawable.name
					path: path_nodes_outgoing
					content: em.metadata.text
					kind: em.drawable.kind()
					tech: em.metadata.technology
				},
				PrecompiledEntity{
					ent_type: em.drawable.ent_type
					entity_id: em.drawable.id
					internal_id: em.drawable.id
					name: em.drawable.name
					path: path_nodes_incoming
					content: em.metadata.text
					kind: em.drawable.kind()
					tech: em.metadata.technology
				},
			]
		}
		else {
			local_hierarchy := em.get_local_hierarchy(index)
			mut pcent := [
				PrecompiledEntity{
					ent_type: em.drawable.ent_type
					entity_id: em.drawable.id
					internal_id: em.drawable.id
					name: em.drawable.name
					path: local_hierarchy
					content: em.metadata.text
					kind: em.drawable.kind()
					tech: em.metadata.technology
				},
			]
			pcent << em.get_ports(index).map(PrecompiledEntity{
				ent_type: 'Port'
				entity_id: '${em.drawable.id}-${it.id}'
				internal_id: '${em.drawable.id}-${it.id}'
				name: '${it.kind}--wip'
				path: local_hierarchy
				content: ''
				kind: it.kind
				tech: entities.TechnoLang{}
			})
			return pcent
		}
	}
}

struct ParentChildRelationship {
	id     string
	parent ?utils.Ref
}

struct LinkType {
	mr        MetadataRecord
	direction LinkDirection
}

enum LinkDirection {
	outgoing = 0x1101
	incoming
}

/// fn ancestry(nodes map[string]ParentChildRelationship, node_id string) []string {
/// 	root:=ParentChildRelationship{
/// 		id: ''
/// 		parent: none
/// 	}
/// 	mut a := []string{}
/// 	mut current_node := nodes[node_id]
/// 	for current_node != root {
/// 		a << current_node.id
/// 		match current_node.parent {
/// 			none {current_node = nodes[current_node.parent.ref?]}
/// 			else {
/// 				current_node = root
/// 			}
/// 		}
/// 	}
/// 	a << ""
/// 	return a
/// }

fn path_between_nodes(index map[string]MetadataRecord, source MetadataRecord, destination MetadataRecord) []LinkType {
	source_hierarchy := source.get_local_hierarchy(index) // ancestry(nodes, node1).filter(it != none)
	destination_hierarchy := destination.get_local_hierarchy(index) // ancestry(nodes, node2).filter(it != none)
	for ip, parent_source in source_hierarchy {
		for id, parent_destination in destination_hierarchy {
			if parent_source.id == parent_destination.id {
				mut traversals1 := source_hierarchy[0..ip].map(LinkType{
					mr: it
					direction: .outgoing
				})
				mut traversals2 := destination_hierarchy[0..id].map(LinkType{
					mr: it
					direction: .incoming
				})
				traversals2 = traversals2.reverse()
				traversals1 << traversals2
				return traversals1
			}
		}
	}
	// else if no common ancestor found
	mut traversals1 := source_hierarchy.map(LinkType{ mr: it, direction: .outgoing })
	mut traversals2 := destination_hierarchy.map(LinkType{ mr: it, direction: .incoming })
	traversals2 = traversals2.reverse()
	traversals1 << traversals2
	return traversals1
}

pub fn (link_em MetadataRecord) get_ports(index map[string]MetadataRecord) []Port {
	mut links := []LinkType{}
	links << link_em.drawable.incoming_links.map(fn [index] (r utils.Ref) LinkType {
		mut mm := LinkType{
			mr: index[r.ref]
			direction: .incoming
		}
		return mm
	})
	links << link_em.drawable.outgoing_links.map(fn [index] (r utils.Ref) LinkType {
		mut mm := LinkType{
			mr: index[r.ref]
			direction: .outgoing
		}
		return mm
	})
	ports := links.map(fn [index, link_em] (link_ref LinkType) Port {
		link := link_ref.mr
		kind := match link_ref.direction {
			.incoming { entities.EntityStereotype.input_port }
			.outgoing { entities.EntityStereotype.output_port }
		}
		drawable := match link_ref.direction {
			.incoming { index[link_ref.mr.drawable.destination.ref] }
			.outgoing { index[link_ref.mr.drawable.source.ref] }
		}
		port_hierarchy := link_em.get_local_hierarchy(index)
		return Port{
			kind: kind
			drawable: drawable
			link: link_em
			definition: link.metadata.text
		}
	})
	return ports
}

pub fn get_partial_file_name(path []MetadataRecord) string {
	return path.map(fn (mr MetadataRecord) string {
		return mr.drawable.name
	}).join('/')
}

pub fn get_partial_fq_name(path []MetadataRecord) string {
	return path.map(fn (mr MetadataRecord) string {
		return mr.drawable.name
	}).join('.')
}
