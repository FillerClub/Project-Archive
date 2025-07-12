data = piece_database(identity);
slot_index = data[PIECEDATA.SLOTSPRITE];
frame_color = data[PIECEDATA.CLASS];
cost = data[PIECEDATA.PLACECOST];
desc = data[PIECEDATA.BRIEFDESCRIPTION];
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
	if lastSlot +1 < maxSlots {
		for (var c = lastSlot; c < maxSlots; c++) {
			if c <= 0 {
				continue;
			}
			instance_create_layer(x +c*sprite_width,y,"Instances",obj_loadout_slot, {
				index: c
			});	
		}
	}
}
if index >= maxSlots {
	instance_destroy();	
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


