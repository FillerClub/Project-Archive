/// @desc Grabs object info from database
// Set on grid if pos nor grid not set for piece
var gridRef = piece_on_grid;
if is_string(gridRef) {
	with obj_grid {
		if tag == gridRef {
			gridRef = id;
			break;
		}
	}
}
if instance_exists(gridRef) && position_meeting(x,y,obj_grid) {
	gridRef = instance_position(x,y,obj_grid);
}
if grid_pos[0] == -1 && grid_pos[1] == -1 && gridRef != noone {
	grid_pos[0] = floor((x -gridRef.bbox_left)/GRIDSPACE);
	grid_pos[1] = floor((y -gridRef.bbox_top)/GRIDSPACE); 
}
if instance_exists(gridRef) {
	x = grid_pos[0]*GRIDSPACE +gridRef.bbox_left;
	y = grid_pos[1]*GRIDSPACE +gridRef.bbox_top;
}
data = piece_database(identity);
hp = data[$ "hp"];
hp_max = variable_clone(data[$ "hp"]);
last_damaged = infinity;
poison_tick = 0;
blink_end = random(5);
blink_timer = 0;
timer = 0;
eye_scale_fact = 1;
default_animation = data[$ "idle_animation"];
animation = -1;
new_animation = -1;
is_predicted = false;
prediction_confidence = 1.0;

if default_animation != -1 {
	animation = layer_sequence_create("Instances",x +sprite_width/2,y +sprite_height/2,default_animation);
	anim_scale = data[$ "anim_scale"];
	sprite_index = spr_phantom_body;
	mask_index = spr_phantom_body;
} else {
	sprite_index = data[$ "sprite"];
	mask_index = spr_phantom_body;
}

move_cooldown_timer = 0;
move_cooldown = data[$ "move_cooldown"];
attack_power = data[$ "attack_power"];

valid_moves = data[$ "moves"];
cost = data[$ "move_cost"];



timer_color = c_white;
error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if timer_color == c_white {
		timer_color = #FF4C55;
	} else {
		timer_color = c_white;
	}			
},[],6);

invin_blink_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if invincible_tick == 1 {
		invincible_tick = .5;
	} else {
		invincible_tick = 1;
	}			
},[],-1);

if asset_get_type(place_sound) == asset_sound {
	audio_stop_sound(place_sound);
	audio_play_sound(place_sound,0,0);
}



effects_management_array[0] = new effect_array_create(EFFECT.NOTHING,"Base");
effects_array = array_create(EFFECT.FIRE +1,0);
