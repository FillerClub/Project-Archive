function correct_objects(host_objects,time_stamp) {
    // Build map of host pieces for quick lookup
	var verbose = global.verbose_debug;
	var debugMessage = "";
    var saveObjects = SHORTSAVEOBJECTS;
    var saveObjectVars = SHORTSAVEOBJECTVARIABLES;
	var updateArray = [];
	
	// Build map of host objects for quick lookup
    var host_object_map = ds_map_create();
    for (var i = 0; i < array_length(host_objects); i++) {
        var object = host_objects[i];
        ds_map_add(host_object_map, object.tag, object);
    }
	
	for (var ii = 0; ii < array_length(saveObjects); ii++) {
	    // Check local objects against host
	    with saveObjects[ii] {
	        if variable_instance_exists(self,"tag") && ds_map_exists(host_object_map, tag) {
				var host_object = host_object_map[? tag];
				
		        if verbose {
		            debugMessage += string(host_object.object_index) +"-" +string(host_object.tag) +" , ";
		        }
				array_push(updateArray,{host_id: id, data: host_object});
				// Get rid of object on ds map
	            ds_map_delete(host_object_map, tag);
	        }
	    }
	}
	for (var iii = 0; iii < array_length(updateArray); iii++) {
		update_instance_from_data(updateArray[iii].host_id,updateArray[iii].data,saveObjectVars,SAVEOBJECTIGNOREVARIABLES,time_stamp);
	}
	
	if verbose {
		show_debug_message("Updating existing objects " +debugMessage);	
	}
    
    // Any remaining objects in host_object_map need to be created
    var object_id = ds_map_find_first(host_object_map);
	debugMessage = "";
    while (object_id != undefined) {
        var object_data = host_object_map[? object_id];
        if verbose {
            debugMessage += string(object_data.object_index) +"-" +string(object_data.tag) +" , ";
        }
		create_instance_from_data(object_data,saveObjectVars,SAVEOBJECTIGNOREVARIABLES,time_stamp);
        // Set other properties as needed
        object_id = ds_map_find_next(host_object_map, object_id);
    }
    if verbose {
		show_debug_message("Creating missing objects " +debugMessage);	
	}
	
	ds_map_destroy(host_object_map);
}