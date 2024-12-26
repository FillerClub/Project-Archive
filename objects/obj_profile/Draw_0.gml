draw_set_color(c_white);
draw_set_font(fnt_tiny);
draw_set_valign(fa_top);
draw_set_halign(hlign);


var off = 0,
off2 = 1,
maxHp = global.max_barriers,
iDamaged = false;


if hlign == fa_right {
	off = 32;
	off2 = -1;
}

draw_text(x +off,y,string(name));
for (var i = 0; i < maxHp; i++) {
	if i >= hp {
		iDamaged = true;	
	}
	draw_sprite(spr_base_hp,iDamaged,x +(i*(64+8))*off2 -off,y +24);
	if iDamaged {
		draw_sprite(spr_base_x,image_index,x +(i*(64+8))*off2 -off,y +24);
	}
}
/*




var hpClamp1 = clamp(hp -20,0,10)/10;
var hpClamp2 = clamp(hp -10,0,10)/10;
var hpClamp3 = clamp(hp,0,10)/10;

if hpClamp3 != 0 { draw_rectangle_color(x +off,y,x +(212*off2)*(hpClamp3) +off, y +32, c_red, c_red, c_red, c_red,0); }
if hpClamp2 != 0 { draw_rectangle_color(x +off,y,x +(212*off2)*(hpClamp2) +off, y +32, c_yellow, c_yellow, c_yellow, c_yellow,0); }
if hpClamp1 != 0 { draw_rectangle_color(x +off,y,x +(212*off2)*(hpClamp1) +off, y +32, c_green, c_green, c_green, c_green,0); }

