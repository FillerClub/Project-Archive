time_source_destroy(timer);
time_source_destroy(graphic_timer);
if time_source_exists(queue_text_timer) {
	time_source_destroy(queue_text_timer);
}

ChatterboxStop(chatterbox);