var gS = GRIDSPACE;

if graphic_show != -1 {
	var timeRemaining = time_source_get_time_remaining(graphic_timer);
	if timeRemaining > 0 {
		var 
		graphicShow = 0,
		alpha = 1;
		switch graphic_show {
			case LEVELSTART:
				graphicShow = spr_level_start_graphic;
				alpha = timeRemaining/2.5;
			break;
			case FINALWAVE:
				graphicShow = spr_final_wave_graphic;
				alpha = timeRemaining/2.5;
			break;
			case VICTORY:
				graphicShow = spr_yourdidit;
			break;
		}
		draw_sprite_ext(graphicShow,image_index,room_width/2,room_height/2,1,1,0,c_white,alpha);
	}	
}


draw_set_font(fnt_tiny);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//draw_text(room_width/2,room_height/2,instance_exists(obj_dropped_slot));
//draw_text(room_width/2,room_height/2 +32,powersAvailable);
//draw_text(room_width/2,room_height/2+128,row_threat);
//draw_text(room_width/2,room_height/2 +64,string(timer) +" : Phase " +string(phase));
//draw_text(piece_focus[0] +96,piece_focus[1] +112,string(piece_target));
//draw_text(piece_focus[0] +96,piece_focus[1] +176,string(piece_focus));

var tickRequest = false,
xRequest = x,
yRequest = y,
hero = "n/a",
powersAvailable = [0,0,0];

with obj_power_slot {
	if team == "enemy" {
		switch identity {
			case "a":
				powersAvailable[0] = usable;
			break;
			
			case "b":
				powersAvailable[1] = usable;
			break;
			
			case "c":
				powersAvailable[2] = usable;
			break;
		}
	}
}
//draw_text(room_width/2,room_height/2 +64,should_protect);