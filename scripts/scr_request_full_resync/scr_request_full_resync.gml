function request_full_resync() {
    var request = {
        Message: SEND.REQUEST_RESYNC,
        client_id: obj_preasync_handler.steam_id,
        tick: tick_count
    };
    steam_relay_data(request);
    show_debug_message("Requested full state resync");
}