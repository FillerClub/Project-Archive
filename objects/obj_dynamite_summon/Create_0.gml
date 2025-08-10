var targetX = -1,
targetY = undefined;

with obj_generic_hero {
	if team == other.team {
		targetX = x;
		targetY = y;
	}
}
x += GRIDSPACE*random(.5);
y += GRIDSPACE*random(.5);
var grid = instance_position(x,y,obj_grid),
b = x -targetX,
a = y -targetY,
angle = abs(arctan(a/b)),
xV = cos(angle)*sign(b),
yV = sin(angle)*sign(a);	

if !is_undefined(targetY) {
	if instance_exists(grid) z = grid.z;
	var distMod = sqrt(max(distance_to_point(targetX,targetY),GRIDSPACE)/GRIDSPACE)*.1;
	instance_create_depth(targetX,targetY,depth -GRIDSPACE/2,obj_dynamite,{
		x_target: x,
		y_target: y,
		z_target: z,
		lob_height: 260,
		team: team,	
		target: id,
		z: 80,
		x_vel: xV*distMod,
		y_vel: yV*distMod
	});
}

