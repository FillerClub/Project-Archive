// Change lifespans of particles to keep consistency
var gameSpd = game_get_speed(gamespeed_fps)/global.level_speed;
part_type_life(dash_part, gameSpd*.3, gameSpd*.3);
part_type_life(bullet_part, gameSpd*.05, gameSpd*.05);