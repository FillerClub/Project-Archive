if draw_red_box == 0 {
	draw_red_box = 1;
} else {
	draw_red_box = 0;
}	

if alarm_repeat[0] > 0 {
	alarm_repeat[0] -= 1;
	alarm_set(0,1);
} else {
	draw_red_box = 0;
}