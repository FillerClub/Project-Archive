function crawler_code() {
	if !global.pause {
		var tM = ((team == "friendly")?1:-1)*(1 -toggle*2),
		gS = global.grid_spacing;
	
		if position_meeting(x +tM*gS,y,obj_obstacle) {
			with instance_position(x +tM*gS,y,obj_obstacle) {
				if hp > 0 {
					other.skip_timer = true;	
				} else {
					other.skip_timer = false;
				}
			}
		} else { skip_timer = false; }

		if timer >= timer_end && moving {
			var canMove = true;
			var still = false;
			if !position_meeting(x +tM*gS,y,obj_grid) {
				toggle = (toggle)?false:true;
			} else {
				var inst = instance_position(x +tM*gS,y,obj_obstacle);
				if inst != -4 {
					if (inst.hp <= 0) || (inst.team == team) {
						toggle = (toggle)?false:true;	
					}
				}
			}
	
			tM = ((team == "friendly")?1:-1)*(1 -toggle*2);
		
		
			if !position_meeting(x +tM*gS,y,obj_grid) {
				canMove = false;	
			} else if position_meeting(x +tM*gS,y,obj_obstacle) {
				with instance_position(x +tM*gS,y,obj_obstacle) {
					if team == other.team {
						canMove = false;
					}	
					if team != other.team {
						still = true;
					}
				}
			}
	
			if canMove {
				if !still {
					x += tM*gS;	
					timer = 0;
				
				}
			} else {
				toggle = (toggle)?false:true;
				tM = ((team == "friendly")?1:-1)*(1 -toggle*2);	
			}
		}


	}
}