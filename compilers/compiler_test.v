module compilers

import arrays

pub fn test_concat_arrays() {
	mut arr1 := [1, 2, 3]
	arr2 := [4, 5, 6]
	println(arr1)
	println(arr2)
	println(arrays.concat(arr1, ...arr2))
}
