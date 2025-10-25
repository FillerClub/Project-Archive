if moves == -1 {
	exit;	
}
var arLeng = array_length(moves);
		
for (var i = 0; i < arLeng; i++) {
	var arLeng2 = array_length(moves[i]) 
	for (var ii = 0; ii < arLeng2; ii++) {
		var arLeng3 = array_length(moves[i][ii]),
		precheckX = moves[i][ii][0],
		precheckY = moves[i][ii][1];		
		if arLeng3 <= 0 {
			continue;
		}
		// Check if affected by team & toggle
		if is_string(precheckX) {
			precheckX = tm_dp(real(precheckX));
		}
		if is_string(precheckY) {
			precheckY = tm_dp(real(precheckY));
		}
		draw_sprite(spr_drawn_move,i,x +precheckX*sprite_width,y +precheckY*sprite_height);	
	}
}

draw_sprite(spr_drawn_move,image_index,x,y);	
draw_self();