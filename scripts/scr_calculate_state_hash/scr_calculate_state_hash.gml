function calculate_state_hash() {
    var state_string = "";
    
    // Critical game state
    state_string += string(global.friendly_turns) + "|";
    state_string += string(global.enemy_turns)
    
    // Pieces - sorted for consistency
    var pieces_list = ds_list_create();
    with (obj_generic_piece) {
        var piece_info = string(grid_pos[0]) + "," + string(grid_pos[1]) + "," + 
                        string(hp) +"," +string(tag);
        ds_list_add(pieces_list, piece_info);
    }
    ds_list_sort(pieces_list, true);
    
    for (var i = 0; i < ds_list_size(pieces_list); i++) {
        state_string += ds_list_find_value(pieces_list, i) + "|";
    }
    ds_list_destroy(pieces_list);
    
	/*
    // Bullets - sorted for consistency
    var bullets_list = ds_list_create();
    with (obj_bullet_parent) {
        var bullet_info = string(floor(x)) + "," + string(floor(y)) + "," + team;
        ds_list_add(bullets_list, bullet_info);
    }
    ds_list_sort(bullets_list, true);
    
    for (var i = 0; i < ds_list_size(bullets_list); i++) {
        state_string += ds_list_find_value(bullets_list, i) + "|";
    }
    ds_list_destroy(bullets_list);
    */
    // Heroes
    var heroes_list = ds_list_create();
    with (obj_generic_hero) {
        var hero_info = string(hp) + "," + team;
        ds_list_add(heroes_list, hero_info);
    }
    ds_list_sort(heroes_list, true);
    
    for (var i = 0; i < ds_list_size(heroes_list); i++) {
        state_string += ds_list_find_value(heroes_list, i) + "|";
    }
    ds_list_destroy(heroes_list);
    
    return md5_string_unicode(state_string);
}