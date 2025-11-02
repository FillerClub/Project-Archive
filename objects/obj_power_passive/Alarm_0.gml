var heroString = "",
her = noone;
with obj_generic_hero {
	if team == other.team {
		her = self;
		heroString = identity + "-0";
	}
}
if !instance_exists(her) {
	exit;	
}
info = power_database(heroString);
sprite_index = info[POWERDATA.SLOTSPRITE];
desc = info[POWERDATA.DESCRIPTION];
tag = heroString;
//passive powers
switch her.identity {
	default:
		var obj = info[POWERDATA.OBJECT];
		instance_create_layer((her.bbox_left +her.bbox_right)/2,her.bbox_top -20,"Instances",obj,{
			team: team,
			tag: heroString +"-object",
		});
	break;
}
