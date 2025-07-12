function shift_hero_displays(){
	if member_status == MEMBERSTATUS.MEMBER {
		var h = obj_hero_display,
		e = obj_enemy_hero_display,
		ohX = h.x,
		oeX = e.x,
		xShift = oeX -ohX;
		// Switch hero displays
		h.x = oeX;
		e.x = ohX;
		with obj_loadout_arrow {
			x += xShift;	
		}
	}
}