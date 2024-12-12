image_xscale = .5;
image_yscale = .5;

var spread_reduce = .25,
rand = random_range(-16,16);
y_vel = spread_reduce*rand/16
x_vel = 1 -abs(rand/16)*spread_reduce