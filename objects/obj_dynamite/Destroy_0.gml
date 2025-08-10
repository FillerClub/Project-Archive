audio_play_sound(snd_bomb_explode,0,0);
var ar_leng = array_length(aura);
// For each move available (i)
for (var i = 0; i < ar_leng; ++i) {
	var xM = aura[i][0]*GRIDSPACE +x +GRIDSPACE/2;
	var yM = aura[i][1]*GRIDSPACE +y +GRIDSPACE/2;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if position_meeting(xM,yM,obj_grid) {
		repeat(20){
			part_particles_burst(global.part_sys,xM,yM -z,part_explode);		
		}
		if position_meeting(xM,yM,obj_obstacle) {
			var pC = instance_position(xM,yM,obj_obstacle);
			if z_collide(self,pC,4) {
				effect_generate(pC,EFFECT.FIRE,"Fire",5,1);
			}
		} 	
	}			
}
if !shot {
	exit;	
}
repeat 15 {
	var
	angle = random(360),
	xV = cos(angle),
	yV = sin(angle);	
	instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth,obj_bullet_parent, {
	team: "neutral",
	x_vel: xV*1.5,
	y_vel: yV*1.5,
	z: z,
	image_xscale: .5,
	image_yscale: .5,
	});		
}
