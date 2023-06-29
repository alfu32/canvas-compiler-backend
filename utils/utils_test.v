module utils
pub fn test_starts_or_ends_with() {
	println("test_starts_or_ends_with")
	c:="coucou_toto"
	println(starts_or_ends_with("coucou","coucou"))
	println(starts_or_ends_with(c,"coucou"))
	println(starts_or_ends_with(c,"toto"))
	println(starts_or_ends_with(c,"abc"))
}
pub fn test_starts_or_ends_with_any_of() {
	println("test_starts_or_ends_with_any_of")
	c:="coucou_toto"
	println(starts_or_ends_with_any_of(c,"coucou"))
	println(starts_or_ends_with_any_of(c,"coucou","toto"))
	println(starts_or_ends_with_any_of(c,"abc","def","ghi"))
}
pub fn test_simple_equality() {
	println("test_starts_or_ends_with_any_of")
	c:="coucou_toto"
	println(c == "coucou_toto" )
}

