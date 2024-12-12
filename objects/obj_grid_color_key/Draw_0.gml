var drawCol = c_black;
switch tip {
	case "Attack only":
		drawCol = c_red;
	break;
	case "Move only":
		drawCol = c_aqua;
	break;
	default:
		drawCol = c_white;
	break;
}

draw_sprite_ext(spr_grid_highlight,image_index,x,y,image_xscale,image_yscale,0,drawCol,image_alpha);
draw_set_font(fnt_tiny);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text_transformed(x +sprite_width*2*image_xscale +8,y +sprite_height/2,string(tip),1,1,0);