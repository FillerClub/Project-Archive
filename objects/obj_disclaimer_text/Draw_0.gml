var scribbleObj = scribble("[scale,2][rainbow]ATTENTION [/s][/rainbow]\n This game is currently very early in development. If you're reading this then thank you for taking the time to playtest. Most, if not all, elements are subject to change. All feedback is appreciated. \nThank you, and happy gaming!");
scribbleObj.starting_format("fnt_basic",c_white);
scribbleObj.align(fa_center,fa_middle);
scribbleObj.line_spacing("100%");
scribbleObj.wrap(room_width -64);
scribbleObj.draw(x,y);