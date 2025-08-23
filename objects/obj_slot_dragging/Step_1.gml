x = obj_cursor.x;
y = obj_cursor.y;
if input_check_released("action") {
	var destroyDrag = false,
	playSound = true,
	online = instance_exists(obj_client_manager),
	ref = instance_position(x,y,obj_loadout_slot);
	if instance_exists(ref) {
		var valid = true;
		if online {
			var player1 = steam_lobby_get_data("Player1"),
			player2 = steam_lobby_get_data("Player2"),
			userID = obj_preasync_handler.steam_id;
			valid = false;
			if player1 == userID && ref.player == 1 {
				valid = true;
			}
			if player2 == userID && ref.player == 2 {
				valid = true;
			}
		}
		if valid {
			destroyDrag = true;
			if ref.index != index {
				if parent.identity != ref.identity && parent.identity == "Empty" {
					parent.identity = ref.identity;
				}
				ref.identity = identity;
				if online {
					with obj_loadout_slot {
						if index = 0  && ((player1 == userID && player == 1) || (player2 == userID && player == 2)){
							read = false;	
						}
					}
				}
			} else {
				playSound = false;	
			}
		}
	}
	
	if position_meeting(x,y,obj_unlocked_slot) {
		var meet = instance_position(x,y,obj_unlocked_slot);
		// Check if empty
		// Grab least index first
		var lowest = infinity,
		firstSlot = noone,
		valid = true;
		with obj_loadout_slot {
			if online {
				var player1 = steam_lobby_get_data("Player1"),
				player2 = steam_lobby_get_data("Player2");
				valid = false;
				if player1 == obj_preasync_handler.steam_id && player == 1 {
					valid = true;
				}
				if player2 == obj_preasync_handler.steam_id && player == 2 {
					valid = true;
				}
			}
			if valid {
				if identity == "Empty" && index < lowest {
					lowest = index;
					firstSlot = id;
				}
			}
		}
		if firstSlot != noone && parent.identity == identity {
			firstSlot.identity = identity;
			destroyDrag = true;
			playSound = false;
			with obj_loadout_slot {
				if index = 0 {
					read = false;	
				}
			}
		}
		if parent.identity != identity {
			destroyDrag = true;
			playSound = true;
		}
	}
	if destroyDrag {
		if playSound {
			audio_stop_sound(snd_put_down);
			audio_play_sound(snd_put_down,0,0);
		}
		instance_destroy();	
	}
}