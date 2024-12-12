global.name = get_string("Enter Name", "");

if global.name == "" {
	create_menu(SETTINGSMENU);					
} else {
	save(PROFILE);
	create_menu(SETTINGSMENU);	
}


instance_destroy();