module entities

import alfu32.geometry

pub struct Ref {
pub mut:
	ref string
}

pub struct Drawable {
pub mut:
	ent_type                  string = 'Drawable'
	name                      string = 'TRANSFORM'
	id                        string
	anchor                    geometry.Point
	size                      geometry.Point
	rotation                  f64
	parent                    ?Ref
	is_open                   bool  = true
	children                  []Ref = []
	outgoing_links            []Ref  [json: outgoingLinks] = []
	incoming_links            []Ref  [json: incomingLinks] = []
	outgoing_traversing_links []Ref  [json: outgoingTraversingLinks] = []
	incoming_traversing_links []Ref  [json: incomingTraversingLinks] = []
}
