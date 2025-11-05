// obj_lobby_controller - Room End Event

// Reset in_level flag when leaving game room
if (instance_exists(obj_lobby_settings) && room != obj_lobby_settings.get_map_room()) {
    in_level = false;
}
