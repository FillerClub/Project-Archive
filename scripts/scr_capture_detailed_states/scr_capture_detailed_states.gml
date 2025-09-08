function capture_detailed_state() {
    var state = {
        resources: {
            friendly_turns: global.friendly_turns,
            enemy_turns: global.enemy_turns,
			max_turns: global.max_turns,
        },
        pieces: [],
        bullets: [],
        heroes: []
    };
    
    // Capture pieces with precise data
    with (obj_obstacle) {
		var pushStruct = {
            tag: tag,
			hp: hp,
            team: team,
        };
		if object_is_ancestor(object_index,obj_generic_piece) {
			pushStruct.grid_pos = grid_pos;
			pushStruct.piece_on_grid = piece_on_grid;
			pushStruct.timer = timer;
			pushStruct.move_cooldown_timer = move_cooldown_timer;
			pushStruct.z = z;
		}
        array_push(state.pieces, pushStruct);
    }
    
    // Capture bullets
    with (obj_bullet_parent) {
        array_push(state.bullets, {
            x: x,
            y: y,
            x_vel: x_vel,
			y_vel: y_vel,
			team: team,
        });
    }
    
    // Capture heroes
    with (obj_generic_hero) {
        array_push(state.heroes, {
            hp: hp,
            team: team
        });
    }
    
    return state;
}