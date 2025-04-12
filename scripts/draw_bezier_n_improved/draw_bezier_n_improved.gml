///draw_bezier_improved(x[n],y[n],complexity,width,color,alpha,fill?,fill_color,fill_alpha);
//this draws a bezier line using two seperate 1 dimensional arrays, each representing either x or y points.
//this will allow you to use as many points in the bezier curve as you desire
//remember that more points = more processing time, use with care!

function draw_bezier_improved(a_array_x,a_array_y, complexity, width = 3, _color = c_white, _alpha = 1, b_array_x = [], b_array_y = [], _fill = false, _fillcolor = c_white, _filltransparency = 1) {
	
	var
	prevAlph = draw_get_alpha(),
	prevCol = draw_get_color(),
	lastpoint_xA = a_array_x[0],
	lastpoint_yA = a_array_y[0],
	lastpoint_xB = b_array_x[0],
	lastpoint_yB = b_array_y[0],
	draw_second_curve = (array_length(b_array_x) == array_length(a_array_x) && array_length(b_array_y) == array_length(a_array_y))?true:false,
	reps = 1 + draw_second_curve,
	iteration = 0;
	
	var
	length = array_length(a_array_x) - 1; 
		
	for(var i = 0; i <= 1; i+= 1/complexity) {
		repeat (reps) {
			var _xA = 0;
			var _yA = 0; 
			var _xB = 0;
			var _yB = 0; 
    
			//complex math here
			for(var jA = 0; jA <= length; jA++){
			    var bern = math_bernstain(jA,length,i); 
			    _xA += bern * a_array_x[jA]; 
			    _yA += bern * a_array_y[jA]; 
			}
    
			//draw the line itself
			draw_set_color(_color);
			draw_set_alpha(_alpha);
			draw_line_width(lastpoint_xA,lastpoint_yA,_xA,_yA,width);
			
			if draw_second_curve {
				//complex math here
				for(var jB = 0; jB <= length; jB++){			
				    var bern = math_bernstain(jB,length,i); 
					    _xB += bern * b_array_x[jB]; 
					    _yB += bern * b_array_y[jB]; 
				}
    
				//draw the line itself
				draw_set_color(_color);
				draw_set_alpha(_alpha);
				draw_line_width(lastpoint_xB,lastpoint_yB,_xB,_yB,width);				
			}
		
			//fill under line
			if(_fill){
			    draw_set_color(_fillcolor);
			    draw_set_alpha(_filltransparency);
			    draw_primitive_begin(pr_trianglestrip);
        
			    draw_vertex(lastpoint_xA,lastpoint_yA);
			    draw_vertex(_xA,_yA);
			    draw_vertex(lastpoint_xB,lastpoint_yB);
				draw_vertex(_xB,_yB);
			    
			    draw_primitive_end();
			}
    
			lastpoint_xA = _xA;
			lastpoint_yA = _yA; 
			lastpoint_xB = _xB;
			lastpoint_yB = _yB; 
		}
	}
	//return drawing state to "normal"
	draw_set_alpha(prevAlph);
	draw_set_color(prevCol);
}