event_inherited();

var tM = (team == "friendly")?1:-1,
gS = global.grid_spacing;

if execute = "move" || ai_controlled { 
	short_shooter_move_handler();
}

// shoot
if !global.pause {
	var 
	gS = global.grid_spacing;
	if (timer >= timer_end) {
		timer = 0;
		timer_end = .8;
		var decideShoot = false,
		xV = 0,
		yV = 0,
		heroWallX = 0,
		leastX = 99999;
		
		var countPiece = 0;
		with obj_obstacle {
			if team != other.team && hp > 0 {
				other.targets[countPiece] = id;
				countPiece++;
			}
		}
		
		with obj_hero_wall {
			if team == other.team && hp > 0 {
				heroWallX = x;	
			}
		}

		if countPiece > 0 {
			var arrayLength = array_length(targets);
			
			repeat countPiece {
				with collision_circle(x +gS/2,y +gS/2,gS*3,targets[countPiece -1],false,true) {
					var offX = 0
					if object_index == obj_hero_wall {
						var tM0 = (team == "friendly")?1:-1,
						offX = gS/2*tM0;
					}
					if distance_to_point(heroWallX,y) < leastX {
						leastX = distance_to_point(heroWallX,y);
						decideShoot = true;	
						var b = x - other.x +offX,
						a = y - other.y,
						angle = abs(arctan(a/b));
						xV = cos(angle)*sign(b);
						yV = sin(angle)*sign(a);						
					}
				}				
				countPiece--;
			}
		}
		
		if decideShoot {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,
			x_vel: xV,
			y_vel: yV
			});
		}
	}
}
