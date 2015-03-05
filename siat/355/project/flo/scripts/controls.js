var selectedCountries;
var filteredCountries;
var selectedSources;
var numOfSources;
var selectedYear;



d3.select("#select-countries").on("change", function(d) {
	var selected = d3.select(this)
					 .selectAll("option")
					 .filter(function() {
						return this.selected;
					 })
					 .data();

	selectedCountries = _.contains(selected, "All Countries") ? energyMetadata.countries : selected;
	updateVisualization();
});

d3.select("#select-sources").on("change", function(d) {
	selectedSources = d3.select(this)
						.selectAll("input")
						.filter(function() {
							return this.checked;
						})
						.data();

	numOfSources = selectedSources.length;
	differentialAngle = 360/numOfSources;
	updateVisualization();
});

d3.select("#select-year").on("change", function(d) {
	selectedYear = +(this.value);
	updateVisualization();
});



function populateControls(countries, sources, years) {
	//countries selection control
	d3.select("#select-countries")
	  .selectAll("option")
	  .data(_.flatten(["All Countries", countries]))
	  .enter()
	  .append("option")
	  .attr("value", function(country) {return country})
	  .text(function(country) {return country})
	  .filter(function(country) {
	  	return (country === "All Countries");
	  })
	  .attr("selected", true);

	
	//sources selection control
	populateEnergySourceControl("#renewable", sources["renewable"]);
	populateEnergySourceControl("#non-renewable", sources["non-renewable"]);
	

	//year selection control
	var latestYear = _.last(energyMetadata.years);
	d3.select("#select-year")
	  .selectAll("option")
	  .data(years)
	  .enter()
	  .append("option")
	  .attr("value", function(year) {return year})
	  .text(function(year) {return year})
	  .filter(function(year) {return (year === latestYear)})
	  .attr("selected", true);
}

function populateEnergySourceControl(selection, sources) {
	var sourceControls = d3.select(selection + " div.source-selectors")
						   .selectAll("div")
						   .data(sources)
						   .enter()
						   .append("div");

	sourceControls.append("input")
				  .attr("type", "checkbox")
				  .attr("value", function(source) {return source})
				  .attr("checked", true);

	sourceControls.append("span")
				  .text(function(source) {return energyMetadata.sourceNames[source]});
}