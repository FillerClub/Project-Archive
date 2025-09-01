function add_shadow_data(_object, _shadow_size, _z_base) {
	var shadow_info = {
	    x: (_object.bbox_left + _object.bbox_right)/2,
	    y: _object.bbox_bottom -(_object.z/1.5) * _shadow_size - _z_base,
	    scale: _shadow_size,
	    alpha: _shadow_size
	};
	array_push(shadow_data, shadow_info);
}

function add_effect_data(_x, _y, _speed_level, _slow_level, _z_off) {
	// Speed arrows
	if (_speed_level > 0) {
	    if (_speed_level < 5) {
	        for (var i = 0; i < _speed_level; i++) {
	            var effect_info = {
	                sprite: spr_boosted,
	                x: _x,
	                y: _y - i*7 + 5 - _z_off,
	                scale: 1,
	                alpha: clamp(_speed_level - i, 0, 1),
	                type: "speed"
	            };
	            array_push(effect_data, effect_info);
	        }
	    } else {
	        var effect_info = {
	            sprite: spr_boosted,
	            x: _x,
	            y: _y - _z_off,
	            scale: 1,
	            alpha: 1,
	            type: "speed_multi",
	            multiplier: floor(_speed_level/5) + 1
	        };
	        array_push(effect_data, effect_info);
	    }
	}
	// Slow arrows  
	if (_slow_level > 0) {
	    if (_slow_level < 5) {
	        for (var i = 0; i < _slow_level; i++) {
	            var effect_info = {
	                sprite: spr_slowed,
	                x: _x,
	                y: _y + i*7 + 5 - _z_off,
	                scale: 1,
	                alpha: clamp(_slow_level - i, 0, 1),
	                type: "slow"
	            };
	            array_push(effect_data, effect_info);
	        }
	    } else {
	        var effect_info = {
	            sprite: spr_slowed,
	            x: _x,
	            y: _y - _z_off,
	            scale: 1,
	            alpha: 1,
	            type: "slow_multi",
	            multiplier: floor(_slow_level/5) + 1
	        };
	        array_push(effect_data, effect_info);
	    }
	}
}
	
function add_timer_data(_x, _y, _progress, _color) {
	var timer_info = {
		x: _x,
		y: _y, 
		progress: _progress,
		color: _color
	};
	array_push(timer_data, timer_info);
}

function render_shadow_batch() {
	if (array_length(shadow_data) == 0) return;
	// Build vertex buffer for all shadows
	vertex_begin(shadow_vb, global.render_vertex_format);
    
	var shadow_texture = sprite_get_texture(spr_shadow, 0);
	var shadow_uvs = sprite_get_uvs(spr_shadow, 0);
    
	for (var i = 0; i < array_length(shadow_data); i++) {
		var shadow = shadow_data[i];
        
		// Get sprite dimensions
		var sw = sprite_get_width(spr_shadow);
		var sh = sprite_get_height(spr_shadow);
		var scaled_w = sw * shadow.scale;
		var scaled_h = sh * shadow.scale;
        
		// Calculate corners
		var x1 = shadow.x - scaled_w/2;
		var y1 = shadow.y - scaled_h/2;
		var x2 = shadow.x + scaled_w/2;
		var y2 = shadow.y + scaled_h/2;
        
		// Add two triangles for this shadow
		// Triangle 1
		vertex_position_3d(shadow_vb, x1, y1, 0);
		vertex_texcoord(shadow_vb, shadow_uvs[0], shadow_uvs[1]);
		vertex_color(shadow_vb, c_white, shadow.alpha);
		vertex_float4(shadow_vb, 0, 0, 0, 0);
        
		vertex_position_3d(shadow_vb, x2, y1, 0);
		vertex_texcoord(shadow_vb, shadow_uvs[2], shadow_uvs[1]);
		vertex_color(shadow_vb, c_white, shadow.alpha);
		vertex_float4(shadow_vb, 0, 0, 0, 0);
        
		vertex_position_3d(shadow_vb, x1, y2, 0);
		vertex_texcoord(shadow_vb, shadow_uvs[0], shadow_uvs[3]);
		vertex_color(shadow_vb, c_white, shadow.alpha);
		vertex_float4(shadow_vb, 0, 0, 0, 0);
        
		// Triangle 2
		vertex_position_3d(shadow_vb, x2, y1, 0);
		vertex_texcoord(shadow_vb, shadow_uvs[2], shadow_uvs[1]);
		vertex_color(shadow_vb, c_white, shadow.alpha);
		vertex_float4(shadow_vb, 0, 0, 0, 0);
        
		vertex_position_3d(shadow_vb, x1, y2, 0);
		vertex_texcoord(shadow_vb, shadow_uvs[0], shadow_uvs[3]);
		vertex_color(shadow_vb, c_white, shadow.alpha);
		vertex_float4(shadow_vb, 0, 0, 0, 0);
        
		vertex_position_3d(shadow_vb, x2, y2, 0);
		vertex_texcoord(shadow_vb, shadow_uvs[2], shadow_uvs[3]);
		vertex_color(shadow_vb, c_white, shadow.alpha);
		vertex_float4(shadow_vb, 0, 0, 0, 0);
	}
    
	vertex_end(shadow_vb);
    
	// Submit the entire batch in one draw call
	gpu_set_blendmode(bm_normal);
	vertex_submit(shadow_vb, pr_trianglelist, shadow_texture);
}

function render_effect_batch() {
	if (array_length(effect_data) == 0) return;
    
	// Sort effects by sprite to minimize texture swaps
	array_sort(effect_data, function(a, b) {
	    if (a.type == b.type) return 0;
	    if (a.type == "speed" && b.type == "slow") return -1;
	    if (a.type == "slow" && b.type == "speed") return 1;
	    return 0;
	});
    
	var current_texture = -1;
	var current_sprite = -1;
    
	vertex_begin(effect_vb, global.render_vertex_format);
	var vertex_count = 0;
    
	for (var i = 0; i < array_length(effect_data); i++) {
		var effect = effect_data[i];
		var effect_texture = sprite_get_texture(effect.sprite, 0);
        
		// Submit current batch if texture changed
		if (current_texture != effect_texture && vertex_count > 0) {
		    vertex_end(effect_vb);
		    gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
		    vertex_submit(effect_vb, pr_trianglelist, current_texture);
            
		    vertex_begin(effect_vb, global.render_vertex_format);
		    vertex_count = 0;
		}
        
		current_texture = effect_texture;
		current_sprite = effect.sprite;
        
		// Handle multiplier text separately
		if (effect.type == "speed_multi" || effect.type == "slow_multi") {
		    // Draw sprite normally for multipliers
		    var uvs = sprite_get_uvs(effect.sprite, 0);
		    var sw = sprite_get_width(effect.sprite);
		    var sh = sprite_get_height(effect.sprite);
            
		    add_sprite_to_vertex_buffer(effect_vb, effect.x, effect.y, sw, sh, uvs, c_white, effect.alpha);
		    vertex_count += 6;
		    continue;
		}
        
		// Regular effect sprites
		var uvs = sprite_get_uvs(effect.sprite, 0);
		var sw = sprite_get_width(effect.sprite);
		var sh = sprite_get_height(effect.sprite);
        
		add_sprite_to_vertex_buffer(effect_vb, effect.x, effect.y, sw, sh, uvs, c_white, effect.alpha);
		vertex_count += 6;
	}
    
	// Submit final batch
	if (vertex_count > 0) {
		vertex_end(effect_vb);
		gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
		vertex_submit(effect_vb, pr_trianglelist, current_texture);
	}
    
	// Handle multiplier text rendering
	draw_effect_multiplier_text();
}

function add_sprite_to_vertex_buffer(_vb, _x, _y, _w, _h, _uvs, _color, _alpha) {
	var x1 = _x - _w/2;
	var y1 = _y - _h/2;
	var x2 = _x + _w/2;
	var y2 = _y + _h/2;
    
	// Triangle 1
	vertex_position_3d(_vb, x1, y1, 0);
	vertex_texcoord(_vb, _uvs[0], _uvs[1]);
	vertex_color(_vb, _color, _alpha);
	vertex_float4(_vb, 0, 0, 0, 0);
    
	vertex_position_3d(_vb, x2, y1, 0);
	vertex_texcoord(_vb, _uvs[2], _uvs[1]);
	vertex_color(_vb, _color, _alpha);
	vertex_float4(_vb, 0, 0, 0, 0);
    
	vertex_position_3d(_vb, x1, y2, 0);
	vertex_texcoord(_vb, _uvs[0], _uvs[3]);
	vertex_color(_vb, _color, _alpha);
	vertex_float4(_vb, 0, 0, 0, 0);
    
	// Triangle 2
	vertex_position_3d(_vb, x2, y1, 0);
	vertex_texcoord(_vb, _uvs[2], _uvs[1]);
	vertex_color(_vb, _color, _alpha);
	vertex_float4(_vb, 0, 0, 0, 0);
    
	vertex_position_3d(_vb, x1, y2, 0);
	vertex_texcoord(_vb, _uvs[0], _uvs[3]);
	vertex_color(_vb, _color, _alpha);
	vertex_float4(_vb, 0, 0, 0, 0);
    
	vertex_position_3d(_vb, x2, y2, 0);
	vertex_texcoord(_vb, _uvs[2], _uvs[3]);
	vertex_color(_vb, _color, _alpha);
	vertex_float4(_vb, 0, 0, 0, 0);
}

function draw_effect_multiplier_text() {
	gpu_set_blendmode(bm_normal);
	draw_set_font(fnt_bit);
	draw_set_halign(fa_right);
	draw_set_valign(fa_middle);
    
	for (var i = 0; i < array_length(effect_data); i++) {
		var effect = effect_data[i];
		if (effect.type == "speed_multi" || effect.type == "slow_multi") {
		    draw_text_scribble(effect.x, effect.y, string(effect.multiplier) + "x ");
		}
	}
}

function render_timer_batch() {
	if (array_length(timer_data) == 0) return;
    
	// Simple approach: render each timer using optimized radial function
	// For more advanced batching, you'd use a shader with uniform arrays
    
	gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
    
	for (var i = 0; i < array_length(timer_data); i++) {
		var timer = timer_data[i];
		draw_sprite_radial(spr_grid_movement_cooldown, 0, timer.progress, 
		                    timer.x, timer.y, 1, 1, timer.color, 1);
	}
}