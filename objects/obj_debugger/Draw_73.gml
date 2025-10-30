var debugOn = global.debug;
var verboseOn = global.verbose_debug;
   
var x_sep = 10;
var start_y = x_sep +y_offset;
var line_height = 20;
var current_y = start_y;
    
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, debugOn?400:120, debugOn?300:20, false);
draw_set_alpha(1);
    
draw_set_color(c_white);
draw_set_font(fnt_bit);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

if keyboard_check(vk_f3) {
	with all {
		if variable_instance_exists(self,"tag") {
			draw_text(x,y,tag);		
		}
	}
}
var debugString = debugOn?"on":"off"
if verboseOn { debugString += " - VERBOSE" }
draw_text(x_sep, current_y, "DEBUG - " +debugString);
current_y += line_height;

if !debugOn exit;

switch menu {
	case DEBUG.GAME:
		draw_text(x_sep, current_y, "=== GAME DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU");
		current_y += line_height;
		var gameState = global.game_state == RUNNING?"Running":(
						global.game_state == PAUSED?"Paused":"Transitioning");
		draw_text(x_sep, current_y, "Game state: " +gameState);
		current_y += line_height;

		var playerTeam = global.player_team == "friendly"?"Friendly":(
						global.player_team == "enemy"?"Enemy":"Unset");
		draw_text(x_sep, current_y, "Team: " +playerTeam);
		current_y += line_height;

		draw_text(x_sep, current_y, "FPS: " +string(display_fps));
		current_y += line_height;	
	break;
	case DEBUG.ONLINE:
		// Network status
		draw_text(x_sep, current_y, "=== NETCODE DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU");
		current_y += line_height;
		draw_text(x_sep, current_y, "#1 - ONLINE STATS");
		current_y += line_height;
		draw_text(x_sep, current_y, "#2 - STATES COMPARISON");
		current_y += line_height;
		if instance_exists(obj_client_manager) {	
			var isHost = obj_client_manager.is_host;
			var status = isHost?"HOST":"CLIENT";
			draw_text(x_sep, current_y, "Role: " + status);
			current_y += line_height;

			var tickShow = isHost?string(obj_client_manager.current_tick):"N/A";
			draw_text(x_sep, current_y, "Tick: " + tickShow);
			current_y += line_height;
    
			draw_set_color(c_white);
		} else {
			draw_text(x_sep, current_y, "xxx NOT ONLINE xxx");
			current_y += line_height;
			draw_text(x_sep, current_y, "GO ONLINE TO VIEW STATS");			
		}
	break;
	case DEBUG.ONLINESTATESCOMPARE:
		// Network status
		draw_text(x_sep, current_y, "=== NETCODE DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU");
		current_y += line_height;
		draw_text(x_sep, current_y, "#1 - ONLINE STATS");
		current_y += line_height;
		draw_text(x_sep, current_y, "#2 - STATES COMPARISON");
		current_y += line_height;
		if instance_exists(obj_client_manager) {
			draw_text(x_sep, current_y, "=== CURRENT STATES ===");
			current_y += line_height;
		} else {
			draw_text(x_sep, current_y, "xxx NOT ONLINE xxx");
			current_y += line_height;
			draw_text(x_sep, current_y, "NO STATES TO COMPARE");
		}
	break;
	default:
		draw_text(x_sep, current_y, "=== HOTKEYS ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "F1 - TOGGLE DEBUG MODE");
		current_y += line_height;
		draw_text(x_sep, current_y, "F2 - TOGGLE VERBOSE");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU (HERE)");
		current_y += line_height;
		draw_text(x_sep, current_y, "#1 - GAME MENU");
		current_y += line_height;
		draw_text(x_sep, current_y, "#2 - ONLINE MENU");
	break;
}
