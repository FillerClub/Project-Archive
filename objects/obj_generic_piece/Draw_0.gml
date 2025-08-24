/// @desc Generic piece draw code
var tM = (team == "enemy")?-1:1,
colS = c_white,
col = team_colours(team),
sPD = effects_array[EFFECT.SPEED],
sLW = effects_array[EFFECT.SLOW];

var zBase = 0;
if instance_exists(piece_on_grid) {
	zBase = piece_on_grid.z;	
}
var
xFlip = (1 -toggle*2)*tM,
xScale = (1 +ai_timer/(TIMETOTAKE*2))*xFlip,
yScale = (1 +ai_timer/(TIMETOTAKE*2)),
tick = invincible_tick,
zOff = zBase +z;

var origXoffset = sprite_xoffset,
origYoffset = sprite_yoffset,
shadowSize = 1/(max(0,log2(z/64 +.5)) +1);
// Draw shadow
draw_sprite_ext(spr_shadow,0,x +sprite_width/2,y +sprite_height -(z/1.5)*shadowSize -zBase, 1, shadowSize, 0, c_white, shadowSize);
if layer_sequence_exists("Instances",animation) {
	var anim = layer_sequence_get_instance(animation),
	animTracks = anim.activeTracks,
	tracks = array_length(animTracks);
	for (var t = 0; t < tracks; t++) {
		piece_draw_components(animTracks[t],zOff,abs(xScale),yScale,col,tick);
	}	
} else {
	// Draw the sprite at a shifted origin to make flipping easier
	sprite_set_offset(sprite_index,sprite_width/2 +sprite_xoffset,sprite_height/2 +sprite_yoffset);
	// Draw sprite
	draw_sprite_ext(sprite_index,image_index,x +sprite_width/2,y +sprite_height/2 -zOff,xScale,yScale,0,col,tick);
	sprite_set_offset(sprite_index,origXoffset,origYoffset);
}
// Draw cooldown timer
if move_cooldown_timer > 0 {
	scr_draw_circle_part(x +sprite_width/2 -origXoffset, y +sprite_height -4 -origYoffset -zOff,16,timer_color,false,180,false,0,(360*move_cooldown_timer)/move_cooldown,.6);
}
/*
// Draw the sprite at a shifted origin to make flipping easier
sprite_set_offset(sprite_index,sprite_width/2 +sprite_xoffset,sprite_height/2 +sprite_yoffset);
// Draw sprite
draw_sprite_ext(sprite_index,image_index,x +sprite_width/2,y +sprite_height/2 -zOff,xScale,yScale,0,col,invincible_tick);
sprite_set_offset(sprite_index,origXoffset,origYoffset);
*/
draw_set_font(fnt_bit);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
// Draw speed arrows
if sPD > 0 {
	if sPD < 5 {
		for (var i = 0; i < sPD; ++i) {
			draw_sprite_ext(spr_boosted,0,x,y -i*7 +5 -zOff,1,1,0,c_white,clamp(sPD -i,0,1));		
		}
	} else {
		draw_sprite_ext(spr_boosted,0,x,y -zOff,1,1,0,c_white,1);
		draw_text_scribble(x,y -zOff,string(floor(sPD/5) +1) + "x ");
	}
}
// Draw slow arrows
if sLW > 0 {
	if sLW < 5 {
		for (var i = 0; i < sLW; ++i) {
			draw_sprite_ext(spr_slowed,0,x,y +i*7 +5 -zOff,1,1,0,c_white,clamp(sLW -i,0,1));			
		}
	} else {
		draw_sprite_ext(spr_slowed,0,x,y -zOff,1,1,0,c_white,1);
		draw_text_scribble(x,y -zOff,string(floor(sLW/5) +1) + "x ");
	}
}

image_speed = 1 +sprite_accel*9;

if global.game_state != PAUSED {
	moved = false;
	skip_click = false;
}
/*

draw_text(x,y,hp);
draw_text(x,y +16,hp_max);
//draw_text(x,y,last_damaged);
/*
draw_set_color(#32E3FF);
draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,false);
draw_text(x,y -8,string(id));
//draw_text_scribble(x,y -16,piece_on_grid);

draw_text(x,y+64,string(effects_array));
draw_text(x,y+80,string(effects_timer));
for (var temp = 0; temp < array_length(effects_management_array); temp++) {
	draw_text(x,y+96 +16*temp,string(effects_management_array[temp]));
}

