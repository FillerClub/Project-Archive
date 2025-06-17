function deal_with_effects() {
	var 
	longestShortLength = -1,
	removedArrays = [-1],
	removedArrayCount = 0;
	var aML = array_length(effects_management_array);
	if aML <= 1 {
		effects_timer = 0;
		exit;	
	}
	// Compare all current lengths on the management array
	for (var i = 0; i < aML; i++) {
		// Index everything with length shorter than current effects timer
		if effects_management_array[i].length <= effects_timer {
			// Record the array index to remove, since they've expired
			removedArrays[removedArrayCount] = i;
			removedArrayCount++;			
			// Find the longest length recorded on the management array (if it is shorter than the effects timer)
			if longestShortLength < effects_management_array[i].length {
				longestShortLength = effects_management_array[i].length;	
			}
		// Else, check to see if the linked object for effect exists still
		} else if !instance_exists(effects_management_array[i].object) && effects_management_array[i].object != noone {
			removedArrays[removedArrayCount] = i;
			removedArrayCount++;	
		}
	}
	var 
	rAL = array_length(removedArrays),
	removalProgress = 0,
	didRemove = false,
	bufferArray = -1;
	

	// Select from recorded arrays
	for (var ii = 0; ii < rAL; ii++) {
		if removedArrays[ii] == -1 {
			continue;
		}
		didRemove = true;
		// Else, copy the array, remove it from the management array, and remove it from the effects array
		bufferArray = array_get(effects_management_array,removedArrays[ii] -removalProgress);
		array_delete(effects_management_array,removedArrays[ii] -removalProgress,1);
		effects_array[bufferArray.type] = max(0,effects_array[bufferArray.type] -bufferArray.potency);
		removalProgress++;
	}
	// If there is nothing to be removed, skip
	if longestShortLength < 0 || !didRemove {
		exit;
	}
	// After every effects is cleared, reset timer and reduce the lengths for other effects in management array
	aML = array_length(effects_management_array);
	for (var iii = 0; iii < aML; iii++) {
		effects_timer = 0;
		effects_management_array[iii].length -= longestShortLength; 	
	}
}
