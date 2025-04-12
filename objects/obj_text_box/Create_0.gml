#macro TOP 0
#macro BOTTOM 1
#macro LEFT 0
#macro RIGHT 1
#macro TEXTYDEFAULT 120

o_x = x;
o_y = y;

for (var i = 0; i < array_length(text); i++) {
	scribble_object[i] = scribble(text[i])
		.starting_format("fnt_generic_dialogue",text_color)	
		.wrap(room_width -GUI_MARGIN*4)
}
scribble_button_prompt_object = scribble("Continue")
	.starting_format("fnt_generic_dialogue",text_color)	
	.scale(.75)

typist = scribble_typist();
typist.in(.6,0.5);
typist.sound_per_char([snd_dialogue_tick],.85,1.15," .,!?");
//typist.ease(SCRIBBLE_EASE.SINE,0,8,1,1,0,0);
var num = instance_number(obj_text_box)
priority = num -1;
typist.pause();