/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if timer >= 1 {
	timer = 0;
	instance_create_layer(x +sprite_width/2,y +sprite_height/2,"AboveBoard",obj_hit_fx, {
		hp: total_health(hp)
	});
}