var gS = GRIDSPACE;
event_inherited();

// shoot
if global.game_state != PAUSED {
	if (timer >= timer_end) {
		var scannedPiece = scan_for_enemy(true,100,true,infinity);
		var zOff = z;
		if instance_exists(piece_on_grid) {
			zOff += piece_on_grid.z;	
		}
		if instance_exists(scannedPiece) {
			var distMod = sqrt(max(distance_to_object(scannedPiece),GRIDSPACE)/GRIDSPACE)*.1;
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?2.2:-2.2)*distMod,
			target: scannedPiece,
			z: zOff,
			lob_height: random_percent(max(512*distMod,32),10),
			});
		}
		timer = 0;
		timer_end = random_percent(.014,4);
	}
}
