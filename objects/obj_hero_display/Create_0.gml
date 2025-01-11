unlocked_heroes = global.unlocked_heroes;
identity = global.active_hero;
index = 0;

for (var i = 0; i < array_length(unlocked_heroes); i++) {
	if identity == unlocked_heroes[i] {
		index = i;
		break;
	}
}