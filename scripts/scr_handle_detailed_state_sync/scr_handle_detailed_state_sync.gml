function handle_detailed_state_sync(packet) {
    var differences = compare_states_detailed(packet.hash, packet.detailed_state);
    handle_state_differences(differences);
}

