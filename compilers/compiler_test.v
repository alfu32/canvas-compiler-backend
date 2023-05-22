module compilers

import arrays

pub fn test_concat_arrays() {
	arr1 := [1, 2, 3]
	arr2 := [4, 5, 6]
	mut arr :=[]int{}
	println(arr1)
	println(arr2)
	println(arrays.concat(arr1, ...arr2))
	arr << arr1
	println( arr )
	arr << arr2
	println( arr )
}
