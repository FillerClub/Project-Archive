switch progress {
	case 0:
		sprite_index = spr_intro_1;
	break;
	case 1:
		sprite_index = spr_aura
	break;
}
draw_self();
draw_text_scribble(room_width/2,room_height/2,image_alpha)
