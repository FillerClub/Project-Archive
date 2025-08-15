unlocked = global.unlocked_pieces;
identity = unlocked[index];
var arLength = array_length(unlocked);
if index == 0 {
	start_x = x;
	start_y = y;
	var shiftY = 0;
	for (var i = 1; i < arLength; i++) {
		if i mod row_length == 0 {
			shiftY++;
		}
		instance_create_layer(x +(i-shiftY*row_length)*sprite_width,y +shiftY*sprite_height,"Instances",obj_unlocked_slot, {
			index: i,
			row_length: row_length,
			start_x: x,
			start_y: y
		});
	}
}
data = piece_database(identity);
slot_index = data[$ "slot_sprite"];
frame_color = data[$ "class"];
cost = data[$ "place_cost"];
desc = data[$ "short_description"];
