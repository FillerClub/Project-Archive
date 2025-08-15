event_inherited();



if global.game_state != PAUSED {
	if global.game_state == PAUSED {
		return false;	
	}
	var 
	tM = tm_dp(1,team,toggle),
	targetX = x +tM*GRIDSPACE +GRIDSPACE/2,
	targetY = y +GRIDSPACE/2,
	targetGrid = noone,
	obstacleInWay = noone,
	canMove = true,
	still = false,
	// Debug setting
	bounce = false;
	if timer >= timer_end && moving {
		// Flip if it meets the end of a grid
		if !position_meeting(targetX,targetY,obj_grid) {
			toggle = (toggle)?false:true;
			return false;	
		}
		// Recalculate target position upon flipping
		tM = tm_dp(1,team,toggle);
		targetX = x +tM*GRIDSPACE +GRIDSPACE/2;
		targetY = y +GRIDSPACE/2;
		// Redetermine if it can move
		if !position_meeting(targetX,targetY,obj_grid) {
			canMove = false;	
		} else {
			targetGrid = instance_position(targetX,targetY,obj_grid);
			if position_meeting(targetX,targetY,obj_obstacle) && !bounce {
				obstacleInWay = instance_position(targetX,targetY,obj_obstacle);
				if obstacleInWay.team == team {
					canMove = false;
				}	
				if obstacleInWay.team != team {
					hurt(obstacleInWay.hp,15,DAMAGE.PHYSICAL,obstacleInWay);
					audio_play_sound(snd_bullet_hit,0,0);
					if total_health(obstacleInWay.hp) > 0 {
						still = true;
					} else {
						canMove = true;
					}
				}
			}
		}
		if bounce {
			skip_timer = false;
			if still {
				toggle = (toggle)?false:true;
			}
			still = false;
		}
		if canMove {
			if !still {
				piece_on_grid = targetGrid;
				var
				targetGridPos = [floor((targetX -targetGrid.bbox_left)/GRIDSPACE),floor((targetY -targetGrid.bbox_top)/GRIDSPACE)];
				grid_pos = targetGridPos;
				x = targetGridPos[0]*GRIDSPACE +targetGrid.bbox_left;
				y = targetGridPos[1]*GRIDSPACE +targetGrid.bbox_top;
			} 
			audio_play_sound(snd_giant_step,0,0);
			timer = 0;
		} else {
			toggle = (toggle)?false:true;
		}
	}
}

