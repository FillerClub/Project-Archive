///draw_bezier_cubic(x1,y1,x2,y2,x3,y3,x4,y4,complexity,width);
//This draws a bezier with two control points (x2,y2,x3,y3)

function draw_bezier_cubic(point1_x,point1_y,point2_x,point2_y,point3_x,point3_y,point4_x,point4_y,complexity,width) {
	var lastpoint_x = point1_x;
	var lastpoint_y = point1_y;
	for(var i = 0; i <= 1; i+= 1/complexity){
	    var point_x = power(1-i,3)*point1_x + 3*power(1-i,2)*i*point2_x+3*(1-i)*power(i,2)*point3_x+power(i,3)*point4_x;
	    var point_y = power(1-i,3)*point1_y + 3*power(1-i,2)*i*point2_y+3*(1-i)*power(i,2)*point3_y+power(i,3)*point4_y;
	    draw_line_width(lastpoint_x,lastpoint_y,point_x,point_y,width);
	    lastpoint_x = point_x;
	    lastpoint_y = point_y; 
	}
}