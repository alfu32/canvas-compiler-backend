module entities

pub struct TechnoLang {
pub mut:
	technoid string = 'none'
	langid   string = 'markdown'
}

pub fn new_technolang() TechnoLang {
	return TechnoLang{'none', 'markdown'}
}

pub fn (tl TechnoLang) compiler_id() string {
	return '${tl.technoid}/${tl.langid}'
}
