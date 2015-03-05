/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: Circle
 
 Description:
 This class is used to control and create new reactive circles onto
 the drawing canvas. It is a sub-class of the GenerativeShape class.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class Circle extends GenerativeShape{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  public static final float DEFAULT_RADIUS = 55.0;
  
  //-- Variables: --//
  //----------------//
  private float maxRadius;
  private float shrinkFactor;
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor with position definition
  //
  //Input parameter:
  //  xPos - x-coordinate of the circle's position
  //  yPos - y-coordinate of the circle's position
  //
  //Output parameter:
  //  None
  Circle(float xPos, float yPos){
    super(xPos, yPos, 0.0, 0.0);
    
    maxRadius = DEFAULT_RADIUS;
    shrinkFactor = 0.6;
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Sets the maximum radius of the circle
  //
  //Input parameter:
  //  maxRad - The desired maximum radius
  //
  //Output parameter:
  //  None
  public void setRadius(float maxRad){
    maxRadius = maxRad;
  }
  
  
  //Sets the circle's radius shrinking factor
  //
  //Input parameter:
  //  newShrinkFactor - The desired radius shrinking factor
  //
  //Output parameter:
  //  None
  public void setShrinkFactor(float newShrinkFactor){
    shrinkFactor = newShrinkFactor;
  }
  
  
  //Sets the circle's position
  //
  //Input parameter:
  //  position - The circle's position
  //
  //Output parameter:
  //  None
  public void setPosition(PVector position){
    super.setPosition(position);
  }
  
  
  
  //-- Getters: --//
  //--------------//
  //  None
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to generate a new circle on the drawing canvas
  //
  //Input parameter:
  //  circleLayerInstance - Instance of the circle layer; used to draw the circle onto the CircleLayer class's draw method
  //  saturationFactor    - A factor, ranging in [0.25, 1.0], to scale the colour saturation level of the generating circle
  //
  //Output parameter:
  //  None
  public void generate(CircleLayer circleLayerInstance, float saturationFactor){
    
    //Set the colour mode to HSB to obtain the correct pre-defined colour palettes
    colorMode(HSB, 399.0, 99.0, 99.0);
    circleLayerInstance.smooth();
    
    pushMatrix();
      //Get and translate the circle's position
      PVector position = super.getPosition();
      circleLayerInstance.translate(position.x, position.y);
      
      //Calculate the maximum diameter of the circle
      float diameter = 2 * maxRadius;
      
      //Use frameCount to determine which colour palette set to use
      int paletteSet = frameCount % 2;
      
      //Draw the circle
      circleLayerInstance.noStroke();
      for(int i = 0; i < super.colourPalette.getSize(); i++){
      
        //Get the colour for the current disk of the circle
        color origColour = super.colourPalette.getColour(i, paletteSet);
        color diskColour = color(hue(origColour), (saturationFactor * saturation(origColour)), brightness(origColour));

        //Draw the circle
        circleLayerInstance.fill(diskColour);
        circleLayerInstance.ellipse(0, 0, diameter, diameter);
        
        //Shrink the next inner circle's diameter by the shrinking factor 
        diameter *= shrinkFactor;
      }
    popMatrix();
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
