function create_menu(menuCreate, menuContext, menuX = menu_x,menuY = menu_y, buttonSeperation = button_seperation,buttonWidth = button_width, buttonHeight = button_height,Font = font,fontHAlign = font_halign,fontVAlign = font_valign, ignoreFirstFrameInput = true){
	instance_create_depth(x,y,-1600,obj_menu, {
		menu: [menuCreate],
		context: menuContext,
		menu_x: menuX,
		menu_y: menuY,
		button_seperation: buttonSeperation,
		button_width: buttonWidth,
		button_height: buttonHeight,
		font: Font,
		font_halign: fontHAlign,
		font_valign: fontVAlign,
		ignore_input: ignoreFirstFrameInput,
	});
}