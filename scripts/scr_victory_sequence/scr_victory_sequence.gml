// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function victory_sequence(start_phase, new_level) {
	if (phase == start_phase) {
		//Increment
		phase = min(phase +1,start_phase +1);
		timer[VICTORY] = 5;
		global.level = new_level;
		audio_play_sound(snd_happy_wheels_victory,0,0);
		save(SAVEFILE);
		with obj_game {
			enable_pausing = false;	
		}
		return true;	
	}
}