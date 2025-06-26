global.name = get_string("Enter Name", "");

if global.name == "" {
	create_menu(SETTINGSMENU);					
} else {
	save_file(PROFILE);
	create_menu(SETTINGSMENU);	
}


instance_destroy();