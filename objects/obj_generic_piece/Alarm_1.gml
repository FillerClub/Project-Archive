/// @desc Controls Flashing for intangibility
if intangible_tick { intangible_tick = false;	
} else { intangible_tick = true; }

if alarm[0] > 0 { alarm_set(1,9); 
} else { intangible_tick = true; }
