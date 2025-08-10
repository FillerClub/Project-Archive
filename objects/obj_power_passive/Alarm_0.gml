var heroString = "",
her = noone;
with obj_generic_hero {
	if team == other.team {
		her = self;
		heroString = identity + "-0";
	}
}

info = power_database(heroString);
sprite_index = info[POWERDATA.SLOTSPRITE];
desc = info[POWERDATA.DESCRIPTION];
//passive powers
switch her.identity {
	default:
		instance_create_layer((her.bbox_left +her.bbox_right)/2,her.bbox_top -20,"Instances",info[POWERDATA.OBJECT],{
			team: team
		});
	break;
}
