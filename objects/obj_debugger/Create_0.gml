debug_overlay = false;
debug_log = [];
max_log_entries = 100;

// Network simulation
sim_lag = 0;           // Additional lag in ms
sim_packet_loss = 0;   // 0-100% packet loss
sim_jitter = 0;        // Random delay variation

// Metrics tracking
prediction_accuracy = 0;
total_predictions = 0;
correct_predictions = 0;
rollback_count = 0;
desync_count = 0;

// State comparison
last_local_hash = "";
last_host_hash = "";
hash_mismatches = 0;

y_offset = 0;

fps_catch_timer = 0;
catch_average_fps = fps_real;
display_fps = fps_real;
iterations = 0;

show_all = false;
game_menu = false;
online_menu = false;