enum EFFECT {
	NOTHING = -1,
	SPEED = 0,
	SLOW = 1,
	INVINCIBILITY = 2,
	POISON = 3,
}
function effect_array_create(effecttype, effectID, effectlength = infinity, effectpotency = 1, effectobjectlink = noone) constructor {
	type = effecttype;
	id_string = effectID;
	length = effectlength;
	potency = effectpotency;
	object = effectobjectlink;
}