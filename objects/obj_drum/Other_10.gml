if repeat_move < 1 {
	repeat_move++;
	move_cooldown_timer = 0;
} else {
	repeat_move = 0;
}