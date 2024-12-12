// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function world_one_levels() {
switch global.level[1] {
	case 1:
		// Stupid idiot check
		with obj_hero_wall {
			if hp <= 0 && other.phase < 6 {
				other.phase = 6;
				other.timer[MAIN] = 0;
				other.stupid_idiot_check = true;
			}
		}
		enemy_spawn_sequence(1,["crawler"],19,2);
		pause_sequence(2,true,14); 
		enemy_spawn_sequence(3,["crawler"],4,2);
		pause_sequence(4,true,12);	
		enemy_spawn_sequence(5,["crawler"],4,2) 
		//Expand grid, introduce movement, etc...
		if pause_sequence(6,(!piece_present || stupid_idiot_check),6/(1+stupid_idiot_check/2)) {
			scale_grid(3);	
			global.mode = "move";
			random_time_add = random_range(0,1);
			with obj_hero_wall {
				instance_create_layer(x,y+gS,"Instances",obj_hero_wall,{
					identity: identity,
					team: team,
				})	
				instance_create_layer(x,y-gS,"Instances",obj_hero_wall,{
					identity: identity,
					team: team,
				})	
			}
		}
		enemy_spawn_sequence(7,["crawler"],5,3,0,random_y); 
		pause_sequence(8,true,10);	
		enemy_spawn_sequence(9,["crawler"],5,3,0,random_y); 
		pause_sequence(10,true,6);	
		enemy_spawn_sequence(11,["crawler"],3,2,0,random_y); 
		if pause_sequence(12,!piece_present,6) {
			timer[FINALWAVEGRAPHIC] = 2.5; 
			audio_group_set_gain(track3,1,4500);
		}
		enemy_spawn_sequence(13,["crawler"],1,8,0,random_y);
		drop_slot(14,"accelerator",!piece_present);
		victory_sequence(FINALWAVE,[1,2]);
	break;
	
	case 2:
		var randomTipEdgeY = irandom_range(0,1)*4;
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		enemy_spawn_sequence(1,["drooper"],0,1,0,randomTipEdgeY);
		enemy_spawn_sequence(2,["crawler"],18,1,0,random_y);
		pause_sequence(3,true,7)
		enemy_spawn_sequence(4,["crawler"],10,3,0,random_y);
		pause_sequence(5,true,14);
		enemy_spawn_sequence(6,["drooper"],0,2,0,randomEdgeY);
		enemy_spawn_sequence(7,["crawler"],8,2,0,random_y);
		if pause_sequence(8,!piece_present,6) {
			timer[FINALWAVEGRAPHIC] = 2.5; 
			audio_group_set_gain(track3,1,4500);
		}
		enemy_spawn_sequence(9,["drooper","crawler"],1,10,0,random_y);	
		drop_slot(10,"short",!piece_present);
		victory_sequence(FINALWAVE,[1,3]);
	break;
	
	case 3:
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		enemy_spawn_sequence(1,["crawler"],18,2,0,random_y);
		pause_sequence(2,true,12);
		enemy_spawn_sequence(3,["crawler"],14,2,0,random_y);
		if enemy_spawn_sequence(4,["tank_crawler"],12,1,0,random_y) {
			audio_group_set_gain(track3,1,4500);
		}
		enemy_spawn_sequence(5,["crawler"],8,3,0,random_y); 
		enemy_spawn_sequence(6,["drooper"],8,2,0,randomEdgeY); 
		pause_sequence(7,true,15);
		enemy_spawn_sequence(8,["tank_crawler"],6,1,0,random_y);
		enemy_spawn_sequence(9,["crawler","drooper"],10,4,0,random_y);
		if pause_sequence(10,!piece_present,6) {
			timer[FINALWAVEGRAPHIC] = 2.5; 
			audio_group_set_gain(track4,1,4500);
		}
		enemy_spawn_sequence(11,["crawler","drooper"],1,9,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],2,3,0,random_y);
		drop_slot(13,"stick",!piece_present);
		victory_sequence(FINALWAVE,[1,4]);
	break;
	
	case 4:
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		enemy_spawn_sequence(1,["crawler"],16,2,0,random_y);
		pause_sequence(2,true,12);
		enemy_spawn_sequence(3,["crawler"],10,2,0,random_y);
		if enemy_spawn_sequence(4,["tank_crawler"],12,1,0,random_y) {
			audio_group_set_gain(track3,1,4500);
		}
		enemy_spawn_sequence(5,["crawler"],8,3,0,random_y); 
		enemy_spawn_sequence(6,["drooper"],8,2,0,randomEdgeY); 
		pause_sequence(7,true,15);
		enemy_spawn_sequence(8,["tank_crawler"],6,1,0,random_y);
		enemy_spawn_sequence(9,["crawler","drooper"],10,4,0,random_y);
		if pause_sequence(10,!piece_present,6) {
			timer[FINALWAVEGRAPHIC] = 2.5; 
			audio_group_set_gain(track4,1,4500);
		}
		enemy_spawn_sequence(11,["crawler","drooper"],1,9,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],2,3,0,random_y);
		drop_slot(13,"bomber",!piece_present);
		victory_sequence(FINALWAVE,[1,5]);
	break;
}	
}