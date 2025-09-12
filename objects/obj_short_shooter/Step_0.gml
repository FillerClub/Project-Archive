event_inherited();

var tM = (team == "friendly")?1:-1,
gS = GRIDSPACE,
zOff = z;


if execute == "move" || ai_controlled { 
	short_shooter_move_handler();
}

// shoot
if global.game_state != PAUSED{
	var 
	gS = GRIDSPACE;
	if (timer >= timer_end) {
		timer = 0;
		timer_end = random_percent(.7,4);
		decide_shoot = false;
		var xV = 0,
		yV = 0,
		heroWallX = 0,
		leastX = 99999;
		
		var countPiece = 0;
		with obj_obstacle {
			if team != other.team && total_health(hp) > 0 {
				other.targets[countPiece] = id;
				countPiece++;
			}
		}
		
		with obj_hero_wall {
			if team == other.team && total_health(hp) > 0 {
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
					if distance_to_point(heroWallX,y) < leastX && z_collide(other,self,0) {
						leastX = distance_to_point(heroWallX,y);
						other.decide_shoot = true;	
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
		
		if decide_shoot {
			var gridOff = piece_on_grid;
			if is_string(gridOff) {
				with obj_grid {
					if tag == gridOff {
						zOff += z;
						break;
					}
				}
			} else if instance_exists(gridOff) { zOff += gridOff.z; }
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,
			x_vel: xV,
			y_vel: yV,
			z: zOff,
			});
		}
	}
}
