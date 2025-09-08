draw_set_font(fnt_tiny);
draw_set_color(c_white);
draw_set_valign(fa_middle);
draw_set_halign(fa_center);
var client = obj_client_manager;
if client.is_host && !obj_ready.ready {
	draw_self();
}

var drawValue = 0;
switch setting {
	case "Enable Bans": drawValue = (global.enable_bans)?"True":"False"; break;
	case "Time Until Timer Upgrade": drawValue = string(global.timeruplength) +" seconds"; break;
	case "Max Pieces": if global.max_pieces > 99 { drawValue = "No limit"; } else { drawValue = string(global.max_pieces); } break;
	case "Max Slots": drawValue = string(global.max_slots); break;
	case "Barrier Win Condition": drawValue = string(global.barrier_criteria); break;
}
draw_text(x +sprite_width/2,y +sprite_height/2,string(setting) +": " +drawValue);