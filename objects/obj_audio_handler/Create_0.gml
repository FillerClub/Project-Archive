x = room_width/2;
y = room_height/2;
var reverbEf = audio_effect_create(AudioEffectType.LPF2);
reverbEf.cutoff = 22000;
reverbEf.q = 1;
soundtrack_bus = audio_bus_create();
soundeffect_bus = audio_bus_create();
soundtrack_bus.effects[0] = reverbEf;
soundtrack_emitter = audio_emitter_create();
soundeffect_emitter = audio_emitter_create();
msc_player = audio_create_sync_group(true);
audio_emitter_bus(soundtrack_emitter,soundtrack_bus);
audio_emitter_position(soundtrack_emitter,x,y,0);
audio_emitter_falloff(soundtrack_emitter,room_width/2,room_width,.5)
audio_emitter_bus(soundeffect_emitter,soundtrack_bus);
audio_emitter_position(soundeffect_emitter,x,y,0);
audio_emitter_falloff(soundeffect_emitter,room_width/2,room_width,.5)
audio_falloff_set_model(audio_falloff_exponent_distance);
audio_listener_orientation(0,0,1,0,1,0)
audio_listener_position(x,y,0);

// For dynamic music during levels
audio_group_set_gain(track3,0,0);
audio_group_set_gain(track4,0,0);
audio_group_set_gain(track2,0,0);
audio_group_set_gain(track1,1,0);		