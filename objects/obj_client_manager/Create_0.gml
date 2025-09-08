with obj_client_manager {
	if self != other {
		instance_destroy();	
	}
}
tick_timer = 0;
tick_count = 0;
tick_action_batches = ds_map_create();
batch_delay = 2;
is_host = false;

default_game_rules();
var datLeng = array_length(LOBBYDATA);
inbuf = buffer_create(16, buffer_grow, 1);
member_status = MEMBERSTATUS.SPECTATOR;
ready_timer = 0;
in_level = false;
for (var i = 0; i < datLeng; i++) {
	lobby_data[i] = {type:"null", data: "null",update: true};
}
