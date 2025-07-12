function write_data_buffer(buffer,data_type,data) {
	// Data index
	buffer_write(buffer, buffer_u8,data_type);
	// Write appropriate buffer based on index
	switch data_type {
		case REMOTEDATA.NAME:
		case REMOTEDATA.HERO:
			buffer_write(buffer,buffer_string,data);
		break;
		case REMOTEDATA.LOADOUT:
			buffer_write(buffer,buffer_string,json_stringify(data))
		break;
		case REMOTEDATA.PORT:
			buffer_write(buffer,buffer_u16,data);
		break;
		case REMOTEDATA.STATUS:
		case REMOTEDATA.MAXSLOTS:
		case REMOTEDATA.SHOWSLOTS:
		case REMOTEDATA.BARRIER:
		case REMOTEDATA.TIMELENGTH:
		default:
			buffer_write(buffer,buffer_u8,data);
		break;
		case REMOTEDATA.MAXPIECES:
			buffer_write(buffer,buffer_u8,clamp(data,0,255));
		break;
	}
}

function read_data_buffer(buffer,data_type) {
	var re = false;
	switch data_type {
		case REMOTEDATA.NAME:
		case REMOTEDATA.HERO:
			re = buffer_read(buffer,buffer_string);
		break;
		case REMOTEDATA.LOADOUT:
			re = json_parse(buffer_read(buffer,buffer_string));
		break;
		case REMOTEDATA.STATUS:
			re = buffer_read(buffer,buffer_u8);
		break;
		case REMOTEDATA.PORT:
			re = buffer_read(buffer,buffer_u16);
		break;
		case REMOTEDATA.END:
			//re = buffer_read(buffer,buffer_u8);
		break;
		default:
			re = buffer_read(buffer,buffer_u8);
		break;
	}		
	return re;
}