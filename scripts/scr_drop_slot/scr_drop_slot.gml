// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function drop_slot(drop_phase,drop_identity,drop_boolean = true){
	if pause_sequence(drop_phase,drop_boolean,0) {
		instance_create_layer(last_piece_x,last_piece_y,"AboveBoard",obj_dropped_slot,{
			identity: drop_identity
		});
		display_identity = drop_identity;
	}
}