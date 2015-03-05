class BasicBrushHead{
  
  //Public Fields
  private float brushSize;
  private color brushColour;
  
  //Constructor
  BasicBrushHead(){
    brushSize = 15.0;
    brushColour = color(0);
  }
  
  //---------------------- Methods ----------------------//
  
  //-- Setters: --//
  //--------------//
  
  //Set brush head size
  public void setBrushSize(float theSize){
    brushSize = theSize;
  }
  
  //Set the brush colour
  public void setBrushColour(float r, float g, float b, float transparency){
    brushColour = color(r, g, b, transparency);
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Get the brush head size
  public float getBrushSize(){
    return brushSize;
  }
  
  //Get the brush colour
  public color getBrushColour(){
    return brushColour;
  }
  
  
  
  //-- Other Public Methods: --//
  //---------------------------//
  
  //Method to draw a circular brush head
  public void draw(){
    //Draw the brush head at where the mouse is currently located
    pushMatrix();
      translate(mouseX, mouseY);
      
      noStroke();
      fill(brushColour);
      ellipse(0, 0, brushSize, brushSize);
    popMatrix();
  }
  
  
  
  //-- Methods to be overrided by subclasses: --//
  //--------------------------------------------//
  
  //From ThinBrushHead class
  public void setBranch(int n){}
  public void setSpread(float percentage){}
  public void setLength(float theLength){}
  public void release(){}
  
  //From SplatterBrushHead class
  public void setUpperLimit(int n){}
  
  //From AutomaticBrushHead class
  public void generateSize(){}
  public void generateColour(){}
}
