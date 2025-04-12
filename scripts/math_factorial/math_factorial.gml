function math_factorial(value) {
	if(value == 0) return 1; 

	for(var m = value-1; m > 1; m-=1){
	    value*=m; 
	}

	return value; 
}