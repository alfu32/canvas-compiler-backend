module compilers

import geometry

pub struct JsNodeCompiler {
	pub mut:
		id string = "node/javascript"
}

pub fn (mut c JsNodeCompiler) get_file_name(path []geometry.MetadataRecord) string {
	return '${get_partial_fq_name(path)}.node.js'
}

pub fn (mut c JsNodeCompiler) get_fq_name(path []geometry.MetadataRecord) string {
	return get_partial_fq_name(path)
}

pub fn (mut c JsNodeCompiler) get_compiled_content(em geometry.MetadataRecord, index map[string]geometry.MetadataRecord) string {
	simple_name := em.drawable.name
	ports := get_ports(em, index)
	if em.drawable.children.len == 0 {
		return '
			module.exports = {
				${simple_name}:_${simple_name},
			}
			/**
			 * @param ${ports.map(it.name).join(',\n			 * @param ')}
			 * @returns boolean
			 */
			function _${simple_name}(${ports.map(it.name).join(', ')}){
				${em.metadata.text}
			}
		'.trim_indent()
	} else {
		mut generated_imports := []string{}
		mut generated_calls := []string{}
		mut generated_port_enqueue := []string{}
		for child_ref in em.drawable.children{
			mut generated_port_dequeue := []string{}
			child := index[child_ref.ref]
			child_ports := get_ports(child, index)
			generated_imports<<'const ${child.drawable.name}=require("./${child.drawable.name}.node");'
			for port in child_ports{
				generated_imports<<'const ${port.name}=require("./${port.name}.link");'
				if port.kind == "in" {
					generated_port_dequeue<<'${port.name}.dequeue()'
				} else {
					generated_port_enqueue<<'${port.name}.push(result_${child.drawable.name}.${port.name})'
				}
			}
			generated_calls<<'
				let result_${child.drawable.name} = ${child.drawable.name}(${generated_port_dequeue.join(', ')})
			'.trim_indent()
		}
		return '
			module.exports = {
				${simple_name}:_${simple_name},
			}
			/**
			 * @returns boolean
			 */
			function _${simple_name}(){
				${em.metadata.text}
				${generated_imports.join("\n			    ")}
				${generated_calls.join("\n			    ")}
				${generated_port_enqueue.join("\n			    ")}
			}
		'.trim_indent()

	}
}
