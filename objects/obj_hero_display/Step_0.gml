//Wrap index
var endInd = array_length(unlocked_heroes) -1;
if index < 0 {
	index = endInd;	
}
if index > endInd {
	index = 0;	
}
identity = unlocked_heroes[index];
sprite_index = hero_database(identity,HERODATA.SPRITE);
classes = hero_database(identity,HERODATA.CLASSES);
if update {
	global.active_hero = identity;
	if instance_exists(obj_client_manager) {
		with obj_client_manager {
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
			write_data_buffer(send_buffer,DATA.HERO,other.identity)
			buffer_write(send_buffer,buffer_u8,DATA.END);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
		}	
	}
	var slotTrack = [];
	with obj_unlocked_slot {
		array_push(slotTrack, id);
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
	update = false;
}