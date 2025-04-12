if priority != 0 {
	exit;	
}

var
textHeight = scribble_object[text_index].get_height(),
origDFM = (room_width/2 -o_x)/room_width/2,
anchorY = ((verticle_pos == BOTTOM)?room_height -sprite_height/2 -GUI_MARGIN:sprite_height/2 +GUI_MARGIN),
flipY = ((verticle_pos == BOTTOM)?-1:1),
lerpX = lerp(o_x,room_width/2,lerp_var),
lerpY = lerp(o_y,anchorY,lerp_var),
lerpWidth = lerp(1,(room_width -GUI_MARGIN*2)/sprite_width,lerp_var),
lerpHeight = max(sprite_height/2,textHeight),
textX = lerpX -lerpWidth*sprite_width/2 +GUI_MARGIN,
textY = lerpY -sprite_height/2 +GUI_MARGIN/2;




if draw_tail {
	draw_bezier_improved([lerpX-10,lerpX-10,o_x],[lerpY,lerpY +(lerpHeight +256*abs(origDFM))*flipY,o_y],12,3,bubble_color,1,[lerpX+10,lerpX+10,o_x],[lerpY,lerpY +(lerpHeight +256*abs(origDFM))*flipY,o_y],true,bubble_color);
}
draw_sprite_ext(spr_speech_bubble,image_index,lerpX,lerpY,lerpWidth,lerpHeight/(sprite_height/2),0,bubble_color,1);
draw_set_color(text_color);
draw_set_font(font);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
scribble_object[text_index].draw(textX +GUI_MARGIN/2,textY,typist);

draw_set_valign(fa_bottom);
var buttonPromptText = "Continue";
var wid = string_width_scribble(buttonPromptText);
draw_set_color(text_color);
draw_text_scribble(lerpX +lerpWidth/2*sprite_width -wid -GUI_MARGIN/2,lerpY +lerpHeight,buttonPromptText)

var spriteDraw = spr_action_x;
if input_source_using(INPUT_KEYBOARD) {
	spriteDraw = spr_action_mouse_button;	
}
if input_source_using(INPUT_GAMEPAD) {
	spriteDraw = spr_action_a;
}

draw_sprite_ext(spriteDraw,image_index,lerpX +lerpWidth/2*sprite_width -wid -GUI_MARGIN/2 -16,lerpY +lerpHeight -16,scale,scale,0,c_white,1);