for (var i = 0; i < array_length(action); ++i) {
	if action[i] != noone {
		var isFriendly = (global.player_team == "friendly")?true:false;
		
		switch i {
			case CREATE:
				scr_send_CREATEaction_to_server(CREATE, isFriendly, cX[0],cY[0], action[CREATE]);
				action[CREATE] = noone;				
			break;
	
			case ABILITY:
				scr_send_ABILITYaction_to_server(ABILITY, isFriendly, cX[0],cY[0]);
				action[ABILITY] = noone;
			break;
	
			case MOVE:
				scr_send_MOVEaction_to_server(MOVE, isFriendly, cX[0],cY[0],cX[1],cY[1]);
				action[MOVE] = noone;
			break;
			
			case DESTROY:
				scr_send_DESTROYaction_to_server(DESTROY, isFriendly, cX[0],cY[0]);
				action[DESTROY] = noone;
			break;
		}		
	}
}
