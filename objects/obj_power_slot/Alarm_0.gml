var heroString = "";
with obj_generic_hero {
	if team == other.team {
		heroString = identity + "-" +other.identity;
	}
}

info = power_database(heroString);
cost = info[POWERDATA.COST];
sprite_slot = info[POWERDATA.SLOTSPRITE];
desc = info[POWERDATA.DESCRIPTION];