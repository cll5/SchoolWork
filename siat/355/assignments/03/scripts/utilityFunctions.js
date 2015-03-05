function padZero(number, desiredWidth) {
	desiredWidth = desiredWidth || 3;
	var digits = number.toString().length;
	return new Array(desiredWidth - digits + 1).join("0") + number;
}

function sum(objects, key) {
	return _.reduce(objects, function(memo, object) {
			return memo + object[key];
	}, 0);
}