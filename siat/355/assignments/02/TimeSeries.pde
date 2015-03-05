class TimeSeries {
  // data attributes of time series
  private String[] time;
  private float[] values;
  
  // data summary attributes
  private String minTime;
  private String maxTime;
  private float minValue;
  private float maxValue;
  
  // metadata of time series
  private String seriesName;
  private int seriesSize;
  
  // visual attributes of time series plot
  private boolean showLineSegments;
  private color lineSegmentColour;
  private float lineSegmentThickness;
  
  
  
  TimeSeries(String timeSeriesName, String fileName) {
    String[] lines = loadStrings(fileName);
    
    if (lines != null) {
      // metadata
      seriesName = timeSeriesName;
      seriesSize = lines.length - 1;  // exclude the column name line of the csv
      
      // load the time series data from the given file, assuming time series data only has one time column and one values column
      time = new String[seriesSize];
      values = new float[seriesSize];
      for (int row = 1; row <= seriesSize; row++) {
        String[] thisLine = split(lines[row], ",");
        time[row - 1] = thisLine[0];
        values[row - 1] = float(thisLine[1]);
      }
      
      // compute summary data
      String[] sortedTime = sort(time);
      minTime = sortedTime[0];
      maxTime = sortedTime[seriesSize - 1];
      minValue = min(values);
      maxValue = max(values);
      
      // report the summary data
      println("\n\n");
      println("Summary of " + timeSeriesName + " data:");
      println("There were " + seriesSize + " lines of data.");
      println("  TIME:");
      println("    min: " + minTime);
      println("    max: " + maxTime);
      println("  VALUE:");
      println("    min: " + minValue);
      println("    max: " + maxValue);
      println("\n\n");
      
      // default visual attributes
      showLineSegments = true;
      lineSegmentColour = color(0, 0, 0);
      lineSegmentThickness = 1.0;
    } else {
      println("\nERROR: Constructing TimeSeries(\"" + timeSeriesName + "\", \"" + fileName + "\") failed: " + fileName + " does not exist!\n");
    }
  }
  
  
  
  public String getTimeSeriesName() {
    return seriesName;
  }
  
  public int getTimeSeriesSize() {
    return seriesSize;
  }
  
  public String getTime(int index) {
    return ((index >= 0) && (index < seriesSize)) ? time[index] : null;
  }
  
  public float getValue(int index) {
    return ((index >= 0) && (index < seriesSize)) ? values[index] : null;
  }
  
  public String getMinTime() {
    return minTime;
  }
  
  public String getMaxTime() {
    return maxTime;
  }
  
  public float getMinValue() {
    return minValue;
  }
  
  public float getMaxValue() {
    return maxValue;
  }
  
  public boolean isLineSegmentVisible() {
    return showLineSegments;
  }
  
  public color getLineSegmentColour() {
    return lineSegmentColour;
  }
  
  public float getLineSegmentThickness() {
    return lineSegmentThickness;
  }
  
  
  
  public void toggleLineSegmentVisibility(boolean enableLineSegments) {
    showLineSegments = enableLineSegments;
  }
  
  public void setLineSegmentColour(color newColour) {
    lineSegmentColour = newColour;
  }
  
  public void setLineSegmentThickness(float newThickness) {
    lineSegmentThickness = newThickness;
  }
}
