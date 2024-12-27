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
hp_start = hp;

// Increase fire rate and power
damage += pieces_sacrificed/12;
timer_end = max(.75, timer_end -pieces_sacrificed/2.5);
repeat_shot_base += min(9, floor(pieces_sacrificed/6));

// Decrease move cost and cooldown
cost = max(1,cost -floor(pieces_sacrificed/3));
move_cooldown = move_cooldown/(1 +pieces_sacrificed/1.5);
move_cooldown_timer = move_cooldown;