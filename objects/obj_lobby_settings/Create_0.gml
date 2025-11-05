// obj_lobby_settings - Simplified game settings manager

// Settings (persisted in lobby)
settings = {
    // Map selection
    map: 1,                         // 1-5 for different maps

    // Game rules
    max_slots: 6,                   // Loadout slots (also determines bans)
    max_pieces: infinity,           // Max pieces that can be placed
    enable_bans: true,              // Enable ban phase
    barrier_criteria: 4,            // Barrier win condition
    timer_up_length: 15,            // Timer upgrade interval

    // Queue settings
    queue_rotation: QUEUE_ROTATION.LOSERS_MOVE  // How to rotate queue after match
};

// Setting constraints
setting_constraints = {
    map: { min: 1, max: 5, type: "int" },
    max_slots: { min: 3, max: 10, type: "int" },
    max_pieces: { min: 1, max: infinity, type: "int" },
    enable_bans: { type: "bool" },
    barrier_criteria: { min: 1, max: 10, type: "int" },
    timer_up_length: { min: 5, max: 120, type: "int" },
    queue_rotation: { min: 0, max: 3, type: "int" }
};

// HOST ONLY: Update setting
function set_setting(_key, _value) {
    if (!obj_lobby_controller.is_host) return false;

    if (!variable_struct_exists(settings, _key)) return false;
    if (!validate_setting(_key, _value)) return false;

    var old_value = settings[$ _key];
    settings[$ _key] = _value;

    // Apply side effects
    apply_setting_effect(_key, _value, old_value);

    // Sync to lobby
    sync_setting(_key, _value);

    // Broadcast to all
    steam_bounce({
        Message: SEND.SETTINGS_UPDATE,
        key: _key,
        value: _value
    });

    return true;
}

// Validate setting
function validate_setting(_key, _value) {
    if (!variable_struct_exists(setting_constraints, _key)) return true;

    var constraint = setting_constraints[$ _key];

    switch (constraint.type) {
        case "int":
            if (!is_numeric(_value)) return false;
            _value = floor(_value);
            if (variable_struct_exists(constraint, "min") && _value < constraint.min) return false;
            if (variable_struct_exists(constraint, "max") && _value > constraint.max) return false;
            break;

        case "bool":
            if (!is_bool(_value) && !is_numeric(_value)) return false;
            break;
    }

    return true;
}

// Apply setting side effects
function apply_setting_effect(_key, _new_value, _old_value) {
    switch (_key) {
        case "map":
            global.map = _new_value;
            break;

        case "max_slots":
            global.max_slots = _new_value;
            // Recalculate ban rounds if in ban phase
            if (instance_exists(obj_phase_manager) && obj_phase_manager.current_phase == LOBBY_PHASE.BANS) {
                obj_phase_manager.total_ban_rounds = floor(_new_value / 3);
            }
            break;

        case "enable_bans":
            // Skip ban phase if disabled
            if (!_new_value && instance_exists(obj_phase_manager) && obj_phase_manager.current_phase == LOBBY_PHASE.BANS) {
                obj_phase_manager.transition_to_phase(LOBBY_PHASE.LOADOUTS);
            }
            break;
    }
}

// Sync single setting to Steam lobby
function sync_setting(_key, _value) {
    steam_lobby_set_data(_key, string(_value));
}

// Sync all settings
function sync_all_settings() {
    if (!obj_lobby_controller.is_host) return;

    var keys = variable_struct_get_names(settings);
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        sync_setting(key, settings[$ key]);
    }
}

// Get setting
function get_setting(_key, _default = undefined) {
    if (variable_struct_exists(settings, _key)) {
        return settings[$ _key];
    }
    return _default;
}

// CLIENT: Load settings from Steam lobby
function load_settings_from_lobby() {
    var keys = variable_struct_get_names(settings);

    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        var value = steam_lobby_get_data(key);

        if (value != "") {
            var constraint = setting_constraints[$ key];
            if (variable_struct_exists(constraint, "type")) {
                switch (constraint.type) {
                    case "int":
                        value = real(value);
                        break;
                    case "bool":
                        value = (value == "1" || value == "true");
                        break;
                }
            }

            settings[$ key] = value;
            apply_setting_effect(key, value, undefined);
        }
    }
}

// CLIENT: Receive setting update
function receive_setting_update(_key, _value) {
    if (variable_struct_exists(settings, _key)) {
        var old_value = settings[$ _key];
        settings[$ _key] = _value;
        apply_setting_effect(_key, _value, old_value);
    }
}

// Apply settings to globals (for game start)
function apply_to_globals() {
    global.map = settings.map;
    global.max_slots = settings.max_slots;
    global.max_pieces = settings.max_pieces;
    global.enable_bans = settings.enable_bans;
    global.barrier_criteria = settings.barrier_criteria;
    global.timeruplength = settings.timer_up_length;

    global.max_turns = 6;
    global.friendly_turns = 4;
    global.enemy_turns = 4;
}

// Get map room
function get_map_room() {
    switch (settings.map) {
        case 1: return rm_level_normal;
        case 2: return rm_level_small;
        case 3: return rm_level_split;
        case 4: return rm_level_conveyor;
        case 5: return rm_level_heights;
        default: return rm_level_normal;
    }
}

// Reset to defaults (only when creating new lobby)
function reset_to_defaults() {
    settings.map = 1;
    settings.max_slots = 6;
    settings.max_pieces = infinity;
    settings.enable_bans = true;
    settings.barrier_criteria = 4;
    settings.timer_up_length = 15;
    settings.queue_rotation = QUEUE_ROTATION.LOSERS_MOVE;
}

// Get ban count based on max_slots
function get_ban_count() {
    return floor(settings.max_slots / 3);
}
