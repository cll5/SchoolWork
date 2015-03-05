/******************************************************
 Game scene:
******************************************************/

class GameScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  
  //-- Constants --//
  //---------------//
  //Falling block region constants
  private static final int BLOCK_REGION_X = 250;                //x-coordinate of the falling block region 
  private static final int BLOCK_REGION_Y = 0;                  //y-coordinate of the falling block region
  private static final float BLOCK_REGION_WIDTH = 360.0;        //Width of the falling block region
  private static final float BLOCK_REGION_HEIGHT = 500.0;       //Height of the falling block region
  private static final float SCORE_REGION_UPPER_LIMIT = 432.0;  //y-coordinate of the scoring region's upper boundary as seen from the screen
  private static final float SCORE_REGION_LOWER_LIMIT = 500.0;  //y-coordinate of the scoring region's lower boundary as seen from the screen
    
  //Colour constants
  //Falling block colours
  private final color [] BLOCK_COLOURS = {color(0, 255, 0),     //Green
                                          color(255, 0, 0),     //Red
                                          color(0, 0, 255),     //Blue
                                          color(255, 255, 0)};  //Yellow
  
  //Falling block region background colours                                       
  private final color DARK_GRAY = color(64);                    //Darker gray
  private final color GRAY = color(96);                         //Normal gray
  private final color WHITE = color(255);                       //White
  
  //Drum flash colour
  private final color GOLD = color(234, 190, 76);               //Gold
  
  
  //Drum property constants
  private final float DRUM_DIAMETER = 80.0;
  private final PVector [] DRUM_POSITION = {new PVector((BLOCK_REGION_X + (0.2 * 1 * BLOCK_REGION_WIDTH) - 10), (BLOCK_REGION_HEIGHT + 100)),    //Position of the green drum
                                            new PVector((BLOCK_REGION_X + (0.2 * 2 * BLOCK_REGION_WIDTH) - 10), (BLOCK_REGION_HEIGHT + 50)),     //Position of the red drum
                                            new PVector((BLOCK_REGION_X + (0.2 * 3 * BLOCK_REGION_WIDTH) + 10), (BLOCK_REGION_HEIGHT + 50)),     //Position of the blue drum
                                            new PVector((BLOCK_REGION_X + (0.2 * 4 * BLOCK_REGION_WIDTH) + 10), (BLOCK_REGION_HEIGHT + 100))};   //Position of the yellow drum
  
  
  //-- Variables --//
  //---------------//
  private ArrayList<FallingBlock> [] fallingBlocks;             //Array to store four dynamic arrays of each coloured falling blocks
  private float [] scoredBlockYPositionTracker;                 //Keeps track of the y-position of scored blocks in each of the four column
  private float blockSpeed;                                     //Velocity (speed) of the falling blocks
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor to pass the background image name and font file name as arguments
  GameScene(PApplet mainSketchInstance, String imageName, String fontFileName){
    
    //Call the parent class's constructor
    super(imageName, fontFileName);
    
    //Initialize the falling blocks dynamic arrays
    fallingBlocks = new ArrayList[4];
    
    //Initialize the scored blocks y-position tracker
    scoredBlockYPositionTracker = new float[4];
    
    for(int i = 0; i < 4; i++){
      fallingBlocks[i] = new ArrayList<FallingBlock>();
      scoredBlockYPositionTracker[i] = SCORE_REGION_UPPER_LIMIT;
    }
    
    //Initialize a default value for the falling blocks speed
    blockSpeed = pow(3, 1) + 1;
  }


  
  //-- Setters: --//
  //--------------//
  //  None
  
  //Set the difficulty level of the game to change the background image of the scene
  public void setDifficulty(DifficultyTracker difficultyLevelTracker){
    
    //Find out the game difficulty level to show the corresponding background image
    String imageName = "NormalLevel.jpg";    //Default initialization
    switch( difficultyLevelTracker.getDifficulty() ){
      
      //Easy mode is chosen
      case(0):
        imageName = "EasyLevel.jpg";
        break;
        
      //Normal mode is chosen
      case(1):
        imageName = "NormalLevel.jpg";
        break;
        
      //Hard mode is chosen  
      case(2):
        imageName = "HardLevel.jpg";
        break;
    }
    
    //Now, set the new background image
    super.setBackground(imageName);
    
    //Update the falling block velocity
    blockSpeed = pow(3, difficultyLevelTracker.getDifficulty()) + 1;
  }
  
  
  
  //-- Getters: --//
  //--------------//
  //  None
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method for adding the GUI controls for the scene
  public void setupGUI(){}
  
  
  //Method to hide all the GUI controls in the scene
  public void hideGUI(){
    sceneGUI.hide();
  }
  
  
  //Method to show all the GUI controls in the scene
  public void showGUI(){
    sceneGUI.show();
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(){}
  
  
  //Method to display the scene's contents
  //Pass a reference of the player's score tracker as the input parameter
  public void showContent(ScoreTracker playerScore){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Update the player's score on the screen
    updateScoreScreen(playerScore.getScore());
    
    //Show the falling blocks background region
    drawBlockBackground();
    
    //Draw the falling blocks if there are any
    drawBlock();
    
    //Show the falling blocks foreground region
    drawBlockForeground();
    
    //Draw the four drums
    for(int column = 0; column < 4; column++){
      drawDrum(column);
    }
  }
  
  
  //Method to add a falling block to one of the four columns on the screen
  //Pass which of the four columns you want to add a falling blocks into as the input parameter
  public void addBlock(int column){
    
    //Only add non-overlapping falling blocks into the column if the new block is not the first falling block in the column
    int lastIndex = fallingBlocks[column].size() - 1;
    float overlapMarginTolerance = 33.0;
    
    if( (lastIndex > -1) && (fallingBlocks[column].get(lastIndex).getUpperEdge() > overlapMarginTolerance) ){
      fallingBlocks[column].add( new FallingBlock(BLOCK_COLOURS[column], (BLOCK_REGION_X + (0.2 * (column + 1) * BLOCK_REGION_WIDTH)), blockSpeed) );
    
    }else if(lastIndex == -1){
      //If falling block to be added is the first one in the column, then just create it without restriction
      fallingBlocks[column].add( new FallingBlock(BLOCK_COLOURS[column], (BLOCK_REGION_X + (0.2 * (column + 1) * BLOCK_REGION_WIDTH)), blockSpeed) );
    }
  }
  
  
  //Method to detect if the player has scored a point from the falling block
  //and the amount of points they will receive
  //Pass which of the four columns' falling blocks to detect as the input parameter
  //Pass a reference of the player's score tracker as the second input parameter
  public boolean checkScore(int column, ScoreTracker playerScore){

    //Local variable declaration
    //Variable for storing how many points the player get from the current falling block
    int scorePoint;
    
    
    for(int i = 0; i < fallingBlocks[column].size(); i++){
      
      //Get the center position of the current block
      float y = fallingBlocks[column].get(i).getCenterPosition();
      
      //If more than half the block is within the scoring region, the player scores a point
      if( (y > SCORE_REGION_UPPER_LIMIT) && (y < SCORE_REGION_LOWER_LIMIT) ){
        
        //Calculate how many points the player will gain
        scorePoint = calculateScorePoint( fallingBlocks[column].get(i) );
        
        //Update the player's score
        playerScore.updateScore(scorePoint);
        
        //Store the current block's center position into the scored block's y-position tracker
        scoredBlockYPositionTracker[column] = y;
        
        //Remove the falling block from the dynamic array
        fallingBlocks[column].remove(i);
        
        //The user gained some points, and so return true
        return true;
      }
    }
    
    //No blocks are detected within the scoring region, and so return false
    return false;
  }
  
  
  //Method to draw the starting animation for the current scene
  public void startAnimation(){
  }
  
  //Method to draw the falling block animation for scoring a point
  public void scoreAnimation(int column, int animationState){
    
    //If the column contains any falling blocks, proceed with the animation
    if(fallingBlocks[column].size() > 0){
      fallingBlocks[column].get(0).scoreAnimation((BLOCK_REGION_X + (0.2 * (column + 1) * BLOCK_REGION_WIDTH)), scoredBlockYPositionTracker[column], animationState);
    }
  }
  
  
  //Method to draw the drums' animation when they are hit
  public void drumHitAnimation(int column){
    drawDrumFlash(column);
    drawDrum(column);
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method to draw the falling blocks region
  private void drawBlockBackground(){
    
    //Draw the overall gray region where the blocks will fall in
    pushMatrix();
      translate(BLOCK_REGION_X, BLOCK_REGION_Y);
      
      fill(GRAY, 64);
      rect(0, 0, BLOCK_REGION_WIDTH, BLOCK_REGION_HEIGHT);
    popMatrix();
    
    //Draw the dark gray bar that represents the scoring region
    pushMatrix();
      translate(BLOCK_REGION_X, SCORE_REGION_UPPER_LIMIT);
      
      strokeWeight(3);
      stroke(DARK_GRAY);
      fill(DARK_GRAY, 128);
      rect(0, 0, BLOCK_REGION_WIDTH, (SCORE_REGION_LOWER_LIMIT - SCORE_REGION_UPPER_LIMIT));
    popMatrix();
  }
  
  
  //Helper method to draw the falling blocks region
  private void drawBlockForeground(){
    
    //Draw the bottom white part of the block region
    pushMatrix();
      translate(BLOCK_REGION_X, SCORE_REGION_LOWER_LIMIT);
      
      noStroke();
      fill(WHITE);
      rect(0, 0, BLOCK_REGION_WIDTH, (height - SCORE_REGION_LOWER_LIMIT));
    popMatrix();
    
    //Re-draw the outline above the bottom white part (or the bottom outline of the score region)
    pushMatrix();
      translate(BLOCK_REGION_X, SCORE_REGION_LOWER_LIMIT);
      
      strokeWeight(3);
      stroke(DARK_GRAY);
      line(0, 0, BLOCK_REGION_WIDTH, 0);
    popMatrix();
    
    //Draw the outline of the overall gray region
    pushMatrix();
      translate(BLOCK_REGION_X, BLOCK_REGION_Y);
      
      strokeWeight(6);
      stroke(GRAY);
      line(0, 0, 0, height);
      line(BLOCK_REGION_WIDTH, 0, BLOCK_REGION_WIDTH, height);
    popMatrix();
  }
  
  
  //Helper method to draw the falling blocks
  private void drawBlock(){
    for(int i = 0; i < 4; i++){
      for(int j = 0; j < fallingBlocks[i].size(); j++){
        
        //Update the position of the current block
        fallingBlocks[i].get(j).updateBlock();
        
        if(fallingBlocks[i].get(j).getUpperEdge() > SCORE_REGION_LOWER_LIMIT){
          //Remove the current block if it is outside the falling block region
          fallingBlocks[i].remove(j);
        }
        else{
          //Otherwise, draw the current block
          fallingBlocks[i].get(j).drawBlock();
        }
      } 
    }
  }
  
  
  //Helper method to calculate how many points the player will receive when part of the falling
  //block is within the score region
  //The amount of points the player can gain depends on where the center position of the falling
  //block is within the score region
  private int calculateScorePoint(FallingBlock theBlock){

    //Determine where the falling block is in order to return the number of score points accordingly
    if( (theBlock.getUpperEdge() > SCORE_REGION_UPPER_LIMIT) && (theBlock.getLowerEdge() < SCORE_REGION_LOWER_LIMIT) ){
      //The block is completely inside the score region, so the player gains +3 points
      return 3;
    }
    else{
      //Less than half the block is outside of the score region, so the player gains +1 point
      return 1;
    }
  }
  
  
  //Helper method to update the player's score on the screen
  private void updateScoreScreen(int currentScore){
    
    //Draw a background behind the player's score
    strokeWeight(2);
    stroke(GRAY);
    fill(WHITE, 128);
    rect(0, 170, BLOCK_REGION_X, 100);
    
    //Set the score point's font to be size 20 pixels, 72% black, and left aligned
    fill(72, 255);
    textAlign(LEFT);
    textFont(super.getFont(), 20);
    
    //Display the player's score
    text("Current Score:", 20, 200);
    text(nf(currentScore, 7), 20, 225);
  }
  
  
  //Helper method to draw the drum at the given column
  private void drawDrum(int column){
    
    pushMatrix();
      translate(DRUM_POSITION[column].x, DRUM_POSITION[column].y);
      
      strokeWeight(4);
      stroke(0);
      fill(BLOCK_COLOURS[column]);
      ellipse(0, 0, DRUM_DIAMETER, DRUM_DIAMETER);
    popMatrix();
  }
  
  
  //Helper method to draw the drum hit flash
  private void drawDrumFlash(int column){
    
    float flashRadius = 0.9 * DRUM_DIAMETER;
    int numCopies = 8;
    
    noStroke();
    fill(GOLD);
    
    pushMatrix();
      translate(DRUM_POSITION[column].x, DRUM_POSITION[column].y);
      
      //Make 8 copies of the flash trangle unit
      for(int i = 0; i < numCopies; i++){
        rotate(TWO_PI * i / numCopies);
        
        //Draw the flash triangle unit
        beginShape();
          vertex(0, flashRadius);
          vertex((0.5 * flashRadius), 0);
          vertex(-(0.5 * flashRadius), 0);
        endShape(CLOSE);
      }
    popMatrix();
  }
}
