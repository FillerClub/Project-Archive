enum POWERDATA {
ALL = -1,					// Everything
NAME = 0,					// String
OBJECT = 1,					// Obj Asset
COST = 2,					// Integer
SLOTCOOLDOWN = 3,			// Real
SLOTSPRITE = 4,				// Spr Asset
PLACEMENTONGRID = 5,		// Macro
PLACEMENTONPIECE = 6,		// Macro
DESCRIPTION = 7,			// String
}

function power_database(name, trait = -1){
with obj_power_database {
	switch name {
		case "Warden-0":
			object = [	"Aegis Bloom",obj_aegis_bloom_passive,0,0,spr_aegis_bloom_passive,
						PLACEABLEANY,PLACEABLEANY,
						"When a wall breaks, it emits a powerful burst of energy that vaporizes any piece in its lane."];
		break;
		case "Warden-1":
			object = [	"Refurbishment",obj_heal_power,1,12,spr_heal_power_slot,
						PLACEABLENONE,SAME,
						"Heal a piece, and gives a slight speed boost."];
		break;
		case "Warden-2":
			object = [	"Meet your maker",obj_light_ray_power,2,35,spr_light_beam_slot,
						PLACEABLENONE,DIFFERENT,
						"Deal 10 damage."];
		break;
		case "Warden-3":
			object = [	"Super boost",obj_supercharge_power,3,100,spr_supercharge_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Supercharges your pieces in a 3x3 area."];
		break;
		// Empress' Powers
		case "Empress-0":
			object = [	"Lust of Wrath",obj_lust_of_wrath_passive,1,0,spr_lust_of_wrath_passive,
						PLACEABLEANY,PLACEABLEANY,
						"Breaking down walls give your pieces a permanent speed boost."];
		break;
		case "Empress-1":
			object = [	"Poison",obj_fizz_power,1,17,spr_fizz_slot,
						PLACEABLENONE,DIFFERENT,
						"Lob poison at an enemy, deal splash damage."];
		break;		
		case "Empress-2":
			object = [	"Forceful Grasp",obj_net_power,2,50,spr_net_slot,
						PLACEABLENONE,PLACEABLEANY,
						"Displace any piece."];
		break;
		case "Empress-3":
			object = [	"Big guy call",obj_horde_power,3,160,spr_horde_slot,
						SAME,PLACEABLEANY,
						"Summons two big guys. For fun."];
		break;
		// Lonestars' Powers
		case "Lonestar-0":
			object = [	"Fire at will",obj_constant_reload,1,13.1,spr_lonestar_passive,
						PLACEABLEANY,PLACEABLEANY,
						"Your powers use ammo. Gain ammo either by taking pieces or slowly overtime."];
		break;
		case "Lonestar-1":
			object = [	"Intimidate",obj_adrenaline_shot,1,0.05,spr_destroy_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Motivate your pieces with a shot. Gives them overhealth and speed temporarily."];
		break;
		case "Lonestar-2":
			object = [	"Infiltrate",obj_dynamite_summon,2,50,spr_dynamite_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Lob dynamite onto the board. Can be shot to detonate early."];
		break;
		case "Lonestar-3":
			object = [	"Destroy",obj_fan_the_hammer,3,65,spr_adrenaline_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Use all bullets in your chamber to deal massive damage to the enemy defenses."];
		break;
		// Engineer's Powers
		case "Engineer-0":
			object = [	"Aegis Bloom",obj_aegis_bloom_passive,0,0,spr_aegis_bloom_passive,
						PLACEABLEANY,PLACEABLEANY,
						"When a wall breaks, it emits a powerful burst of energy that vaporizes any piece in its lane."];
		break;
		case "Engineer-1":
			object = [	"Refurbishment",obj_heal_power,1,12,spr_heal_power_slot,
						PLACEABLENONE,SAME,
						"Heal a piece, and gives a slight speed boost."];
		break;
		case "Engineer-2":
			object = [	"Forceful Grasp",obj_net_power,2,50,spr_net_slot,
						PLACEABLENONE,PLACEABLEANY,
						"Displace any piece."];
		break;
		case "Engineer-3":
			object = [	"Destroy",obj_horde_power,3,160,spr_horde_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Use all bullets in your chamber to deal massive damage to the enemy defenses."];
		break;
		default:
			object = [	"debug_power",obj_debug_piece,1,2,spr_generic_slot,
						SAME,PLACEABLENONE,
						"tf"];
		break;
	}
	if trait >= 0 { return object[trait]; } else { return object; }
}
}