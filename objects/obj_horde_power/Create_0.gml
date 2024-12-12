var gS = global.grid_spacing;
if position_meeting(x,y+gS,obj_grid) && !position_meeting(x,y+gS,obj_obstacle) {
	instance_create_layer(x,y+gS,"Instances",obj_crawler, {
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,					
	});
}

if position_meeting(x,y,obj_grid) && !position_meeting(x,y,obj_obstacle) {
	instance_create_layer(x,y,"Instances",obj_crawler, {
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,					
	});
}

if position_meeting(x,y-gS,obj_grid) && !position_meeting(x,y-gS,obj_obstacle) {
	instance_create_layer(x,y-gS,"Instances",obj_crawler, {
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,					
	});
}

instance_destroy();