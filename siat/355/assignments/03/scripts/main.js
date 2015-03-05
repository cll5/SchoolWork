var height = 300;
var padding = {top: 20, right: 10, bottom: 20, left: 10};
var nodeMargin = {upDown: 20, leftRight: 20};
var nodeRadius = 20;
var nodeDiameter = 2 * nodeRadius;
var nodeLabelXOffset = -12;
var nodeLabelYOffset = nodeDiameter;

function drawSelectedNodeLinkGraph(dataset, contactedPhoneIds, selectedPhoneId, filterThreshold) {
	var width = contactedPhoneIds.length * (nodeDiameter + nodeMargin.leftRight);
	var selectedNodeXPosition = (padding.left + nodeDiameter + width + padding.right) / 2;
	var selectedNodeYPosition = padding.top + nodeDiameter;
	var nodesYPosition = height - padding.top - padding.bottom - nodeDiameter;
	var nodesXScale = d3.scale.linear()
							  .domain([0, contactedPhoneIds.length - 1])
							  .range([padding.left + nodeDiameter, width + padding.right]);

	var curve = d3.svg.line.radial()
						   .interpolate("bundle")
						   .tension(0.1)
						   .radius(function(d) {
						   		return d[0];
						   })
						   .angle(function(d) {
						   		return d[1];
						   });

	/*aggregate the number of calls to the selected phone id from the other ids in contactedPhoneIds*/
	var totalCallsSummary = getTotalCallsToId(dataset, selectedPhoneId);
	var aggregatedNodeset = _.map(contactedPhoneIds, function(phoneId) {
		return {
			id: phoneId,
			totalCalls: totalCallsSummary[phoneId]
		};
	});

	/*just making a linear scale relative to the current contactedPhoneIds for determining the links thicknesses*/
	var totalCallAccessor = function(d) {
		return d.totalCalls;
	};
	var linkThickness = d3.scale.linear()
								.domain([d3.min(aggregatedNodeset, totalCallAccessor), d3.max(aggregatedNodeset, totalCallAccessor)])
								.range([2, 20]);



	/*draw the nodes*/
	var phoneIdNodes = d3.select("#phone-ids-nodes");
	clearVisualization(phoneIdNodes);

	/*draw the nodes of the phone ids that have contacted the selected phone id*/
	phoneIdNodes.append("g")
				.selectAll("circle")
				.data(aggregatedNodeset)
				.enter()
				.append("circle")
				.filter(function(d, i) {
			  		return d.totalCalls >= filterThreshold;
			    })
				.attr("class", "node")
				.attr("cx", function(d, i) {
					return nodesXScale(i);
				})
				.attr("cy", nodesYPosition)
				.attr("r", nodeRadius)
				.on("mouseover", showToolTip)
				.on("mouseout", hideToolTip);

	
	/*want to show the tooltip when hovering over the selected phone id node*/
	var aggregatedSelectedPhoneId = [{
		id: selectedPhoneId,
		totalCalls: sum(aggregatedNodeset, "totalCalls")
	}];

	/*draw the node for the selected phone id*/
	phoneIdNodes.append("g")
				.selectAll("circle")
				.data(aggregatedSelectedPhoneId)
				.enter()
				.append("circle")
				.attr("class", "node")
				.attr("cx", selectedNodeXPosition)
				.attr("cy", selectedNodeYPosition)
				.attr("r", nodeRadius)
				.on("mouseover", showToolTip)
				.on("mouseout", hideToolTip);



	/*label the nodes*/
	var phoneIdLabels = d3.select("#phone-ids-nodes-labels");
	clearVisualization(phoneIdLabels);

	/*label the nodes from the contactedPhoneIds*/
	phoneIdLabels.append("g")
				 .selectAll("text")
				 .data(aggregatedNodeset)
				 .enter()
				 .append("text")
				 .filter(function(d, i) {
				 	return d.totalCalls >= filterThreshold;
				 })
				 .attr("class", "node-label")
				 .attr("transform", function(d, i) {
				 	return "translate(" + nodesXScale(i) + "," + nodesYPosition + ")";
				 })
				 .attr("x", nodeLabelXOffset)
				 .attr("y", nodeLabelYOffset)
				 .text(function(d) {
				 	return padZero(d.id);
				 });

	/*label the selected phone id node*/
	phoneIdLabels.append("g")
				 .append("text")
				 .attr("class", "node-label")
				 .attr("x", nodeLabelXOffset)
				 .attr("y", -(1.5 * nodeRadius))
				 .attr("transform", "translate(" + selectedNodeXPosition + "," + selectedNodeYPosition + ")")
				 .text(padZero(selectedPhoneId));



	/*draw the links that connect the nodes to the selected phone id node*/
	var phoneCallLinks = d3.select("#phone-calls-links");
	clearVisualization(phoneCallLinks);

	phoneCallLinks.selectAll("path")
				  .data(aggregatedNodeset)
				  .enter()
				  .append("path")
				  .filter(function(d, i) {
				  	return d.totalCalls >= filterThreshold;
				  })
				  .attr("class", "link")
				  .attr("transform", "translate(" + selectedNodeXPosition + "," + selectedNodeYPosition + ")")
				  .attr("stroke-width", function(d, i) {
				  	return linkThickness(d.totalCalls);
				  })
				  .attr("d", function(d, i) {
				  	/*TODO: figure out how to make use of the interpolate and tension features*/
				  	var x = selectedNodeXPosition - nodesXScale(i);
				  	var y = nodesYPosition - selectedNodeYPosition;

				  	var startRadius = 0;
				  	var endRadius = Math.sqrt(Math.pow(y, 2) + Math.pow(x, 2));	/*Ecludean distance*/
				  	var startAngle = endAngle = Math.PI + Math.atan(x/y);
				  	return curve([[startRadius, startAngle], [endRadius, endAngle]]);
				  })
				  .on("mouseover", showToolTip)
				  .on("mouseout", hideToolTip);
				  
}

function showToolTip(d, i) {
	d3.select("#tooltip")
	  .style({
	  	"top": (event.pageY - 10) + "px",
	  	"left": (event.pageX + 10) + "px"
	  })
	  .text("Number of calls: " + d.totalCalls)
	  .classed("hide-this-element", false);
}

function hideToolTip() {
	d3.select("#tooltip").classed("hide-this-element", true);
}

function clearVisualization(visualizationSelector) {
	visualizationSelector.html("");
}

function getTotalCallsToId(dataset, phoneId) {
	return _.countBy(dataset, function(row) {
		return (row.from === phoneId) ? row.to : row.from;
	});
}



/*control handlers*/
/*filtering threshold control handler*/
var phoneCallsThreshold = +d3.select("#controls-calls-threshold").attr("value");
d3.select("#controls-calls-threshold").on("change", function() {
	var threshold = Math.round(+this.value);
	phoneCallsThreshold = this.value = (threshold < 0) ? 0 : threshold; /*bound threshold to be 0 or greather*/
});

/*phone id selection control handler*/
var selectedPhoneId = +d3.select("#controls-select-id").attr("value");
d3.select("#controls-select-id").on("change", function() {
	var id = Math.round(+this.value);
	selectedPhoneId = this.value = (id < 0) ? 0 : id; /*bound id to be 0 or greater*/
	filteredPhoneDataset = filterPhoneDataset(phoneDataset, selectedPhoneId);
	phoneIds = extractUniquePhoneIdSet(filteredPhoneDataset, selectedPhoneId);
});

/*visualization controller handler*/
d3.select("#visualization-controls").on("change", function() {	
	drawSelectedNodeLinkGraph(filteredPhoneDataset, phoneIds, selectedPhoneId, phoneCallsThreshold);
});