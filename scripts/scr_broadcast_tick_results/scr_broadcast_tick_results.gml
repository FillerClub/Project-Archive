function broadcast_tick_results(tick, results) {
    var packet = {
        Message: SEND.TICK_RESULTS,
        actions: results
    };
	if global.verbose_debug {
        show_debug_message("Broadcasting " + string(array_length(results)) + " results");
    }
	steam_bounce(packet);
}