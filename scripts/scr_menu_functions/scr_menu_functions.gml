// Contexts
//#macro MAIN 0 (ALREADY ON LEVEL PIECEDATA.OBJECT)
#macro PAUSE 1
#macro JOURNAL 2
#macro POSTLEVELJOURNAL 3
// Main menu functions
#macro FIRSTMENU ["Singleplayer","Settings","Journal","Exit Game"]
#macro SINGLEPLAYERMENU ["Campaign","Sandbox","Back"]
#macro MULTIPLAYERMENU ["Join Lobby","Create Lobby","Back"]
#macro SETTINGSMENU ["Data","Music","Cursor","FPS","Display","Debug","Back"]
#macro DISPLAYMENU ["3840x2160","2560x1440","1920x1080","1280x720","640x360","Fullscreen","Back"]
// Pause menu functions
#macro FIRSTPAUSE ["Resume","Restart Level","Settings","Back to Title","Exit Game"]
#macro SETTINGSPAUSE ["Music","Cursor","FPS","Display","Debug","Back"]
// Journal menu functions
#macro ONPIECEJOURNAL ["Back to Title"]

function menu_function(purpose = "Back",contextArg = context){
	//Play sound 
	switch contextArg {
		case PAUSE:
			audio_play_sound(snd_phone_select,0,0);	
		break;
		default:
			audio_play_sound(snd_error,0,0);
		break;	
	}
	
	//Journal Base function
	switch contextArg {
		case JOURNAL:
		case POSTLEVELJOURNAL:
			journal_piece_create(purpose);
		break;
	}	
	
	switch purpose {
		case "Singleplayer":
			progress_menu(1,SINGLEPLAYERMENU);
		break;
		
		case "Campaign":
		case "Continue":
			instance_create_layer(room_width - 80, room_height - 80, "GUI",obj_loading, {
				run: "Lvl",
				load: [track1,track2,track3,track4,standalone_soundtracks]
			});
		break;
		
		case "Journal":
			instance_create_layer(room_width - 80, room_height - 80, "GUI",obj_loading, {
				run: "Journal",
				load: [standalone_soundtracks]
			});
		break;
		
		case "Sandbox":
			instance_create_layer(room_width - 80, room_height - 80, "GUI",obj_loading, {
				run: "Sandbox",
				load: [standalone_soundtracks]
			});
		break;

		case "Multiplayer":
			if global.name != "" {
				progress_menu(1,MULTIPLAYERMENU);					
			}
		break;

		case "Exit Game":
			game_end();
		break;
		
		case "Join Lobby":
			if instance_exists(obj_client) { instance_destroy(obj_client); }
			instance_create_layer(0,672,"GUI",obj_client);
		break;
		
		case "Create Lobby":
			if instance_exists(obj_client) { instance_destroy(obj_client); }
			instance_create_layer(0,672,"GUI",obj_client);

		break;
		
		case "Settings":
			switch contextArg {
				case MAIN:
					progress_menu(1,SETTINGSMENU);
				break;
				default:
					progress_menu(1,SETTINGSPAUSE);
				break;
			}

		break;
		
		case "Manage Profile":
			instance_create_layer(x,y,"GUI",obj_profile_manager);
		break;
		
		case "Debug":
			global.debug = global.debug?false:true;
		break;
		
		case "FPS":
			global.fps_target = clamp(int64(string_digits(get_integer_async("Enter Desired FPS", 60))),0,999);
			if global.fps_target != "" {
				game_set_speed(global.fps_target,gamespeed_fps);
				save(PROFILE);
			}			
		break;
		
		case "Fullscreen":
			if window_get_fullscreen() == true {
				global.fullscreen = false;
				window_set_fullscreen(false);	
			} else {
				global.fullscreen = true;
				window_set_fullscreen(true);	
			}
			save(PROFILE);
		break;
		
		case "Data":
			if file_exists(SAVEFILE) {
				file_delete(SAVEFILE);
				global.level = [1,1];
				global.tutorial_progress = 0;
				global.unlocked_pieces = ["shooter"];
				global.discovered_pieces = ["shooter","crawler"];
				global.unlocked_heroes = ["Warden"];
				audio_play_sound(snd_explosion,0,0);
			}
			if global.debug && file_exists(PROFILE) {
				global.difficulty = 0;
				file_delete(PROFILE);
				initialize_variables(true);
				audio_play_sound(snd_game_end,0,0);
			}
			obj_menu.savefile_exists = file_exists(SAVEFILE);
			obj_menu.profile_exists = file_exists(PROFILE);
		break;
		
		case "Music":
			global.music_volume = clamp(int64(string_digits(get_integer_async("Enter Volume", 50))),0,100)/100;
			if global.music_volume != "" {
			// Save Profile Data
				save(PROFILE);
			}
		break;
		
		case "Cursor":
			global.cursor_sens = clamp(int64(string_digits(get_integer_async("Enter Sensitivity", 3))),0.5,10);

			if global.cursor_sens != "" {
			// Save Profile Data
				save(PROFILE);
			}
		break;
		
		case "Display":
			progress_menu(1,DISPLAYMENU);			
		break;
		
		case "3840x2160":
			screen_resize(3840,2160);
		break;
		case "2560x1440":
			screen_resize(2560,1440);
		break;
		case "1920x1080":
			screen_resize(1920,1080);
		break;		
		case "1280x720":
			screen_resize(1280,720);
		break;
		case "640x360":
			screen_resize(640,360);
		break;
		case "256x144":
			screen_resize(256,144);
		break;
		
		default:
			progress_menu(-1);
		break;
		
		// PAUSE
		case "Resume":
			instance_destroy(obj_menu);
			instance_destroy(obj_button);
			audio_stop_sound(snd_phone_select);
			pause_game(true);
		break;
		
		case "Back to Title":
			room_goto(rm_setup);
		break;
		
		case "Restart Level":
			room_restart();
			global.pause = false;
		break;
		
		case "View Journal":

		break;
	}
}