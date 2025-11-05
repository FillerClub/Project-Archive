var debugOn = global.debug;
var verboseOn = global.verbose_debug;
   
var x_sep = 10;
var start_y = x_sep +y_offset;
var line_height = 20;
var current_y = start_y;
    
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, debugOn?400:300, debugOn?300:30, false);
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
		draw_set_color(c_aqua);
		draw_text(x_sep, current_y, "=== GAME DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU");
		current_y += line_height;
		draw_set_color(c_white);
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
		// Controls
		draw_set_color(c_aqua);
		// Network status
		draw_text(x_sep, current_y, "=== NETCODE DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU");
		current_y += line_height;
		
		draw_set_color(#ADDAFF);
		draw_text(x_sep, current_y, "F3: Show tags | F4/F5: Lag +/- | F6/F7: Loss +/-");
		current_y += line_height;
		draw_text(x_sep, current_y, "F8: Force Desync | F9: Request State | F10: Request Full Sync | F11: Toggle Sim");
		current_y += line_height;
		draw_set_color(c_white);
		
		// Lag simulation status
		if simulate_lag {
			draw_set_color(c_yellow);
			draw_text(x_sep, current_y, "LAG SIMULATION ACTIVE:");
			current_y += line_height;
			draw_set_color(c_white);
			draw_text(x_sep + 20, current_y, "Delay: " + string(artificial_lag_ms) + "ms");
			current_y += line_height;
			draw_text(x_sep + 20, current_y, "Loss: " + string(packet_loss_percent) + "%");
			current_y += line_height;
    
			var queued = ds_priority_size(packet_queue);
			draw_text(x_sep + 20, current_y, "Queued Packets: " + string(queued));
			current_y += line_height;
		}
		current_y += line_height * 0.5;
		
		if instance_exists(obj_client_manager) {	
			var isHost = obj_client_manager.is_host;
			var status = isHost?"HOST":"CLIENT";
			draw_text(x_sep, current_y, "Role: " + status);
			current_y += line_height;
			
			if isHost {
				var tickShow = isHost?string(obj_client_manager.current_tick):"N/A";
				draw_text(x_sep, current_y, "Tick: " + tickShow);
				current_y += line_height;
			
				var dumbassstring = " tick"
				if obj_client_manager.processing_delay != 0 { dumbassstring += "s" }
				draw_text(x_sep, current_y, "Processing Delay: " + string(obj_client_manager.processing_delay) +dumbassstring);
				current_y += line_height;
			
		        // Show buffered actions
		        var buffered_count = 0;
		        var buff_tick = ds_map_find_first(obj_client_manager.action_buffer);
		        while (buff_tick != undefined) {
		            var actions = obj_client_manager.action_buffer[? buff_tick];
		            buffered_count += array_length(actions);
		            buff_tick = ds_map_find_next(obj_client_manager.action_buffer, buff_tick);
		        }
        
		        draw_text(x_sep, current_y, "Buffered Actions: " + string(buffered_count));
		        current_y += line_height;			
  
				draw_set_color(c_white);
			} else if instance_exists(obj_battle_handler) {
				var pending = ds_map_size(obj_battle_handler.prediction_history);
		        draw_text(x_sep, current_y, "Pending Predictions: " + string(pending));
		        current_y += line_height;
        
		        // Show individual predictions
		        if pending > 0 {
		            current_y += line_height * 0.5;
		            draw_set_color(c_lime);
		            draw_text(x_sep, current_y, "Predictions:");
		            current_y += line_height;
		            draw_set_color(c_white);
            
		            var pred_id = ds_map_find_first(obj_battle_handler.prediction_history);
		            var count = 0;
            
		            while (pred_id != undefined && count < 5) {
		                var pred = obj_battle_handler.prediction_history[? pred_id];
		                var age_ms = (get_timer() - pred.time_stamp) / 1000;
                
		                draw_text(x_sep + 20, current_y, "#" + string(pred_id) + ": " + pred.action.action_type + " (" + string(floor(age_ms)) + "ms)");
		                current_y += line_height * 0.8;
                
		                pred_id = ds_map_find_next(obj_battle_handler.prediction_history, pred_id);
		                count++;
		            }
				}
		        if pending > 5 {
		            draw_text(x_sep + 20, current_y, "... and " + string(pending - 5) + " more");
		            current_y += line_height * 0.8;
		        }
			}
			current_y += line_height * 0.5;

			// Current state hash
			var current_hash = calculate_state_hash();
			draw_text(x_sep, current_y, "State Hash: " + string_copy(current_hash, 1, 16) + " ...");
			current_y += line_height;

			// Piece/hero counts
			var piece_count = instance_number(obj_obstacle);
			var hero_count = instance_number(obj_bullet_parent);
			draw_text(x_sep, current_y, "Entities: " + string(piece_count) + " | Projectiles: " + string(hero_count));
			current_y += line_height;

			// Resources
			draw_text(x_sep, current_y, "Resources: F:" + string(global.friendly_turns) + " E:" + string(global.enemy_turns));
			current_y += line_height;

			current_y += line_height * 0.5;
			
		} else {
			draw_set_color(c_white);        
			draw_text(x_sep, current_y, "xxx NOT ONLINE xxx");
			current_y += line_height;
			draw_text(x_sep, current_y, "GO ONLINE TO VIEW STATS");			
		}
	break;
	case DEBUG.ONLINESTATESCOMPARE:
		draw_set_color(c_aqua);
		// Network status
		draw_text(x_sep, current_y, "=== NETCODE DEBUG ===");
		current_y += line_height;
		draw_text(x_sep, current_y, "#0 - CONTROL MENU");
		current_y += line_height;
		draw_set_color(c_white);
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
		draw_set_color(c_aqua);
		draw_text(x_sep, current_y, "=== HOTKEYS ===");
		draw_set_color(c_white);
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
