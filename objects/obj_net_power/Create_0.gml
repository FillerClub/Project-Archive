if !position_meeting(x +GRIDSPACE/2,y +GRIDSPACE/2,obj_generic_piece) {
	instance_destroy();
	exit;
}
cost = power_database("Empress-2",POWERDATA.COST);
if team == "friendly" {
	global.friendly_turns += cost;	
}
if team == "enemy" {
	global.enemy_turns += cost;	
}
if team != global.player_team {
	instance_destroy();
	exit;
}
with instance_position(x +GRIDSPACE/2,y +GRIDSPACE/2,obj_generic_piece) {
	execute = "force_move";	
	other.piece_link = self;
	skip_move = true;
	other.tag = tag;
}
with obj_power_slot {
	if other.link.team == team && other.link.identity == identity {
		other.slot_linked = id;
		pause_cooldown = true;
		cooldown = cooldown_length;
	}
}

valid_moves[ONLY_MOVE] = [	[0,0],
							[0, 1],
							[0, 2],
							[0, -1],
							[0, -2],
							[1, 0],
							[1, 1],
							[1, 2],
							[1, -1],
							[1, -2],
							[2, 0],
							[2, 1],
							[2, 2],
							[2, -1],
							[2, -2],
							[-1, 0],
							[-1, 1],
							[-1, 2],
							[-1, -1],
							[-1, -2],
							[-2, 0],
							[-2, 1],
							[-2, 2],
							[-2, -1],
							[-2, -2]];