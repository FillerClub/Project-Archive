function create_system_message(text_array){
	instance_create_layer(room_width/2,TEXTYDEFAULT,"GUI",obj_text_box, {
		text: text_array,
		bubble_color: $FF000000,
		text_color: $FFFFFFFF
	});
}