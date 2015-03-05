var differentialAngle;
var convertToPathData = d3.svg.line.radial()
								   .radius(function(d) {
										return d.radius;
								   })
								   .angle(function(d) {
										return Math.PI * (d.angle / 180);
								   });

function generatePathData(radii) {
	var vertices = _.map(radii, function(radius, i) {
		return {
			radius: radius,
			angle: (i * differentialAngle)
		};
	});
	return (convertToPathData(vertices) + "Z");
}

function drawStarPlotPolygon(starPlotSVG, pathData, styles) {
	//accept styles as an array of css classes
	if (_.isArray(styles) || _.isString(styles)) {
		var stylesObject = {};
		_.forEach((_.isString(styles) ? [styles] : styles), function(style) {
			stylesObject[style] = true;
		});
		styles = stylesObject;
	}

	starPlotSVG.append("path")
			   .attr("d", pathData)
			   .classed(styles);
}

function drawRadialLine(starPlotSVG, initialRadius, finalRadius, angle, styles) {
	var initialPoint = {radius: initialRadius, angle: angle};
	var finalPoint = {radius: finalRadius, angle: angle};
	var pathData = convertToPathData([initialPoint, finalPoint]);
	drawStarPlotPolygon(starPlotSVG, pathData, styles);
}

function drawStarPlot(svgContainer, data, dataLayers, sustainableLayer, radius, branches, showBranchNames, plotTitle, styles) {
	var maxConsumption = _.reduce(branches, function(totalConsumption, branch) {
		var consumption = dataLayers ? data[dataLayers[0]][branch] : data[branch];
		return (totalConsumption + consumption);
	}, 0);

	var radiusScale = d3.scale.linear()
							  .domain([0, maxConsumption])
							  .range([(0.1 * radius), radius]);

	var isAggregatedView = sustainableLayer ? true : false;
	drawStarPlotBase(svgContainer, plotTitle, branches, radius, showBranchNames, isAggregatedView);
	if (dataLayers) {
		_.forEach(dataLayers, function(layer) {
			insertDataToStarPlot(svgContainer, data[layer], radiusScale, styles[layer]);
		});
	} else {
		insertDataToStarPlot(svgContainer, data, radiusScale, styles);
	}

	if (sustainableLayer) {
		insertSustainableGoalToStarPlot(svgContainer, data[sustainableLayer], radiusScale, styles[sustainableLayer]);
	}
}

function drawStarPlotBase(starPlotSVG, title, branches, radius, showBranchNames, isAggregatedView) {
	//show title
	var titleYOffset = radius + padding.inner + (0.6 * padding.outer);

	if (isAggregatedView) {
		titleYOffset += (1.25 * padding.outer)
	}

	starPlotSVG.append("text")
			   .text(title)
			   .attr({"dx": 0, "dy": -titleYOffset})
			   .classed({"starplot-title": true, "starplot-text": true});

	//draw the base starplot shape
	var vertices = _.map(branches, function() {
		return (radius + padding.inner);
	});
	drawStarPlotPolygon(starPlotSVG, generatePathData(vertices), "starplot-base");

	//draw the radial lines and branches' names
	showBranchNames = showBranchNames || false;
	_.forEach(branches, function(branch, i) {
		var currentAngle = i * differentialAngle;
		drawRadialLine(starPlotSVG, (0.1 * radius), radius, currentAngle, "starplot-radial-lines");	//wanted a slight offset from the center of the starplot to avoid the visual limitation of starplots with only one non-zero data point

		if (showBranchNames) {
			var scaledRadius = isAggregatedView ? (1.2 * (radius + padding.inner)) : (1.35 * (radius + padding.inner));
			var angleInRadians = Math.PI * ((currentAngle - 90) / 180);
			starPlotSVG.append("text")
					   .attr({"dx": scaledRadius * Math.cos(angleInRadians), "dy": scaledRadius * Math.sin(angleInRadians)})
					   .text(energyMetadata.sourceNames[branch])
					   .classed("starplot-text", true);
		}
	});
}

function insertDataToStarPlot(starPlotSVG, data, radiusScale, styles) {
	var innerCutData = newFilledArray(_.size(data), radiusScale(0));
	var scaledData = _.map(data, function(d) {
		return radiusScale(d);
	});
	
	var pathData = generatePathData(innerCutData) + generatePathData(scaledData);
	drawStarPlotPolygon(starPlotSVG, pathData, styles);
}

function insertSustainableGoalToStarPlot(starPlotSVG, data, radiusScale, styles) {
	var scaledData = _.map(data, function(d) {
		return radiusScale(d);
	});
	drawStarPlotPolygon(starPlotSVG, generatePathData(scaledData), styles);
}