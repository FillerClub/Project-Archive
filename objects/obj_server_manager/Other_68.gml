var buffer = async_load[? "buffer"];
buffer_seek(buffer, buffer_seek_start,0);
process_packet_server(buffer);
