draw_slot(sprite_slot,class,c_white,cost);

//draw_text_transformed(x + sprite_width/2,y + sprite_height*1.2 +x,string(identity["name"]),.25,.25,0);

if position_meeting(obj_cursor.x,obj_cursor.y,self) { draw_sprite(spr_slot_highlight,image_index,x,y);	}