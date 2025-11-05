
switch(async_load[?"event_type"]) {
	case "lobby_created":
		var client = obj_client_manager;
		var steamID = steam_id;
		steam_lobby_join_id(steam_lobby_get_lobby_id());
		steam_lobby_set_data("Name",string(steam_name) +"'s Lobby");
		steam_lobby_set_data("Status","Looking for players.");
		steam_lobby_set_data("Player1",string(0));
		steam_lobby_set_data("Player1Loadout",json_stringify(["Empty"]));
		steam_lobby_set_data("Player1Hero","");	
		steam_lobby_set_data("Player1Ready","0");	
		steam_lobby_set_data("Player2",string(0));
		steam_lobby_set_data("Player2Loadout",json_stringify(["Empty"]));
		steam_lobby_set_data("Player2Hero","");
		steam_lobby_set_data("Player2Ready","0");
		steam_lobby_set_data("MaxSlots",string(global.max_slots));			
		steam_lobby_set_data("Bans",string(global.enable_bans));	
		steam_lobby_set_data("Barrier",string(global.barrier_criteria));	
		steam_lobby_set_data("TimeLength",string(global.timeruplength));
		steam_lobby_set_data("MaxPieces",string(global.max_pieces));
		steam_lobby_set_data("Map",string(global.map));	
	break;
	case "lobby_joined": // Join lobby as host
	case "lobby_join_requested": // Player Joined through invite or steam overlay
		var LobbyID = async_load[? "lobby_id"],
		Success = async_load[? "success"],
		player1 = steam_lobby_get_data("Player1"),
		player2 = steam_lobby_get_data("Player2");
		if Success { 
			if player1 == 0 || player2 == 0 {
				steam_relay_data({Message: SEND.PLAYERJOIN, Player: steam_id, PlayerHero: global.active_hero, PlayerLoadout: global.loadout});
			}
			} else { show_message("Join Failed :("); }
	break;
	case "lobby_chat_update":
		var flag = async_load[? "change_flags"],
		userID = async_load[? "user_id"],
		player1 = steam_lobby_get_data("Player1"),
		player2 = steam_lobby_get_data("Player2");
		switch flag {
			case 1:
			break;
			default:
				if userID == player1 {
					steam_lobby_set_data("Player1",string(0));
					steam_lobby_set_data("Player1Loadout",json_stringify(["Empty"]));
					steam_lobby_set_data("Player1Hero","");	
					steam_lobby_set_data("Player1Ready","0");	
				} 
				if userID == player2 {
					steam_lobby_set_data("Player2",string(0));
					steam_lobby_set_data("Player2Loadout",json_stringify(["Empty"]));
					steam_lobby_set_data("Player2Hero","");						
					steam_lobby_set_data("Player2Ready","0");						
				}
			break;
		}
	break;
	case "lobby_list":
	    var _lb_count = steam_lobby_list_get_count();
		lobby_list = array_create(_lb_count,{undefined});
	    for (var i = 0; i < _lb_count; i++) {
	        var _lb_ID = steam_lobby_list_get_lobby_id(i);
	        var _lb_owner = steam_lobby_list_get_lobby_owner_id(i);
	        var _lb_name = steam_lobby_list_get_data(i,"Name");
	        var _lb_members_count = steam_lobby_list_get_lobby_member_count(i);
			lobby_list[i] = {
				lobby_id: _lb_ID,
				owner_id: _lb_owner,
				name: _lb_name,
				count: _lb_members_count,
			};
			// Put in request to fetch the name from owner id
			//steam_get_user_persona_name(_lb_owner);
	        //for (var j = 0; j < _lb_members_count; j++) {
	            //var _lb_member_ID = steam_lobby_list_get_lobby_member_id(i, j);
	        //}
	    }
	break;
	case "user_persona_name":
		var count = array_length(lobby_list),
		userID = async_load[? "steamid"],
		userName = async_load[? "persona_name"];
		for (var i = 0; i < count; i++) {
			if lobby_list[i].owner_id == userID {
				lobby_list[i].name = userName;	
			}
		}
	break;
}