if update {
	filtered_list = filter_search_array(list,text_input);
	var leng = array_length(filtered_list);
	starting_index = max(0,(min(starting_index,leng -display_limit)));
	//show_message(starting_index);
	display_list = [];
	instance_destroy(obj_journal_slot);
	for (var i = starting_index; i < leng && i -starting_index < display_limit; i++) {
		filtered_list[i].index_object = instance_create_layer(x,y +64*(i -starting_index),"Instances",obj_journal_slot,{
			sprite_slot: filtered_list[i].slot_sprite,
			class: filtered_list[i].class,
			cost: filtered_list[i].cost,
			name: filtered_list[i].name,
			code: filtered_list[i].code,
		});
		array_push(display_list, filtered_list[i]);
	}
	update = false;	
}