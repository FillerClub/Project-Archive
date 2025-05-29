if global.game_state == PAUSED exit;
if input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self) {
	instance_destroy();	
}


x += x_inc*delta_time*DELTA_TO_FRAMES;	
y_init += y_inc;
	
y += y_spd*delta_time*DELTA_TO_FRAMES;

if y > y_init {
	y_spd_max = y_spd_max/degrade;
	y_spd = min(y_spd_max,-y_spd/degrade);
	bounces++;
	if bounces > 3 {
		degrade += .25;
	}
} else { y_spd += .05*delta_time*DELTA_TO_FRAMES; }

if bounces > 3 {
	x_inc = x_inc/1.25;
	y_inc = y_inc/1.25;
}