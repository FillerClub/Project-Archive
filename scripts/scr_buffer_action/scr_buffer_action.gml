function buffer_action(action) {
    // Determine target tick (current + processing delay)
    var target_tick = current_tick;
    if global.verbose_debug {
        show_debug_message("Buffering action for tick " + string(target_tick) + ": " + action.action_type);
    }
    // Get or create array for this ticks
    if !ds_map_exists(action_buffer, target_tick) {
        action_buffer[? target_tick] = [];
    }
    var tick_actions = action_buffer[? target_tick];
    array_push(tick_actions, action);
    action_buffer[? target_tick] = tick_actions;
}