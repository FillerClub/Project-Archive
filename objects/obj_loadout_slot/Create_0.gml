loadout = global.loadout;
var arLength = global.max_slots;
var arLength2 = array_length(loadout);
if index < arLength2 {
	identity = loadout[index];
} else {
	identity = "Empty"	
}
if index == 0 {
	for (var i = 1; i < arLength; i++) {
		instance_create_layer(x +i*sprite_width,y,"Instances",obj_loadout_slot, {
			index: i
		});
	}
}
