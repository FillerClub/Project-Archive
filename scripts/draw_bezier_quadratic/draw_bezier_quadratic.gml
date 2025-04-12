///draw_bezier_quadratic(x1,y1,x2,y2,x3,y3,complexity,width);
//This draws a bezier with a single control point (x2,y2)

function draw_bezier_quadratic(x1,y1,x2,y2,x3,y3,complexity,width) {
	var lastpoint_x = x1;
	var lastpoint_y = y1;
	for(var i = 0; i <= 1; i+= 1/complexity){
	    var point_x = power(1-i,2) * x1 + 2*(1-i)*i*x2 + power(i,2) * x3;
	    var point_y = power(1-i,2) * y1 + 2*(1-i)*i*y2 + power(i,2) * y3;
	    draw_line_width(lastpoint_x,lastpoint_y,point_x,point_y,width);
	    lastpoint_x = point_x;
	    lastpoint_y = point_y; 
	}
}