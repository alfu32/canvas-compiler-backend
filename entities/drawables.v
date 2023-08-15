module entities

import alfu32.geometry
import utils

pub enum EntityStereotype {
	unknown = 0x100
	composite_worker=0x101            // ="composite-worker"
	composite_error_handler     // ="composite-error-handler"
	generator                   // ="generator"
	transformer                 // ="transformer"
	sink                        // ="sink"
	script                      // ="script"
	error_handler               // ="error-handler"
	service_library             // ="service-library"
	transport                   // ="transport"
	error_pipe                  // ="error-pipe"
	dependency_injection        // ="dependency-injection"
	test                        // ="test"
	test_suite                  // ="test-suite"
	input_port=0x140                  // ="test-suite"
	output_port
}
pub enum EntityStatus{
	planned=0x1001       // ="planned"
	in_progress   // ="in-progress"
	done          // ="done"
}

pub interface IDrawable {
	ent_type string
	name string
	id string
	anchor geometry.Point
	size geometry.Point
	rotation f64
	parent ?utils.Ref
	is_open bool
	children []utils.Ref
	outgoing_links []utils.Ref
	incoming_links []utils.Ref
	outgoing_traversing_links []utils.Ref
	incoming_traversing_links []utils.Ref
}
