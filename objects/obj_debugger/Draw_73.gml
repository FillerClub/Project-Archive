var debugOn = global.debug;
   
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

var debugString = global.debug?"on":"off"
draw_text(x_sep, current_y, "DEBUG - " +debugString);
current_y += line_height;

if !debugOn exit;

switch menu {
	case DEBUG.GAME:
		draw_text(x_sep, current_y, "=== GAME DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "F2 - CONTROL MENU");
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
		draw_text(x_sep, current_y, "F2 - CONTROL MENU");
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

			var tickShow = isHost?string(obj_client_manager.tick_count):"N/A";
			draw_text(x_sep, current_y, "Tick: " + tickShow);
			current_y += line_height;
    
			// Simulation settings
			if (sim_lag > 0 || sim_packet_loss > 0 || sim_jitter > 0) {
			    draw_set_color(c_yellow);
			    draw_text(x_sep, current_y, "SIM - Lag:" + string(sim_lag) + "ms Loss:" + string(sim_packet_loss) + "% Jitter:" + string(sim_jitter));
			    current_y += line_height;
			    draw_set_color(c_white);
			}
    
			// Prediction metrics
			if (total_predictions > 0) {
			    prediction_accuracy = (correct_predictions / total_predictions) * x_sep;
			    var accuracy_color = prediction_accuracy > 90 ? c_green : (prediction_accuracy > 70 ? c_yellow : c_red);
			    draw_set_color(accuracy_color);
			    draw_text(x_sep, current_y, "Prediction Accuracy: " + string(round(prediction_accuracy)) + "%");
			    current_y += line_height;
			    draw_set_color(c_white);
			}
    
			draw_text(x_sep, current_y, "Rollbacks: " + string(rollback_count));
			current_y += line_height;
    
			draw_text(x_sep, current_y, "Desyncs: " + string(desync_count));
			current_y += line_height;
    
			// Hash comparison
			if (last_local_hash != "" && last_host_hash != "") {
			    var hash_match = (last_local_hash == last_host_hash);
			    draw_set_color(hash_match ? c_green : c_red);
			    draw_text(x_sep, current_y, "Hash Match: " + (hash_match ? "YES" : "NO"));
			    current_y += line_height;
			    draw_set_color(c_white);
			}
    
			// Recent log entries
			draw_text(x_sep, current_y, "=== RECENT EVENTS ===");
			current_y += line_height;
    
			var log_start = max(0, array_length(debug_log) - 8);
			for (var i = log_start; i < array_length(debug_log); i++) {
			    var entry = debug_log[i];
			    draw_set_color(entry.color);
			    draw_text(x_sep, current_y, entry.text);
			    current_y += line_height;
			}
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
		draw_text(x_sep, current_y, "F2 - CONTROL MENU");
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
		draw_text(x_sep, current_y, "F2 - CONTROL MENU (HERE)");
		current_y += line_height;
		draw_text(x_sep, current_y, "#1 - GAME MENU");
		current_y += line_height;
		draw_text(x_sep, current_y, "#2 - ONLINE MENU");
	break;
}
