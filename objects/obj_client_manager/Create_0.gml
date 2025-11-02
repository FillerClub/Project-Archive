with obj_client_manager {
	if self != other {
		instance_destroy();	
	}
}
// Tick system
//TICKRATE
current_tick = 0;
processing_delay = 1; 
tick_timer = 0;

// Hash system
hash_check_interval = 35;  // In ticks
hash_check_timer = 0;

// Resync system
resync_attempt_count = 0;
max_state_correction_attempts = 2;
max_total_resync_attempts = 4;

// Action buffering
action_buffer = ds_map_create(); 
action_history = [];

is_host = false;
status_change = false;
object_tag_list = [];
tag_list_length = 16;

default_game_rules();
var datLeng = array_length(LOBBYDATA);
inbuf = buffer_create(16, buffer_grow, 1);
member_status = MEMBERSTATUS.SPECTATOR;
ready_timer = 0;
in_level = false;
requests = [];
for (var i = 0; i < datLeng; i++) {
	lobby_data[i] = {type:"null", data: "null",update: true};
}
