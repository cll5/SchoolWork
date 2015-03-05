class Canvas{
  
  //Private Fields
  private int canvasPosX, canvasPosY; //Sets position of the drawing canvas
  private int canvasWidth, canvasHeight; //Controls the size of the drawing canvas
  private int shadowThickness; //Controls the thickness of the drawing canvas shadow
  private int canvasColour; //Controls the background colour of the drawing canvas
  private PFont arial, century; //GUI fonts

  //Constructor to set the drawing canvas position
  Canvas(int xPosition, int yPosition){
    
    //Load the fonts
    arial = loadFont("ArialUnicodeMS-12.vlw");
    century = loadFont("CenturyGothic-30.vlw");
    
    //Initialize all the other fields
    canvasPosX = xPosition;
    canvasPosY = yPosition;
    canvasWidth = width - (2 * xPosition);
    canvasHeight = 660;
    shadowThickness = 5;
    canvasColour = 255;
  }
  
  //---------------------- Methods ----------------------//
  
  //-- Setters: --//
  //--------------//
  //None
  
  
  //-- Getters: --//
  //--------------//
  
  //Get the width of the drawing canvas
  public int getWidth(){
    return canvasWidth;
  }
  
  //Get the height of the drawing canvas
  public int getHeight(){
    return canvasHeight;
  }
  
  
  
  //-- Other Public Methods: --//
  //---------------------------//
  
  //Method to clear the drawing canvas
  public void clear(){
    //Change the colour mode to 8-bits RGB channels
    colorMode(RGB, 255);
    
    //Clear the drawing canvas
    background(196);
    
    //Draw the drawing canvas
    pushMatrix();
      translate(canvasPosX, canvasPosY);
      noStroke();
      fill(canvasColour);
      rect(0, 0, canvasWidth, canvasHeight);
    popMatrix();
    
    //Draw the shadow
    drawShadow();
    
    //Refresh the GUI
    refreshGUIBackground();
    refreshGUIText();
  }
  
  
  //Method to create an illustional boundary for the canvas
  //to keep the paintings within the drawing canvas
  public void checkBoundary(){
    //Change the colour mode to 8-bits RGB channels
    colorMode(RGB, 255);
    
    noStroke();
    fill(196);
    
    //Top boundary
    rect(0, 0, width, canvasPosY); 
    
    //Left boundary
    rect(0, 0, canvasPosX, height); 
    
    //Right boundary
    pushMatrix();
      translate((canvasPosX + canvasWidth), 0);
      rect(0, 0, width, height);
    popMatrix();
    
    //Bottom boundary
    pushMatrix();
      translate(0, (canvasPosY + canvasHeight));
      rect(0, 0, width, (height - canvasPosY - canvasHeight));
    popMatrix();
    
    //Draw the shadow
    drawShadow();
    
    //Refresh the GUI
    refreshGUIBackground();
    refreshGUIText();
  }
  
  
  
  //-- Private Methods: --//
  //----------------------//
  
  //Method to draw the canvas shadow
  private void drawShadow(){
    noStroke();
    fill(64);
    
    //Draw the right shadow
    pushMatrix();
      translate((canvasPosX + canvasWidth), (canvasPosY + shadowThickness));  
      rect(0, 0, shadowThickness, canvasHeight);
    popMatrix();
    
    //Draw the bottom shadow
    pushMatrix();
      translate((canvasPosX + shadowThickness), (canvasPosY + canvasHeight));
      rect(0, 0, canvasWidth, shadowThickness);
    popMatrix();
  }
  
  //Method to refresh the background colour of the GUI
  //(Technically, this method isn't related to the canvas, but for clarity purposes
  // in the main code... what the heck, it gets stored in this class for now)
  private void refreshGUIBackground(){
    fill(0);
    rect(canvasPosX, (canvasHeight + canvasPosY + 20), canvasWidth, 120);
  }
  
  //Method to refresh the GUI texts
  private void refreshGUIText(){
    
    //Type out the GUI control names
    textFont(arial, 12);
    fill(0, 255, 0);
    text("Brush Type:", 24, 704);
    text("Brush Colour/Size:", 160, 704);
    text("Thin Brush Settings:", 320, 704);
    text("Auto Brush Mode:", 24, 780);
    text("Splatter Brush Setting:", 456, 704);
    text("Clear Screen / Save:", 456, 744);
    
    //Type out the program name
    textFont(century, 30);
    fill(255);
    text("Draw for Fun", 396, 804);
  }
}
