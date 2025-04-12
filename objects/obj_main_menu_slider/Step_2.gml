if !instance_exists(obj_menu) exit;
var vol = 0;

switch purpose {
	case "Master":
		global.master_volume = round(linked_object.value/5)*(5/100);
	break;
	case "SFX":
		global.sfx_volume = round(linked_object.value/5)*(5/100);
	break;
	case "Music":
		global.music_volume = round(linked_object.value/5)*(5/100);
	break;
	case "FPS":
		var maxFPS = display_get_frequency();
		global.fps_target = round(linked_object.value)*(maxFPS/100);
	break;
	case "Cursor":
		global.cursor_sens = round(linked_object.value)*(10/100);
	break;
}

if obj_menu.current_index == index {
	var
	LL = bbox_left +linked_object.sprite_width/3,
	RR = bbox_right -linked_object.sprite_width/3,
	leftInput = input_check_pressed("left")*10,
	rightInput = input_check_pressed("right")*10;
	linked_object.x = clamp(linked_object.x +rightInput -leftInput,LL,RR);	
	image_index = 1; 
} else { 
	image_index = 0;
}
// Slider Values
#macro SLIDERS case "Master": \
case "SFX": \
case "Music": \
case "FPS": \
case "Cursor": \


