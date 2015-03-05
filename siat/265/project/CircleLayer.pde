/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: CircleLayer
 
 Description:
 This class represents the layer where all the reactive circles will
 be generated into. It is a sub-class of the CanvasLayer class.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class CircleLayer extends CanvasLayer {

  //-- Fields --------------------------------//
  //------------------------------------------//

  //-- Constants: --//
  //----------------//
  private final int NUM_ROW = 6;               //Number of rows in the circle position's arrays; there are 30 different circle positions on the drawing canvas
  private final int NUM_COL = 5;               //Number of columns in the circle position's arrays; there are 30 different circle positions on the drawing canvas


  //-- Variables: --//
  //----------------//
  private boolean generateCircle;        //Flag to indicate rather the user wish to generate a circle at the current moment
  private Circle circle;                 //A Circle object used for generating the reactive circles on the drawing canvas
  float saturationFactor;                //The colour saturation factor for the reactive circles' colours; used for reacting with the circle
  float circleSpeedFactor;               //Controls the speed of the reactive circles when they are moving
  private PVector [][] defaultPosition;  //Array to store the 30 circle default positions
  private PVector [][] position;         //Array to store the 30 circle current positions
  private PVector velocity;              //The velocity for the reactive circle 



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
  CircleLayer(PApplet sketchInstance){

    //Call the parent class's constructor and pass in an instance of the main sketch
    super(sketchInstance);

    //Initialize all the flags
    generateCircle = false;

    //Initialize the saturation factor for the reactive circles' colour
    saturationFactor = 1.0;

    //Initialize the circle's velocity
    velocity = new PVector(0.0, 0.0);

    //Initialize the Circle object
    circle = new Circle(velocity.x, velocity.y);

    //Initialize the reactive circles' speed factor
    circleSpeedFactor = 0.0;

    //Initialize the circle position arrays
    defaultPosition = new PVector[NUM_ROW][NUM_COL];
    position = new PVector[NUM_ROW][NUM_COL];

    //Calculate the horizontal and vertical distances between each adjacent circle's outer edges
    float xSpace = ( (float) CanvasLayer.CANVAS_WIDTH - (NUM_COL * 2 * Circle.DEFAULT_RADIUS) ) / ( (float) (NUM_COL + 1) );
    float ySpace = ( (float) CanvasLayer.CANVAS_HEIGHT - (NUM_ROW * 2 * Circle.DEFAULT_RADIUS) ) / ( (float) (NUM_ROW + 1) );

    //Define the default and initial circle positions
    for(int row = 0; row < NUM_ROW; row++){
      for(int col = 0; col < NUM_COL; col++){

        //Calculate the next circle's position
        float xPos = ( (col + 1) * (xSpace + (2 * Circle.DEFAULT_RADIUS)) ) - Circle.DEFAULT_RADIUS + CanvasLayer.CANVAS_ORIGIN;
        float yPos = ( (row + 1) * (ySpace + (2 * Circle.DEFAULT_RADIUS)) ) - Circle.DEFAULT_RADIUS + CanvasLayer.CANVAS_ORIGIN;

        defaultPosition[row][col] = new PVector(xPos, yPos);
        position[row][col] = new PVector(xPos, yPos);
      }
    }
  }



  //-- Setters: --//
  //--------------//
  
  //Sets the speed factor of the reactive circles
  //
  //Input parameter:
  //  speedFactor - The speed factor that controls the speed of the reactive circles
  //
  //Output parameter:
  //  None
  public void setSpeedFactor(float speedFactor){
    circleSpeedFactor = speedFactor;
  }



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


  //Draw method for this layer; used for drawing the reactive circles
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void draw(){

    //Set the colour mode of this layer to be HSB with channel ranges:  Hue: 0.0 - 399.0
    //                                                                  Saturation: 0.0 - 99.0
    //                                                                  Brightness: 0.0 - 99.0
    this.colorMode(HSB, 399.0, 99.0, 99.0);

    //Generate a new reactive circle and reset the generateCircle flag
    if(generateCircle == true){
      this.circle.generate(this, saturationFactor);
      generateCircle = false;
    }
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


  //Method to generate a circle at the given position, specified by its array's indices
  //
  //Input parameter:
  //  row                  - The first index (rows) of the circles' 2D position array
  //  col                  - The second index (columns) of the circles' 2D position array
  //  song                 - The song currently playing in the background
  //  fractalStartPosition - The tracker object for storing all the generated fractals' origin coordinates
  //
  //Output parameter:
  //  None
  public void generate(int row, int col, SongTracker song, FractalOriginTracker fractalStartPosition){

    //React the circle with the current song if it is playing
    if(song.isPlaying()){
      reactToMusic(song);
    }
    
    //React the circle's speed with the GUI control if the speed Factor is greater than 0
    if(circleSpeedFactor > 0.0){
      reactToGUI(row, col);
    }
    
    //Set the position for the reactive circle
    circle.setPosition(position[row][col]);

    //Calculate the saturation factor
    saturationFactor = reactToDistance(position[row][col], fractalStartPosition);

    if(saturationFactor < 0.0){
      //The default saturation factor value for no reaction is 10% of the normal saturation values
      saturationFactor = 0.1;
    }

    //Set the generateCircle flag true to indicate the user wants to generate a new reactive circle now
    generateCircle = true;
  }


  //Method to reset the circle positions back to default
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void resetPosition(){
    
    //Reset the circle positions with the default position array
    for(int row = 0; row < NUM_ROW; row++){
      for(int col = 0; col < NUM_COL; col++){
        position[row][col].x = defaultPosition[row][col].x;
        position[row][col].y = defaultPosition[row][col].y;
      }
    }
  }



  //-- Private Methods -------------------------------//
  //--------------------------------------------------//

  //Helper method for reacting the circle with the GUI's slider controller
  //
  //Input parameter:
  //  row - The first index (rows) of the circles' 2D position array
  //  col - The second index (columns) of the circles' 2D position array
  //
  //Output parameter:
  //  None
  private void reactToGUI(int row, int col){
    
    //Calculate a candidate velocity
    float xCandidateVelocity = circleSpeedFactor * velocity.x;
    float yCandidateVelocity = circleSpeedFactor * velocity.y;
    
    //Use the candidate velocity to check if collision along the drawing canvas four edges would occur or not and update the candidate velocity accordingly
    if( ((position[row][col].x + xCandidateVelocity) < CanvasLayer.CANVAS_ORIGIN) || ((position[row][col].x + xCandidateVelocity) > (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_WIDTH)) ){
      xCandidateVelocity *= -1;
    }
    
    if( ((position[row][col].y + yCandidateVelocity) < CanvasLayer.CANVAS_ORIGIN) || ((position[row][col].y + yCandidateVelocity) > (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_HEIGHT)) ){
      yCandidateVelocity *= -1;
    }
    
    //Now update the specified position with the updated candidate velocity after wall collision checking
    position[row][col].x += xCandidateVelocity;
    position[row][col].y += yCandidateVelocity;
  }
  

  //Helper method for reacting the circle with music
  //
  //Input parameter:
  //  song     - The song currently playing in the background
  //
  //Output parameter:
  //  None
  private void reactToMusic(SongTracker song){
    
    //Set the maximum radius of the circle to a random normalized FFT band of the current song only if it is greater than or equal to 10
    float radius = song.getRandomBand();
    if(radius >= 10.0){
      circle.setRadius(radius);
    }
    
    //Update the circle's velocity with a random normalized FFT band and a random scaling factor
    velocity.x = random(-3.0, 3.0) * song.getRandomBand();
    velocity.y = random(-3.0, 3.0) * song.getRandomBand();
  }


  //Helper method for reacting the circle's colour saturation with respect to distance
  //
  //Input parameter:
  //  position             - The position of the circle
  //  fractalStartPosition - The origins of all generated fractals on the drawing canvas
  //
  //Output parameter:
  //  colourSaturationFactor - A factor, ranging in [0.25, 1.0], for the colour saturation of the circle
  //                           Returns a negative value if no there is no reaction, else returns a positive value
  //
  private float reactToDistance(PVector position, FractalOriginTracker fractalStartPosition){

    //Local constants and variables declaration
    float MAX_DISTANCE = sqrt( sq(width) + sq(height) );  //Maximum distance between a circle's position and a fractal's position
    float colourSaturationFactor = -1.0;                  //The output parameter with its default value

    //Only react to the distance if there exist at least one fractal on the drawing canvas
    if(fractalStartPosition.getSize() > 0){

      float minDistance = MAX_DISTANCE;    //Arbitrarily chosen an initial minimum distance between the circle's position and every generated fractals on the drawing canvas

      //Loop through all existing fractals on the drawing canvas and find the shortest distance
      for(int i = 0; i < fractalStartPosition.getSize(); i++){

        //Calculate the distance between the circle's position and the i'th fractal's position
        float tempDistance = sqrt( sq(fractalStartPosition.getOrigin(i).x - position.x) + sq(fractalStartPosition.getOrigin(i).y - position.y) );

        //Update the minimum distance only if the calculated distance is smaller than it
        if(tempDistance < minDistance){
          minDistance = tempDistance;
        }
      }

      //Now react the circle's colour saturation factor with respect to the minimum distance
      //The minimum distance is mapped linearly to the range [0.0, 0.95]
      colourSaturationFactor = 1.0 - map(minDistance, 0.0, MAX_DISTANCE, 0.0, 0.95);
    }

    return colourSaturationFactor;
  }
}

