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
		case "Warden-passive":
			object = [	"Aegis Bloom",obj_aegis_bloom_passive,0,0,spr_aegis_bloom_passive,
						PLACEABLEANY,PLACEABLEANY,
						"When a wall breaks, it emits a powerful burst of energy that vaporizes any piece in its lane."];
		break;
		case "Warden-a":
			object = [	"Refurbishment",obj_heal_power,5,12,spr_heal_power_slot,
						PLACEABLENONE,SAME,
						"Heal a piece, and gives a slight speed boost."];
		break;
		case "Warden-b":
			object = [	"Meet your maker",obj_light_ray_power,10,45,spr_light_beam_slot,
						PLACEABLENONE,DIFFERENT,
						"Deal 10 damage."];
		break;
		case "Warden-c":
			object = [	"Super boost",obj_supercharge_power,15,100,spr_supercharge_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Supercharges your pieces in a 3x3 area."];
		break;
		// Empress' Powers
		case "Empress-passive":
			object = [	"Lust of Wrath",obj_lust_of_wrath_passive,1,0,spr_lust_of_wrath_passive,
						PLACEABLEANY,PLACEABLEANY,
						"Breaking down walls give your pieces a permanent speed boost."];
		break;
		case "Empress-a":
			object = [	"Poison",obj_fizz_power,5,17,spr_fizz_slot,
						PLACEABLENONE,DIFFERENT,
						"Lob poison at an enemy, deal splash damage."];
		break;		
		case "Empress-b":
			object = [	"Forceful Grasp",obj_net_power,10,50,spr_net_slot,
						PLACEABLENONE,PLACEABLEANY,
						"Displace any piece."];
		break;
		case "Empress-c":
			object = [	"Big guy call",obj_horde_power,15,160,spr_horde_slot,
						SAME,PLACEABLEANY,
						"Summons two big guys. For fun."];
		break;
		// Lonestars' Powers
		case "Lonestar-passive":
			object = [	"Fire at will",obj_constant_reload,1,13.5,spr_lust_of_wrath_passive,
						PLACEABLEANY,PLACEABLEANY,
						"Your powers use ammo. Ammo recharges overtime."];
		break;
		case "Lonestar-a":
			object = [	"Intimidate",obj_horde_power,5,2.5,spr_horde_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Fire a warning shot, stunning pieces briefly."];
		break;
		case "Lonestar-b":
			object = [	"Infiltrate",obj_horde_power,10,35,spr_horde_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Lob dynamite onto the board. Can be shot to detonate early."];
		break;
		case "Lonestar-c":
			object = [	"Destroy",obj_horde_power,15,65,spr_horde_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Use all bullets in your chamber to deal massive damage to the enemy defenses."];
		break;
		// Engineer's Powers
		case "Engineer-passive":
			object = [	"Aegis Bloom",obj_aegis_bloom_passive,0,0,spr_aegis_bloom_passive,
						PLACEABLEANY,PLACEABLEANY,
						"When a wall breaks, it emits a powerful burst of energy that vaporizes any piece in its lane."];
		break;
		case "Engineer-a":
			object = [	"Refurbishment",obj_heal_power,5,12,spr_heal_power_slot,
						PLACEABLENONE,SAME,
						"Heal a piece, and gives a slight speed boost."];
		break;
		case "Engineer-b":
			object = [	"Forceful Grasp",obj_net_power,10,50,spr_net_slot,
						PLACEABLENONE,PLACEABLEANY,
						"Displace any piece."];
		break;
		case "Engineer-c":
			object = [	"Destroy",obj_horde_power,15,160,spr_horde_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Use all bullets in your chamber to deal massive damage to the enemy defenses."];
		break;
		default:
			object = [	"debug_power",obj_debug_piece,1,10,spr_generic_slot,
						SAME,PLACEABLENONE,
						"tf"];
		break;
	}
	if trait >= 0 { return object[trait]; } else { return object; }
}
}