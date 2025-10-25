// @function draw_text_wrapped(x, y, text, width, margin)
/// @description Draws text with automatic word wrapping to fit within specified width
/// @param {real} x The x position to start drawing
/// @param {real} y The y position to start drawing
/// @param {string} text The text to draw
/// @param {real} width The maximum width available for text
/// @param {real} margin The margin/padding to apply on both sides (default: 0)
/// @return {real} The total height of the drawn text

function draw_text_wrapped(_x, _y, _text, _width, _margin = 0) {
    // Apply margin to get actual drawing width
    var draw_width = _width - (_margin * 2);
    var current_x = _x + _margin;
    var current_y = _y + _margin;
    
    // Get line height based on current font
    var line_height = string_height("M");
    var space_width = string_width(" ");
    
    // Split text into words
    var words = [];
    var word = "";
    var text_length = string_length(_text);
    
    // Parse text into words and preserve line breaks
    for (var i = 1; i <= text_length; i++) {
        var char = string_char_at(_text, i);
        
        if (char == " " || char == "\n") {
            if (word != "") {
                array_push(words, word);
                word = "";
            }
            if (char == "\n") {
                array_push(words, "\n"); // Preserve line breaks
            }
        } else {
            word += char;
        }
    }
    
    // Add the last word if exists
    if (word != "") {
        array_push(words, word);
    }
    
    // Build and draw lines
    var current_line = "";
    var line_count = 0;
    
    for (var i = 0; i < array_length(words); i++) {
        var test_word = words[i];
        
        // Handle explicit line breaks
        if (test_word == "\n") {
            if (current_line != "") {
                draw_text(current_x, current_y, current_line);
                current_y += line_height;
                line_count++;
                current_line = "";
            }
            // Add extra line for the line break
            current_y += line_height;
            line_count++;
            continue;
        }
        
        // Build test line
        var test_line = current_line;
        if (current_line != "") {
            test_line += " " + test_word;
        } else {
            test_line = test_word;
        }
        
        // Check if test line fits
        var test_width = string_width(test_line);
        
        if (test_width <= draw_width) {
            // Line fits, add word to current line
            current_line = test_line;
        } else {
            // Line doesn't fit
            if (current_line != "") {
                // Draw current line and start new line with this word
                draw_text(current_x, current_y, current_line);
                current_y += line_height;
                line_count++;
                current_line = test_word;
            } else {
                // Even single word doesn't fit - draw it anyway
                // (You might want to handle this differently)
                draw_text(current_x, current_y, test_word);
                current_y += line_height;
                line_count++;
                current_line = "";
            }
        }
    }
    
    // Draw remaining text
    if (current_line != "") {
        draw_text(current_x, current_y, current_line);
        current_y += line_height;
        line_count++;
    }
    
    // Return total height used (including margins)
    return (line_count * line_height) + (_margin * 2);
}


/// @function draw_text_wrapped_ext(x, y, text, width, height, margin, v_align)
/// @description Extended version with height limit and vertical alignment
/// @param {real} x The x position to start drawing
/// @param {real} y The y position to start drawing
/// @param {string} text The text to draw
/// @param {real} width The maximum width available for text
/// @param {real} height The maximum height available for text (0 for unlimited)
/// @param {real} margin The margin/padding to apply on all sides
/// @param {real} v_align Vertical alignment: 0=top, 0.5=middle, 1=bottom (default: 0)
/// @return {real} The total height of the drawn text

function draw_text_wrapped_ext(_x, _y, _text, _width, _height, _margin = 0, _v_align = 0) {
    // First, calculate how much height we would need
    var old_font = draw_get_font();
    var old_color = draw_get_color();
    var old_alpha = draw_get_alpha();
    
    // Calculate required height by doing a "dry run"
    var draw_width = _width - (_margin * 2);
    var line_height = string_height("M");
    var space_width = string_width(" ");
    
    // Split text into words
    var words = [];
    var word = "";
    var text_length = string_length(_text);
    
    for (var i = 1; i <= text_length; i++) {
        var char = string_char_at(_text, i);
        
        if (char == " " || char == "\n") {
            if (word != "") {
                array_push(words, word);
                word = "";
            }
            if (char == "\n") {
                array_push(words, "\n");
            }
        } else {
            word += char;
        }
    }
    
    if (word != "") {
        array_push(words, word);
    }
    
    // Calculate line count
    var current_line = "";
    var line_count = 0;
    
    for (var i = 0; i < array_length(words); i++) {
        var test_word = words[i];
        
        if (test_word == "\n") {
            if (current_line != "") {
                line_count++;
                current_line = "";
            }
            line_count++;
            continue;
        }
        
        var test_line = current_line;
        if (current_line != "") {
            test_line += " " + test_word;
        } else {
            test_line = test_word;
        }
        
        var test_width = string_width(test_line);
        
        if (test_width <= draw_width) {
            current_line = test_line;
        } else {
            if (current_line != "") {
                line_count++;
                current_line = test_word;
            } else {
                line_count++;
                current_line = "";
            }
        }
    }
    
    if (current_line != "") {
        line_count++;
    }
    
    // Calculate total height needed
    var total_height = (line_count * line_height);
    
    // Apply vertical alignment if height is specified
    var start_y = _y + _margin;
    if (_height > 0 && _v_align > 0) {
        var available_height = _height - (_margin * 2);
        if (total_height < available_height) {
            start_y += (available_height - total_height) * _v_align;
        }
    }
    
    // Now actually draw the text
    var actual_height = draw_text_wrapped(_x, start_y, _text, _width, _margin);
    
    return actual_height;
}


/// @function draw_text_wrapped_in_object(text, margin)
/// @description Draws wrapped text fitted to the current object's sprite size
/// @param {string} text The text to draw
/// @param {real} margin The margin/padding from object edges (default: 8)
/// @return {real} The total height of the drawn text

function draw_text_wrapped_in_object(_text, _margin = 8) {
    // Get object dimensions from sprite
    var obj_width = sprite_width;
    var obj_height = sprite_height;
    
    // Calculate top-left corner (accounting for sprite offset)
    var obj_x = x - sprite_xoffset;
    var obj_y = y - sprite_yoffset;
    
    // Draw the wrapped text
    return draw_text_wrapped_ext(obj_x, obj_y, _text, obj_width, obj_height, _margin, 0);
}
