audio_play_sound(snd_pick_up,0,0);
instance_create_layer(x,y,"Instances",obj_spr_particle, {
	sprite_index: spr_delete
});
var 
isNewUnlocked = true,
isNewDiscovered = true,
arUnlocked = global.unlocked_pieces,
arDiscovered = global.discovered_pieces,
arLengthUnlocked = array_length(arUnlocked),
arLengthDiscovered = array_length(arDiscovered);

for (var i = 0; i < arLengthUnlocked; i++) {
	if identity == arUnlocked[i] {
		isNewUnlocked = false;	
	}
}

if isNewUnlocked {
	array_push(global.unlocked_pieces,identity);	
}

discover_piece(identity);

with obj_world_one {
	phase = VICTORY;
	timer = 0;
}