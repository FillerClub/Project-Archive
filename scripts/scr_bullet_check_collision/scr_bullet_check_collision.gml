function bullet_check_collision(x_col,y_col) {
var destroy = false;
with collision_point(x_col,y_col,obj_obstacle,false,true) { 
	if object_index == obj_boundary {
		instance_destroy(other.id,false);
		return false;
	}
	if team != other.team && !invincible {
		destroy = true;
		hurt(hp,other.dmg,DAMAGE.NORMAL,self);
		other.object_hit = id;
	}
}
return destroy;
}