info = refer_database(identity);

sprite_slot = info[SLOTSPRITE];
cost = info[PLACECOST];
class = info[CLASS];

x_init = x;
y_init = y;
x_inc = random_range(-.25,.25);
y_inc = random_range(-.25,.25);