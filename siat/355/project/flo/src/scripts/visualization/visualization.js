var individualCountryVisualizationContainer = d3.select("#individual-country-visualization svg");
var aggregatedCountryVisualizationContainer = d3.select("#aggregated-country-visualization svg");
var aggregatedStarPlotContainer = d3.select("#starplot-container");
var aggregatedStarPlotLegend = d3.select("#starplot-legend");
var aggregatedBarChartContainer = d3.select("#barchart-container");

var padding = {inner: 10, outer: 60};
var margin = 20;

function updateVisualization() {
	filteredCountries = [];
	sortCountriesByLargestTotalConsumptions();
	updateAllAggregatedEnergyData();
	clearVisualization(individualCountryVisualizationContainer);
	drawIndividualEnergyStarPlotForCountries(individualCountryVisualizationContainer, selectedCountries, selectedSources, selectedYear);
	clearVisualization(aggregatedStarPlotContainer);
	drawAggregatedEnergyStarPlotForCountries(aggregatedCountryVisualizationContainer, selectedCountries, filteredCountries, selectedSources, selectedYear);
}

function clearVisualization(visualizationContainer) {
	visualizationContainer.html("");
}

function sortCountriesByLargestTotalConsumptions() {
	selectedCountries = _.sortBy(selectedCountries, function(country) {
		return _.reduce(selectedSources, function(sum, source) {
			return (sum - energyData[country][source][selectedYear]);
		}, 0);
	});
}

var starPlotMatrixOrigins;
function drawIndividualEnergyStarPlotForCountries(starPlotsContainer, countries, sources, year) {
	var diameter = 100;
	var radius = diameter/2;
	var starPlotUnitWidth = diameter + (2 * (padding.inner + padding.outer));
	
	//defines the grid for the starplot matrix
	var numOfColumns = 4;
	var numOfRows = quotient(countries.length, numOfColumns) + 1;

	var starPlotsContainerWidth = numOfColumns * starPlotUnitWidth;
	var starPlotsContainerHeight = numOfRows * starPlotUnitWidth;

	var countryGridXScaleRange = _.map(_.range(numOfColumns), function(d) {
		return ((d + 0.5) * starPlotUnitWidth);
	});
	var countryGridXScale = d3.scale.quantize()
									.domain([0, (numOfColumns - 1)])
									.range(countryGridXScaleRange);
	
	var countryGridYScaleRange = _.map(_.range(numOfRows), function(d) {
		return ((d + 0.5) * starPlotUnitWidth);
	});
	var countryGridYScale = d3.scale.quantize()
									.domain([0, Math.max((numOfRows - 1), 1)])
									.range(countryGridYScaleRange);
	
	starPlotMatrixOrigins = {};
	var assignStarPlotOrigin = function(i) {
		return {
			x: countryGridXScale(i % numOfColumns),
			y: countryGridYScale(quotient(i, numOfColumns))
		};
	}

	var xBrushScaler = d3.scale.identity().domain([0, starPlotsContainerWidth]);
	var yBrushScaler = d3.scale.identity().domain([0, starPlotsContainerHeight]);
	brushingEventListener.x(xBrushScaler)
						 .y(yBrushScaler);

	var starPlotSVG = starPlotsContainer.selectAll("g")
										.data(countries);

	starPlotSVG.enter()
	   		   .append("g")
	   		   .attr("id", function(country) {
	   		   		return country;
	   		   })
	   		   .attr("transform", function(country, i) {
	   		   		var origin = assignStarPlotOrigin(i);
	   		   		starPlotMatrixOrigins[country] = origin;	//useful for determining which countries are brushed
	   		   		return ("translate(" + origin.x + "," + origin.y + ")");
	   		   	})
			   .classed({"country": true, "starplot": true})
			   .each(function(country) {
			   		var countryEnergyData = {};
			   		_.forEach(sources, function(source) {
			   			countryEnergyData[source] = energyData[country][source][year];
			   		});
			   		drawStarPlot(d3.select(this), countryEnergyData, null, null, radius, sources, true, country, "starplot-energy");
			   });

	starPlotsContainer.attr("viewBox", [0, 0, starPlotsContainerWidth, starPlotsContainerHeight].join(" "))	// {width: starPlotsContainerWidth, height: starPlotsContainerHeight}
					  .call(brushingEventListener);
}

var aggregatedEnergyData = {
	total: {},
	filtered: {},
	sustainableGoal: {}
};
function drawAggregatedEnergyStarPlotForCountries(visualizationContainer, countries, filteredCountries, sources, year) {
	var plotTitle = "Total Energy Consumption"
	var diameter = 500;
	var radius = diameter/2;
	var starPlotUnitWidth = diameter + (2 * (padding.inner + (2 * padding.outer)));
	var barChartContainerWidth = starPlotUnitWidth;
	var barChartContainerHeight = 1000;
	var visualizationContainerWidth = starPlotUnitWidth  + (2 * padding.outer);
	var visualizationContainerHeight = starPlotUnitWidth + (2 * padding.outer) + (2 * barChartContainerHeight);
	var origin = {
		starplot: {
			x: 0.5 * visualizationContainerWidth,
			y: 0.5 * (starPlotUnitWidth + (3 * padding.outer))
		},
		legend: {
			x: 2 * padding.outer,
			y: starPlotUnitWidth + padding.outer + margin
		},
		barchart: {
			x: 4 * padding.outer,
			y: (starPlotUnitWidth + (3.3 * padding.outer)) + (2 * margin)
		}
	};

	visualizationContainer.attr("viewBox", [0, 0, visualizationContainerWidth, visualizationContainerHeight].join(" "));	// {width: visualizationContainerWidth, height: visualizationContainerHeight}
	
	//draw the starplot											  
	var starPlotContainer = aggregatedStarPlotContainer.attr("transform", "translate(" + origin.starplot.x + "," + origin.starplot.y + ")")
												  	   .classed("starplot", true);
	
	var allDataLayers = _.keys(aggregatedEnergyData);
	var dataLayers = _.initial(allDataLayers);
	var sustainableLayer = _.last(allDataLayers);
	var styles = {
		total: "starplot-energy",
		filtered: ["starplot-energy", "starplot-filtered-energy"],
		sustainableGoal: ["starplot-energy", "sustainable-goal"]
	};
	drawStarPlot(starPlotContainer, aggregatedEnergyData, dataLayers, "sustainableGoal", radius, sources, true, plotTitle, styles);


	//update starplot legend location
	aggregatedStarPlotLegend.attr("transform", "translate(" + origin.legend.x + "," + origin.legend.y + ")")


	//draw the bar charts
	aggregatedBarChartContainer.attr("transform", "translate(" + origin.barchart.x + "," + origin.barchart.y + ")");

	var maxBarLength = diameter;
	var maxConsumption = _.reduce(aggregatedEnergyData.total, function(totalConsumption, consumption) {
		return (totalConsumption + consumption);
	}, 0);
	var consumptions = [];
	_.forEach(selectedSources, function(source) {
		var sourceGroup = {
			total: aggregatedEnergyData.total[source],
			filtered: aggregatedEnergyData.filtered[source]
		};
		consumptions.push(sourceGroup);
	});
	var barChartData = {
		maxConsumption: maxConsumption,
		labels: selectedSources,
		consumptions: consumptions
	};
	drawTwoViewedBarChart(aggregatedBarChartContainer, barChartData, maxBarLength, barChartContainerWidth, barChartContainerHeight);
}

function updateAllAggregatedEnergyData() {
	updateTotalAggregatedEnergyData();
	updateFilteredAggregatedEnergyData();
}

function updateTotalAggregatedEnergyData() {
	aggregatedEnergyData.total = {};
	_.forEach(selectedSources, function(source) {
		aggregatedEnergyData.total[source] = _.reduce(selectedCountries, function(totalConsumptionForSource, country) {
			return (totalConsumptionForSource + energyData[country][source][selectedYear]);
		}, 0);
	});

	aggregatedEnergyData.sustainableGoal = {};
	var sustainableAverageConsumption = _.reduce(selectedSources, function(totalConsumption, source) {
		return (totalConsumption + aggregatedEnergyData.total[source]);
	}, 0)/_.size(_.intersection(selectedSources, energyMetadata.sourcesByTypes["renewable"]));
	_.forEach(selectedSources, function(source) {
		aggregatedEnergyData.sustainableGoal[source] = (energyMetadata.sourceTypes[source] === "non-renewable") ? 0 : sustainableAverageConsumption;
	});
}

function updateFilteredAggregatedEnergyData() {
	aggregatedEnergyData.filtered = {};
	_.forEach(selectedSources, function(source) {
		aggregatedEnergyData.filtered[source] = _.reduce(filteredCountries, function(totalConsumptionForSource, country) {
			return (totalConsumptionForSource + energyData[country][source][selectedYear]);
		}, 0);
	});
}



var brushingEventListener = d3.svg.brush()
								  .on("brush", brushMove)
								  .on("brushend", brushEnd);

function brushMove() {
	var currentExtent = brushingEventListener.extent();
	individualCountryVisualizationContainer.selectAll("g.starplot")
										   .classed("starplot-selected", function(country, i) {
										   		var origin = starPlotMatrixOrigins[country];
										   		return ((origin.x > currentExtent[0][0]) &&
										   				(origin.y > currentExtent[0][1]) &&
										   				(origin.x < currentExtent[1][0]) &&
										   				(origin.y < currentExtent[1][1]));
										   });
}

function brushEnd() {
	if (brushingEventListener.empty()) {
		individualCountryVisualizationContainer.selectAll("g.starplot-selected")
											   .classed("starplot-selected", false);
	}
	individualCountryVisualizationContainer.call(brushingEventListener.clear());
	
	filteredCountries = individualCountryVisualizationContainer.selectAll("g.starplot-selected").data();
	updateFilteredAggregatedEnergyData();
	clearVisualization(aggregatedStarPlotContainer);
	drawAggregatedEnergyStarPlotForCountries(aggregatedCountryVisualizationContainer, selectedCountries, filteredCountries, selectedSources, selectedYear);
}