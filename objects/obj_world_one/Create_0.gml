#macro MAIN 0
#macro LEVELSTART 1
#macro FINALWAVE 1000
#macro VICTORY 9999
level = global.level;
graphic_show = -1;

// Responsible for graphics
graphic_timer = time_source_create(time_source_global,2.5,time_source_units_seconds,function() {
	graphic_show = -1;
},[],1,time_source_expire_after);

timer = 0;


//phase = 3;