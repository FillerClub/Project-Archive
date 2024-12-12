/// @function	progress_menu(increment,menu_macro);
/// @param {integer}	increment	Whether to go forward (1), back (-1), or refresh (0) in the submenus 
/// @param {array}		menu		Menu array
/// @description	Run anytime an existing menu needs to be updated
function progress_menu(increment = 1, menuSet = undefined){
	// Destroy all linked buttons
	for (var i = 0; i < array_length(links) ; i++) {
		instance_destroy(links[i]);
	}
	if menu_index +increment >= 0 {
		// When going backwards, set the current_index to what was last selected for consistency
		if increment > 0 {
			saved_index[menu_index] = current_index;	
		// Else, save the current index if going forward
		} else if increment < 0 {
			current_index = saved_index[menu_index +increment];
		}
		// Increment menus
		menu_index += increment;
		if menuSet != undefined {
			menu[menu_index] = menuSet;
		} 
	}
	menu_create_buttons();
}