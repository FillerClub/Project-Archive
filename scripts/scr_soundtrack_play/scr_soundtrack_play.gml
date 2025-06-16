#macro GETOUTOFMYWAY 0 
#macro GETOUTOFMYWAYFULL 0.5 
#macro BATTLE 1 
#macro LOOKINGBACK 2
#macro MENUMUSIC 3
function soundtrack_play(track) {
	with obj_audio_handler {
		// Load Music
		switch track {
			case BATTLE:
				audio_play_sound_on(soundtrack_emitter,msc_battle_bob,1,1,1);
			break;
			case GETOUTOFMYWAY:
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_bass,1,1,1);
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_melody,1,1,1);
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_chords,1,1,1);
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_percs,1,1,1);
				audio_group_set_gain(track3,0,0);
				audio_group_set_gain(track4,0,0);
				audio_group_set_gain(track2,0,0);
				audio_group_set_gain(track2,1,10000);	
			break;
			case GETOUTOFMYWAYFULL:
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_bass,1,1,1);
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_melody,1,1,1);
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_chords,1,1,1);
				audio_play_sound_on(soundtrack_emitter,msc_getoutofmyway_percs,1,1,1);
				audio_group_set_gain(track3,1,0);
				audio_group_set_gain(track4,1,0);
				audio_group_set_gain(track2,0,0);
				audio_group_set_gain(track2,1,10000);	
			break;
			case LOOKINGBACK:
				audio_play_sound_on(soundtrack_emitter,msc_beauty_in_recollection,1,1,1);
			break;
			case MENUMUSIC:
				audio_play_sound_on(soundtrack_emitter,msc_menu_music,1,1,1);
			break;
		}
	}
}