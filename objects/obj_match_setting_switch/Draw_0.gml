draw_set_font(fnt_basic);
draw_set_color(c_white);
draw_set_valign(fa_middle);
draw_set_halign(fa_center);
draw_self();
var drawValue = string(setting_value);
switch setting {
	case "Show Opponent's Picks": drawValue = (drawValue)?"True":"False"; break;
	case "Time Until Timer Upgrade": drawValue = drawValue +" seconds"; break;
	case "Max Pieces": if drawValue == infinity { drawValue = "No limit"; } break;
}
draw_text(x +sprite_width/2,y +sprite_height/2,string(setting) +": " +drawValue);