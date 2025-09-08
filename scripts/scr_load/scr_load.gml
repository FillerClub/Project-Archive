function load_file(FILE){
switch (FILE) {
        case SAVEFILE:
            if (file_exists(SAVEFILE)) {
                var buff = -1;
                var load_data = undefined;
                
                try {
                    // Buffer operations with error checking
                    buff = buffer_load(SAVEFILE);
                    if (buff == -1) {
                        show_debug_message("Error: Failed to load save file buffer");
                        break;
                    }
                    
                    buffer_seek(buff, buffer_seek_start, 0);
                    var strng = buffer_read(buff, buffer_string);
                    buffer_delete(buff);
                    buff = -1; // Mark as deleted
                    
                    // Validate string data
                    if (is_undefined(strng) || strng == "") {
                        show_debug_message("Error: Save file contains no data");
                        break;
                    }
                    
                    // JSON parsing with error handling
                    load_data = json_parse(strng);
                    if (is_undefined(load_data)) {
                        show_debug_message("Error: Failed to parse save file JSON");
                        break;
                    }
                    
                    // Validate array structure
                    if (!validate_array_data(load_data, 0)) {
                        show_debug_message("Error: Invalid save file structure");
                        break;
                    }
                    
                    var save_data = load_data[0];
                    
                    // Safe assignment with fallbacks
                    global.level = get_safe_value(save_data, "level", [1,1]);
                    global.tutorial_progress = get_safe_value(save_data, "tutorial_progress", 0);
                    global.unlocked_pieces = get_safe_value(save_data, "unlocked_pieces", ["shooter"]);
                    global.unlocked_heroes = get_safe_value(save_data, "unlocked_heroes", ["Warden"]);
                    global.loadout = get_safe_value(save_data, "loadout", ["shooter","Empty","Empty","Empty","Empty","Empty"]);
                    global.active_hero = get_safe_value(save_data, "active_hero", "Warden");
                    global.discovered_pieces = get_safe_value(save_data, "discovered_pieces", ["shooter","crawler"]);
                    
                    show_debug_message("Save file loaded successfully");
                    
                } catch (e) {
                    show_debug_message("Exception while loading save file: " + string(e));
                    // Clean up buffer if it exists
                    if (buff != -1) {
                        buffer_delete(buff);
                    }
                }
            } else {
                show_debug_message("Save file does not exist, using defaults");
                // Set default values
                global.level = [1,1];
                global.tutorial_progress = 0;
                global.unlocked_pieces = ["shooter"];
                global.unlocked_heroes = ["Warden"];
                global.loadout = ["shooter","Empty","Empty","Empty","Empty","Empty"];
                global.active_hero = "Warden";
                global.discovered_pieces = ["shooter","crawler"];
            }
            break;
            
        case PROFILE:
            if (file_exists(PROFILE)) {
                var buff = -1;
                var load_data = undefined;
                
                try {
                    // Buffer operations with error checking
                    buff = buffer_load(PROFILE);
                    if (buff == -1) {
                        show_debug_message("Error: Failed to load profile buffer");
                        break;
                    }
                    
                    buffer_seek(buff, buffer_seek_start, 0);
                    var strng = buffer_read(buff, buffer_string);
                    buffer_delete(buff);
                    buff = -1; // Mark as deleted
                    
                    // Validate string data
                    if (is_undefined(strng) || strng == "") {
                        show_debug_message("Error: Profile file contains no data");
                        break;
                    }
                    
                    // JSON parsing with error handling
                    load_data = json_parse(strng);
                    if (is_undefined(load_data)) {
                        show_debug_message("Error: Failed to parse profile JSON");
                        break;
                    }
                    
                    // Validate array structure
                    if (!validate_array_data(load_data, 0)) {
                        show_debug_message("Error: Invalid profile structure");
                        break;
                    }
                    
                    var profile_data = load_data[0];
                    
                    // Safe assignment with fallbacks and validation
                    global.master_volume = clamp(get_safe_value(profile_data, "master_volume", .5), 0.0, 1.0);
                    global.sfx_volume = clamp(get_safe_value(profile_data, "sfx_volume", .5), 0.0, 1.0);
                    global.music_volume = clamp(get_safe_value(profile_data, "music_volume", .5), 0.0, 1.0);
                    global.cursor_sens = clamp(get_safe_value(profile_data, "cursor_sens", 3), 0.1, 5.0);
                    global.fps_target = clamp(get_safe_value(profile_data, "fps_target", 60), 30, 240);
                    global.screen_res = get_safe_value(profile_data, "screen_res", [1280,720]);
                    global.fullscreen = get_safe_value(profile_data, "fullscreen", false);
                    global.difficulty = clamp(get_safe_value(profile_data, "difficulty", 0), 1, 99);
                    global.first_boot = get_safe_value(profile_data, "first_boot", true);
                    global.tooltips_enabled = get_safe_value(profile_data, "tooltips_enabled", true);
                    global.healthbar_config = get_safe_value(profile_data, "healthbar_config", HEALTHBARCONFIG.ONHIT);
					global.debug = get_safe_value(profile_data, "debug", false);
                    
                    show_debug_message("Profile loaded successfully");
                    
                } catch (e) {
                    show_debug_message("Exception while loading profile: " + string(e));
                    // Clean up buffer if it exists
                    if (buff != -1) {
                        buffer_delete(buff);
                    }
                }
            } else {
                show_debug_message("Profile does not exist, using defaults");
                // Set default profile values
                global.master_volume = .5;
                global.sfx_volume = .5;
                global.music_volume = .5;
                global.cursor_sens = 3;
                global.fps_target = 60;
                global.screen_res = [1280,720];
                global.fullscreen = false;
                global.difficulty = 0;
                global.first_boot = true;
                global.tooltips_enabled = true;
                global.healthbar_config = HEALTHBARCONFIG.ONHIT;
				global.debug = false;
            }
            break;
            
        default:
            show_debug_message("Warning: Unknown file type passed to load_file: " + string(FILE));
            break;
    }
}

// Helper function to validate and get a value with fallback
function get_safe_value(data, key, fallback) {
    if (is_undefined(data) || !variable_struct_exists(data, key)) {
        return fallback;
    }
    var value = variable_struct_get(data, key);
    return is_undefined(value) ? fallback : value;
}
// Helper function to validate array data
function validate_array_data(arr, index) {
    return (is_array(arr) && array_length(arr) > index && !is_undefined(arr[index]));
}