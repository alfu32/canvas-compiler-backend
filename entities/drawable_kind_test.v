module entities

import utils
import modelstore


pub fn test_kind_is_composite_worker(){
	dw1:=Drawable{name:'drawable_composite',children: [utils.Ref{ref:'a'},utils.Ref{ref:'b'}]}
	println(dw1)
	assert dw1.kind()==.composite_worker
}
pub fn test_kind_is_composite_error_handler(){
	dw1:=Drawable{name:'error_drawable',children: [utils.Ref{ref:'a'},utils.Ref{ref:'b'}]}
	println(dw1)
	assert dw1.kind()==.composite_error_handler
	dw2:=Drawable{name:'drawable_error',children: [utils.Ref{ref:'a'},utils.Ref{ref:'b'}]}
	println(dw2)
	assert dw2.kind()==.composite_error_handler
	dw3:=Drawable{name:'error',children: [utils.Ref{ref:'a'},utils.Ref{ref:'b'}]}
	println(dw3)
	assert dw3.kind()==.composite_error_handler
}
pub fn test_kind_is_generator(){
	dw:=Drawable{name:'drawable',outgoing_links: [utils.Ref{ref: 'a'}]}
	println(dw)
	assert dw.kind()==.generator
}
pub fn test_kind_is_transformer(){
	dw:=Drawable{name:'drawable',incoming_links: [utils.Ref{ref: 'a'}],outgoing_links: [utils.Ref{ref: 'a'}]}
	println(dw)
	assert dw.kind()==.transformer
}
pub fn test_kind_is_sink(){
	dw:=Drawable{name:'drawable',incoming_links: [utils.Ref{ref: 'a'}]}
	println(dw)
	assert dw.kind()==.sink
}
pub fn test_kind_is_script(){
	dw:=Drawable{name:'drawable'}
	println(dw)
	assert dw.kind()==.script
}
pub fn test_kind_is_error_handler(){
	dw1:=Drawable{name:'error'}
	println(dw1)
	assert dw1.kind()==.error_handler
	dw2:=Drawable{name:'error_log'}
	println(dw2)
	assert dw2.kind()==.error_handler
	dw3:=Drawable{name:'log_error'}
	println(dw3)
	assert dw3.kind()==.error_handler
	dw4:=Drawable{name:'terror_terror'}
	println(dw4)
	assert dw4.kind()!=.error_handler
}
pub fn test_kind_is_service_library(){
	dw1:=Drawable{name:'database_service'}
	println(dw1)
	assert dw1.kind()==.service_library
	dw2:=Drawable{name:'service_layer'}
	println(dw2)
	assert dw2.kind()==.service_library
	dw3:=Drawable{name:'client_os_filesystem'}
	println(dw3)
	assert dw3.kind()==.service_library
	dw4:=Drawable{name:'rest_client'}
	println(dw4)
	assert dw4.kind()==.service_library
	dw5:=Drawable{name:'strings_library'}
	println(dw5)
	assert dw5.kind()==.service_library
	dw6:=Drawable{name:'library_entities'}
	println(dw6)
	assert dw6.kind()==.service_library
}
pub fn test_kind_is_transport(){
	dw:=Link{name:'link'}
	println(dw)
	assert dw.kind()==.transport
}
pub fn test_kind_is_error_pipe(){
	dw1:=Link{name:'error'}
	println(dw1)
	assert dw1.kind()==.error_pipe
	dw2:=Link{name:'read_error'}
	println(dw2)
	assert dw2.kind()==.error_pipe
	dw3:=Link{name:'error_fetch'}
	println(dw3)
	assert dw3.kind()==.error_pipe
}
pub fn test_kind_is_dependency_injection(){
	dw:=Link{
		name:'link',
		source:utils.Ref{ref:'sl'},
		model_store:modelstore.ModelStore[Drawable]{
			drawables_index:{'id':Drawable{id:'sl',name:"service_layer"}}
		}
	}
	println(dw)
	assert dw.kind()==.dependency_injection
}
pub fn test_kind_is_test(){
	dw:=Drawable{name:'drawable'}
	println(dw)
	assert dw.kind()==.test
}
pub fn test_kind_is_test_suite(){
	dw:=Drawable{name:'drawable'}
	println(dw)
	assert dw.kind()==.test_suite
}
