if instance_exists(obj_preasync_handler) {
	lobby_list = obj_preasync_handler.lobby_list;
}
var inputV = input_check_pressed("up") -input_check_pressed("down"),
arLeng = array_length(lobby_list),
LobbyID = steam_lobby_get_lobby_id();
index -= inputV;
arLeng = array_length(lobby_list);
// Clear self from list
for(var i = 0 ; i < arLeng; i++) {
	if LobbyID == lobby_list[i].lobby_id {
		array_delete(lobby_list,i,1);
	}
}	
arLeng = array_length(lobby_list);
if arLeng <= 0 {
	exit;	
}
if index >= arLeng {
	index = 0;	
} else if index < 0 {
	index = arLeng -1;
}

if input_check_pressed("action_no_mouse") {
	steam_lobby_join_id(lobby_list[index].lobby_id);
	room_goto(rm_match_menu);
}

