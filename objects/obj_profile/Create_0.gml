var hasHero = false;
with obj_generic_hero {
	if other.team == team {
		hasHero = true;	
	}
}
if !hasHero {
	visible = false	
}

