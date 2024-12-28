var gS = GRIDSPACE;

var tm = (team == "friendly")?1:-1;

piece();

if !skip_move {
	switch execute {
		case "ability":
			execute = "nothing";
		break;
	
		case "move":
			piece_attack(valid_moves[BOTH], BOTH);	
		break;

		default:
			piece_interact();
		break;
	}
} else { skip_move = false; }
	
// shoot
if !global.pause {
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer = 0;
		timer_end = 4*random_range(0.98,1.02);
		
		if repeat_shot <= 0 {
			repeat_shot = 6;
		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.97;	
		}
		
		var decideShoot = scr_scan_for_enemy(x,y);
		
		if decideShoot {
			instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2+random_range(-4,4),"Instances",obj_bullet, {
				team: team,	
			});
		}
	}
}




