if identity != "noone" {
	sprite_index = hero_database(identity,HERODATA.SPRITE);
	draw_self();
} else {
	sprite_index = spr_missing_hero;
	draw_self();
	var fntA = fa_right,
	mult = 1,
	add = 0;
	if instance_exists(obj_client_manager) {
		if obj_client_manager.member_status == MEMBERSTATUS.MEMBER {
			fntA = fa_left;
			mult = -1;
			add = sprite_width;
		}
	}
	draw_set_font(fnt_basic);
	draw_set_valign(fa_middle);
	draw_set_halign(fntA);
	draw_text(x -16*mult +add,y +sprite_height/2,"Waiting for player...");
}
