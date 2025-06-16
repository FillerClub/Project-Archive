switch room {
	case rm_sandbox:
		deal_with_level([0,0]);
	break;
	case rm_multiplayer:
	case rm_debug_room:
		deal_with_level([0,1]);
	break;
	default:
	
		deal_with_level(global.level);	
	break;
}