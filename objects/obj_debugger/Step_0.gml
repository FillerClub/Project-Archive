if keyboard_check_pressed(vk_f1) {
	global.debug = !global.debug;	
	var debugString = global.debug?"on":"off";
	show_debug_message("Debug mode: " + debugString);
	save_file(PROFILE);
}
if keyboard_check_pressed(vk_f2) {
	global.verbose_debug = !global.verbose_debug;	
	var debugString = global.verbose_debug?"on":"off";
	show_debug_message("Verbose mode: " + debugString);
}

// Process delayed packets if simulation is active
process_delayed_packets(simulate_lag);

if !global.debug {
	exit;	
}
if keyboard_check_pressed(vk_numpad0) {
	menu = -1;	
}
// Submenus
switch menu {
	case -1:
		if keyboard_check_pressed(vk_numpad1) {
			menu = DEBUG.GAME;	
		}
		if keyboard_check_pressed(vk_numpad2) {
			menu = DEBUG.ONLINE;	
		}
	break;
	case DEBUG.ONLINE:
	case DEBUG.ONLINESTATESCOMPARE:
		if keyboard_check_pressed(vk_numpad1) {
			menu = DEBUG.ONLINE;	
		}
		if keyboard_check_pressed(vk_numpad2) {
			menu = DEBUG.ONLINESTATESCOMPARE;	
		}
		// F4: Increase lag
		if keyboard_check_pressed(vk_f4) {
		    artificial_lag_ms += 25;
		    show_debug_message("Artificial lag: " + string(artificial_lag_ms) + " ms");
		}

		// F5: Decrease lag
		if keyboard_check_pressed(vk_f5) {
		    artificial_lag_ms = max(0, artificial_lag_ms -25);
		    show_debug_message("Artificial lag: " + string(artificial_lag_ms) + " ms");
		}

		// F6: Increase packet loss
		if keyboard_check_pressed(vk_f6) {
		    packet_loss_percent = min(100, packet_loss_percent + 5);
		    show_debug_message("Packet loss: " + string(packet_loss_percent) + " %");
		}

		// F7: Decrease packet loss
		if keyboard_check_pressed(vk_f7) {
		    packet_loss_percent = max(0, packet_loss_percent - 5);
		    show_debug_message("Packet loss: " + string(packet_loss_percent) + " %");
		}

		// F8: Force desync (client only, for testing)
		if keyboard_check_pressed(vk_f8) {
		    if !steam_lobby_is_owner() {
		        force_desync();
		    } else {
		        show_debug_message("Cannot force desync on host");
		    }
		}

		// F9: Request state sync (client only)
		if keyboard_check_pressed(vk_f9) {
		    if !steam_lobby_is_owner() && instance_exists(obj_client_manager) {
				with obj_client_manager {
					request_state_correction();
				}
		        show_debug_message("Manual state sync requested");
		    }
		}

		// F10: Request full resync (client only)
		if keyboard_check_pressed(vk_f10) {
		    if !steam_lobby_is_owner() && instance_exists(obj_client_manager) {
				with obj_client_manager {
					request_full_resync();
				}
		        show_debug_message("Manual resync requested");
		    }
		}

		// F11: Toggle lag simulation
		if keyboard_check_pressed(vk_f11) {
		    simulate_lag = !simulate_lag;
			var debugString = simulate_lag?"on":"off";
		    show_debug_message("Lag simulation: " + debugString);
		}
	break;
}




fps_catch_timer += delta_time*DELTA_TO_SECONDS;
catch_average_fps = (catch_average_fps*iterations +fps_real)/(iterations +1);
iterations++;
if fps_catch_timer >= .5 {
	display_fps = catch_average_fps;
	fps_catch_timer -= .5;
	catch_average_fps = 0;
	iterations = 1;
}
