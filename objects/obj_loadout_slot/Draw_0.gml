var drawcost = (identity != "Empty")?cost:"",
drawslot = (identity != "Empty")?spr_slot_frame:spr_slot_frame_empty,
markValid = false;
draw_slot(slot_index,frame_color,c_white,drawcost,drawslot);
with obj_hero_display {
	var ar = hero_database(identity,HERODATA.CLASSES);
	var arLength = array_length(ar);
	for (var i = 0; i < arLength; i++) {
		if other.frame_color == ar[i] {
			markValid = true;	
		}
	}		
}
if !markValid && identity != "Empty" {
	draw_sprite(spr_cant_slot,0,x+2,y+2);
}
if instance_exists(obj_ready) {
	if obj_ready.ready {
		draw_sprite(spr_slot_lock,0,x,y);	
	}
}