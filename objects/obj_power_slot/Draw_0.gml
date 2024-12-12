var hero = noone;
with obj_generic_hero {
	if team == global.team {
		hero = identity;
	}
}
switch hero {
	case "Monarch":
		switch identity {
			case 1:
				sprite_index = spr_net_slot
			break;
	
			case 2:
				sprite_index = spr_fizz_slot
			break;
			
			case 3:
				sprite_index = spr_horde_slot
			break;

		}
	break;
	
	default:
	case "Warden":
		switch identity {
			case 1:
				sprite_index = spr_generic_power_1
			break;
	
			case 2:
				sprite_index = spr_earthshock_slot
			break;
			
			case 3:
				sprite_index = spr_supercharge_slot
			break;

		}
	break;
}

image_alpha = 4*usable/5 + .2;

draw_self();

