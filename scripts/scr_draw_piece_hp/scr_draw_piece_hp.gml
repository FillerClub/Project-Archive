function draw_piece_hp(){
	// Draw Health
	// Divide health into chunks
	var 
	// Grab current health
	healthCount = floor(hp/HEALTHCHUNK),
	healthPart = hp/HEALTHCHUNK -healthCount,
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
	centerX = (x +64/2),
	centerY = (y +64),
	startX = centerX -totalWid/2;
	
	// Draw total health
	draw_bar(sPrE,sPrEp,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
	// Draw current health
	draw_bar(sPrF,sPrFp,wid,hei,healthCount,healthPart,startX,centerY,scale);
}