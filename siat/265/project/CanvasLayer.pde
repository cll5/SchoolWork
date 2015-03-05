/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: CanvasLayer
 
 Description:
 This class represents the parent class of all the drawing canvas layers.
 It contains the position and dimension of the drawing canvas. This class
 is a sub-class of the Layer class from the Layers library.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class CanvasLayer extends Layer{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  //Drawing canvas's origin coordinate and dimensions
  public static final int CANVAS_ORIGIN = 10;
  public static final int CANVAS_WIDTH = 580;
  public static final int CANVAS_HEIGHT = 780;
  
  
  //-- Variables: --//
  //----------------//
  //  None
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  //
  //Input parameter:
  //  sketchInstance - Instance of the main sketch
  //
  //Output parameter:
  //  None
  CanvasLayer(PApplet sketchInstance){
    
    //Pass an instance of the main sketch into the Layer class's constructor as required by the Layers library
    super(sketchInstance);
    
    //Limit the dimension of the drawing canvas layers by using the Layer class's clipping variables
    //All drawing canvas layers will start at (10, 10) with dimensions 580px by 780px
    //This is meant for performance purposes
    super.clipX = CANVAS_ORIGIN;
    super.clipY = CANVAS_ORIGIN;
    super.clipWidth = CANVAS_WIDTH;
    super.clipHeight = CANVAS_HEIGHT;
  }
  
  
  
  //-- Setters: --//
  //--------------//
  //  None
  
  //-- Getters: --//
  //--------------//
  //  None
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to turn the current layer off
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void turnLayerOff(){
    
    //Turn off the current layer by passing false into the Layer class's setVisible method's parameter
    super.setVisible(false);
  }
  
  
  //Method to turn the current layer on
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void turnLayerOn(){
    
    //Turn on the current layer by passing true into the Layer class's setVisible method's parameter
    super.setVisible(true);
  }
  
  
  //Method to clear the current layer's contents
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void clearContent(){
    
    //Set the colour mode of this layer to be RGB with the channel range, [0.0, 255.0]
    this.colorMode(RGB, 255.0);
    
    //Fill the entire drawing canvas white
    //Alpha channel set to 0% as required by the Layers library
    background(255, 0);  //RGB, white, transparent
  }
  
  
  
  //-- Methods to be Overrided: --//
  //------------------------------//
  
  //Descriptions of the following methods are given in their specific implementations
  
  //General override methods
  public void setup(){}   //Setup method
  public void draw(){}    //Draw method
  
  //CanvasBackground class specific override methods
  //CircleLayer class specific override methods
  public void generate(int row, int col, SongTracker song, FractalOriginTracker fractalPosition){}
  public void setSpeedFactor(float speedFactor){}
  public void resetPosition(){}
  
  //FractalLayer class specific override methods
  public void createFractal(float xMousePosition, float yMousePosition, FractalOriginTracker fractalStartPosition){}
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
