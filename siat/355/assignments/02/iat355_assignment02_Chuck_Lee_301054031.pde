/************************************************************
IAT 355 - Assignment 2
Notes: The controller on the right side of the plotting area 
       contains a number of controlP5 toggle switches, which 
       are (hopefully) self explanatory.

Missing functionalities: - markings for the axes
                         - grid for plot
                         - names for axes and plots
                         - interactive filtering
                         - changing colour of time series

Author: Chuck Lee (301054031, cll5@sfu.ca)
************************************************************/



import controlP5.*;
import java.util.List;

final color RED = color(255, 52, 52);
final color BLUE = color(57, 114, 255);
final color GREEN = color(58, 188, 42);
final color PINK = color(255, 196, 207);
final color CYAN = color(101, 229, 245);
final color ORANGE = color(255, 179, 26);
final color BROWN = color(137, 77, 77);
final color PURPLE = color(188, 8, 255);

TimeSeries australiaCurrency;
TimeSeries britishCurrency;
TimeSeries canadianCurrency;
TimeSeries dutchCurrency;
TimeSeries frenchCurrency;
TimeSeries germanCurrency;
TimeSeries japaneseCurrency;
TimeSeries swissCurrency;

TimeSeriesPlot dailyForeignExchangeSeries;

void setup() {
  size(1024, 480);
  smooth();
  background(240);
  
  australiaCurrency = new TimeSeries("Australia to US", "australia-to-us-currency.csv");
  britishCurrency = new TimeSeries("British to US", "british-to-us-currency.csv");
  canadianCurrency = new TimeSeries("Canada to US", "canadian-to-us-currency.csv");
  dutchCurrency = new TimeSeries("Dutch to US", "dutch-to-us-currency.csv");
  frenchCurrency = new TimeSeries("French to US", "french-to-us-currency.csv");
  germanCurrency = new TimeSeries("German to US", "german-to-us-currency.csv");
  japaneseCurrency = new TimeSeries("Japan to US", "japanese-to-us-currency.csv");
  swissCurrency = new TimeSeries("Swiss to US", "swiss-to-us-currency.csv");
  
  australiaCurrency.setLineSegmentColour(RED);
  britishCurrency.setLineSegmentColour(BLUE);
  canadianCurrency.setLineSegmentColour(GREEN);
  dutchCurrency.setLineSegmentColour(PINK);
  frenchCurrency.setLineSegmentColour(CYAN);
  germanCurrency.setLineSegmentColour(ORANGE);
  japaneseCurrency.setLineSegmentColour(BROWN);
  swissCurrency.setLineSegmentColour(PURPLE);
  
  dailyForeignExchangeSeries = new TimeSeriesPlot(this);
  dailyForeignExchangeSeries.addTimeSeries(australiaCurrency);
  dailyForeignExchangeSeries.addTimeSeries(britishCurrency);
  dailyForeignExchangeSeries.addTimeSeries(canadianCurrency);
  dailyForeignExchangeSeries.addTimeSeries(dutchCurrency);
  dailyForeignExchangeSeries.addTimeSeries(frenchCurrency);
  dailyForeignExchangeSeries.addTimeSeries(germanCurrency);
  dailyForeignExchangeSeries.addTimeSeries(japaneseCurrency);
  dailyForeignExchangeSeries.addTimeSeries(swissCurrency);
}

void draw() {
  dailyForeignExchangeSeries.drawPlotArea();
  dailyForeignExchangeSeries.plot();
  dailyForeignExchangeSeries.drawPlotController();
}



public void controlEvent(ControlEvent thisEvent) {
  if (thisEvent.isGroup() && (thisEvent.group().name() == "timeSeriesCheckBox")) {
    // update the minimum and maximum currency values when the time series are reselected by the users
    dailyForeignExchangeSeries.updateCurrencyExtremes();
  }
}
