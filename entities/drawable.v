module entities

import alfu32.geometry
import utils

pub struct Drawable {
pub mut:
	ent_type                  string = 'Drawable'
	name                      string = 'TRANSFORM'
	id                        string
	anchor                    geometry.Point
	size                      geometry.Point
	rotation                  f64
	parent                    ?utils.Ref
	is_open                   bool  = true
	children                  []utils.Ref = []
	outgoing_links            []utils.Ref          [json: outgoingLinks] = []
	incoming_links            []utils.Ref          [json: incomingLinks] = []
	outgoing_traversing_links []utils.Ref          [json: outgoingTraversingLinks] = []
	incoming_traversing_links []utils.Ref          [json: incomingTraversingLinks] = []
}

pub fn (this Drawable) kind() EntityStereotype {
	if this.children.len > 0 {
		if utils.starts_or_ends_with(this.name,'error') {
			return .composite_error_handler
		} else if utils.starts_or_ends_with(this.name,'test') {
			return .test_suite
		} else {
			return .composite_worker
		}
	} else if utils.starts_or_ends_with_any_of(this.name,'service', 'client', 'service', 'library',
		'lib')
	{
		return .service_library
	} else if utils.starts_or_ends_with(this.name,'error') {
		return .error_handler
	} else if utils.starts_or_ends_with(this.name,'test') {
		return .test
	} else {
		if this.incoming_links.len > 0 && this.outgoing_links.len > 0 {
			return .transformer
		} else if this.incoming_links.len == 0 && this.outgoing_links.len > 0 {
			return .generator
		} else if this.incoming_links.len > 0 && this.outgoing_links.len == 0 {
			return .sink
		} else {
			return .script
		}
	}
}
