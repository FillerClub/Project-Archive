#macro MAIN 0
#macro LEVELSTART 1
#macro FINALWAVE 1000
#macro HEROBATTLEEND 99
#macro VICTORY 9999
level = global.level;
graphic_show = -1;

// Responsible for graphics
graphic_timer = time_source_create(time_source_global,2.5,time_source_units_seconds,function() {
	graphic_show = -1;
},[],1,time_source_expire_after);

timer = 0;


var piecePush = noone;
// Push new pieces to discovered pieces array
switch level[1] {
	case 2:
		piecePush = "drooper";
	break;
	case 3:
		piecePush = "tank_crawler";
	break;
	case 4:
	break;
	case 5:
		piecePush = "jumper";
	break;
}

discover_piece(piecePush);
//phase = 3;