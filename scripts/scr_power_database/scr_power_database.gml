enum POWERDATA {
ALL = -1,					// Everything
NAME = 0,					// String
OBJECT = 1,					// Obj Asset
COST = 2,					// Integer
SLOTSPRITE = 3,				// Spr Asset
PLACEMENTONGRID = 4,		// Macro
PLACEMENTONPIECE = 5,		// Macro
DESCRIPTION = 6,			// String
}

function power_database(name, trait = -1){
with obj_power_database {
	switch name {
		// Warden's Powers
		case "Warden-passive":
			object = [	"Aegis Bloom",obj_aegis_bloom_passive,0,spr_aegis_bloom_passive,
						PLACEABLEANY,PLACEABLEANY,
						"When a wall breaks, it emits a powerful burst of energy that vaporizes any piece in its lane."];
		break;
		case "Warden-a":
			object = [	"Shield",obj_shield_power,1,spr_generic_power_1,
						PLACEABLENONE,PLACEABLEANY,
						"Gives 5 additional health."];
		break;
		case "Warden-b":
			object = [	"Poison",obj_fizz_power,1,spr_fizz_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Splashes enemies, slowing and poisoning them"];
		break;
		case "Warden-c":
			object = [	"Super boost",obj_supercharge_power,1,spr_supercharge_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Supercharges your pieces in a 3x3 area."];
		break;
		// Empress' Powers
		case "Empress-passive":
			object = [	"Lust of Wrath",obj_lust_of_wrath_passive,0,spr_lust_of_wrath_passive,
						PLACEABLEANY,PLACEABLEANY,
						"Breaking down walls gives your pieces a permanent speed boost."];
		break;
		case "Empress-a":
			object = [	"Forceful Grasp",obj_net_power,0,spr_net_slot,
						PLACEABLENONE,PLACEABLEANY,
						"Displace any piece."];
		break;
		case "Empress-b":
			object = [	"Poison",obj_fizz_power,1,spr_fizz_slot,
						PLACEABLEANY,PLACEABLEANY,
						"Splashes enemies, slowing and poisoning them"];
		break;
		case "Empress-c":
			object = [	"Horde Summon",obj_horde_power,1,spr_horde_slot,
						SAME,PLACEABLENONE,
						"Summons a massivehorde of crawlers."];
		break;
		default:
			object = [	"debug_power",obj_debug_piece,1,spr_generic_slot,
						SAME,PLACEABLENONE,
						"tf"];
		break;
	}
	if trait >= 0 { return object[trait]; } else { return object; }
}
}