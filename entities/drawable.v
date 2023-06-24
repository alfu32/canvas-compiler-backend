module entities

import alfu32.geometry

pub struct Ref {
pub mut:
	ref string
}

pub interface IDrawable {
	ent_type string
	name string
	id string
	anchor geometry.Point
	size geometry.Point
	rotation f64
	parent ?Ref
	is_open bool
	children []Ref
	outgoing_links []Ref
	incoming_links []Ref
	outgoing_traversing_links []Ref
	incoming_traversing_links []Ref
}

pub struct Drawable {
	IDrawable
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
	outgoing_links            []Ref          [json: outgoingLinks] = []
	incoming_links            []Ref          [json: incomingLinks] = []
	outgoing_traversing_links []Ref          [json: outgoingTraversingLinks] = []
	incoming_traversing_links []Ref          [json: incomingTraversingLinks] = []
}

pub struct Link {
	IDrawable
pub mut:
	ent_type                  string = 'Link'
	name                      string = 'LINK'
	id                        string
	anchor                    geometry.Point
	size                      geometry.Point
	rotation                  f64
	parent                    ?Ref
	is_open                   bool = true
	source                    ?Ref
	destination               ?Ref
	children                  []Ref = []
	outgoing_links            []Ref          [json: outgoingLinks] = []
	incoming_links            []Ref          [json: incomingLinks] = []
	outgoing_traversing_links []Ref          [json: outgoingTraversingLinks] = []
	incoming_traversing_links []Ref          [json: incomingTraversingLinks] = []
}
