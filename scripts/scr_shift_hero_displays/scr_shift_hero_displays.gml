function shift_hero_displays(){
	var h = obj_hero_display;
	switch obj_client_manager.member_status {
		case MEMBERSTATUS.HOST:
		break;
		case MEMBERSTATUS.MEMBER:
			var e = obj_enemy_hero_display,
			ohX = h.x,
			oeX = e.x,
			xShift = oeX -ohX;
			// Switch hero displays
			h.x = oeX;
			e.x = ohX;
			with obj_loadout_arrow {
				x += xShift;	
			}
		break;		
		default:
			instance_create_depth(h.x,h.y,-1000,obj_enemy_hero_display);
			instance_destroy(h);
		break;
	}
}