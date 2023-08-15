module entities

import alfu32.geometry
import utils
import modelstore

pub struct Drawable {
pub mut:
	model_store modelstore.ModelStore[Drawable]
	ent_type                  string = 'Drawable'
	name                      string = 'TRANSFORM'
	id                        string
	anchor                    geometry.Point
	size                      geometry.Point
	rotation                  f64
	parent                    utils.Ref = utils.Ref{ref:'root'}
	is_open                   bool  = true
	children                  []utils.Ref = []
	outgoing_links            []utils.Ref          [json: outgoingLinks] = []
	incoming_links            []utils.Ref          [json: incomingLinks] = []
	outgoing_traversing_links []utils.Ref          [json: outgoingTraversingLinks] = []
	incoming_traversing_links []utils.Ref          [json: incomingTraversingLinks] = []
	source                    utils.Ref = utils.Ref{ref:'root'}
	destination               utils.Ref = utils.Ref{ref:'root'}
}

pub fn (dw Drawable) kind() EntityStereotype {
	/// println(typeof(dw).name)
	/// unsafe {
	/// 	if typeof(dw).name == 'nil' {
	/// 		return EntityStereotype.transformer
	/// 	}
	/// }
	/// println("drawable.kind :: [${dw.ent_type}]" )
	if dw.ent_type == 'NIL' {
		return EntityStereotype.unknown
	}
	return if dw.name.len ==  0 {
		if dw.ent_type == "Drawable" {
			if dw.children.len > 0 {
				EntityStereotype.composite_worker
			} else {
				if dw.incoming_links.len > 0 && dw.outgoing_links.len > 0 {
					EntityStereotype.transformer
				} else if dw.incoming_links.len == 0 && dw.outgoing_links.len > 0 {
					EntityStereotype.generator
				} else if dw.incoming_links.len > 0 && dw.outgoing_links.len == 0 {
					EntityStereotype.sink
				} else {
					EntityStereotype.script
				}
			}
		} else {
			match dw.model_store.get_by_ref[Drawable](dw.source).kind() {
				.service_library {
					EntityStereotype.dependency_injection
				}
				.unknown {
					EntityStereotype.unknown
				}
				else {
					EntityStereotype.transport
				}
			}
		}
	} else if dw.ent_type.len==0 {
		EntityStereotype.transformer
	} else if dw.ent_type=="Drawable" {
		if dw.children.len > 0 {
			if utils.starts_or_ends_with(dw.name,'error') {
				EntityStereotype.composite_error_handler
			} else if utils.starts_or_ends_with(dw.name,'test') {
				EntityStereotype.test_suite
			} else {
				EntityStereotype.composite_worker
			}
		} else if utils.starts_or_ends_with_any_of(dw.name,'service', 'client', 'service', 'library',
			'lib') {
			EntityStereotype.service_library
		} else if utils.starts_or_ends_with(dw.name,'error') {
			EntityStereotype.error_handler
		} else if utils.starts_or_ends_with(dw.name,'test') {
			EntityStereotype.test
		} else {
			if dw.incoming_links.len > 0 && dw.outgoing_links.len > 0 {
				EntityStereotype.transformer
			} else if dw.incoming_links.len == 0 && dw.outgoing_links.len > 0 {
				EntityStereotype.generator
			} else if dw.incoming_links.len > 0 && dw.outgoing_links.len == 0 {
				EntityStereotype.sink
			} else {
				EntityStereotype.script
			}
		}
	} else {
		if utils.starts_or_ends_with(dw.name,"error") {
			EntityStereotype.error_pipe
		}else {
			match dw.model_store.get_by_ref[Drawable](dw.source).kind() {
				.service_library {
					EntityStereotype.dependency_injection
				}
				else {
					EntityStereotype.transport
				}
			}
		}
	}
}
