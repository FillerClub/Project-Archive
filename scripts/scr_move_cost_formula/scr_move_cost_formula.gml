function move_cost_formula(hp_of_opposing_piece, base_move_cost = 1){
	return floor(hp_of_opposing_piece/10) +base_move_cost;	
}