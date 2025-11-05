audio_play_sound(snd_pick_up,0,0);
instance_create_layer(x,y,"Instances",obj_spr_particle, {
	sprite_index: spr_delete
});
var 
isNewUnlocked = true,
isHeroNewUnlocked = true,
isNewDiscovered = true,
isNewLoadout = true,
arUnlocked = global.unlocked_pieces,
heroUnlocked = global.unlocked_heroes,
arLoadout = global.loadout,
arLengthUnlocked = array_length(arUnlocked),
arLengthLoadout = array_length(arLoadout),
heroLengthUnlocked = array_length(heroUnlocked);

for (var i = 0; i < arLengthUnlocked; i++) {
	if identity == arUnlocked[i] {
		isNewUnlocked = false;	
		break;
	}
}
for (var ii = 0; ii < heroLengthUnlocked; ii++) {
	if hero_unlock == heroUnlocked[ii] {
		isHeroNewUnlocked = false;
		break;
	}
}
for (var iii = 0; iii < arLengthLoadout; iii++) {
	if identity == arLoadout[iii] {
		isNewLoadout = false;
		break;
	}
}

if isNewUnlocked {
	array_push(global.unlocked_pieces,identity);	
}
if isNewLoadout && arLengthLoadout < global.max_slots {
	//array_push(global.loadout,identity);	
}
if isHeroNewUnlocked && is_string(hero_unlock) {
	array_push(global.unlocked_heroes,hero_unlock);
}
discover_piece(identity);

with obj_world_one {
	phase = VICTORY;
	timer = 0;
}
