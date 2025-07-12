// Contexts
//#macro MAIN 0 (ALREADY ON LEVEL PIECEDATA.OBJECT)
#macro PAUSE 1
#macro JOURNAL 2
#macro POSTLEVELJOURNAL 3
// Main menu functions
#macro FIRSTMENU ["Singleplayer","Multiplayer","Settings","Journal","Edit Loadout","Exit Game"]
#macro SINGLEPLAYERMENU ["Campaign","Sandbox","Back"]
#macro MULTIPLAYERMENU ["SERVER MODE","Connect to Server","Back"]
#macro SERVERMODECONFIRM ["YES SERVER MODE","No"]
#macro MULTIPLAYERSETTINGSMENU ["Set Name","Back"]
#macro SETTINGSMENU ["Multiplayer Settings","Audio","Display","Cursor","Data","Debug","Back"]
#macro DEBUGMENU ["Debug Mode","Unlock Everything","Debug Room 1","Debug Room 2","Back"]
#macro HUDSETTINGSMENU ["Tooltips","Healthbars","Back"]
#macro AUDIOSETTINGSMENU ["Master","SFX","Music","Back"]
#macro DISPLAYMENU ["3840x2160","2560x1440","1920x1080","1280x720","HUD","FPS","Fullscreen","Back"]
// Pause menu functions
#macro FIRSTPAUSE ["Resume","Restart Level","Settings","Back to Title","Exit Game"]
#macro SETTINGSPAUSE ["Audio","Display","HUD","Cursor","Debug","Back"]
// Journal menu functions
#macro ONPIECEJOURNAL ["Back to Title"]

function menu_function(purpose = "Back",contextArg = context){
	//Play sound 
	switch contextArg {
		case PAUSE:
			audio_play_sound(snd_phone_select,0,0);	
		break;
		case MAIN:	
			audio_stop_sound(snd_main_selected);
			audio_play_sound(snd_main_selected,0,0);
		break;
		default:
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
		default:
			save_file(PROFILE);
			//Reset FPS Target
			game_set_speed(max(global.fps_target,30),gamespeed_fps);
			// Delete stray text entries
			instance_destroy(obj_text_entry);
			progress_menu(-1);
		break;
		// Main menu
		case "Singleplayer":
			progress_menu(1,SINGLEPLAYERMENU);
		break;
		case "Multiplayer":
			if global.name != "" {
				progress_menu(1,MULTIPLAYERMENU);					
			} else {
				create_system_message(["Create a name in the multiplayer settings first."],BOTTOM);	
			}
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
		case "Journal":
			var lD = {
				run: "Journal",
				rm: rm_journal,
				load: [standalone_soundtracks]
			};
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;
		case "Edit Loadout":
			var lD = {
				run: "Loadout",
				rm: rm_loadout_zone,
				load: [standalone_soundtracks]	
			}
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;
		case "Exit Game":
			game_end();
		break;
		// Singleplayer menu
		case "Campaign":
		case "Continue":
			var lD = {
				run: "Lvl",
				rm: rm_world_one,
				load: [track1,track2,track3,track4,standalone_soundtracks]
			};
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;	
		case "Sandbox":
			var lD = {
				run: "Sandbox",
				rm: rm_sandbox,
				load: [standalone_soundtracks]	
			}
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;
		// Multiplayer menu
		case "SERVER MODE":
			create_system_message(["The game will be set up to host multiplayer games off of this machine. You cannot go back after turning on server mode. Are you sure you want to continue?"],BOTTOM);
			progress_menu(1,SERVERMODECONFIRM);
		break;
		case "YES SERVER MODE":
			var lD = {
				run: "Server Host",
				rm: rm_server
			}
			start_transition(sq_circle_out,sq_circle_in,lD);			
		break;
		case "Connect to Server":
			if global.game_state != TRANSITIONING {
				progress_menu(1,[]);
				instance_create_layer(x,y,"Instances",obj_client_manager);					
			}
		break;
		// Main game prompts
		case "Resume":
			instance_destroy(obj_menu);
			instance_destroy(obj_button);
			audio_stop_sound(snd_phone_select);
			pause_game(true);
		break;
		case "Back to Title":
			var lD = {
				run: "MainMenu",
				rm: rm_main_menu,
				load: [standalone_soundtracks]
			}
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;
		case "Restart Level":
			var lD = {
				run: "default",
				rm: room,
				load: [track1,track2,track3,track4,standalone_soundtracks,sound_effects]
			};
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;		
		// Settings
		case "Multiplayer Settings":
			progress_menu(1,MULTIPLAYERSETTINGSMENU);					
		break;
		// Debug Settings
		case "Debug":
			progress_menu(1,DEBUGMENU);	
		break;
		case "Debug Mode":
			global.debug = global.debug?false:true;
		break;
		case "Unlock Everything":
			global.unlocked_heroes = ["Warden","Empress","Lonestar","Engineer"];
			global.unlocked_pieces = EVERYTHING;
			global.discovered_pieces = global.unlocked_pieces;
			audio_play_sound(snd_happy_wheels_victory,0,0);
			save_file(SAVEFILE);
		break;
		case "Debug Room 1":
			var lD = {
				run: "Multiplayer",
				rm: rm_multiplayer,
				load: [track1,track2,track3,track4]	
			}
			start_transition(sq_circle_out,sq_circle_in,lD);			
		break;
		case "Debug Room 2":
			var lD = {
				run: "Multiplayer",
				rm: rm_debug_room,
				load: [track1,track2,track3,track4]	
			}
			start_transition(sq_circle_out,sq_circle_in,lD);			
		break;
		case "Fullscreen":
			if window_get_fullscreen() == true {
				global.fullscreen = false;
				window_set_fullscreen(false);	
			} else {
				global.fullscreen = true;
				window_set_fullscreen(true);	
			}
			save_file(PROFILE);
		break;
		case "Data":
			if file_exists(SAVEFILE) {
				file_delete(SAVEFILE);
				global.level = [1,1];
				global.tutorial_progress = 0;
				global.unlocked_pieces = ["shooter","wall","bishop","crawler","drooper","jumper","tank_crawler","super_tank_crawler","the_goliath","bomber"];
				global.discovered_pieces = ["shooter","crawler"];
				global.loadout = ["shooter"];
				global.unlocked_heroes = ["Warden"];
				global.active_hero = "Warden";
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
		case "Audio":
			progress_menu(1,AUDIOSETTINGSMENU);
		break;
		case "HUD":
			progress_menu(1,HUDSETTINGSMENU);
		break;
		case "Tooltips":
			global.tooltips_enabled = global.tooltips_enabled?false:true;
		break;
		case "Healthbars":
			global.healthbar_config++;
			if global.healthbar_config > HEALTHBARCONFIG.SHOWALL {
				global.healthbar_config = HEALTHBARCONFIG.HIDEALL;
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
		case "Set Name":
			if instance_exists(obj_text_entry) {
				instance_destroy(obj_text_entry);	
			} else {
				instance_create_layer(x,y,"GUI",obj_text_entry);	
			}
		break;
		// Misc
		SLIDERS
		break;
		case "DEBUG ROOM":
			var lD = {
				run: "default",
				rm: rm_debug_room,
				load: [track1,track2,track3,track4,standalone_soundtracks,sound_effects]
			};
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;
	}
}