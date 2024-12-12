event_inherited();

// shoot
if !global.pause {
	var gS = global.grid_spacing;
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer = 0;
		timer_end = 1.8*random_range(0.95,1.05);
		
		if repeat_shot <= 0 {
			repeat_shot = 2;

		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.95;	
			var decideShoot0 = scan_for_enemy(999,x,y -gS),
			decideShoot2 = scan_for_enemy(999,x,y),  
			decideShoot1 = scan_for_enemy(999,x,y +gS);
			decision_matrix = [decideShoot0,decideShoot1,decideShoot2];
		}
		

		
		// yes this code is shit, I'm not changing it anytime soon
		if repeat_shot > 1 {
			if decision_matrix[0] == true {
					instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4) -gS,"Instances",obj_bullet, {
						team: team,	
					});	
				decision_matrix[0] = false;
			} else {
				if decision_matrix[1] == true {
					instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4) +gS,"Instances",obj_bullet, {
						team: team,	
					});	
					decision_matrix[1] = false;
				} else {
					if decision_matrix[2] == true {
						instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4),"Instances",obj_bullet, {
							team: team,	
						});	
						decision_matrix[2] = false;
					}
				}
			}	
		} else {
			if decision_matrix[1] == true {
				instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4) +gS,"Instances",obj_bullet, {
				team: team,	
				});
				decision_matrix[1] = false; 
			} else {
				if decision_matrix[0] == true {
					instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4) -gS,"Instances",obj_bullet, {
					team: team,	
					});		
					decision_matrix[0] = false;
				} else {
					if decision_matrix[2] == true {
						instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4),"Instances",obj_bullet, {
						team: team,	
						});
						decision_matrix[2] = false;
					} else {
						var decideShoot0 = scan_for_enemy(999,x,y -gS),
						decideShoot2 = scan_for_enemy(999,x,y),  
						decideShoot1 = scan_for_enemy(999,x,y +gS);
						decision_matrix = [decideShoot0,decideShoot1,decideShoot2];	
						if decision_matrix[0] == true {
							instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4) -gS,"Instances",obj_bullet, {
							team: team,	
							});	
						} else {
							if decision_matrix[1] == true {
								instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4) +gS,"Instances",obj_bullet, {
								team: team,	
								});	
							} else {
								if decision_matrix[2] == true {
									instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4),"Instances",obj_bullet, {
									team: team,	
									});	
								}
							}
						}	
					}
				}
			}
		}
	}
}
