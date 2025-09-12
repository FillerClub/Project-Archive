// Host sends detailed state periodically for micro-corrections
function send_detailed_state_sync() {
    var detailed_state = capture_detailed_state();
    
    var sync_packet = {
        Message: SEND.DETAILED_STATE_SYNC,
        tick: tick_count,
        detailed_state: detailed_state,
        hash: calculate_state_hash()
    };
    
    steam_bounce(sync_packet);
}