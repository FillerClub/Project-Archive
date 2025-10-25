// ===== FUNCTION: Filter Array =====
/// @function filter_search_array()
/// @description Filters the search array based on current text input
function filter_search_array(input_list,input_text) {
    var filtered = [];
    
    // If text is empty, show all results
    if input_text == "" {
        return input_list;
    }
    
    var search_text = input_text;
    
    // Convert to lowercase for case-insensitive search
    search_text = string_lower(search_text);
    
    // Loop through the search array and find matches
    for (var i = 0; i < array_length(input_list); i++) {
        var item = input_list[i].keywords;
        var compare_item = item;
        compare_item = string_lower(item);
               
        // Check if the search text is contained in the item
        if string_pos(search_text, compare_item) > 0 {
            array_push(filtered, input_list[i]);
        }
    }
	return filtered;
}
