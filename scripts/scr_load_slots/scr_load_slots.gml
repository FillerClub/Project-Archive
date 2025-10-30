function load_slots(deploy_loadout = undefined,deploy_enemy_loadout = undefined){
	var spriteW = 48,
	spriteH = 64,
	shiftY = 0,
	shiftX = 0;
	with obj_slot_bg {
		var slotRow = per_row;
		if team != global.opponent_team && deploy_loadout != undefined {
			var loadoutLength = array_length(deploy_loadout);
			shiftY = floor((loadoutLength -1)/slotRow) +1;
			shiftX = -1;
			if team == "enemy" {
				x -= spriteW*(min(loadoutLength,slotRow) -1);
			}
			for (var l = 0; l < loadoutLength; l++) {
				if l mod slotRow == 0 {
					shiftY--;
					shiftX++;
				}
				instance_create_layer(x +(l -shiftX*slotRow)*spriteW,y -shiftY*spriteH,"Instances",obj_piece_slot,{
					identity: deploy_loadout[l],
					index: l,
					team: team,
					tag: string_copy(team,1,1) +string(l),
				});				
			}
		}
		if team != global.player_team && deploy_enemy_loadout != undefined {
			var loadoutLengthE = array_length(deploy_enemy_loadout);
			shiftY = floor((loadoutLengthE -1)/slotRow) +1;
			shiftX = -1;
			if team == "enemy" {
				x -= spriteW*(min(loadoutLengthE,slotRow) -1);
			}	
			for (var l = 0; l < loadoutLengthE; l++) {
				if l mod slotRow == 0 {
					shiftY--;
					shiftX++;
				}
				instance_create_layer(x +(l -shiftX*slotRow)*spriteW,y -shiftY*spriteH,"Instances",obj_piece_slot,{
					identity: deploy_enemy_loadout[l],
					index: l,
					team: team,
					tag: string_copy(team,1,1) +string(l),
				});				
			}
		}
	}
}