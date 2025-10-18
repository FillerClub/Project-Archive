function bullet_check_collision(x_col,y_col) {
var destroy = false;
with collision_point(x_col,y_col,obj_obstacle,false,true) { 
	if object_index == obj_boundary {
		instance_destroy(other.id,false);
		return false;
	}
	if team != other.team && !invincible {
		// Make sure collision is accurate to sprite's hitbox
		var sprOriginX = sprite_get_xoffset(sprite_index),
		sprOriginY = sprite_get_yoffset(sprite_index),
		sprHitboxLeft = sprite_get_bbox_left(sprite_index) -sprOriginX +x,
		sprHitboxTop = sprite_get_bbox_top(sprite_index) -sprOriginY +y,
		sprHitboxRight = sprite_get_bbox_right(sprite_index) -sprOriginX +x,
		sprHitboxBottom = sprite_get_bbox_bottom(sprite_index) -sprOriginY +y,
		spriteCollide = point_in_rectangle(x_col,y_col,sprHitboxLeft,sprHitboxTop,sprHitboxRight,sprHitboxBottom);
		if spriteCollide {
			destroy = true;
			hurt(hp,other.dmg,DAMAGE.NORMAL,self);
			other.object_hit = id;
		}
	}
}
return destroy;
}