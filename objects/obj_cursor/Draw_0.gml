// Set cursor sprite
window_set_cursor(cr_none);
draw_self();

// Tooltip
if tooltip_string != "" && global.game_state != PAUSED && global.tooltips_enabled {
    var margin = 3;
	draw_set_font(fnt_bit);
    draw_set_halign(tooltip_flip == 1 ? fa_left : fa_right);
    draw_set_valign(fa_middle);
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(x, y, x + (tooltip_width + margin * 2) * tooltip_flip, y - tooltip_height - margin, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text_scribble(x + margin * tooltip_flip, y - margin - 4, tooltip_string);
}