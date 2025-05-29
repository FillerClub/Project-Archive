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

if global.game_state == PAUSED exit;

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
gS = GRIDSPACE,
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

world_timer_tick();


#macro INITIAL 999
// Initiate level
if timer >= 7 && phase == 0 {
	phase++;
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
		graphic_show = VICTORY;
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
			var lD = {
				run: "Journal",
				rm: rm_journal,
				load: [standalone_soundtracks]
			}
			start_transition(sq_fade_out,sq_fade_in,lD);
			save(PROFILE);		
		});
		time_source_start(graphic_timer);
	break;
}

switch level[1] {
	case 1:
		if tutorial_text_create("Tutorial1",0) {
			queue_text_timer = time_source_create(time_source_game,8.5,time_source_units_seconds,function() {
				tutorial_text_create("Tutorial1",1);
			},[],1,time_source_expire_after);
			time_source_start(queue_text_timer);
		}
		if instance_exists(obj_text_box) && text_phase <= 1 {
			obj_game.timer[MAIN] = 0;
			timer = 0;
		}
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
			tutorial_text_create("Tutorial1",2);
		}
		enemy_spawn_sequence(7,["crawler"],5,3,0,random_y); 
		pause_sequence(8,true,10);	
		enemy_spawn_sequence(9,["crawler"],4,3,0,random_y); 
		pause_sequence(10,true,6);	
		enemy_spawn_sequence(11,["crawler"],3,2,0,random_y); 
		initiate_final_wave(12,!enemyPiecePresent,track3);
		enemy_spawn_sequence(13,["crawler"],.5,10,0,random_y);
		drop_slot(14,"accelerator",[1,2],!enemyPiecePresent,);
	break;
	
	case 2:
		var randomTipEdgeY = irandom_range(0,1)*4;
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		tutorial_text_create("Tutorial2",0);
		enemy_spawn_sequence(1,["drooper"],INITIAL,1,0,randomTipEdgeY);	
		enemy_spawn_sequence(2,["crawler"],20,1,0,random_y);
		enemy_spawn_sequence(3,["crawler"],9,3,0,random_y);
		pause_sequence(4,true,15);
		enemy_spawn_sequence(5,["drooper"],.5,2,0,randomEdgeY);
		enemy_spawn_sequence(6,["crawler"],7,2,0,random_y);
		initiate_final_wave(7,!enemyPiecePresent,track3);		
		enemy_spawn_sequence(8,["drooper","crawler"],.5,12,0,random_y);	
		drop_slot(9,"stick",[1,3],!enemyPiecePresent);
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
		pause_sequence(7,true,7);
		enemy_spawn_sequence(8,["tank_crawler"],6,1,0,random_y);
		enemy_spawn_sequence(9,["crawler","drooper"],10,4,0,random_y);
		initiate_final_wave(10,!enemyPiecePresent);
		enemy_spawn_sequence(11,["crawler","drooper"],1,10,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],1,5,0,random_y);
		drop_slot(13,"splitter",[1,4],!enemyPiecePresent);
	break;
	
	case 4:
		var randomTipEdgeY = irandom_range(0,1)*6;
		var randomCenterY = irandom_range(2,4);
		tutorial_text_create("Tutorial4",0);
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,randomCenterY);
		enemy_spawn_sequence(2,["tank_crawler"],2,1,0,randomCenterY);
		enemy_spawn_sequence(3,["crawler"],2,2,0,randomCenterY);
		pause_sequence(4,true,12);
		enemy_spawn_sequence(5,["crawler"],2.5,4,0,randomTipEdgeY);
		pause_sequence(6,true,12);
		enemy_spawn_sequence(7,["crawler","drooper"],2.5,8,0,random_y);
		pause_sequence(8,true,12);
		enemy_spawn_sequence(9,["crawler","tank_crawler"],2.5,8,0,random_y);
		initiate_final_wave(10,!enemyPiecePresent);
		enemy_spawn_sequence(11,["drooper","tank_crawler","crawler"],1.5,12,0,random_y);
		drop_slot(12,"short",[1,5],!enemyPiecePresent);
	break;
	case 5:
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(2,["crawler"],12,2,0,random_y);
		pause_sequence(3,true,7);
		enemy_spawn_sequence(4,["tank_crawler"],12,1,0,random_y);
		enemy_spawn_sequence(5,["crawler"],10,2,0,random_y);
		pause_sequence(6,true,7);
		enemy_spawn_sequence(7,["jumper"],0,1,0,random_y);
		enemy_spawn_sequence(8,["crawler"],8,2,0,random_y);
		initiate_final_wave(9,!enemyPiecePresent);
		enemy_spawn_sequence(10,["jumper"],.5,2,0,random_y);
		enemy_spawn_sequence(11,["crawler"],.5,1,0,random_y);
		enemy_spawn_sequence(12,["tank_crawler"],.5,4,0,random_y);
		enemy_spawn_sequence(13,["crawler"],.5,6,0,random_y);
		drop_slot(14,"piercer",[1,6],!enemyPiecePresent);
	break;
	case 6:
		var randomEdgeY = irandom_range(0,1)?irandom_range(0,1):irandom_range(3,4);
		enemy_spawn_sequence(1,["jumper"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(2,["crawler"],12,1,0,random_y);
		enemy_spawn_sequence(3,["jumper","crawler"],11,3,0,random_y);
		pause_sequence(4,true,7);
		enemy_spawn_sequence(5,["jumper","drooper"],11,4,0,randomEdgeY);
		enemy_spawn_sequence(6,["crawler"],2,2,0,random_y);
		pause_sequence(7,true,7);
		enemy_spawn_sequence(8,["jumper","drooper"],6,4,0,randomEdgeY);
		enemy_spawn_sequence(9,["crawler"],2,2,0,random_y);
		initiate_final_wave(10,!enemyPiecePresent);
		enemy_spawn_sequence(11,["jumper","drooper"],.5,16,0,random_y);
		drop_slot(12,"cross",[1,7],!enemyPiecePresent,"Lonestar");
	break;
	case 7:
		var randomCenterY = irandom_range(2,4);
		enemy_spawn_sequence(1,["crawler"],INITIAL,1,0,random_y);
		enemy_spawn_sequence(2,["crawler"],12,2,0,random_y);
		enemy_spawn_sequence(3,["tank_crawler"],12,1,0,randomCenterY);
		if pause_sequence(4,true,7) {
			audio_group_set_gain(track3,1,4500);	
		}
		enemy_spawn_sequence(5,["crawler"],8,2,0,random_y);
		enemy_spawn_sequence(6,["super_tank_crawler"],12,2,0,randomCenterY);
		pause_sequence(7,true,5);
		enemy_spawn_sequence(8,["tank_crawler","super_tank_crawler"],10,6,0,random_y);
		initiate_final_wave(9,!enemyPiecePresent);
		enemy_spawn_sequence(10,["tank_crawler","super_tank_crawler"],.5,12,0,random_y);
		drop_slot(11,"super_stick",[1,8],!enemyPiecePresent);
	break;
	case 8:
		var random_x = irandom(1) +2;
		tutorial_text_create("Tutorial8",0)
		if phase < HEROBATTLEEND {
			hero_ai();
		}

		if should_protect {
			enemy_spawn_sequence(1,["crawler"],INITIAL,1,1,ai_lane_protect);
			enemy_spawn_sequence(2,["crawler"],9,2,1,ai_lane_protect);
			enemy_spawn_sequence(3,["tank_crawler"],9,1,1,ai_lane_protect);
			pause_sequence(4,true,7);
			enemy_spawn_sequence(5,["tank_crawler","super_tank_crawler"],11,2,1,ai_lane_protect);
			enemy_spawn_sequence(6,["crawler"],7,2,1,ai_lane_protect);
			pause_sequence(7,true,6);
		} else {
			enemy_spawn_sequence(1,["jumper"],INITIAL,1,1,ai_lane_choose);
			enemy_spawn_sequence(2,["crawler"],9,1,1,ai_lane_choose);
			enemy_spawn_sequence(3,["jumper","crawler"],9,3,1,ai_lane_choose);
			pause_sequence(4,true,7);
			enemy_spawn_sequence(5,["jumper","drooper"],9,4,1,ai_lane_choose);
			enemy_spawn_sequence(6,["crawler"],9,2,1,ai_lane_protect);
			pause_sequence(7,true,7);
		}
		if phase >= 7 && phase < HEROBATTLEEND {
			phase = 5;
			timer = 0;
			hero_phase += 2;
		}
		drop_slot(HEROBATTLEEND,"big_shooter",[1,1],!enemyPiecePresent,"Empress");
	break;
}											