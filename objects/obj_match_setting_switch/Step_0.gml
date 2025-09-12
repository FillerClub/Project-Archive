if !obj_client_manager.is_host || obj_ready.ready {
	exit;	
}
var curX = obj_cursor.x,
sendUpdate = false,
increment = 0;
if position_meeting(curX,obj_cursor.y,self) {
	var client = obj_client_manager;
	if input_check_pressed("action") {
		sendUpdate = true;
		if curX < x +sprite_width/2 {
			increment = -1;	
		} else {
			increment = 1;
		}
		// Clamp based on setting
		switch setting {
			case "Max Slots": global.max_slots = clamp(global.max_slots +increment,1,18); 
			break;
			case "Enable Bans": global.enable_bans = clamp(global.enable_bans +increment,false,true);
			break;
			case "Barrier Win Condition": global.barrier_criteria = clamp(global.barrier_criteria +increment,1,6);
			break;
			case "Time Until Timer Upgrade": global.timeruplength = clamp(global.timeruplength +increment*5,1,120);
			break;
			case "Max Pieces": global.max_pieces = clamp(global.max_pieces +increment*5,0,50);
			break;
		}
	}
	if mouse_check_button_pressed(mb_middle) {
		sendUpdate = true;
		switch setting {
			case "Max Slots":  global.max_slots= DEFAULT.MAXSLOTS;
			break;
			case "Enable Bans": global.enable_bans = DEFAULT.SHOWSLOTS;
			break;
			case "Barrier Win Condition": global.barrier_criteria = DEFAULT.BARRIER;
			break;
			case "Time Until Timer Upgrade": global.timeruplength = DEFAULT.TIMELENGTH;
			break;
			case "Max Pieces": global.max_pieces = infinity;
			break;
		}	
	}
	if sendUpdate {
		var readData = "",
		setData = "",
		lobbyData = obj_client_manager.lobby_data,
		datLeng = array_length(lobbyData);
		switch setting {
			case "Max Slots": readData = "MaxSlots"; setData = global.max_slots;
			break;
			case "Enable Bans": readData = "Bans"; setData = global.enable_bans;	
			break;
			case "Barrier Win Condition": readData = "Barrier"; setData = global.barrier_criteria;
			break;
			case "Time Until Timer Upgrade": readData = "TimeLength"; setData = global.timeruplength;
			break;
			case "Max Pieces": readData = "MaxPieces"; setData = global.max_pieces;
			break;
		}
		for (var i = 0; i < datLeng; i++) {
			if lobbyData[i].type == readData {
				lobbyData[i].update = true;	
			}
		}
		steam_lobby_set_data(readData,setData);
		//steam_relay_data({Message: SEND.MATCHDATA, Request: true, Data: dataSend});
	}
}
