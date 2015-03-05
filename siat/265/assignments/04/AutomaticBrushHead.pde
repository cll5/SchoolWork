class AutomaticBrushHead extends BasicBrushHead{
  
  //Private Fields
  private int sizeMod;
  private int sizeShift;
  
  //Constructor
  AutomaticBrushHead(){
    super();
    sizeMod = 50;
    sizeShift = 13;
  }
  
  //---------------------- Methods ----------------------//
  
  //-- Setters: --//
  //--------------//
  
  //Set brush head size
  public void setBrushSize(float theSize){
    super.setBrushSize(theSize);
  }
  
  //Set the brush colour
  public void setBrushColour(float r, float g, float b, float transparency){
    super.setBrushColour(r, g, b, transparency);
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Get the brush head size
  public float getBrushSize(){
    return super.getBrushSize();
  }
  
  //Get the brush colour
  public color getBrushColour(){
    return super.getBrushColour();
  }
  
  
  
  //-- Other Public Methods: --//
  //---------------------------//
  
  //Method to automatically generate a brush colour based on the current frameCount
  public void generateColour(){
    float r = (frameCount % 155) + 101;
    float g = (frameCount % 200) + 31;
    float b = (frameCount % 185) + 71;
    float a = (frameCount % 64) + 128;
    super.setBrushColour(r, g, b, a);
  }
  
  //Method to automatically generate a brush size based on the current frameCount
  public void generateSize(){
    float autoSize = (frameCount % 61) + 17; //Arbitrarily chosen prime numbers as the modulo and offset
    super.setBrushSize(autoSize);
  }
  
  //Draw method
  public void draw(){
    super.draw();
  }
  
  
  
  //-- Private Methods: --//
  //----------------------//
  //None
}
