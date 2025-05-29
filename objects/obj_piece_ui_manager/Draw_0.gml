with obj_generic_piece	{
	if global.healthbar_config != HEALTHBARCONFIG.HIDEALL && (global.healthbar_config == HEALTHBARCONFIG.SHOWALL || (last_damaged <= 8 && last_damaged > 0)) {
		draw_piece_hp();	
	}
}
