function place_position_valid(identity,team,pos,grid_tag,type) {
	var gridInst = find_tagged_grid(grid_tag);
	if !instance_exists(gridInst) {
		//show_debug_message("Grid not found" +string(grid_tag));
		return false;
	}
	var posX = gridInst.bbox_left +(pos[0] +.5)*GRIDSPACE,
	posY = gridInst.bbox_top +(pos[1] +.5)*GRIDSPACE;
	if !position_meeting(posX,posY,obj_grid) {
		//show_debug_message("Position not meeting grid");
		return false;	
	}
	var gridBehavior = 0,
	pieceBehavior = 0;
	// Reference placement behavior
	switch type {
		case 0:
			gridBehavior = piece_database(identity,"grid_placement_behavior");
			pieceBehavior = piece_database(identity,"piece_placement_behavior");
		break;
		case 1:
			gridBehavior = power_database(identity,POWERDATA.PLACEMENTONGRID);
			pieceBehavior = power_database(identity,POWERDATA.PLACEMENTONPIECE);			
		break;
	}
	var returnValue = grid_placement_valid(gridBehavior,gridInst.team,team),
	placement = piece_placement_valid(pieceBehavior,posX,posY,team);
	if placement != -1 {
		returnValue = placement;	
	}
	/*
	if !returnValue {
		show_debug_message("Checks failed");
	}
	*/
	return returnValue;
}