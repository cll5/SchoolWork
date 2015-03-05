/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: GenerativeShape
 
 Description:
 This class is the parent class of all generative shapes, which are
 the circle and fractal shapes. It contains an instance of the colour
 scheme for the circle and fractal shape classes to use.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class GenerativeShape{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  //  None
  
  //-- Variables: --//
  //----------------//
  private PVector position;            //The position of the generative shape
  private PVector velocity;            //The velocity of the generative shape
  public ColourTracker colourPalette;  //Colour palette for the gnerative shapes to use



  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructors: --//
  //-------------------//
  
  //Constructor with velocity definition
  //
  //Input parameter:
  //  xVel - x-component of the shape's velocity vector
  //  yVel - y-component of the shape's velocity vector
  //
  //Output parameter:
  //  None
  GenerativeShape(float xVel, float yVel){
    position = new PVector(0, 0);
    velocity = new PVector(xVel, yVel);
    
    //Initialize the colour palette for the generative shapes to use
    colourPalette = new ColourTracker();
  }
  
  
  //Constructor with position and velocity definitions
  //
  //Input parameter:
  //  xPos - x-coordinate of the shape's position
  //  yPos - y-coordinate of the shape's position
  //  xVel - x-component of the shape's velocity vector
  //  yVel - y-component of the shape's velocity vector
  //
  //Output parameter:
  //  None
  GenerativeShape(float xPos, float yPos, float xVel, float yVel){
    position = new PVector(xPos, yPos);
    velocity = new PVector(xVel, yVel);
    
    //Initialize the colour palette for the generative shapes to use
    colourPalette = new ColourTracker();
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Sets the shape's position
  //
  //Input parameter:
  //  newPosition - The desired shape position
  //
  //Output parameter:
  //  None
  public void setPosition(PVector newPosition){
    position.x = newPosition.x;
    position.y = newPosition.y;
  }
  
  
  //Sets the shape's velocity
  //
  //Input parameter:
  //  newVelocity - The desired shape velocity
  //
  //Output parameter:
  //  None
  public void setVelocity(PVector newVelocity){
    velocity.x = newVelocity.x;
    velocity.y = newVelocity.y;
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the shape's position
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  shapePosition - The shape's current position
  //
  public PVector getPosition(){
    PVector shapePosition = new PVector(position.x, position.y);
    return shapePosition;
  }
  
  
  //Returns the shape's velocity
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  shapeVelocity - The shape's current velocity
  //
  public PVector getVelocity(){
    PVector shapeVelocity = new PVector(velocity.x, velocity.y);
    return shapeVelocity;
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to update the shape's position according to its current velocity
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void updatePosition(){
    position.add(velocity);
  }
  
  
  public void generate(){}
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
