simulate_lag = false;
artificial_lag_ms = 0;
packet_loss_percent = 0;

packet_queue = ds_priority_create();

debug_log = [];
y_offset = 0;

fps_catch_timer = 0;
catch_average_fps = fps_real;
display_fps = fps_real;
iterations = 0;

menu = -1;