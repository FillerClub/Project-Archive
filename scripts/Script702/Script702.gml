function number_wrap(input,minimum,maximum) {
	var output = input;
	if output < minimum {
		output = maximum -(minimum -output) +1;
	}
	if output > maximum {
		output = minimum +(output -maximum) -1;	
	}
	if output < minimum || output > maximum {
		output = number_wrap(output,minimum,maximum);	
	}
	return output;
}