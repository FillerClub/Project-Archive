x = obj_cursor.x;
y = obj_cursor.y;
if input_check_released("action") {
	var destroyDrag = false,
	playSound = true;
	if position_meeting(x,y,obj_loadout_slot) {
		destroyDrag = true;
		var ref = instance_position(x,y,obj_loadout_slot);
		if ref.index != index {
			if parent.identity != ref.identity && parent.identity == "Empty" {
				parent.identity = ref.identity;
			}
			ref.identity = identity;	
		} else {
			playSound = false;	
		}
	}
	
	if position_meeting(x,y,obj_unlocked_slot) {
		var meet = instance_position(x,y,obj_unlocked_slot);
		// Check if empty
		// Grab least index first
		var lowest = infinity,
		firstSlot = noone;
		with obj_loadout_slot {
			if identity == "Empty" && index < lowest {
				lowest = index;
				firstSlot = id;
			}
		}
		if firstSlot != noone && parent.identity == identity {
			firstSlot.identity = identity;
			destroyDrag = true;
			playSound = false;
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