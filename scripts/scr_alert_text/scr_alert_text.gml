function scr_alert_text(argument0){
	var text_show = argument0;
	instance_create_layer(room_width/2,room_height/2 +128, "Instances", obj_alert, {
		text: text_show,	
	});
}