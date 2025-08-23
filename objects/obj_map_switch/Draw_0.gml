switch global.map {
	case MAP.NORMAL: draw_sprite(spr_map_normal,0,x,y); break;
	case MAP.SMALL: draw_sprite(spr_map_small,0,x,y); break;
	case MAP.SPLIT: draw_sprite(spr_map_split,0,x,y); break;
	case MAP.MOVE: draw_sprite(spr_map_move,0,x,y); break;
}
if obj_client_manager.member_status == MEMBERSTATUS.HOST && !obj_ready.ready {
	draw_self();
}