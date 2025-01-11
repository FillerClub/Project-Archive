loadout = global.loadout;
identity = loadout[index];
var arLength = array_length(loadout);
if index == 0 {
	for (var i = 1; i < arLength; i++) {
		instance_create_layer(x +i*sprite_width,y,"Instances",obj_loadout_slot, {
			index: i
		});
	}
}
