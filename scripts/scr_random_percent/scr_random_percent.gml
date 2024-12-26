function random_percent(base_value, percentage_off){
	return base_value*(random_range(100 -percentage_off, 100 +percentage_off)/100);
}