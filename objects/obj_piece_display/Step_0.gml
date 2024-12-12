switch identity {
	case "bishop":
		bishop_move_handler();
	break;
	
	case "drooper":
		drooper_move_handler();
	break;
	
	case "short":
		short_shooter_move_handler();
	break;
	
	default:
	break;
}
