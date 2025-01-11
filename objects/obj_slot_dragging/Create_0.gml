x = obj_cursor.x;
y = obj_cursor.y;

released = false;

data = piece_database(identity);
slot_index = data[PIECEDATA.SLOTSPRITE];
frame_color = data[PIECEDATA.CLASS];
cost = data[PIECEDATA.PLACECOST];