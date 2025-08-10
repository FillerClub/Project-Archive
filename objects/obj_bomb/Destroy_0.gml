audio_play_sound(snd_bomb_explode,0,0);
var ar_leng = array_length(aura);
// For each move available (i)
for (var i = 0; i < ar_leng; ++i) {
	var xM = aura[i][0]*GRIDSPACE +x +GRIDSPACE/2;
	var yM = aura[i][1]*GRIDSPACE +y +GRIDSPACE/2;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if position_meeting(xM,yM,obj_grid) {
		repeat(20){
			part_particles_burst(global.part_sys,xM,yM,part_explode);		
		}
		// And if coords collide with obstacle/piece, draw RED. Else...
		if position_meeting(xM,yM,obj_obstacle) {
			var pC = instance_position(xM,yM,obj_obstacle);
			if z_collide(self,pC,4) {
				hurt(pC.hp,attack_power,pC);
			}
		} 	
	}			
}