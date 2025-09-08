// Initialize rendering data arrays
shadow_data = [];
effect_data = [];
timer_data = [];

// Create vertex buffers for batched rendering
shadow_vb = vertex_create_buffer();
effect_vb = vertex_create_buffer();

// Define vertex format for our custom rendering
vertex_format_begin();
vertex_format_add_position_3d();  // x, y, z
vertex_format_add_texcoord();     // u, v  
vertex_format_add_color();        // color
vertex_format_add_custom(vertex_type_float4, vertex_usage_texcoord);  // custom data (scale, alpha, etc.)
global.render_vertex_format = vertex_format_end();
