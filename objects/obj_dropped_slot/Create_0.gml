info = piece_database(identity);

sprite_slot = info[PIECEDATA.SLOTSPRITE];
cost = info[PIECEDATA.PLACECOST];
class = info[PIECEDATA.CLASS];

x_init = x;
y_init = y;
x_inc = random_range(-.25,.25);
y_inc = random_range(-.25,.25);