function draw_piece_hp(subtract_health = 0){
	// Draw Health
	// Divide health into chunks
	var 
	// Grab current health
	healthTempVar = max(hp -subtract_health,0),
	healthCount = floor(healthTempVar/HEALTHCHUNK),
	healthPart = healthTempVar/HEALTHCHUNK -healthCount,
	// Grab max health
	totalHealthCount = floor(hp_max/HEALTHCHUNK),
	totalHealthPart = hp_max/HEALTHCHUNK -totalHealthCount,
	// Scaling if bar is large
	scale = 1;
	if hp_max > 20 {
		scale = 20/hp_max;
	}
	var
	sPrE = spr_health_bit_empty,
	sPrF = spr_health_bit,
	sPrEp = spr_health_bit_empty_part,
	sPrFp = spr_health_bit_part,
	wid = sprite_get_width(sPrE),
	hei = sprite_get_height(sPrE),
	totalWid = wid*scale*(totalHealthPart +totalHealthCount),
	centerX = (x +GRIDSPACE/2),
	centerY = (y +GRIDSPACE -z),
	startX = centerX -totalWid/2,
	col = c_white,
	arrayLengthIDFK = array_length(other.piece_attacking_array),
	preHealthCount = floor(hp/HEALTHCHUNK),
	preHealthPart = hp/HEALTHCHUNK -preHealthCount;
	
	// Draw total health
	draw_bar(sPrE,sPrEp,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
	if subtract_health > 0 {
		draw_bar(sPrF,sPrFp,wid,hei,preHealthCount,preHealthPart,startX,centerY,scale,c_red);		
	}
	// Draw current
	draw_bar(sPrF,sPrFp,wid,hei,healthCount,healthPart,startX,centerY,scale);
}