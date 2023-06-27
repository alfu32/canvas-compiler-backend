module modelstore

import utils

pub struct ModelStore[E]{
pub mut:
	drawables_index           map[string]E
}

pub fn (this ModelStore[E]) get_by_ref(ref utils.Ref) E {
	return this.drawables_index[ref.ref]
}
