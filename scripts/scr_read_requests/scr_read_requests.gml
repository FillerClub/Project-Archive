function read_requests(ar,is_online = false) {
	var leng = array_length(ar);
	if leng <= 0 {
		exit;	
	}
	var verified = ar; 
	if is_online {
		var deduplicated = deduplicate_actions(ar);
		var resolved = resolve_conflicts(deduplicated);
		leng = array_length(resolved);
		verified = sort_actions_by_execution_priority(resolved);
		
	}
	execute_actions_with_dependencies(verified, is_online);
	array_resize(ar,0);
}