x = obj_cursor.x;
y = obj_cursor.y;

released = false;

data = piece_database(identity);
slot_index = data[$ "slot_sprite"];
frame_color = data[$ "class"];
cost = data[$ "place_cost"];