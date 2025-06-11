switch room {
	case rm_sandbox:
	case rm_debug_room:
		deal_with_level([0,0]);
	break;
	default:
		deal_with_level(global.level);	
	break;
}