function handle_authoritative_actions(packet) {
    if (!instance_exists(obj_online_battle_handler)) {
        exit;    
    }
    handle_prediction_results(packet);
}