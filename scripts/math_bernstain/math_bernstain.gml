function math_bernstain(k,n,t) {
	var firstFact = math_factorial(n); 
	var secondFact = math_factorial(k);
	var thirdFact = math_factorial(n-k); 
	var firstPow = power(t, k); 
	var secondPow = power(1-t, n-k); 

	return (firstFact / (secondFact * thirdFact)) * firstPow * secondPow;
}