var gS = GRIDSPACE,
show = false;
with obj_generic_piece {
	if x >= other.x -gS && x <= other.x +gS && team != other.team {
		show = true;
	}
}

if show {
	timer += delta_time*DELTA_TO_SECONDS;		
} else {
	timer -= delta_time*DELTA_TO_SECONDS;	
}

timer = clamp(timer,0,2.5);