function bullet_check_collision(x_col,y_col) {
var destroy = false;
with collision_point(x_col,y_col,obj_obstacle,false,true) { 
	if object_index == obj_boundary {
		destroy = true;
		break;
	}
		
	if team != other.team && !invincible {
		destroy = true;
		hurt(hp,other.dmg,self);	
	}
}
return destroy;
}