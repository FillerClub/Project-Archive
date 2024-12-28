var gS = GRIDSPACE;
if position_meeting(x,y+gS,obj_grid) && !position_meeting(x,y+gS,obj_obstacle) {
	instance_create_layer(x,y+gS,"Instances",obj_crawler, {
		identity: "crawler",
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,					
	});
}

if position_meeting(x,y-gS,obj_grid) && !position_meeting(x,y-gS,obj_obstacle) {
	instance_create_layer(x,y-gS,"Instances",obj_crawler, {
		identity: "crawler",
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,					
	});
}

instance_destroy();