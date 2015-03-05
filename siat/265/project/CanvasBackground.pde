/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: CanvasBackground
 
 Description:
 This class represents the lowest layer of the drawing canvas, which
 draws the white background. It is a sub-class of the CanvasLayer class.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class CanvasBackground extends CanvasLayer{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  //  None
  
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
  CanvasBackground(PApplet sketchInstance){
    
    //Call the parent class's constructor and pass in an instance of the main sketch
    super(sketchInstance);
  }
  
  
  
  //-- Setters: --//
  //--------------//
  //  None
  
  //-- Getters: --//
  //--------------//
  //  None
  
  //-- Essential Methods: (Required by Layers library) --//
  //-----------------------------------------------------//
  
  //Setup method for this layer
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void setup(){}
  
  
  //Draw method for this layer; used for drawing the white background of the drawing canvas
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void draw(){
    
    //Set the colour mode of this layer to be RGB with the channel range, [0.0, 255.0]
    this.colorMode(RGB, 255.0);
    
    //Fill the entire drawing canvas white
    background(255);  //RGB, white
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to turn the current layer off
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void turnLayerOff(){
    
    //Turn off the current layer by calling the parent class's turnLayerOff method
    super.turnLayerOff();
  }
  
  
  //Method to turn the current layer on
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void turnLayerOn(){
    
    //Turn on the current layer by calling the parent class's turnLayerOn method
    super.turnLayerOn();
  }
  
  
  //Method to clear the current layer's contents
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void clearContent(){
    
    //Clear the current layer's contents by calling the parent class's clearContent method
    super.clearContent();
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
