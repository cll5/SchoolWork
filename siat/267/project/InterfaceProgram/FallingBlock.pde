/******************************************************
 Falling block:
 ******************************************************/

class FallingBlock{

  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  
  //-- Constants --//
  //---------------//
  private static final float SQUARE_SIZE = 50.0;    //The width of every falling block


  //-- Variables --//
  //---------------//
  private color squareColour;                       //Colour of the falling block
  private PVector position;                         //Position of the falling block's center
  private float velocity;                           //Velocity of the falling block; used to control the falling block's speed



  //-- Public Methods --------------------------------//
  //--------------------------------------------------//

  //-- Constructor: --//
  //------------------//

  //Constructor to pass the falling block's colour, x-coordinate, and velocity as arguments
  FallingBlock(color theColour, float x, float vel){
    
    //Defined settings
    squareColour = theColour;
    position = new PVector(x, -(0.5 * SQUARE_SIZE));
    velocity = vel;
  }



  //-- Setters: --//
  //--------------//

  //Set the velocity of the falling block
  public void setVelocity(float vel){
    velocity = vel;
  }



  //-- Getters: --//
  //--------------//
  
  //Returns the center position of the falling block
  public float getCenterPosition(){
    return position.y;
  }
  
  
  //Returns the position of the falling block's top edge
  public float getUpperEdge(){
    return (position.y - (0.5 * SQUARE_SIZE));
  }
  
  
  //Returns the position of the falling block's bottom edge
  public float getLowerEdge(){
    return (position.y + (0.5 * SQUARE_SIZE));
  }



  //-- Other Methods: --//
  //--------------------//

  //Method to draw a falling block
  public void drawBlock(){

    //Code to draw a falling block
    pushMatrix();
      //Translate to the center of the block
      translate(position.x, position.y);
  
      //Set the falling block's colour properties
      strokeWeight(4);      //Set the block's stroke thickness to 4
      stroke(0);            //Set the block's stroke colour as black
      fill(squareColour);   //Set the block's fill colour
  
      //Draw the falling block
      drawFallingBlock();
    popMatrix();
  }


  //Method to scene of the falling block
  //Method to update the vertical position of the falling block
  public void updateBlock(){
    position.y += velocity;
  }
  
  
  //Method to draw the scoring animation of the falling block
  public void scoreAnimation(float xPosition, float yPosition, int animationState){
    animateScore(xPosition, yPosition, animationState);
  }



  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method to draw a falling block
  private void drawFallingBlock(){

    //Local constants declaration
    //Some pre-calculated sizes of SQUARE_SIZE, used for reducing computation time when drawing the falling block
    float SQ_SZ_20_PERCENT = 0.2 * SQUARE_SIZE;   //20% of SQUARE_SIZE
    float SQ_SZ_40_PERCENT = 0.4 * SQUARE_SIZE;   //40% of SQUARE_SIZE
    float SQ_SZ_50_PERCENT = 0.5 * SQUARE_SIZE;   //Half of SQUARE_SIZE
  
    //Draw the falling block
    //Draw the main body of the falling block (a custom octagon)
    beginShape();
      vertex(-SQ_SZ_40_PERCENT, -SQ_SZ_50_PERCENT);
      vertex(SQ_SZ_40_PERCENT, -SQ_SZ_50_PERCENT);
      vertex(SQ_SZ_50_PERCENT, -SQ_SZ_40_PERCENT);
      vertex(SQ_SZ_50_PERCENT, SQ_SZ_40_PERCENT);
      vertex(SQ_SZ_40_PERCENT, SQ_SZ_50_PERCENT);
      vertex(-SQ_SZ_40_PERCENT, SQ_SZ_50_PERCENT);
      vertex(-SQ_SZ_50_PERCENT, SQ_SZ_40_PERCENT);
      vertex(-SQ_SZ_50_PERCENT, -SQ_SZ_40_PERCENT);
    endShape(CLOSE);

    //Draw the four round corners of the falling block
    arc(-SQ_SZ_40_PERCENT, -SQ_SZ_40_PERCENT, SQ_SZ_20_PERCENT, SQ_SZ_20_PERCENT, -PI, -HALF_PI);  //Draw the top left quarter circle
    arc(SQ_SZ_40_PERCENT, -SQ_SZ_40_PERCENT, SQ_SZ_20_PERCENT, SQ_SZ_20_PERCENT, -HALF_PI, 0);     //Draw the top right quarter circle
    arc(SQ_SZ_40_PERCENT, SQ_SZ_40_PERCENT, SQ_SZ_20_PERCENT, SQ_SZ_20_PERCENT, 0, HALF_PI);       //Draw the bottom right quarter circle
    arc(-SQ_SZ_40_PERCENT, SQ_SZ_40_PERCENT, SQ_SZ_20_PERCENT, SQ_SZ_20_PERCENT, HALF_PI, PI);     //Draw the bottom left quarter circle
  }
  
  
  //Score animation of the falling block, which is called a "phantom block"
  private void animateScore(float xPosition, float yPosition, int animationState){
    
    //Local variable declaration
    //The scale size of the falling block's "phantom block"
    float blockScale = 1.0;
    
    //Set the corresponding animation state
    switch(animationState){
      
      //Animation state 0: phantom block is scaled 1.0x
      case(0):
        blockScale = 1.0;
        break;
        
      //Animation state 1: phantom block is scaled 1.25x
      case(1):
        blockScale = 1.25;
        break;
      
      //Animation state 2: phantom block is scaled to 1.5x
      case(2):
        blockScale = 1.5;
        break;
        
      //Animation state 3: phantom block is scaled to 1.75x
      case(3):
        blockScale = 1.75;
        break;
      
      //Animation state 4: phantom block is scaled to 2.0x
      case(4):
        blockScale = 2.0;
        break;
    }
    
    //Draw the phantom block
    pushMatrix();
      //Translate to the center of the phantom block
      translate(xPosition, yPosition);
      
      //Scale the phantom block
      scale(blockScale);
  
      //Set the phantom block's colour properties
      strokeWeight(2);             //Set the phantom block's stroke thickness to 2
      stroke(255);                 //Set the phantom block's stroke colour as white
      fill(96, 64/blockScale);     //Set the phantom block's fill colour
      
      //Draw the phantom block
      drawFallingBlock();
    popMatrix();
  }
}

