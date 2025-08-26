data = piece_database(identity);
slot_index = data[$ "slot_sprite"];
frame_color = data[$ "class"];
cost = data[$ "place_cost"];
desc = data[$ "short_description"];
var cX = obj_cursor.x,
cY = obj_cursor.y,
create = false,
setIdentity = "Empty",
maxSlots = steam_lobby_get_data("MaxSlots"),
array1 = steam_lobby_get_data("Player1Loadout"),
array2 = steam_lobby_get_data("Player2Loadout"),
lastSlot = 0;
// Live updating of slots
if maxSlots == "" {
	exit;
}
maxSlots = int64(maxSlots);
array1 = json_parse(array1);
array2 = json_parse(array2);
var userID = obj_preasync_handler.steam_id,
player1 = steam_lobby_get_data("Player1"),
player2 = steam_lobby_get_data("Player2"),
pass = false;

if index == 0 {
	with obj_loadout_slot {
		if player == other.player {
			if index > lastSlot {
				lastSlot = index;
			}
		}
	}
	if lastSlot +1 < maxSlots {
		var shiftY = 0;
		for (var c = lastSlot +1; c < maxSlots; c++) {
			shiftY = floor(c/SLOTROW);
			if c <= 0 {
				continue;
			}
			instance_create_layer(x +(c -shiftY*SLOTROW)*sprite_width,y +shiftY*sprite_height,"Instances",obj_loadout_slot_online, {
				index: c,
				player: player,
				locked: locked,
			});	
		}
	}
	if read {
		with obj_loadout_slot {
			if player == 1 {
				var leng = array_length(array1);
				if index < leng {
					identity = array1[index];
				} else {
					identity = "Empty";	
				}
			}
			if player == 2 {
				var leng = array_length(array2);
				if index < leng {
					identity = array2[index];
				} else {
					identity = "Empty";	
				}
			}
		}
	} else if update {
		var sendArray = array_create(maxSlots),
		structSend = {Message: SEND.MATCHDATA},
		playerString = "";		
		with obj_loadout_slot {
			if player == 1 && player1 == userID {
				if index < maxSlots {
					sendArray[index] = identity;
				}
				playerString = "Player1Loadout";
			}
			if player == 2 && player2 == userID {
				if index < maxSlots {
					sendArray[index] = identity;
				}
				playerString = "Player2Loadout";
			}
		}
		struct_set(structSend,playerString,sendArray);
		if playerString != "" {
			steam_bounce(structSend);
			update = false;
		}
	}
}
if index >= maxSlots {
	instance_destroy();	
}

if player1 == userID && player == 1 {
	pass = true;
}
if player2 == userID && player == 2 {
	pass = true;
}
if locked || !pass {
	exit;	
}
if instance_exists(obj_ready) {
	if obj_ready.ready {
		exit;	
	}
}
// On Click
if position_meeting(cX,cY,self) && input_check_pressed("action") && identity != "Empty" {
	if !instance_exists(obj_slot_dragging) {
		select_sound(snd_pick_up);
		create = true;
	} else {
		var iD = obj_slot_dragging.identity,
		parnet = obj_slot_dragging.parent;
		instance_destroy(obj_slot_dragging);
		if identity != iD {
			if parnet.identity != "Empty" {
				setIdentity = iD;
			}
			create = true;	
		}
	}
}


if create {
	with obj_loadout_slot_online {
		if index = 0 && ((player1 == userID && player == 1) || (player2 == userID && player == 2)) {
			read = false;	
		}
	}
	audio_stop_sound(snd_pick_up);
	audio_stop_sound(snd_put_down);
	audio_play_sound(snd_pick_up,0,0);
	instance_destroy(obj_slot_dragging);
	instance_create_layer(x,y,"GUI",obj_slot_dragging, {
		parent: id,
		identity: identity,	
		index: index
	});
	identity = setIdentity;
	var sendArray = array_create(maxSlots),
	structSend = {Message: SEND.MATCHDATA},
	playerString = "";		
	with obj_loadout_slot {
		if player == 1 && player1 == userID {
			if index < maxSlots {
				sendArray[index] = identity;
			}
			playerString = "Player1Loadout";
		}
		if player == 2 && player2 == userID {
			if index < maxSlots {
				sendArray[index] = identity;
			}
			playerString = "Player2Loadout";
		}
	}
	struct_set(structSend,playerString,sendArray);
	if playerString != "" {
		steam_bounce(structSend);
		update = false;
	}
}


