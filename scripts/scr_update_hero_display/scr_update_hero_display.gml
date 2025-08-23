function update_hero_display(){
	var online = instance_exists(obj_client_manager);
	var slotTrack = [];
	with obj_unlocked_slot {
		array_push(slotTrack, id);
	}
	sprite_index = hero_database(identity,HERODATA.SPRITE);
	classes = hero_database(identity,HERODATA.CLASSES);
	if online {
		var player1 = steam_lobby_get_data("Player1"),
		player2 = steam_lobby_get_data("Player2"),
		steamID = obj_preasync_handler.steam_id;
		if !(player1 == steamID && player == 1) && !(player2 == steamID && player == 2) {
			exit;	
		}
	}
	var _f = function sort_class_then_price(_a,_b) {
		var classPriorityA = class_priority(_a.frame_color),
		classPriorityB = class_priority(_b.frame_color);
		for (var i = 0; i < array_length(classes); i++) {
			if classes[i] == _a.frame_color {
				classPriorityA += 10;
			}
		} 
		for (var i = 0; i < array_length(classes); i++) {
			if classes[i] == _b.frame_color {
				classPriorityB += 10;
			}
		}
		if classPriorityB != classPriorityA {
			return classPriorityB - classPriorityA;
		} else {
			return _a.cost -_b.cost;
		}
	}
	array_sort(slotTrack,_f);
	for (var up = 0; up < array_length(slotTrack); up++) {
		with (slotTrack[up]) {
			index = up;
		}
	}
}