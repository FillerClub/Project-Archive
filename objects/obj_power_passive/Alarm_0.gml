var heroString = "";
with obj_generic_hero {
	if team == other.team {
		heroString = identity + "-passive";
	}
}

info = power_database(heroString);
sprite_index = info[POWERDATA.SLOTSPRITE];
desc = info[POWERDATA.DESCRIPTION];
instance_create_layer(room_width/2,room_height/2,"Instances",info[POWERDATA.OBJECT],{
	team: team
});