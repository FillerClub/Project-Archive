for (var i = 0; i < array_length(action); ++i) {
	if action[i] != noone {
		switch i {
			case CREATE:
				for (var s = 0; s < ds_list_size(sockets); s++) {
					var so = ds_list_find_value(sockets, s);
					scr_send_action_to_client(so,action[CREATE],cX[0],cY[0],CREATE);
				}
				action[CREATE] = noone;				
			break;
	
			case ABILITY:
				for (var s = 0; s < ds_list_size(sockets); s++) {
					var so = ds_list_find_value(sockets, s);
					scr_send_action_to_client(so,action[ABILITY],cX[0],cY[0],ABILITY);
				}
				action[ABILITY] = noone;
			break;
	
			case MOVE:
				for (var s = 0; s < ds_list_size(sockets); s++) {
					var so = ds_list_find_value(sockets, s);
					scr_send_MOVEaction_to_client(so,action[MOVE],cX[0],cY[0],MOVE,cX[1],cY[1]);
				}
				action[MOVE] = noone;
			break;
		}		
	}
}


/*for (var i = 0; i < instance_number(obj_generic_piece); i++) {
	var pl = instance_find(obj_generic_piece, i);
	
	}
}