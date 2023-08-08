module adapter

import entities
import utils
import arrays
import modelstore
import alfu32.geometry

pub struct Port {
	id         string
	kind       entities.EntityStereotype
	drawable   MetadataRecord
	link       MetadataRecord
	direction LinkDirection
	definition string
}

pub struct CompiledFile {
	path    string
	content string
}

pub struct MetadataRecord {
pub mut:
	id          string
	drawable    entities.Drawable
	metadata    entities.EntityMetadata
	compiler_id string
	hierarchy   []string
}

pub fn (mr MetadataRecord) get_local_hierarchy(index map[string]MetadataRecord) []MetadataRecord {
	mut local_hierarchy := mr.hierarchy.map(fn [index] (id string) MetadataRecord {
		return index[id]
	})
	local_hierarchy.reverse_in_place()
	return local_hierarchy
}

pub fn (mr MetadataRecord) get_partial_file_name(index map[string]MetadataRecord) string {
	return mr.get_local_hierarchy(index).map(fn (mr MetadataRecord) string {
		return mr.drawable.name
	}).join('/')
}

pub fn (mr MetadataRecord) get_partial_fq_name(index map[string]MetadataRecord) string {
	return mr.get_local_hierarchy(index).map(fn (mr MetadataRecord) string {
		return mr.drawable.name
	}).join('../geometry')
}

pub fn (mr MetadataRecord) precompile(index map[string]MetadataRecord) []PrecompiledEntity {
	match mr.drawable.ent_type {
		'Link' {
			lnk := mr.drawable
			source := index[lnk.source.ref]
			destination := index[lnk.destination.ref]

			path_nodes := path_between_nodes(index, source, destination)
			path_nodes_outgoing := path_nodes.filter(it.direction == .outgoing).map(index[it.mr.id])
			path_nodes_incoming := path_nodes.filter(it.direction == .incoming).map(index[it.mr.id])
			// f:=path_nodes_outgoing.last()
			// l:=path_nodes_incoming.first()
			// derive an entity for each node on the path
			return [
				PrecompiledEntity{
					ent_type: mr.drawable.ent_type
					entity_id: mr.drawable.id
					internal_id: mr.drawable.id
					name: '${source.drawable.name}_to_${destination.drawable.name}'
					path: path_nodes_outgoing
					link: mr
					content: mr.metadata.text
					kind: mr.drawable.kind()
					tech: mr.metadata.technology
				},
				PrecompiledEntity{
					ent_type: mr.drawable.ent_type
					entity_id: mr.drawable.id
					internal_id: mr.drawable.id
					name: '${source.drawable.name}_to_${destination.drawable.name}'
					path: path_nodes_incoming
					link: mr
					content: mr.metadata.text
					kind: mr.drawable.kind()
					tech: mr.metadata.technology
				},
			]
		}
		else {
			local_hierarchy := mr.get_local_hierarchy(index)
			mut pcent := [
				PrecompiledEntity{
					ent_type: mr.drawable.ent_type
					entity_id: mr.drawable.id
					internal_id: mr.drawable.id
					name: mr.drawable.name
					path: local_hierarchy
					link: none
					content: mr.metadata.text
					kind: mr.drawable.kind()
					tech: mr.metadata.technology
				},
			]
			mut ix := 0
			pcent << mr.get_ports(index).map(PrecompiledEntity{
				ent_type: "${it.link.drawable.kind()}"// if it.link.drawable.kind() == entities.EntityStereotype.dependency_injection { 'Dependency' } else { 'Port' }
				entity_id: '${mr.drawable.id}-${it.id}'
				internal_id: '${mr.drawable.id}-${it.id}'
				name: '${it.drawable.drawable.name}_${it.link.drawable.name}_${it.kind}'
				link: it.link
				path: local_hierarchy/*arrays.concat[MetadataRecord](local_hierarchy, MetadataRecord{
					id: ''
					drawable: entities.Drawable{
						ent_type: 'Port'
						name: '${it.drawable.drawable.name}_${it.link.drawable.name}_${it.kind}'
					}
					metadata: entities.EntityMetadata{
						ent_type: 'Port'
						technology: mr.metadata.technology
					}
				})*/
				content: ''
				kind: it.kind
				tech: mr.metadata.technology
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

pub fn (mr MetadataRecord) get_ports(index map[string]MetadataRecord) []Port {
	mut links := []LinkType{}
	links << mr.drawable.incoming_links.map(fn [index] (r utils.Ref) LinkType {
		mut mm := LinkType{
			mr: index[r.ref]
			direction: .incoming
		}
		return mm
	})
	links << mr.drawable.outgoing_links.map(fn [index] (r utils.Ref) LinkType {
		mut mm := LinkType{
			mr: index[r.ref]
			direction: .outgoing
		}
		return mm
	})
	ports := links.map(fn [index, mr] (link_ref LinkType) Port {
		link := link_ref.mr
		kind := match link_ref.direction {
			.incoming { entities.EntityStereotype.input_port }
			.outgoing { entities.EntityStereotype.output_port }
		}
		drawable := match link_ref.direction {
			.incoming { index[link_ref.mr.drawable.destination.ref] }
			.outgoing { index[link_ref.mr.drawable.source.ref] }
		}
		port_hierarchy := mr.get_local_hierarchy(index)
		return Port{
			kind: kind
			drawable: drawable
			link: mr
			direction: link_ref.direction
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
