function store_executed_actions(tick, actions) {
    // Store copy of executed actions for potential resync
    ds_map_set(executed_actions_history, tick, variable_clone(actions));
    
    // Clean up old history (keep last 100 ticks)
    var cleanup_tick = tick - 100;
    if (ds_map_exists(executed_actions_history, cleanup_tick)) {
        ds_map_delete(executed_actions_history, cleanup_tick);
    }
}