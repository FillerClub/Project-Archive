enum EFFECT {
	NOTHING = -1,
	SPEED = 0,
	SLOW = 1,
	INTANGIBILITY = 2,
}
function effect_add(effecttype, effectlength = -1, effectpotency = 1) constructor {
	type = effecttype;
	length = effectlength;
	potency = effectpotency;
}