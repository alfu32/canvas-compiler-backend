module geometry

pub struct TechnoLang {
	technoid string = 'none'
	langid   string = 'markdown'
}

pub fn new_technolang() TechnoLang {
	return TechnoLang{'none', 'markdown'}
}
