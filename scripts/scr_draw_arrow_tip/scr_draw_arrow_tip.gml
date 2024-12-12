function scr_draw_arrow_tip(x1, y1, x2, y2, color, size){
    var 
	lengthX = sqrt(sqr(x1 -x2))*sign(x1 -x2),
	lengthY = sqrt(sqr(y1 -y2))*sign(y1 -y2),
    angle = arctan2(y2,x2),
	angleOS = 40*pi/180/2;
	
    var 
	y3 = size*sin(angleOS) +y2,
	x3 = sqrt(sqr(size)+sqr(y3)) +x2;
	

    // draw small triangle at end point
    draw_triangle_color(x2,y2,x3,y3,x2-32,y2-32,color,color,color,0);
}