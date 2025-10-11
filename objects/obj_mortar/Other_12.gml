var gS = GRIDSPACE;
var scannedPiece = scan_for_enemy(true,100,true,infinity);
var zOff = z;
var gridOff = piece_on_grid;
if is_string(gridOff) {
	with obj_grid {
		if tag == gridOff {
			zOff += z;
			break;
		}
	}
} else if instance_exists(gridOff) { zOff += gridOff.z; }
if instance_exists(scannedPiece) {
	var distMod = sqrt(max(distance_to_object(scannedPiece),GRIDSPACE)/GRIDSPACE)*.1;
	instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
	team: team,	
	x_vel: ((team == "friendly")?2:-2)*distMod,
	target: scannedPiece,
	z: zOff,
	lob_height: random_percent(max(1024*distMod,32),10),
	dmg: 4,
	image_xscale: 2,
	image_yscale: 2,
	// Splash
	on_destroy: function() {
		static aura =	[[0, 1],
						[0, -1],
						[1, 0],
						[1, 1],
						[1, -1],
						[-1, 0],
						[-1, 1],
						[-1, -1]],
		ar_leng = array_length(aura),
		relX = x,
		relY = y;
		// For each move available (i)
		if instance_exists(object_hit) {
			relX = object_hit.x;
			relY = object_hit.y;
		}
		for (var i = 0; i < ar_leng; ++i) {
			var xM = aura[i][0]*GRIDSPACE +relX +GRIDSPACE/2;
			var yM = aura[i][1]*GRIDSPACE +relY +GRIDSPACE/2;		
			// If coords within move array are on the grid; 0 = x, 1 = y
			if position_meeting(xM,yM,obj_obstacle) {
				var pC = instance_position(xM,yM,obj_obstacle);
				if z_collide(self,pC,2) {
					hurt(pC.hp,1.5,DAMAGE.NORMAL,pC);
				}
			} 				
		}								
	}
	});
}
timer -= timer_end;
timer_end = random_percent(3.6,4);