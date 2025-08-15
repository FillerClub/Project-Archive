info = piece_database(identity);

sprite_slot = info[$ "slot_sprite"];
cost = info[$ "place_cost"];
class = info[$ "class"];

x_init = x;
y_init = y;
x_inc = random_range(-.25,.25);
y_inc = random_range(-.25,.25);