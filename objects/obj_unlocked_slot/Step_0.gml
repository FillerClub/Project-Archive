var shiftY = floor(index/row_length);
x = start_x +(index -shiftY*row_length)*sprite_width;
y = start_y +shiftY*sprite_height;