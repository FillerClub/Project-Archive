function special_slot_checks(){
	// Special power code 
	switch identity {
		// Ammo mechanics
		case "Lonestar-1":
		case "Lonestar-3":
			if instance_exists(obj_constant_reload) {
				if obj_constant_reload.ammo <= 0 {
					with obj_constant_reload {
						scr_error();	
						audio_stop_sound(snd_critical_error);
						audio_play_sound(snd_critical_error,0,0);								
					}
					return false;
				}
			} else {
				return false;
			}
		break;
	}
	return true;
}