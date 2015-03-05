class TimeSeriesPlot {
  final private float PLOT_MARGIN = 40.0;
  final private float PLOT_PADDING = 10.0;
  final private float PLOT_CONTROLLER_PADDING = 10.0;
  final private float PLOT_CONTROLLER_WIDTH = 280.0;
  private float PLOT_CONTROLLER_HEIGHT;
  private float PLOT_WIDTH;
  private float PLOT_HEIGHT;
  
  final private color PLOT_CONTROLLER_BACKGROUND = color(120);
  final private color PLOT_BACKGROUND = color(255);
  final private color PLOT_OUTLINE = color(200);
  
  private String minTime;
  private String maxTime;
  private float minCurrency;
  private float maxCurrency;
  
  private ArrayList<TimeSeries> timeSeriesSet;
  private ControlP5 plotController;
  private Toggle lineSegmentToggle;
  private CheckBox timeSeriesCheckBox;
  
  
  
  TimeSeriesPlot(PApplet sketchInstance) {
    PLOT_CONTROLLER_HEIGHT = height;
    PLOT_WIDTH = width - (2 * PLOT_MARGIN) - PLOT_CONTROLLER_WIDTH;
    PLOT_HEIGHT = height - (2 * PLOT_MARGIN);
    
    timeSeriesSet = new ArrayList<TimeSeries>();
    minTime = "9999-99-99";
    maxTime = "0000-00-00";
    minCurrency = 0.0;
    maxCurrency = 0.0;
    
    plotController = new ControlP5(sketchInstance);
    setupPlotController();
  }
  
  private void setupPlotController() {
    // defining the color scheme of the plot controller
    plotController.setColorBackground(color(255));
    plotController.setColorForeground(color(200, 80, 0));
    plotController.setColorActive(color(240, 100, 0));
    plotController.setColorLabel(color(0, 102, 153));
    
    plotController.setFont(loadFont("font/ArialMT-52.vlw"), 12);
    
    // defining the controls
    float controlAreaX = PLOT_WIDTH + (2 * PLOT_MARGIN) + PLOT_CONTROLLER_PADDING;
    float controlAreaY = PLOT_CONTROLLER_PADDING;
    lineSegmentToggle = plotController.addToggle("lineSegmentToggle", true, controlAreaX, controlAreaY, 15, 15);
    lineSegmentToggle.captionLabel().set("Show Line Segments");
    lineSegmentToggle.captionLabel().toUpperCase(false);
    lineSegmentToggle.captionLabel().getStyle().marginLeft = 20;
    lineSegmentToggle.captionLabel().getStyle().marginTop = -15;
    
    timeSeriesCheckBox = plotController.addCheckBox("timeSeriesCheckBox", 10, 10)
                                       .setPosition(controlAreaX, controlAreaY + 50)
                                       .setItemsPerRow(1)
                                       .setSpacingRow(10);
  }
  
  
  
  public void addTimeSeries(TimeSeries newTimeSeries) {
    if (timeSeriesSet.size() == 0) {
      minCurrency = newTimeSeries.getMinValue();
      maxCurrency = newTimeSeries.getMaxValue();
    }
    
    minTime = (newTimeSeries.getMinTime().compareToIgnoreCase(minTime) <= 0) ? newTimeSeries.getMinTime() : minTime;
    maxTime = (newTimeSeries.getMaxTime().compareToIgnoreCase(maxTime) >= 0) ? newTimeSeries.getMaxTime() : maxTime;
    minCurrency = (newTimeSeries.getMinValue() <= minCurrency) ? newTimeSeries.getMinValue() : minCurrency;
    maxCurrency = (newTimeSeries.getMaxValue() >= maxCurrency) ? newTimeSeries.getMaxValue() : maxCurrency;
    
    String newTimeSeriesName = newTimeSeries.getTimeSeriesName();
    timeSeriesSet.add(newTimeSeries);
    timeSeriesCheckBox.addItem(newTimeSeriesName, 0.0)
                      .activate(newTimeSeriesName);
  }
  
  void drawPlotArea() {
    noStroke();
    fill(PLOT_BACKGROUND);
    rect(0, 0, PLOT_WIDTH + (2 * PLOT_MARGIN), PLOT_HEIGHT + (2 * PLOT_MARGIN));
    
    // draw in plotting area
    pushMatrix();
      translate(PLOT_MARGIN, PLOT_MARGIN);
      stroke(PLOT_OUTLINE);
      strokeWeight(1.5);
      rect(0, 0, PLOT_WIDTH, PLOT_HEIGHT);
      
      // draw in the extreme axes markers
      float halfLength = PLOT_PADDING/2.0;
      fill(0);
      textSize(8);
      pushMatrix();
        translate(0, PLOT_PADDING);
        line(-halfLength, 0, halfLength, 0);
        text(nfc(maxCurrency, 2), -halfLength - 30.0, 2.0);
        
        pushMatrix();
          translate(0, PLOT_HEIGHT - (2 * PLOT_PADDING));
          line(-halfLength, 0, halfLength, 0);
          text(nfc(minCurrency, 2), -halfLength - 30.0, 2.0);
          
          pushMatrix();
            translate(PLOT_PADDING, PLOT_PADDING);
            line(0, -halfLength, 0, halfLength);
            text(minTime, -25.0, halfLength + 10.0);
            
            pushMatrix();
              translate(PLOT_WIDTH - (2 * PLOT_PADDING), 0);
              line(0, -halfLength, 0, halfLength);
              text(maxTime, -25.0, halfLength + 10.0);
            popMatrix();
          popMatrix();
        popMatrix();
      popMatrix();
    popMatrix();
  }
  
  void drawPlotController() {
    pushMatrix();
      translate(PLOT_WIDTH + (2 * PLOT_MARGIN), 0);
      noStroke();
      fill(PLOT_CONTROLLER_BACKGROUND);
      rect(0, 0, PLOT_CONTROLLER_WIDTH, PLOT_CONTROLLER_HEIGHT);
      
      // draw the colour code indicators for the time series
      pushMatrix();
        translate(PLOT_CONTROLLER_WIDTH - PLOT_CONTROLLER_PADDING - 30.0, PLOT_CONTROLLER_PADDING + 50);
        for (int i = 0; i < timeSeriesSet.size(); i++) {
          fill(timeSeriesSet.get(i).getLineSegmentColour());
          rect(0, 0, 30.0, 10.0);
          translate(0, 20.0);
        }
      popMatrix();
    popMatrix();
  }
  
  public void plot() {
    pushMatrix();
      translate(PLOT_MARGIN + PLOT_PADDING, PLOT_MARGIN + PLOT_PADDING);
      
      float plottableWidth = PLOT_WIDTH - (2 * PLOT_PADDING);
      float plottableHeight = PLOT_HEIGHT - (2 * PLOT_PADDING);
      
      // draw each time series plot
      for (int i = 0; i < timeSeriesSet.size(); i++) {
        TimeSeries thisTimeSeries = timeSeriesSet.get(i);
        
        // should only draw the time series that are selected
        if (timeSeriesCheckBox.getState(thisTimeSeries.getTimeSeriesName())) {
          float oldX = 0.0;
          float oldY = plottableHeight - (((thisTimeSeries.getValue(0) - minCurrency) / (maxCurrency - minCurrency)) * plottableHeight);
          
          // draw each point of this time series
          strokeWeight(thisTimeSeries.getLineSegmentThickness());
          for (int j = 1; j < thisTimeSeries.getTimeSeriesSize(); j++) {
            float x = (j / float(thisTimeSeries.getTimeSeriesSize() - 1)) * plottableWidth;
            float y = plottableHeight - (((thisTimeSeries.getValue(j) - minCurrency) / (maxCurrency - minCurrency)) * plottableHeight);
            
            // draw line segments
            if (lineSegmentToggle.getState()) {
              stroke(thisTimeSeries.getLineSegmentColour());
              noFill();
              line(oldX, oldY, x, y);
            }
            
            // draw points
            noStroke();
            fill(thisTimeSeries.getLineSegmentColour());
            ellipse(x, y, 2, 2);
            
            oldX = x;
            oldY = y;
          }
        }
      }
    popMatrix();
  }
  
  public void updateCurrencyExtremes() {
    if (timeSeriesSet.size() > 0) {
      int firstSelectedTimeSeriesIndex = 0;
      boolean isAnyTimeSeriesSelected = false;
      
      // identify which time series is selected first on the check box list
      List<Toggle> timeSeriesToggles = timeSeriesCheckBox.getItems();
      int i = 0;
      while (!isAnyTimeSeriesSelected && (i < timeSeriesToggles.size())) {
        isAnyTimeSeriesSelected = isAnyTimeSeriesSelected || timeSeriesToggles.get(i).getState();
        i++;
      }
      firstSelectedTimeSeriesIndex = i - 1;
      
      // update the currency minimum and maximum according to the set of selected time series
      if (isAnyTimeSeriesSelected) {
        float newMinCurrency = timeSeriesSet.get(firstSelectedTimeSeriesIndex).getMinValue();
        float newMaxCurrency = timeSeriesSet.get(firstSelectedTimeSeriesIndex).getMaxValue();
        for (i = firstSelectedTimeSeriesIndex + 1; i < timeSeriesSet.size(); i++) {
          TimeSeries thisTimeSeries = timeSeriesSet.get(i);
          if (timeSeriesCheckBox.getState(thisTimeSeries.getTimeSeriesName())) {
            newMinCurrency = (newMinCurrency <= thisTimeSeries.getMinValue()) ? newMinCurrency : thisTimeSeries.getMinValue();
            newMaxCurrency = (newMaxCurrency >= thisTimeSeries.getMaxValue()) ? newMaxCurrency : thisTimeSeries.getMaxValue();
          }
        }
        minCurrency = newMinCurrency;
        maxCurrency = newMaxCurrency;
      } else {
        minCurrency = 0.0;
        maxCurrency = 0.0;
      }
    }
  }
}
