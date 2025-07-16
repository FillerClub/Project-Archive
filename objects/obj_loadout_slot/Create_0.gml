loadout = global.loadout;
var arLength = global.max_slots;
var arLength2 = array_length(loadout);
if index < arLength2 {
	identity = loadout[index];
} else {
	identity = "Empty"	
}
if index == 0 {
	var shiftY = 0;
	for (var i = 1; i < arLength; i++) {
		if i mod SLOTROW == 0 {
			shiftY++;	
		}
		instance_create_layer(x +(i -shiftY*SLOTROW)*sprite_width,y +shiftY*sprite_height,"Instances",obj_loadout_slot, {
			index: i
		});
	}
}
