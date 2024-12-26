// Stupid idiot check
if level[1] == 1 && phase < 6 && time_source_get_time_remaining(timer) > 0 {
	with obj_hero_wall {
		if hp <= 0 {
			other.phase = 6;
			other.timer = 0;
			other.stupid_idiot_check = true;
		}
	}
}

if global.pause {
	exit;
}

// Grab last piece's position
var enemyPiecePresent = false;

with obj_generic_piece {
	if team == global.enemy_team {
		other.last_piece_x = x;
		other.last_piece_y = y;
		enemyPiecePresent = true;
	} 
}
// Generate random numbers
var
gS = global.grid_spacing,
gD = global.grid_dimensions,
board_height = (gD[3] -gD[2])/gS,
random_y = 0,
reroll_y = true,
cycle_wall = 0;
//Count amount of walls
with obj_hero_wall {
	if team == global.team {
		cycle_wall++;
	} 
}
// Find valid y
do {
	random_y = irandom_range(0,board_height);
	// Cycle through player's walls
	with obj_hero_wall {
		// If it is in position, has hp, and is player's, settle on this y
		if position_meeting(x,random_y*gS +gD[2],self) && hp > 0 && team == global.team {
			reroll_y = false
		}
	}
	cycle_wall--;
} until !reroll_y || cycle_wall <= 0
var timerAccel = ((!enemyPiecePresent && phase >= 1))/1.5
timer += delta_time*DELTA_TO_SECONDS*(1 +timerAccel)*timer_mod;
#macro INITIAL 999
// Initiate level
if timer >= 7 && phase == 0 {
	phase = 1;
	timer = INITIAL;
}
// Global Level Behaviors
switch phase {
	case LEVELSTART:
		graphic_show = LEVELSTART;
		time_source_start(graphic_timer);
	break;
	case FINALWAVE:
		graphic_show = LEVELSTART;
		time_source_start(graphic_timer);			
	break;
	case VICTORY:
		phase++;
		graphic_show = VICTORY
		time_source_start(graphic_timer);
		global.level = new_level;
		audio_play_sound(snd_happy_wheels_victory,0,0);
		save(SAVEFILE);
		with obj_game {
			enable_pausing = false;	
		}
		graphic_show = VICTORY;	
		time_source_reconfigure(graphic_timer,5,time_source_units_seconds,function(){
			with obj_game {
				journal_starting_entry = other.display_identity;	
			}
			instance_create_layer(room_width - 80, room_height - 80, "GUI",obj_loading, {
				run: "Journal",
				load: [standalone_soundtracks]
			});			
		});
		time_source_start(graphic_timer);
	break;
}

switch level[1] {
	case 1:
		enemy_spawn_sequence(1,["crawler"],INITIAL,1);
		enemy_spawn_sequence(1,["crawler"],18,1);
		pause_sequence(2,true,14); 
		enemy_spawn_sequence(3,["crawler"],4,2);
		pause_sequence(4,true,12);	
		enemy_spawn_sequence(5,["crawler"],4,2) 
		//Expand grid, introduce movement, etc...
		if pause_sequence(6,(!enemyPiecePresent || stupid_idiot_check),6/(1+stupid_idiot_check/2)) {
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
		initiate_final_wave(12,!enemyPiecePresent,track3);
		enemy_spawn_sequence(13,["crawler"],1,8,0,random_y);
		drop_slot(14,"accelerator",[1,2],!enemyPiecePresent,);
	break;
	
	case 2:
		var randomTipEdgeY = irandom_range(0,1)*4;
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		
		enemy_spawn_sequence(1,["drooper"],INITIAL,1,0,randomTipEdgeY);	
		enemy_spawn_sequence(2,["crawler"],20,1,0,random_y);
		enemy_spawn_sequence(3,["crawler"],9,3,0,random_y);
		pause_sequence(4,true,15);
		enemy_spawn_sequence(5,["drooper"],.5,2,0,randomEdgeY);
		enemy_spawn_sequence(6,["crawler"],8,2,0,random_y);
		initiate_final_wave(7,!enemyPiecePresent,track3);		
		enemy_spawn_sequence(8,["drooper","crawler"],1,10,0,random_y);	
		drop_slot(9,"short",[1,3],!enemyPiecePresent);
	break;
	
	case 3:
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(1,["crawler"],18,1,0,random_y);
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
		initiate_final_wave(10,!enemyPiecePresent);
		enemy_spawn_sequence(11,["crawler","drooper"],1,9,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],2,3,0,random_y);
		drop_slot(13,"stick",[1,4],!enemyPiecePresent);
	break;
	
	case 4:
		var randomTipEdgeY = irandom_range(0,1)*6;
		var randomCenterY = irandom_range(2,4);
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,randomCenterY);
		enemy_spawn_sequence(2,["tank_crawler"],3,1,0,randomCenterY);
		enemy_spawn_sequence(3,["crawler"],3,2,0,randomCenterY);
		pause_sequence(4,true,10);
		enemy_spawn_sequence(5,["crawler"],4,5,0,randomTipEdgeY);
		pause_sequence(6,true,10);
		enemy_spawn_sequence(7,["crawler","drooper"],3,6,0,random_y);
		pause_sequence(8,true,8);
		enemy_spawn_sequence(9,["crawler","tank_crawler"],2,6,0,random_y);
		initiate_final_wave(10,!enemyPiecePresent);
		enemy_spawn_sequence(11,["drooper"],.8,8,0,random_y);
		drop_slot(12,"splitter",[1,5],!enemyPiecePresent);
	break;
	case 5:
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(2,["crawler"],12,2,0,random_y);
		pause_sequence(3,true,12);
		enemy_spawn_sequence(4,["tank_crawler"],12,1,0,random_y);
		enemy_spawn_sequence(5,["crawler"],10,2,0,random_y);
		if pause_sequence(6,true,8) {
			audio_group_set_gain(track3,1,4500);	
		}
		enemy_spawn_sequence(7,["jumper"],10,1,0,random_y);
		enemy_spawn_sequence(8,["crawler"],10,2,0,random_y);
		initiate_final_wave(9,!enemyPiecePresent);
		enemy_spawn_sequence(10,["jumper"],1,1,0,random_y);
		enemy_spawn_sequence(11,["crawler"],1,2,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],1.2,2,0,random_y);
		enemy_spawn_sequence(13,["crawler"],1.2,4,0,random_y);
		drop_slot(14,"crawler",[1,6],!enemyPiecePresent);
	break;
	case 6:
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(2,["crawler"],12,2,0,random_y);
		pause_sequence(3,true,12);
		enemy_spawn_sequence(4,["tank_crawler"],12,1,0,random_y);
		enemy_spawn_sequence(5,["crawler"],10,2,0,random_y);
		if pause_sequence(6,true,8) {
			audio_group_set_gain(track3,1,4500);
		}
		enemy_spawn_sequence(7,["jumper"],10,1,0,random_y);
		enemy_spawn_sequence(8,["crawler"],10,2,0,random_y);
		initiate_final_wave(9,!enemyPiecePresent);
		enemy_spawn_sequence(10,["jumper"],1,1,0,random_y);
		enemy_spawn_sequence(11,["crawler"],1,2,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],1.2,2,0,random_y);
		enemy_spawn_sequence(13,["crawler"],1.2,4,0,random_y);
		drop_slot(14,"tank_crawler",[1,7],!enemyPiecePresent);
	break;
	case 7:
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(2,["crawler"],12,2,0,random_y);
		pause_sequence(3,true,12);
		enemy_spawn_sequence(4,["tank_crawler"],12,1,0,random_y);
		enemy_spawn_sequence(5,["crawler"],10,2,0,random_y);
		if pause_sequence(6,true,8) {
			audio_group_set_gain(track3,1,4500);
		}
		enemy_spawn_sequence(7,["jumper"],10,1,0,random_y);
		enemy_spawn_sequence(8,["crawler"],10,2,0,random_y);
		initiate_final_wave(9,!enemyPiecePresent);
		enemy_spawn_sequence(10,["jumper"],1,1,0,random_y);
		enemy_spawn_sequence(11,["crawler"],1,2,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],1.2,2,0,random_y);
		enemy_spawn_sequence(13,["crawler"],1.2,4,0,random_y);
		drop_slot(14,"super_tank_crawler",[1,8],!enemyPiecePresent);
	break;
	case 8:
		drop_slot(1,"bomber",[1,1],!enemyPiecePresent);
	break;
}											