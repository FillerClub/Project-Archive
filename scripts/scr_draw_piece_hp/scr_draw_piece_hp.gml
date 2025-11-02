function draw_piece_hp(subtract_health = 0){
	// Draw Health
	// Divide health into chunks
	var 
	// Grab current health
	newHP = variable_clone(hp),
	preHealthCount = floor(total_health(newHP)/HEALTHCHUNK),
	preHealthPart = total_health(newHP)/HEALTHCHUNK -preHealthCount;
	hurt(newHP,subtract_health,DAMAGE.PHYSICAL);
	var
	totalHP = total_health(newHP),
	totalHPMax = total_health(hp_max),
	//healthTempVar = max(totalHP -subtract_health,0),
	healthCount = floor(totalHP/HEALTHCHUNK),
	healthPart = totalHP/HEALTHCHUNK -healthCount,
	// Grab max health
	totalHealthCount = floor(totalHPMax/HEALTHCHUNK),
	totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount,
	// Scaling if bar is large
	scale = 1;
	if totalHPMax > 20 {
		scale = 20/totalHPMax;
	}
	var zOff = z;
	if variable_instance_exists(self,"piece_on_grid") {
		var gridOff = piece_on_grid;
		if is_string(gridOff) {
			with obj_grid {
				if tag == gridOff {
					zOff += z;
					break;
				}
			}
		} else if instance_exists(gridOff) { zOff += gridOff.z; }
	}
	var
	spriteReference = spr_health_bit_empty,
	wid = sprite_get_width(spriteReference),
	hei = sprite_get_height(spriteReference),
	totalWid = wid*scale*(totalHealthPart +totalHealthCount),
	centerX = (x +GRIDSPACE/2),
	centerY = (y +GRIDSPACE -zOff),
	startX = centerX -totalWid/2,
	col = c_white;
	
	var newHPMAX = variable_clone(hp_max);
	// Draw total health
	if variable_struct_exists(newHPMAX,"over") {
		draw_bar(spr_over_health_bit_empty,spr_over_health_bit_empty_part,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
		totalHPMax -= newHPMAX.over;
		totalHealthCount = floor(totalHPMax/HEALTHCHUNK);
		totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount;
	}
	if variable_struct_exists(newHPMAX,"rainbow") {
		draw_bar(spr_rainbow_health_bit_empty,spr_rainbow_health_bit_empty_part,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
		totalHPMax -= newHPMAX.rainbow;
		totalHealthCount = floor(totalHPMax/HEALTHCHUNK);
		totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount;
	}
	if variable_struct_exists(newHPMAX,"shield") {
		draw_bar(spr_shield_health_bit_empty,spr_shield_health_bit_empty_part,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
		totalHPMax -= newHPMAX.shield;
		totalHealthCount = floor(totalHPMax/HEALTHCHUNK);
		totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount;
	}
	if variable_struct_exists(newHPMAX,"gel") {
		draw_bar(spr_gel_health_bit_empty,spr_gel_health_bit_empty_part,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
		totalHPMax -= newHPMAX.gel;
		totalHealthCount = floor(totalHPMax/HEALTHCHUNK);
		totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount;	
	}	
	if variable_struct_exists(newHPMAX,"armor") {
		draw_bar(spr_armor_health_bit_empty,spr_armor_health_bit_empty_part,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
		totalHPMax -= newHPMAX.armor;
		totalHealthCount = floor(totalHPMax/HEALTHCHUNK);
		totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount;	
	}	
	if variable_struct_exists(newHPMAX,"base") {
		draw_bar(spr_health_bit_empty,spr_health_bit_empty_part,wid,hei,totalHealthCount,totalHealthPart,startX,centerY,scale);
		totalHPMax -= newHPMAX.base;
		totalHealthCount = floor(totalHPMax/HEALTHCHUNK);
		totalHealthPart = totalHPMax/HEALTHCHUNK -totalHealthCount;	
	}
	
	// When moving a piece, show how much health it can take off enemy pieces
	if subtract_health > 0 {
		draw_bar(spr_health_bit,spr_health_bit_part,wid,hei,preHealthCount,preHealthPart,startX,centerY,scale,c_red);		
	}

	// Draw current health
	if variable_struct_exists(newHP,"over") {
		draw_bar(spr_over_health_bit,spr_over_health_bit_part,wid,hei,healthCount,healthPart,startX,centerY,scale);
		totalHP -= newHP.over;
		healthCount = floor(totalHP/HEALTHCHUNK);
		healthPart = totalHP/HEALTHCHUNK -healthCount;
	}
	if variable_struct_exists(newHP,"rainbow") {
		draw_bar(spr_rainbow_health_bit,spr_rainbow_health_bit_part,wid,hei,healthCount,healthPart,startX,centerY,scale);
		totalHP -= newHP.rainbow;
		healthCount = floor(totalHP/HEALTHCHUNK);
		healthPart = totalHP/HEALTHCHUNK -healthCount;
	}
	if variable_struct_exists(newHP,"shield") {
		draw_bar(spr_shield_health_bit,spr_shield_health_bit_part,wid,hei,healthCount,healthPart,startX,centerY,scale);
		totalHP -= newHP.shield;
		healthCount = floor(totalHP/HEALTHCHUNK);
		healthPart = totalHP/HEALTHCHUNK -healthCount;
	}
	if variable_struct_exists(newHP,"gel") {
		draw_bar(spr_gel_health_bit,spr_gel_health_bit_part,wid,hei,healthCount,healthPart,startX,centerY,scale);
		totalHP -= newHP.gel;
		healthCount = floor(totalHP/HEALTHCHUNK);
		healthPart = totalHP/HEALTHCHUNK -healthCount;	
	}	
	if variable_struct_exists(newHP,"armor") {
		draw_bar(spr_armor_health_bit,spr_armor_health_bit_part,wid,hei,healthCount,healthPart,startX,centerY,scale);
		totalHP -= newHP.armor;
		healthCount = floor(totalHP/HEALTHCHUNK);
		healthPart = totalHP/HEALTHCHUNK -healthCount;	
	}	
	if variable_struct_exists(newHP,"base") {
		draw_bar(spr_health_bit,spr_health_bit_part,wid,hei,healthCount,healthPart,startX,centerY,scale);
		totalHP -= newHP.base;
		healthCount = floor(totalHP/HEALTHCHUNK);
		healthPart = totalHP/HEALTHCHUNK -healthCount;	
	}
}