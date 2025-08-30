function draw_sprite_radial(_sprite, _subimg, _value, _x, _y, _xscale, _yscale, _color, _alpha, _flip = true, _uncrop = true) {
    var _x1, _y1, _x2, _y2;
    if (_uncrop) {
        var _ox = sprite_get_xoffset(_sprite);
        var _oy = sprite_get_yoffset(_sprite);
        _x1 = _x + _xscale * (sprite_get_bbox_left(_sprite) - _ox);
        _x2 = _x + _xscale * (sprite_get_bbox_right(_sprite) + 1 - _ox);
        _y1 = _y + _yscale * (sprite_get_bbox_top(_sprite) - _oy);
        _y2 = _y + _yscale * (sprite_get_bbox_bottom(_sprite) + 1 - _oy);
    } else {
        _x1 = _x - _xscale * sprite_get_xoffset(_sprite);
        _x2 = _x1 + _xscale * sprite_get_width(_sprite);
        _y1 = _y - _yscale * sprite_get_yoffset(_sprite);
        _y2 = _y1 + _yscale * sprite_get_height(_sprite);
    }
    draw_texture_radial(sprite_get_texture(_sprite, _subimg), _value, _x1, _y1, _x2, _y2, _color, _alpha, _flip);
}

function draw_texture_radial(_tex, _value, _x1, _y1, _x2, _y2, _color, _alpha, _flip = false) {
    if (_value <= 0) exit;
    if (_value >= 1) {
        draw_primitive_begin_texture(pr_trianglelist, _tex);
        draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
        repeat (2) {
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        }
        draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
        draw_primitive_end();
        exit;
    }
    
    // middle point:
    var _mx = (_x1 + _x2) / 2;
    var _my = (_y1 + _y2) / 2;
    draw_primitive_begin_texture(pr_trianglelist, _tex);
    draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
    draw_vertex_texture_color(_mx, _y1, 0.5, 0, _color, _alpha);
    
    // corners, each of these finishes the last triangle and starts a new one:
    if (_flip) {
        // Clockwise direction
        if (_value >= 1/8) {
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
        }
        if (_value >= 3/8) {
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        }
        if (_value >= 5/8) {
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
        }
        if (_value >= 7/8) {
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
        }
    } else {
        // Counter-clockwise direction (original)
        if (_value >= 1/8) {
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
        }
        if (_value >= 3/8) {
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
        }
        if (_value >= 5/8) {
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        }
        if (_value >= 7/8) {
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
            //
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
        }
    }
    
    // final vertex (towards value-angle):
	if _flip {
		var _dir = (_value * 2 +1)*pi;
	    var _dx = sin(_dir);
	    var _dy = cos(_dir);		
	} else {
		var _dir = (_value * 2 - 0.5)*pi;
	    var _dx = cos(_dir);
	    var _dy = sin(_dir);
	}
    // normalize:
    var _dmax = max(abs(_dx), abs(_dy));
    if (_dmax < 1) {
        _dx /= _dmax;
        _dy /= _dmax;
    }
    //
    _dx = (1 + _dx) / 2;
    _dy = (1 + _dy) / 2;
    draw_vertex_texture_color(
        lerp(_x1, _x2, _dx),
        lerp(_y1, _y2, _dy),
        _dx, _dy, _color, _alpha
    );
    draw_primitive_end();
}