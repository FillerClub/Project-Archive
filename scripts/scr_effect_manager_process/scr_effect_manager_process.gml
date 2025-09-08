function effect_manager_process() {
	var 
	longestShortLength = -1,
	removedArrays = [-1],
	removedArrayCount = 0,
	arr = effects_management_array,
	effectsArr = effects_array,
	aML = array_length(arr),
	eL = array_length(effectsArr);
	for (var r = 0; r < eL; r++) {
		effects_array[r] = 0;	
	}
	if aML <= 1 {
		effects_timer = 0;
		exit;	
	}
	// Compare all current lengths on the management array
	for (var i = 0; i < aML; i++) {
		var type = arr[i].type;
		if type < 0 {
			continue;
		}
		// Index everything with length shorter than current effects timer
		if arr[i].length <= effects_timer {
			// Record the array index to remove, since they've expired
			removedArrays[removedArrayCount] = i;
			removedArrayCount++;			
			// Find the longest length recorded on the management array (if it is shorter than the effects timer)
			if longestShortLength < arr[i].length {
				longestShortLength = arr[i].length;	
			}
		// Else, check to see if the linked object for effect exists still
		} else if !instance_exists(arr[i].object) && arr[i].object != noone {
			removedArrays[removedArrayCount] = i;
			removedArrayCount++;	
		}
		var
		setPot = arr[i].potency,
		setTime = arr[i].length,
		cum = 0;
		// Give buff/debuff on the effect array
		if arr[i].decay {
			// If it's set to decay, decay the potency of effect
			var lerpVal = (setTime-effects_timer)/arr[i].true_length;
			cum = lerp(0,setPot,clamp(lerpVal,0,1));
		} else {
			cum = setPot;
		}
		effects_array[type] += cum;	
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
		bufferArray = array_get(arr,removedArrays[ii] -removalProgress);
		array_delete(arr,removedArrays[ii] -removalProgress,1);
		//if !bufferArray.decay { effects_array[bufferArray.type] = max(0,effects_array[bufferArray.type] -bufferArray.potency); }
 		removalProgress++;
	}
	// If there is nothing to be removed, skip
	if longestShortLength < 0 || !didRemove {
		exit;
	}
	// After every effects is cleared, reset timer and reduce the lengths for other effects in management array
	aML = array_length(arr);
	for (var iii = 0; iii < aML; iii++) {
		effects_timer -= longestShortLength;
		arr[iii].length -= longestShortLength;
	}
}
