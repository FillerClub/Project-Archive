draw_slot(slot_index,frame_color,c_white,cost);
var available = false;
with obj_hero_display {
	var ar = hero_database(identity,HERODATA.CLASSES);
	var arLength = array_length(ar);
	for (var i = 0; i < arLength; i++) {
		if other.frame_color == ar[i] {
			available = true;	
		}
	}		
}

if !available {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
	draw_set_alpha(1);
	draw_set_color(c_white);
} else if input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self) {
	audio_stop_sound(snd_pick_up);
	audio_stop_sound(snd_put_down);
	audio_play_sound(snd_pick_up,0,0);
	instance_destroy(obj_slot_dragging);
	instance_create_layer(x,y,"GUI",obj_slot_dragging, {
		identity: identity	
	});
}