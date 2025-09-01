function draw_sprite_radial(_sprite, _subimg, _value, _x, _y, _xscale, _yscale, _color, _alpha, _flip = true, _uncrop = true) {
    // OPTIMIZATION: Early exit for invisible elements
    if (_alpha <= 0 || _value <= 0) return;
    
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
    // OPTIMIZATION: Early exits and reduced calculations
    if (_value <= 0) return;
    
    // OPTIMIZATION: Set primitive state once at the beginning
    gpu_push_state();
    gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
    
    if (_value >= 1) {
        // Full circle - optimized path
        draw_primitive_begin_texture(pr_trianglelist, _tex);
        draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
        draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
        draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        
        draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
        draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
        draw_primitive_end();
        
        gpu_pop_state();
        return;
    }
    
    // Partial circle - optimized calculations
    var _mx = (_x1 + _x2) * 0.5;  // Slightly faster than division
    var _my = (_y1 + _y2) * 0.5;
    
    draw_primitive_begin_texture(pr_trianglelist, _tex);
    draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
    draw_vertex_texture_color(_mx, _y1, 0.5, 0, _color, _alpha);
    
    // OPTIMIZATION: Pre-calculate thresholds to avoid repeated divisions
    var threshold_1_8 = 0.125;
    var threshold_3_8 = 0.375;
    var threshold_5_8 = 0.625;
    var threshold_7_8 = 0.875;
    
    // Corner vertices based on direction
    if (_flip) {
        // Clockwise direction
        if (_value >= threshold_1_8) {
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
        }
        if (_value >= threshold_3_8) {
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        }
        if (_value >= threshold_5_8) {
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
        }
        if (_value >= threshold_7_8) {
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
        }
        
        // OPTIMIZATION: Pre-calculate direction values
        var _dir = (_value * 2 + 1) * pi;
        var _dx = sin(_dir);
        var _dy = cos(_dir);        
    } else {
        // Counter-clockwise direction (original)
        if (_value >= threshold_1_8) {
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y1, 1, 0, _color, _alpha);
        }
        if (_value >= threshold_3_8) {
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x2, _y2, 1, 1, _color, _alpha);
        }
        if (_value >= threshold_5_8) {
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y2, 0, 1, _color, _alpha);
        }
        if (_value >= threshold_7_8) {
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
            draw_vertex_texture_color(_mx, _my, 0.5, 0.5, _color, _alpha);
            draw_vertex_texture_color(_x1, _y1, 0, 0, _color, _alpha);
        }
        
        var _dir = (_value * 2 - 0.5) * pi;
        var _dx = cos(_dir);
        var _dy = sin(_dir);
    }
    
    // OPTIMIZATION: Normalize only when necessary
    var _dmax = max(abs(_dx), abs(_dy));
    if (_dmax < 1) {
        _dx /= _dmax;
        _dy /= _dmax;
    }
    
    // Final vertex calculation
    _dx = (1 + _dx) * 0.5;  // Slightly faster than division
    _dy = (1 + _dy) * 0.5;
    
    draw_vertex_texture_color(
        lerp(_x1, _x2, _dx),
        lerp(_y1, _y2, _dy),
        _dx, _dy, _color, _alpha
    );
    
    draw_primitive_end();
    gpu_pop_state();
}