function write_data_buffer(buffer,data_type,data) {
	// Data index
	buffer_write(buffer, buffer_u8,data_type);
	// Write appropriate buffer based on index
	switch data_type {
		case DATA.NAME:
		case DATA.HERO:
			buffer_write(buffer,buffer_string,data);
		break;
		case DATA.LOADOUT:
			buffer_write(buffer,buffer_string,json_stringify(data))
		break;
		case DATA.ID:
			buffer_write(buffer,buffer_string,data);
		break;
		case DATA.STATUS:
		case DATA.MAXSLOTS:
		case DATA.SHOWSLOTS:
		case DATA.BARRIER:
		case DATA.TIMELENGTH:
		case DATA.MAP:
		default:
			buffer_write(buffer,buffer_u8,data);
		break;
		case DATA.MAXPIECES:
			buffer_write(buffer,buffer_u8,clamp(data,0,255));
		break;
	}
}

function read_data_buffer(buffer,data_type) {
	var re = false;
	switch data_type {
		case DATA.NAME:
		case DATA.HERO:
			re = buffer_read(buffer,buffer_string);
		break;
		case DATA.LOADOUT:
			re = json_parse(buffer_read(buffer,buffer_string));
		break;
		case DATA.STATUS:
			re = buffer_read(buffer,buffer_u8);
		break;
		case DATA.ID:
			re = buffer_read(buffer,buffer_u16);
		break;
		case DATA.END:
			//re = buffer_read(buffer,buffer_u8);
		break;
		default:
			re = buffer_read(buffer,buffer_u8);
		break;
	}		
	return re;
}