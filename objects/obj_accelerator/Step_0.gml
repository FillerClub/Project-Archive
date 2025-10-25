event_inherited();

if global.game_state == PAUSED {
	exit;	
}
var pointReady = timer >= timer_end;
if pointReady {
	var checkNoExcess = ((team == "friendly")? (global.friendly_turns < global.max_turns):(global.enemy_turns < global.max_turns));
	var zOff = 0;
	var gridOff = piece_on_grid;
	if is_string(gridOff) {
		with obj_grid {
			if tag == gridOff {
				zOff += z;
				break;
			}
		}
	} else if instance_exists(gridOff) { zOff += gridOff.z; }
	if input_check_pressed("action") && collision_rectangle(bbox_left,bbox_top -zOff,bbox_right,bbox_bottom -zOff,obj_cursor,false,false) && checkNoExcess && team == global.player_team {
		var collect = {
			Message: SEND.GAMEDATA,
			action_type: "Interact",
			tag: tag,
		}
		with obj_battle_handler {
			array_push(requests,collect);
		}
		exit;
	}
	if !animation_change {
		new_animation = sq_ira_ready;
		animation_change = true;
	}
}
// By default return to idle animations when done playing misc animations
if pointReady && layer_sequence_exists("Instances",animation) {
	var anim = layer_sequence_get_instance(animation);
	if layer_sequence_is_finished(animation) {
		new_animation = -1;
	}
}