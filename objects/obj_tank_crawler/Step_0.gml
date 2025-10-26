event_inherited();
if !instance_exists(armor) { exit; }

if !instance_exists(track_armor_to) {
	// Track armor to crawler
	if layer_sequence_exists("Instances", animation) {
	    var anim = layer_sequence_get_instance(animation),
	        animTracks = anim.activeTracks,
	        tracks = array_length(animTracks);
    
	    for (var t = 0; t < tracks; t++) {
	        track_armor_to = find_sequence_object(animTracks[t], obj_armor_asset);
			if instance_exists(track_armor_to) {
				track_armor_to.sprite_index = armor.sprite_index;
				track_armor_to.image_index = armor.image_index;
				break;	
			}
	    }    
	}
}

if armor.destroyed { 
	instance_destroy(track_armor_to);
	exit; 
}

if instance_exists(track_armor_to) {
	var gridOn = piece_on_grid;
	if is_string(gridOn) {
		with obj_grid {
			if tag == gridOn {
				gridOn = id;
				break;
			}
		}
	} else if instance_exists(gridOn) {
		armor.z = gridOn.z +z;	
	}
	armor.x = track_armor_to.x;
	armor.y = track_armor_to.y;
	armor.depth = track_armor_to.depth;
}

if hp.armor <= 0 {
	armor.destroyed = true;
	armor.x_init = armor.x;
	armor.y_init = armor.y;
	hp_max.armor = 0;
}
