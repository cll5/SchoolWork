var energyData = {};
var energyMetadata = {
	sources: [],
	sourcesByTypes: {},
	sourceNames: {},
	sourceTypes: {},
	sourceUnits: {},
	years: [],
	countries: []};



//loads energy data and energy metadata from csv
d3.csv("data/countries.csv", function(row) {
	energyMetadata.countries.push(row.country);
}, function(error) {
	if (!_.isEmpty(error)) {
		console.log("Error at loading countries.csv");
		console.log(error);
	}

	d3.csv("data/sources.csv", function(row) {
		energyMetadata.sources.push(row.sourceKey);
		energyMetadata.sourceNames[row.sourceKey] = row.sourceName;
		energyMetadata.sourceTypes[row.sourceKey] = row.sourceType;
		energyMetadata.sourceUnits[row.sourceKey] = row.unit;

		if (!energyMetadata.sourcesByTypes[row.sourceType]) {
			energyMetadata.sourcesByTypes[row.sourceType] = [];
		}
		energyMetadata.sourcesByTypes[row.sourceType].push(row.sourceKey);
		
	}, function(error) {
		if (!_.isEmpty(error)) {
			console.log("Error at loading sources.csv");
			console.log(error);
		}

		d3.csv("data/years.csv", function(row) {
			energyMetadata.years.push(+row.year);
		}, function(error) {
			if (!_.isEmpty(error)) {
				console.log("Error at loading years.csv");
				console.log(error);
			}

			d3.csv("data/energyData.csv", function(row) {
				if (!energyData[row.country]) {
					energyData[row.country] = {};
				}
				var annualConsumptions = {};
				_.forEach(energyMetadata.years, function(year) {
					annualConsumptions[year] = +row[year];
				});
				energyData[row.country][row.source] = annualConsumptions;
			}, function(error) {
				if (!_.isEmpty(error)) {
					console.log("Error at loading energyData.csv");
					console.log(error);
				}

				populateControls(energyMetadata.countries, energyMetadata.sourcesByTypes, energyMetadata.years);

				selectedCountries = energyMetadata.countries;
				filteredCountries = [];

				selectedSources = energyMetadata.sources;
				numOfSources = selectedSources.length;
				differentialAngle = 360/numOfSources;

				selectedYear = _.last(energyMetadata.years);	//initialize to the latest year

				updateVisualization();
			});
		});
	});
});