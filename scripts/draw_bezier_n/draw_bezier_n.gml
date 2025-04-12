///draw_bezier_n(x[n],y[n],complexity,width,color,alpha,fill?,fill_color,fill_alpha);
//this draws a bezier line using two seperate 1 dimensional arrays, each representing either x or y points.
//this will allow you to use as many points in the bezier curve as you desire
//remember that more points = more processing time, use with care!

function draw_bezier_n(point_x,point_y,complexity,width = 1,_color = c_white,_alpha = 1,_fill = false,_fillcolor = c_white,_filltransparency = 1) {
	var
	prevAlph = draw_get_alpha(),
	prevCol = draw_get_color(),
	lastpoint_x = point_x[0],
	lastpoint_y = point_y[0];

	var length = array_length(point_x) - 1; 

	for(var i = 0; i <= 1; i+= 1/complexity){
    
	    var _x = 0;
	    var _y = 0; 
    
	    //complex math here
	    for(var j = 0; j <= length; j++){
	        var bern = math_bernstain(j,length,i); 
	        _x += bern * point_x[j]; 
	        _y += bern * point_y[j]; 
	    }
    
	    //draw the line itself
	    draw_set_color(_color);
	    draw_set_alpha(_alpha);
	    draw_line_width(lastpoint_x,lastpoint_y,_x,_y,width);
    
	    //fill under line
	    if(_fill){
	        draw_set_color(_fillcolor);
	        draw_set_alpha(_filltransparency);
	        draw_primitive_begin(pr_trianglestrip);
        
	        draw_vertex(lastpoint_x,room_height);
	        draw_vertex(_x,room_height);
	        draw_vertex(lastpoint_x,lastpoint_y);
	        draw_vertex(_x,_y);
        
	        draw_primitive_end();
	    }
    
	    lastpoint_x = _x;
	    lastpoint_y = _y; 
	}

	//return drawing state to "normal"
	draw_set_alpha(prevAlph);
	draw_set_color(prevCol);
}