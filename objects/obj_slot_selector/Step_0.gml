#macro SLOTHOTKEYS [1,2,3,4,5,6,7,8,9]
#macro POWERSLOTHOTKEYS ["Q","W","E"]
var keys = SLOTHOTKEYS;
array_push(keys,POWERSLOTHOTKEYS);
var keyAmt = array_length(SLOTHOTKEYS),
pressed = false,
goPower = false,
cIncrement = input_check_pressed("hotkey_right") -input_check_pressed("hotkey_left"),
cPowerInput1 = input_check_pressed("hotkey_power_1"),
cPowerInput2 = input_check_pressed("hotkey_power_2"),
cPowerInput3 = input_check_pressed("hotkey_power_3"),
cInputFirst = input_check_pressed("hotkey_first");

if cIncrement != 0 || (cPowerInput1 || cPowerInput2 || cPowerInput3 || cInputFirst) {
	if cPowerInput1 { last_pressed = "Q"; }
	if cPowerInput2 { last_pressed = "W"; }
	if cPowerInput3 { last_pressed = "E"; }
	if cInputFirst  { last_pressed = last_slot_index;  }
	if cIncrement != 0 {
		// Cycle using pads
		switch typeof(last_pressed) {
			case "number":
			case "int32":
			case "int64":
				var slotCount = 0;
				with obj_piece_slot {
					if team == global.player_team && object_index != obj_power_slot { 
						slotCount++;				
					}
				}
				last_pressed = number_wrap(last_pressed +cIncrement,1,slotCount);
			break;
			case "string":
				var idx = array_find_index(POWERSLOTHOTKEYS, function(_element,_index) {
					return _element == last_pressed;	
				});
				if (idx != -1) {
				    last_pressed = POWERSLOTHOTKEYS[number_wrap(idx + cIncrement, 0, 2)];
				}
			break;
		}
	}
	pressed = true;
} else {
	for (var k = 0; k < keyAmt; k++) {
		if keyboard_check_pressed(ord(keys[k])) {
			last_pressed = keys[k];
			pressed = true;
			break;
		}
	}
}

if last_pressed != -1 {
	switch typeof(last_pressed) {
		case "number":
		case "int32":
		case "int64": index = last_pressed -1;
		break;
		case "string":
			goPower = true;
			switch last_pressed {
				case "Q": index = 1; break;
				case "W": index = 2; break;
				case "E": index = 3; break;
			}
		break;
	}
}
if !pressed {
	if input_mouse_check_pressed(mb_any) || input_check_pressed("action") {
		hide = true;
	} 	
	exit;
}
if !goPower {
	last_slot_index = last_pressed;	
}
hide = false;
with obj_piece_slot {
	if team == global.player_team && index == other.index {
		if (object_index != obj_power_slot && !goPower) || (object_index == obj_power_slot && goPower) { 
			other.x = x;
			other.y = y;
			if special_slot_checks() {
				instance_destroy(obj_dummy);
				create_piece_from_slot(true);
			}
			break;
		}
	}
}