function draw_bar(unit_whole_sprite,unit_part_sprite,unit_sprite_width,unit_sprite_height,whole_units,unit_part,draw_x,draw_y,scale = 1,color = c_white,alpha = 1) {
	var convertedSpriteWidth = unit_sprite_width*scale;
	// Draw total full units
	for (var i = 0; i < whole_units; i++) {
	    var drawX = draw_x +i*convertedSpriteWidth +convertedSpriteWidth/2;
	    draw_sprite_ext(unit_whole_sprite,image_index,drawX,draw_y -unit_sprite_height/3,scale,1,0,color,alpha);
	}
	// Draw total partial units
	if unit_part > 0 {
	    var partWid = convertedSpriteWidth*unit_part,
		srcPartWid = unit_sprite_width*unit_part,
	    drawX2 = draw_x + whole_units*convertedSpriteWidth,
		offX = sprite_get_xoffset(unit_whole_sprite),
		offY = sprite_get_xoffset(unit_whole_sprite);
		draw_sprite_ext(unit_part_sprite,image_index,round(drawX2),draw_y -unit_sprite_height/3,scale*unit_part,1,0,color,alpha);
	    //draw_sprite_part_ext(sPrEp,image_index,0,0,srcPartWid,unit_sprite_height,ceil(drawX2 + partWid/2 -offX*unit_part),draw_y -offY -unit_sprite_height/3,scale,1,c_white,1);		
	}	
}