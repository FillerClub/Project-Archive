
if parent {
	var gS = GRIDSPACE;
	audio_play_sound(snd_zap,0,0);
	instance_create_layer(x,y -gS,"AboveBoard",obj_stun_power, {
		parent: false	
	})
	instance_create_layer(x,y +gS,"AboveBoard",obj_stun_power, {
		parent: false	
	})
}