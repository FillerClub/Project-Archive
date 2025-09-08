function request_detailed_comparison() {
    var request = {
        Message: SEND.REQUEST_DETAILED_STATE,
        client_id: obj_preasync_handler.steam_id
    };
    steam_relay_data(request);
}