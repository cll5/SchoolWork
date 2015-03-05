//create an array of n values (i.e. returns [value, value, value, ... n times])
//reference: http://stackoverflow.com/questions/1295584/most-efficient-way-to-create-a-zero-filled-javascript-array
function newFilledArray(n, value) {
	n = (n < 0) ? 0 : Math.floor(n);	//n should be a natural number
	filledArray = new Array(n);
	while (--n >= 0) {
		filledArray[n] = value;
	}
	return filledArray;
}


//Calculate the integer part of a division
//refernces: 
//1. See post by KalEl from http://stackoverflow.com/questions/4228356/integer-division-in-javascript
//2. http://en.wikipedia.org/wiki/Quotient
function quotient(a, b) {
	return ~~(a/b);
}