audio_play_sound(snd_pick_up,0,0);
instance_create_layer(x,y,"Instances",obj_spr_particle, {
	sprite_index: spr_delete
});
var 
isNew = true,
arUnlocked = global.unlocked_pieces,
arLength = array_length(arUnlocked);

for (var i = 0; i < arLength; i++) {
	if identity == arUnlocked[i] {
		isNew = false;	
	}
}

if isNew {
	array_push(global.unlocked_pieces,identity);	
}

with obj_world_one {
	phase = FINAL;
}