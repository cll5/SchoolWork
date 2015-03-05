var phoneDataset;
var filteredPhoneDataset;
var phoneIds;
d3.csv("data/CellPhoneCallRecords.csv", function(row) {
	/*Datetime column should be converted to Date objects for convenient comparison later on*/
	var date = row["Datetime"];
	var year = +date.substring(0, 4);
	var month = (+date.substring(4, 6)) - 1; /*month is zero indexed*/
	var day = +date.substring(6, 8);
	var hour = +date.substring(9, 11);
	var minute = +date.substring(11);
	
	return {
		from: 	   +row["From"],
		to: 	   +row["To"],
		datetime:  new Date(year, month, day, hour, minute),
		duration:  +row["Duration(seconds)"],
		cellTower: +row["Cell Tower"]
	};
}, function(error, data) {
	phoneDataset = data;
	filteredPhoneDataset = filterPhoneDataset(phoneDataset, selectedPhoneId);
	phoneIds = extractUniquePhoneIdSet(filteredPhoneDataset, selectedPhoneId);
	drawSelectedNodeLinkGraph(filteredPhoneDataset, phoneIds, selectedPhoneId, phoneCallsThreshold);
});

function extractUniquePhoneIdSet(dataset, phoneIdToExclude) {
	var fromIdSet = _.pluck(dataset, "from");
	var toIdSet = _.pluck(dataset, "to");
	var uniquePhoneIdSet = _.union(fromIdSet, toIdSet);
	uniquePhoneIdSet = _.reject(uniquePhoneIdSet, function(id) {
		return id === phoneIdToExclude;
	});
	return _.sortBy(uniquePhoneIdSet);
}

/*subset the phone dataset to the rows that have contacted a selected phone id*/
function filterPhoneDataset(dataset, selectedPhoneId) {
	return _.filter(dataset, function(d) {
		return (d.from === selectedPhoneId) || (d.to === selectedPhoneId);
	});
}