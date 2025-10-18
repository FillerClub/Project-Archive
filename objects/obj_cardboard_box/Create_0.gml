override_color = c_white;
destroyed = false;

x_init = x;
y_init = y;
x_inc = random_range(-.5,.5);
y_inc = random_range(-.25,.25);
death_timer = 0;
o_depth = depth;
override_color = c_white;

image_index = irandom(3);

y_spd = -3;
y_spd_max = -6;
rotation_speed = sign_random(random_range(270,360*2));
bounces = 0;
degrade = 2;


/*
for (var s = 0; s < stack; s++) {
	instance_create_depth(x,y,o_depth,obj_shield,{
		z: z +(s +1)*12,
		stack: 0,
		parent: id,
	});	
}