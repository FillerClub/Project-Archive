switch room {
	case rm_sandbox:
	case rm_heights:
		deal_with_level([0,0]);
	break;
	default:
		deal_with_level([0,1]);
	break;
	case rm_server:
		// Do nothing
	break;
	case rm_world_one:
		deal_with_level(global.level);	
	break;
}