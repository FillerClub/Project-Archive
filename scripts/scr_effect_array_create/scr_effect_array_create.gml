enum EFFECT {
	NOTHING = -1,
	SPEED = 0,
	SLOW = 1,
	INVINCIBILITY = 2,
	POISON = 3,
	OVERHEALTH = 4,
	FIRE = 5,
}
function effect_array_create(effecttype, effectID, effectlength = infinity, effectpotency = 1, effectobjectlink = noone,effectdecay = false,effecttruelength = effectlength) constructor {
	type = effecttype;
	id_string = effectID;
	length = effectlength;
	potency = effectpotency;
	object = effectobjectlink;
	decay = effectdecay;
	true_length = effecttruelength
}