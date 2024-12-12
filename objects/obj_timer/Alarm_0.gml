if draw_blue_green == 1 {
	draw_blue_green = 0;
} else {
	draw_blue_green = 1;
}	

if alarm_repeat[0] > 0 {
	alarm_repeat[0] -= 1;
	alarm_set(0,1);
} else {
	draw_blue_green = 1;
}