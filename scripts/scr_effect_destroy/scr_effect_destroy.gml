function effect_destroy(array_index, effect_type, effect_potency) {
	effects_array[effect_type] -= effect_potency;
	time_source_destroy(effects_management_array[array_index]);
	effects_management_array[array_index] = new effect_add(EFFECT.NOTHING);
}