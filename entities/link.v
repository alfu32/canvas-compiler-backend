module entities

import alfu32.geometry
import utils
import modelstore


pub struct Link {
	Drawable
	pub mut:
	model_store               ?&modelstore.ModelStore[Drawable]
	ent_type                  string = 'Link'
	name                      string = 'LINK'
	id                        string
	anchor                    geometry.Point
	size                      geometry.Point
	rotation                  f64
	parent                    ?utils.Ref
	is_open                   bool = true
	source                    ?utils.Ref
	destination               ?utils.Ref
	children                  []utils.Ref = []
	outgoing_links            []utils.Ref          [json: outgoingLinks] = []
	incoming_links            []utils.Ref          [json: incomingLinks] = []
	outgoing_traversing_links []utils.Ref          [json: outgoingTraversingLinks] = []
	incoming_traversing_links []utils.Ref          [json: incomingTraversingLinks] = []
}

pub fn (this Link) kind()  EntityStereotype {
	if utils.starts_or_ends_with(this.name,"error") {
		return .error_pipe
	}
	//// important to implement !!!
	if this.model_store!=none {
		source:=this.model_store.get_by_ref[Drawable](this.source)
		if source != none {
			if source.kind()==.service_library {
				return .dependency_injection
			}
		}
	}
	return .transport
}
