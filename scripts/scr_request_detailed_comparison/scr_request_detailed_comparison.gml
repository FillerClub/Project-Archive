function request_detailed_comparison() {
    var request = {
        Message: SEND.REQUEST_RESYNC,
        client_id: obj_preasync_handler.steam_id,
		resync_severity: 0,
    };
    steam_relay_data(request);
	show_debug_message("Requested state sync");
}