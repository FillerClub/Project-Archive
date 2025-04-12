var sprWidth = sprite_width/3,
cursX = obj_cursor.x,
LL = left_bound +sprWidth,
RR = right_bound -sprWidth;
if position_meeting(cursX,obj_cursor.y,self) && mouse_check_button_pressed(mb_left) {
	dragging = true;
}
if mouse_check_button_released(mb_left) {
	dragging = false;
}

if dragging {
	x = clamp(cursX -click_offset,LL,RR);
} else {
	// Reset offset
	click_offset = cursX -x;	
}
value = lerp(0,100,(x -LL)/(RR -LL));