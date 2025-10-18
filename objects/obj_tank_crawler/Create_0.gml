event_inherited();
// Best guess on where to spawn
var xRel = 36,
yRel = 19;
armor = instance_create_depth(x +xRel,y +yRel,depth -1,obj_cardboard_box,{
	team: team
});

track_armor_to = noone;