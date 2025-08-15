function can_place_on_grid(grid_team, piece_team, mode) {
    switch (mode) {
        case SAME:            return (grid_team == piece_team);
        case NEUTRAL:         return (grid_team == piece_team || grid_team == "neutral");
        case PLACEABLENONE:   return false;
        default:              return true;
    }
}

function can_place_on_piece(px, py, piece_team, mode) {
    var inst = noone;
    switch (mode) {
        case SAME:
            inst = instance_position(px, py, obj_generic_piece);
            return (inst == noone || inst.team == piece_team);

        case DIFFERENT:
            inst = instance_position(px, py, obj_generic_piece);
            return (inst == noone || inst.team != piece_team);

        case PLACEABLEANY:
            return position_meeting(px, py, obj_generic_piece);

        case PLACEABLENONE:
            return !position_meeting(px, py, obj_obstacle);

        default:
            return true;
    }
}

function play_place_sound() {
    select_sound(snd_put_down);
}