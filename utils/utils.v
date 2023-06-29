module utils

pub fn starts_or_ends_with_any_of(str string,src... string) bool {
	for s in src {
		if starts_or_ends_with(str,s) {
			return true
		}
	}
	return false
}

pub fn starts_or_ends_with(str string,src string) bool {
	return str == src || str.starts_with(src+"_") || str.ends_with("_$src")
}
