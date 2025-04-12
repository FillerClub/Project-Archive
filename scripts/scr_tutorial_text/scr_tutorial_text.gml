function tutorial_text_create(node,phase){
	if text_phase <= phase {
		if ChatterboxIsStopped(chatterbox) {
			ChatterboxJump(chatterbox,node);
		} else if ChatterboxIsWaiting(chatterbox) {
			ChatterboxContinue(chatterbox);	
		}
		var tempText = ChatterboxGetContent(chatterbox,0);
		create_system_message([tempText]);
		text_phase++;
		return true;
	}
}