/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: Fractal
 
 Description:
 This class controls and creates new fractal shapes onto the drawing
 canvas. It is a sub-class of the GenerativeShape class.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class Fractal extends GenerativeShape{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  private final int MAX_ITERATION = 200;       //Maximum number of iterations allowed when iterating the potential Mandelbrot set value
  
  
  //-- Variables: --//
  //----------------//
  private int pixelRemaining;   //Remaining number of pixels left to fill in a colour
  private int paletteSet;       //Use frameCount to determine which colour palette set to use
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  //
  //Input parameter:
  //  xVel      - x-component of the fractal's velocity vector
  //  yVel      - y-component of the fractal's velocity vector
  //  numPixels - Number of pixels to colour
  //
  //Output parameter:
  //  None
  Fractal(float xVel, float yVel, int numPixels){
    
    //Call the parent class's constructor and pass in the velocity components
    super(xVel, yVel);
    
    //Initialize the remaining number of pixels
    pixelRemaining = numPixels;
    
    //Use frameCount to determine which colour palette set to use
    paletteSet = frameCount % 2;
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Sets the origin of the fractal
  //
  //Input parameter:
  //  xOrigin - x-coordinate of the fractal's initial position
  //  yOrigin - y-coordinate of the fractal's initial position
  //
  //Output parameter:
  //  None
  public void setOrigin(float xOrigin, float yOrigin){
    super.setPosition(new PVector(xOrigin, yOrigin));
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the number of pixels left to colour
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  pixelRemaining - The number of pixels left to fill in a colour
  //
  public int getNumberOfPixelsLeft(){
    return pixelRemaining;
  }
  
  public PVector getPosition(){
    return super.getPosition();
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to update the next position of the fractal
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void update(){
    super.updatePosition();
  }
  
  
  //Method to check for collision along the four edges of the drawing canvas
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void checkCollision(){
    
    //Get the position and velocity from the parent class
    PVector pixelPosition = super.getPosition();
    PVector velocity = super.getVelocity();
    
    //Check for collision along the left and right edges of the drawing canvas
    if( (pixelPosition.x < CanvasLayer.CANVAS_ORIGIN) || (pixelPosition.x > (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_WIDTH)) ){
      velocity.x *= -1.0;
    }
    
    //Check for collision along the top and bottom edges of the drawing canvas
    if( (pixelPosition.y < CanvasLayer.CANVAS_ORIGIN) || (pixelPosition.y > (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_HEIGHT)) ){
      velocity.y *= -1.0;
    }
    
    //Update the velocity and position
    super.setVelocity(velocity);
    super.updatePosition();
  }
  
  
  //Method for colouring the current pixel of the fractal based on the number of iterations taken to diverge
  //
  //Input parameter:
  //  fractalLayerInstance - Instance of the fractal layer
  //
  //Output parameter:
  //  None
  public void colourPixel(FractalLayer fractalLayerInstance){
    
    PVector pixelPosition = super.getPosition();              //Get the current position
    int numIter = iterate(pixelPosition.x, pixelPosition.y);  //Get the number of iterations for this pixel
    int colourIndex = 4 - floor( ((float) numIter) / 40.0 );  //Determine the index of the colour palette based on the number of iterations
    
    
    //Determine what colour to fill into the current pixel
    fractalLayerInstance.loadPixels();
    fractalLayerInstance.pixels[((int) pixelPosition.y * width) + (int) pixelPosition.x] = super.colourPalette.getColour(colourIndex, paletteSet);
    fractalLayerInstance.updatePixels();
    
    pixelRemaining--;
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method to perform the iteration: zNext = (zCurr)^2 + zConst, as in calculating the Mandelbrot set
  //
  //Input parameter:
  //  x - x-coordinate of current pixel
  //  y - y-coordinate of current pixel
  //
  //Output parameter:
  //  numIter - Number of iterations taken to calculate
  //
  private int iterate(float x, float y){
    
    //Normalize the current pixel's position relative to the drawing canvas
    float xNormalized = map(x, CanvasLayer.CANVAS_ORIGIN, (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_WIDTH), -2.5, 1.0);
    float yNormalized = map(y, CanvasLayer.CANVAS_ORIGIN, (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_HEIGHT), -1.0, 1.0);
    
    //Initialize a constant complex number based on the current pixel's position
    ComplexNumber zConst = new ComplexNumber(xNormalized, yNormalized);
    
    //Initialize complex variables to perform the iteration
    ComplexNumber zNext = new ComplexNumber(0.0, 0.0);
    ComplexNumber zCurr = new ComplexNumber(0.0, 0.0);
    
    //Counter to keep track of the number of iterations
    int numIter = 0;
    
    //Perform the iteration
    while( (zCurr.getMagnitude() < 2) && (numIter < MAX_ITERATION) ){
      
      //Perform the calculation: zNext = (zCurr)^2 + zConst
      zCurr = zCurr.squared();
      zNext = zCurr.add(zConst);
      zCurr = zNext;
      
      numIter++;  //Increment the iteration counter
    }
    
    return numIter;
  }
}
