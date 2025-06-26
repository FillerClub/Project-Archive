
function seq_transition(type){
	if layer_exists("Transition") layer_destroy("Transition");
	var Lay = layer_create(-9000,"Transition");
	layer_sequence_create(Lay,0,0,type);
}

function start_transition(type_out,type_in,load_in_struct,interrupt = true) {
	if global.game_state != TRANSITIONING {
		global.load = load_in_struct;
		global.game_state = TRANSITIONING;
		if type_out != INSTANT {
			seq_transition(type_out);
		} else {
			start_loading(load_in_struct);
		}
		
		if type_in != INSTANT {
			layer_set_target_room(load_in_struct.rm);
			seq_transition(type_in);
			layer_reset_target_room();
		}	
		return true;
	} else {
		return false;
	}
}

function start_loading(load_struct = global.load) {
	global.load = load_struct;
	if layer_exists("Load GUI") layer_destroy("Load GUI");
	var LAY = layer_create(-9999,"Load GUI");	
	instance_create_layer(room_width - 80, room_height - 80, "Load GUI",obj_loading, load_struct);		
}

function finish_loading(finish_run_protocol, room_going_to) {
	switch run {
		case "Lvl":
			if file_exists(SAVEFILE) {
				var buff = buffer_load(SAVEFILE);
				buffer_seek(buff,buffer_seek_start,0);
				var strng = buffer_read(buff, buffer_string);
				buffer_delete(buff);

				load = json_parse(strng);
				global.level = load[0].level;
				with obj_game {
				//level = global.level;
				switch global.level[0] {
						case 1:
							switch global.level[1] {
								default:
									room_goto(room_going_to);
								break;
							}
						break;
					}		
				}
			} else {
				save_file(SAVEFILE);			
			}
		break;
		default:
			room_goto(room_going_to);
		break;
	}	
	
}

function finish_transition() {
	layer_sequence_destroy(self.elementID);
	global.game_state = RUNNING;
}