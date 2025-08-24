if variable_struct_exists(hp,"shield") && variable_struct_exists(hp_max,"shield") {
	hp.shield = min(hp.shield +timer/10,hp_max.shield);
	timer = 0;
}

event_inherited();

