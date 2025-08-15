data = piece_database(identity);
slot_index = data[$ "slot_sprite"];
frame_color = data[$ "class"];
cost = data[$ "place_cost"];
desc = data[$ "short_description"];
var cX = obj_cursor.x,
cY = obj_cursor.y,
create = false,
setIdentity = "Empty",
maxSlots = global.max_slots,
lastSlot = 0;
// Live updating of slots
if index == 0 {
	with obj_loadout_slot {
		if index > lastSlot {
			lastSlot = index;
		}
	}
	if lastSlot +1< maxSlots {
		var shiftY = 0;
		for (var c = lastSlot +1; c < maxSlots; c++) {
			shiftY = floor(c/SLOTROW);
			if c <= 0 {
				continue;
			}
			instance_create_layer(x +(c -shiftY*SLOTROW)*sprite_width,y +shiftY*sprite_height,"Instances",obj_loadout_slot, {
				index: c
			});	
		}
	}	
	var arrayLength = instance_number(obj_loadout_slot);
	var array = array_create(arrayLength,0);
	with obj_loadout_slot {
		array[index] = identity;
	}
	global.loadout = array;
}
if index >= maxSlots {
	instance_destroy();	
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
}


