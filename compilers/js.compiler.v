module compilers

import geometry

pub struct JsNodeCompiler {
pub mut:
	id string
}

pub fn (mut c JsNodeCompiler) get_file_name(path []geometry.MetadataRecord) string {
	return '${get_partial_file_name(path)}.node.js'
}

pub fn (mut c JsNodeCompiler) get_fq_name(path []geometry.MetadataRecord) string {
	return get_partial_fq_name(path)
}

pub fn (mut c JsNodeCompiler) get_compiled_content(em geometry.MetadataRecord, index map[string]geometry.MetadataRecord) string {
	simple_name = em.drawable.name
	ports := get_ports(em, index)
	return '
		module.exports = {
			${simple_name}:_${simple_name},
			${ports.map(it.name).join(',\n')}
		function _${simple_name}(${ports.map(it.name).join(', ')}){
			${em.metadata.text}
		}
	'.trim_indent()
}
