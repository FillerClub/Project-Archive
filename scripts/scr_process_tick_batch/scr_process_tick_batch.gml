function process_tick_batch(tick_actions) {
    var results = [],
	verbose = global.verbose_debug;
    // Phase 1: Validate each action individually
    var validated_actions = [];
    for (var i = 0; i < array_length(tick_actions); i++) {
        var action = tick_actions[i];
        var validation = validate_action(action);
        if validation.valid {
            array_push(validated_actions, action);
        } else {
            // Mark as rejected
            action.result = "rejected";
            action.rejection_reason = validation.reason;
            array_push(results, action);
            if verbose {
                show_debug_message("  REJECTED: " + action.action_type + " - " + validation.reason);
            }
        }
    }
    // Phase 2: Resolve conflicts between valid actions
    var resolved_actions = validated_actions;//resolve_conflicts(validated_actions);
	
    // Phase 3: Execute resolved actions
    for (var i = 0; i < array_length(resolved_actions); i++) {
        var action = resolved_actions[i];
        action.result = "success";
		array_push(requests,action);
		array_push(action_history,{action: action, time_stamp: action.time_stamp})
        array_push(results, action);
        if verbose {
            show_debug_message("  EXECUTED: " + action.action_type);
        }
    }
    return results;
}