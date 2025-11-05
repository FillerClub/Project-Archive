// rm_match_menu - Room Creation Code
// Initialize the new lobby system

// Initialize lobby controller (replaces obj_client_manager)
if (!instance_exists(obj_lobby_controller)) {
    var controller = instance_create_depth(0, 0, 0, obj_lobby_controller);
    controller.initialize();
}

// Create UI components
if (!instance_exists(obj_lobby_status_ui)) {
    instance_create_depth(0, 0, 0, obj_lobby_status_ui);
}

if (!instance_exists(obj_ban_ui)) {
    instance_create_depth(0, 0, 0, obj_ban_ui);
}

show_debug_message("Lobby system initialized");
