module utils

pub fn starts_or_ends_with_any_of(str string, src ...string) bool {
	for s in src {
		if starts_or_ends_with(str, s) {
			return true
		}
	}
	return false
}

pub fn starts_or_ends_with(str string, src string) bool {
	return str == src || str.starts_with(src + '_') || str.ends_with('_${src}')
}

pub fn array_sort_by[T](mut a []T, f fn (t T) string) {
	a.sort_with_compare(fn [f] [T](a &T, b &T) int {
		return if f(a) < f(b) {
			-1
		} else if f(a) == f(b) {
			0
		} else {
			-1
		}
	})
}
