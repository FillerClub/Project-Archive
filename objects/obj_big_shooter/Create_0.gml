event_inherited();

// Sacrifice the things
var pieces_sacrificed = 0;
var selfVar = self;
with obj_generic_piece {
	if team == other.team && identity != "big_shooter" {
		pieces_sacrificed++;
		instance_destroy();
	}
}

// Increase hp
hp += floor(pieces_sacrificed/2)*5;
hp_init = hp;
hp_max = hp;

// Increase fire rate and power
damage += pieces_sacrificed/32;
timer_end = max(.75, timer_end -pieces_sacrificed/6);
repeat_shot_base += min(9, floor(pieces_sacrificed/12));

// Decrease move cost and cooldown
cost = max(1,cost -floor(pieces_sacrificed/6));
move_cooldown = move_cooldown/(1 +pieces_sacrificed/6);
move_cooldown_timer = 0;