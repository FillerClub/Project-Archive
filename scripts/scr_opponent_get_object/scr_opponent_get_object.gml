function scr_opponent_get_object(){
	var client_id = argument0;
	
	if ds_map_exists(clientmap,string(client_id)) {
		return clientmap[? string(client_id)];
	} else {
		var l = instance_create_layer(room_width/2,-128,"Instances",obj_online_player);
		clientmap[? string(client_id)] = l;
		return l;
	}
}