module compilers

import geometry

pub struct JsNodeCompiler {
pub mut:
	id string = 'node/javascript'
}

pub fn (mut c JsNodeCompiler) get_file_name(path []geometry.MetadataRecord) string {
	return '${get_partial_file_name(path)}.node.js'
}

pub fn (mut c JsNodeCompiler) get_fq_name(path []geometry.MetadataRecord) string {
	return get_partial_fq_name(path)
}

pub fn (mut c JsNodeCompiler) get_compiled_content(em geometry.MetadataRecord, index map[string]geometry.MetadataRecord) string {
	simple_name := em.drawable.name
	ports := get_ports(em, index)
	lines := em.metadata.text
		.split('\n')
		.join('\n					')
	args_comment := ports.map(fn (it Port) string {
		return ' * param ${it.name} ${it.fqname}'
	}).join('\n		 ')
	arg_list := ports.map(it.name).join(', ')
	return 'module.exports = {
			${simple_name}:_${simple_name},
			${ports.map(it.name).join(',\n')}
		}
		/**
		${args_comment}
		 * returns Promise<boolean>
		 */
		async function _${simple_name}(${arg_list}){
			return new Promise(function(resolve,reject){
				try{
					${lines}
					resolve(true)
				}catch(err){
					reject(err)
				}
			})
		}
	'.trim_indent()
}
