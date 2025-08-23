var drawcost = (identity != "Empty")?cost:"",
drawslot = (identity != "Empty")?spr_slot_frame:spr_slot_frame_empty,
markValid = true,
skip = false,
online = instance_exists(obj_client_manager);
draw_slot(slot_index,frame_color,c_white,drawcost,drawslot);
if online {
	var player1 = steam_lobby_get_data("Player1"),
	player2 = steam_lobby_get_data("Player2"),
	userID = obj_preasync_handler.steam_id;
}
with obj_hero_display {
	if online {
		if player != other.player {
			continue;	
		}
	}
	markValid = false;
	var ar = hero_database(identity,HERODATA.CLASSES);
	var arLength = array_length(ar);
	for (var i = 0; i < arLength; i++) {
		if other.frame_color == ar[i] {
			markValid = true;	
		}
	}
}
if online {
	var ignore = true;
	if player == 1 && player1 == userID {
		ignore = false;	
	}
	if player == 2 && player2 == userID {
		ignore = false;
	}
	if ignore {
		markValid = true;	
	}
}
if !markValid && identity != "Empty" {
	draw_sprite(spr_cant_slot,0,x+2,y+2);
}
if instance_exists(obj_client_manager) {
	if obj_ready.ready && !locked {
		draw_sprite(spr_slot_lock,0,x,y);	
	}
}
