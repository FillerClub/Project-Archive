var inputV = input_check_pressed("up") -input_check_pressed("down");
index -= inputV;

if index >= array_length(player) {
	index = 0;	
} else if index < 0 {
	index = array_length(player) -1;
}