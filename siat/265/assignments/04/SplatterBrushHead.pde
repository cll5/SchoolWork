class SplatterBrushHead extends AutomaticBrushHead{
  
  //Private Fields
  private int upperLimit;
  
  //Constructor
  SplatterBrushHead(){
    super();
    upperLimit = 1;
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
  
  //Set the number of splattered "blobs" to draw each time the mouse is pressed
  public void setUpperLimit(int n){
    upperLimit = n;
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
  
  //Method to draw random splattered "blobs" about the mouse position
  public void draw(){
    
    //Initial setting:
    //Use frameCount as the seed for the random generator
    randomSeed(frameCount);
    
    //Variables definition:
    //Get the brush colour
    color splatterColour = super.getBrushColour();
    
    //Generate a splatter distance from the brush size
    float splatterDistance = random( 1, super.getBrushSize() );
    
    //A random diameter of the splattered "blob" based half the splatter distance
    float diameter = random( 1, (0.5 * splatterDistance) );
    
    //A reference angle
    float directionalAngle = 0.0;
    
    //Get the current and previous mouse positions
    int currMouseX = mouseX;
    int currMouseY = mouseY;
    int prevMouseX = pmouseX;
    int prevMouseY = pmouseY;
   
    
    //Calculate the reference angle based on the direction that the mouse was moving in
    if((currMouseX != prevMouseX) || (currMouseY != prevMouseY)){
      directionalAngle = atan2( (currMouseY - prevMouseY), (currMouseX - prevMouseX) );
    } //If the mouse did not move, then keep the reference angle at 0 radian
    
    
    //Draw the splatter effect
    pushMatrix();
      //Start off from the current mouse position
      translate(currMouseX, currMouseY);
      noStroke();
      
      //Draw a splattered "blob" at each round of the for loop
      for(int i = 0; i < upperLimit; i++){
        pushMatrix();
          //Rotate to a splatter direction about the referenced angle
          rotate( (directionalAngle + (directionalAngle * random(-5, 5))) );
          
          pushMatrix();
            //Move along the splatter direction
            translate( (splatterDistance * random(0.5, 1)), 0 );
            
            //Colour the splattered "blob" with the same colour as the brush colour, but with a random transparency
            //Also, randomly stretch the splattered "blob" along the splatter direction
            fill(red(splatterColour), green(splatterColour), blue(splatterColour), random( 1, alpha(splatterColour) ));
            ellipse( 0, 0, diameter, (diameter * random(0.1, 1)) );
          
          popMatrix();
        popMatrix();
      }
    popMatrix();
  }
  
  
  
  //-- Private Methods: --//
  //----------------------//
  //None
}
