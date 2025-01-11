enum HERODATA {
ALL = -1,					// Everything
NAME = 0,					// String
SPRITE = 1,					// Obj Asset
CLASSES = 2,				// Macro array
}

function hero_database(name, trait = -1) {
	var obj = [	HERODATA.NAME,HERODATA.SPRITE,HERODATA.CLASSES];
	switch name {
		case "Warden":
			obj = [	"Warden",spr_warden,[RANGECLASS,SUPPORTCLASS]];
		break;
		case "Empress":
			obj = [	"Empress",spr_empress,[WANDERCLASS,DEFENSECLASS]];
		break;
		case "Lonestar":
			obj = [	"Lonestar",spr_arthur_morgan,[RANGECLASS,EXPLOSIVECLASS]];
		break;
		default:
			obj = [	"debug",spr_generic_hero,[SUPPORTCLASS,DEFENSECLASS]];
		break;
	}
	if trait >= 0 { return obj[trait]; } else { return obj; }
}