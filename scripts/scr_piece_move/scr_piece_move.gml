function piece_move(valid_moves = [0,0]){
var gS = global.grid_spacing,
gX = obj_cursor.x,
gY = obj_cursor.y;
var gClampX = floor(gX/gS)*gS;
var gClampY = floor(gY/gS)*gS;
var tempX = x;
var tempY = y;
can_move = true;
var clientPresent = instance_exists(obj_client);
var force = 1;

switch execute {
	case "move":
		if global.mode != "move" {
			execute = "nothing";
			exit;
		} else {
			if input_check_pressed("action") && !position_meeting(gX,gY,self) {
				if position_meeting(gX,gY, obj_obstacle) {
					var clickedon = instance_position(gX,gY,obj_obstacle) 
					if clickedon.team == team {
						execute = "nothing";
						exit;
					}					
				}
				
				switch team {
					case "friendly":
						if !global.turns >= force {
							audio_play_sound(snd_critical_error,0,0);
							with obj_timer {
								scr_error(); 
							}
							with obj_turn_operator {
								scr_error(); 
							}
							exit;
						}
					break;
					
					case "enemy":
						if !global.enemy_turns >= force {
							audio_play_sound(snd_critical_error,0,0);
							with obj_timer {
								scr_error(); 
							}
							with obj_turn_operator {
								scr_error(); 
							}
							exit;
						}
					break;
				}
				
				var ar_leng = array_length(valid_moves);
				var clicked_on_valid = false;

				
				for (var i = 0; i < ar_leng; ++i)	{
					if (gClampX == valid_moves[i][0])
					&& (gClampY == valid_moves[i][1])
					&& (place_meeting(gClampX,gClampY,obj_grid)) {
						var ifPlace = place_meeting(gClampX,gClampY,obj_obstacle);
						
						if ifPlace && can_attack {
							with instance_place(gClampX,gClampY,obj_obstacle) {
								if intangible {
									exit;	
								}
								var cliePres = instance_exists(obj_client);
								if squishy {
									if cliePres {
										with obj_client {
											action[DESTROY] = object_index;
											cX = [x];
											cY = [y];
										
										}											
									} else {
										instance_destroy();
									}
								} else {
									if object_get_parent(object_index) == obj_generic_hero_OLD {
										switch team {
											case "friendly":
												global.enemy_turns -= force;
											break;
					
											case "enemy":
												global.turns -= force;	
											break;
										}
										hp -= 10;
										other.can_move = false
										with other {
											var cliPre = instance_exists(obj_client);
/*											if cliPre {
												action[DESTROY] = object_index;
												cX = [x];
												cY = [y];												
											} else {
												instance_destroy();
											}*/
										}
									} else {
	
										var forc = hp/10;

										switch team {
											case "friendly":
												if global.enemy_turns >= forc {
													global.enemy_turns -= forc;
													hp -= forc*10;
												}
											break;
					
											case "enemy":
												if global.turns >= forc {
													global.turns -= forc;
													hp -= forc*10;
												}
											break;
										}										
										other.can_move = true;
									}
								}
							}
						} else {
							can_move = false;
						}
						
						if (!place_meeting(gClampX,gClampY,obj_obstacle)) || (can_move) {
							clicked_on_valid = true;
							xPre = x;
							yPre = y;
							xPost = gClampX;
							yPost = gClampY;
						
							if clientPresent {	
								with obj_client {
									action[MOVE] = self;
									cX = [other.xPre,other.xPost];
									cY = [other.yPre,other.yPost];
								}
							} else {
								x = gClampX;
								y = gClampY;
								grid_pos = [gClampX/gS,gClampY/gS];	
							
							switch team {
								case "friendly":
									global.turns -= force;	
								break;
					
								case "enemy":
									global.enemy_turns -= force;	
								break;
								}
							}	
							execute = "nothing";
							exit;
						}
					}
				}
			}
		}
	break;
	
	default:

	break;
}
}