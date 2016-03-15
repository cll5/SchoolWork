function drawTwoViewedBarChart(visualizationContainer, combinedData, maxBarLength, chartWidth, chartHeight) {
	var n = _.size(combinedData.consumptions);
	var barChartWidth = chartWidth - (2 * barChartMargin);
	chartHeight = chartHeight - (4 * barChartMargin);
	var barChartHeight = chartHeight * (n / (1 + n));
	drawBarChart(visualizationContainer.select("#barchart-source-breakdown"), combinedData, maxBarLength, barChartWidth, barChartHeight);

	visualizationContainer.select("#barchart-aggregated").attr("transform", "translate(0," + (barChartHeight + barChartMargin) + ")");
	barChartHeight = chartHeight / (1 + n);
	
	var filtered = _.reduce(combinedData.consumptions, function(totalConsumption, consumption) {
		return (totalConsumption + consumption.filtered);
	}, 0);
	var aggregatedData = _.cloneDeep(combinedData);
	aggregatedData.labels = ["Total Consumptions"];
	aggregatedData.consumptions = [{
		total: combinedData.maxConsumption,
		filtered: filtered
	}];

	drawBarChart(visualizationContainer.select("#barchart-aggregated"), aggregatedData, maxBarLength, barChartWidth, barChartHeight);
}



var barChartMargin = 20;
var barChartPadding = {top: 20, right: 20, bottom: 20, left: 20};
function drawBarChart(visualizationContainer, data, maxBarLength, chartWidth, chartHeight) {
	var n = _.size(data.labels);
	var barScale = d3.scale.linear()
						   .domain([0, data.maxConsumption])
						   .range([0, maxBarLength]);

	var axisScale = d3.scale.linear()
							.domain([0, (n - 1)])
							.range([barChartPadding.top, chartHeight - barChartPadding.bottom]);

	var labelScale = d3.scale.ordinal()
							 .domain(data.labels)
							 .rangeBands(axisScale.range(), 0.2, 0);

	var barChartBinSize = (labelScale.rangeBand()/2);
	drawBarChartAxis(visualizationContainer, data.labels, labelScale);
	
	var enteringData = visualizationContainer.select("g.barchart")
											 .html("")
											 .selectAll("rect.bar")
									 	 	 .data(data.consumptions)
									 	 	 .enter();

	enteringData.append("rect")
				.classed({"bar": true, "bar-total": true})
				.attr("x", barChartPadding.left)
				.attr("y", function(d, i) {
					return labelScale(data.labels[i]);
				})
				.attr("height", barChartBinSize)
				.attr("width", function(d, i) {
					return barScale(d.total);
			 	});

	enteringData.append("rect")
				.classed({"bar": true, "bar-filtered": true})
				.attr("x", barChartPadding.left)
				.attr("y", function(d, i) {
					return (labelScale(data.labels[i]) + barChartBinSize);
				})
				.attr("height", barChartBinSize)
				.attr("width", function(d, i) {
					return barScale(d.filtered);
				});
}

function drawBarChartAxis(visualizationContainer, labels, labelScale) {
	var axis = d3.svg.axis()
	                 .scale(labelScale)
	                 .orient("left");

	visualizationContainer.select("g.barchart-axis")
						  .call(axis);
}