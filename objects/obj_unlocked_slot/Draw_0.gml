draw_slot(slot_index,frame_color,c_white,cost);
var available = true;
var markValid = false;
var create = false,
canTouch = true;
if instance_exists(obj_client_manager) {
	var player1 = steam_lobby_get_data("Player1"),
	player2 = steam_lobby_get_data("Player2"),
	userID = obj_preasync_handler.steam_id;
	with obj_loadout_slot {
		if player1 == userID && player == 1 {
			if identity == other.identity {
				available = false;	
			}
		}
		if player2 == userID && player == 2 {
			if identity == other.identity {
				available = false;	
			}
		}
	}	
} else {
	with obj_loadout_slot {
		if identity == other.identity {
			available = false;	
		}
	}	
}

with obj_hero_display {
	if instance_exists(obj_client_manager) {
		var pass = false;
		if player1 == userID && player == 1 {
			pass = true;
		}
		if player2 == userID && player == 2 {
			pass = true;
		}
		if !pass {
			continue;	
		}
		var ar = hero_database(identity,HERODATA.CLASSES);
		var arLength = array_length(ar);
		for (var i = 0; i < arLength; i++) {
			if other.frame_color == ar[i] {
				markValid = true;	
			}
		}			
	} else {
		var ar = hero_database(identity,HERODATA.CLASSES);
		var arLength = array_length(ar);
		for (var i = 0; i < arLength; i++) {
			if other.frame_color == ar[i] {
				markValid = true;	
			}
		}		
	}
}
if instance_exists(obj_ready) {
	if obj_ready.ready {
		canTouch = false;	
	}
}
if !available {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
	draw_set_color(c_white);
	if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") && canTouch {
		with obj_loadout_slot {
			if identity == other.identity {
				identity = "Empty";
				audio_play_sound(snd_put_down,0,0);
			}
		}		
	}
} else {
	// On Click
	if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") && canTouch {
		if !instance_exists(obj_slot_dragging) {
			select_sound(snd_pick_up);
			create = true;
		} else {
			var iD = obj_slot_dragging.identity;
			instance_destroy(obj_slot_dragging);
			if identity != iD {
				create = true;	
			}
		}
	}
	if create {
		audio_stop_sound(snd_pick_up);
		audio_stop_sound(snd_put_down);
		audio_play_sound(snd_pick_up,0,0);
		instance_destroy(obj_slot_dragging);
		instance_create_layer(x,y,"GUI",obj_slot_dragging, {
			identity: identity,
			parent: id,
		});
	}
	create = false;
}
if markValid {
	draw_sprite(spr_can_slot,0,x+2,y+2)
}
draw_set_alpha(1);
