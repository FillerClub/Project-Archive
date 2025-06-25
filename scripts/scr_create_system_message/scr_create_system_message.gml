function create_system_message(text_array,verticle_pos = TOP) {
	var spawnY = TEXTYDEFAULT;
	if verticle_pos == BOTTOM {
		spawnY = room_height -TEXTYDEFAULT;
	}
	instance_create_layer(room_width/2,TEXTYDEFAULT,"GUI",obj_text_box, {
		text: text_array,
		bubble_color: $FF000000,
		text_color: $FFFFFFFF,
		y: spawnY,
		verticle_pos: verticle_pos
	});
}