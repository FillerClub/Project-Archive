var sprWidth = sprite_width/3,
LL = left_bound +sprWidth,
RR = right_bound -sprWidth,
cursX = obj_cursor.x,
maxFPS = display_get_frequency();
switch purpose {
	case "Master":
		x = lerp(LL,RR,global.master_volume);
	break;
	case "SFX":
		x = lerp(LL,RR,global.sfx_volume);
	break;
	case "Music":
		x = lerp(LL,RR,global.music_volume);
	break;
	case "FPS":
		x = lerp(LL,RR,global.fps_target/maxFPS);
	break;
	case "Cursor":
		x = lerp(LL,RR,global.cursor_sens/10);
	break;
}
