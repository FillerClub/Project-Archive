var gD = 0;
with instance_position(x,y,obj_grid) {
	if team == global.player_team {
		if team == "friendly" {
			gD = bbox_left;
		} else if team == "enemy" {
			gD = bbox_right -GRIDSPACE;
		}
	}	
}
if position_meeting(gD,y+GRIDSPACE,obj_grid) && !position_meeting(gD,y+GRIDSPACE,obj_obstacle) {
	instance_create_layer(gD,y+GRIDSPACE,"Instances",obj_goliath, {
		identity: "the_goliath",
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,	
		ai_controlled: ai_controlled
	});
}

if position_meeting(gD,y-GRIDSPACE,obj_grid) && !position_meeting(gD,y-GRIDSPACE,obj_obstacle) {
	instance_create_layer(gD,y-GRIDSPACE,"Instances",obj_goliath, {
		identity: "the_goliath",
		dragging: false,
		fresh: false,
		moveable: false,		
		team: team,
		link: link,	
		ai_controlled: ai_controlled
	});
}

instance_destroy();


/*
var gD = global.grid_dimensions;
posx = gD[1] -GRIDSPACE;
posy = gD[2];
alarm[0] = 1;

time_src = time_source_create(time_source_game,.13,time_source_units_seconds,function() {
	var gD = global.grid_dimensions;
	var tMScan = (team == "friendly")?obj_territory_friendly:obj_territory_enemy;
	if !position_meeting(posx,posy,obj_obstacle) {
		instance_create_layer(posx,posy,"Instances",obj_crawler, {
			identity: "crawler",
			dragging: false,
			fresh: false,
			moveable: false,		
			team: team,
			link: link,
			ai_controlled: ai_controlled,
		});	
	}	

	posy += GRIDSPACE;

	if !position_meeting(posx,posy,tMScan) {
		posy = gD[2];
		posx -= GRIDSPACE;
	}

	if !position_meeting(posx,posy,tMScan) {
		time_source_stop(time_src);
		instance_destroy();
	}	
},[],-1)

time_source_start(time_src);
