var heroString = "",
out = true;
with obj_generic_hero {
	if team == other.team {
		heroString = identity + "-" +string(other.index);
		out = false;
	}
}

if out { alarm[0] = 1; exit; }
var info = power_database(heroString);
cost = info[POWERDATA.COST];
cooldown_length = info[POWERDATA.SLOTCOOLDOWN];
sprite_slot = info[POWERDATA.SLOTSPRITE];
desc = info[POWERDATA.DESCRIPTION];
identity = heroString;
tag = heroString;
if index != 1 {
	cooldown = cooldown_length;
}