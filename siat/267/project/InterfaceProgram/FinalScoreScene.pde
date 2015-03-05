/******************************************************
 Final score scene for two players:
******************************************************/

class FinalScoreScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private Button replay;                  //ControlP5 button variable for replaying the game
  private ControllerSprite replaySprite;  //ControlP5 sprite variable for the replay button design
  private PImage replayButtonMask;        //Image buffer for the replay button sprite's mask 
 
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  FinalScoreScene(){
    
    //Call the parent class's constructor
    super();
    
    //Initialize the GUI controls for the scene
    initializeGUI();
  }

  
  //Constructor to pass the background image name and
  //font file name as arguments
  FinalScoreScene(String imageName, String fontFileName){
    
    //Call the parent class's constructor
    super(imageName, fontFileName);
    
    //Initialize the GUI controls for the scene
    initializeGUI();
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //-- Getters: --//
  //--------------//
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method for adding the GUI controls for the scene
  public void setupGUI(){
    
    //Create a button to restart the game and attach it with its custom button sprite
    replay = sceneGUI.addButton("replayGame", 0, (int) ((0.8 * width) - (0.2 * replayButtonMask.width)), (int) (height - (1.5 * replayButtonMask.height)), replayButtonMask.width, replayButtonMask.height);
    replay.setSprite(replaySprite);
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(){
    sceneGUI.remove("replayGame");  //Remove the replay game button sprite
  }
  
  
  //Method to display the scene's contents for one player mode
  public void showContent(ScoreTracker playerScore){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the scene title's font to be size 70 pixels, 25% black, and right aligned
    fill(64, 255);
    textAlign(RIGHT);
    super.setFont("CenturyGothic-70.vlw");
    textFont(super.getFont(), 70);
    
    //Display the scene title
    text("Player Score Results", 874, 74);
    
    //Set the scene font to be size 40 pixels and 28% black
    fill(72, 255);
    super.setFont("CenturyGothic-40.vlw");
    textFont(super.getFont(), 40);
    
    //Display the player's score result
    String congratulation = "CONGRATULATIONS!\n";
    String scoreResult = "Score Points:\n" + str(playerScore.getScore());
    String playerResult = congratulation + scoreResult;
    text(playerResult, 874, 275);
    
    //Set the scene font to be size 25 pixels
    super.setFont("CenturyGothic-25.vlw");
    textFont(super.getFont(), 25);
    
    //Ask if the player wants to replay the game
    text("Play Again?", (int) ((0.8 * width) + (0.68 * replayButtonMask.width)), (int) (height - (1.75 * replayButtonMask.height)));
  }
  
  
  //Method to display the scene's contents for two player mode
  public void showContent(ScoreTracker playerOneScore, ScoreTracker playerTwoScore){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the scene title's font to be size 70 pixels, 25% black, and center aligned
    fill(64, 255);
    textAlign(CENTER);
    super.setFont("CenturyGothic-70.vlw");
    textFont(super.getFont(), 70);
    
    //Display the scene title
    String title = "FINAL SCORE RESULTS";
    text(title, (width/2), 74);
    
    
    //Find out who the winner is
    int winner = findWinner(playerOneScore, playerTwoScore);
    

    //Set the scene font to be size 40 pixels and 28% black
    fill(72, 255);
    super.setFont("CenturyGothic-40.vlw");
    textFont(super.getFont(), 40);
    
    if(winner != 0){
      
      //Display the final result and announce the winner
      String congratulation = "CONGRATULATIONS PLAYER " + str(winner) + "\n";
      String youAreWinner = "YOU ARE THE WINNER!";
      String winnerSpeech = congratulation + youAreWinner;
      text(winnerSpeech, (width/2), 175);
    
    }else{
      
      //Display the final result and announce the draw
      text("DRAW!", (width/2), 175);
    }
    
    //Set the scene font to be size 25 pixels
    super.setFont("CenturyGothic-25.vlw");
    textFont(super.getFont(), 25);
    
    //Display both players' scores
    String playerOneResult = "Player 1:\n" + str(playerOneScore.getScore());
    String playerTwoResult = "Player 2:\n" + str(playerTwoScore.getScore());
    text(playerOneResult, ((width/2) - 200), 300);
    text(playerTwoResult, ((width/2) + 200), 300);
        
    //Draw a line to divide the two players' scores
    noFill();
    strokeWeight(2);
    stroke(72);
    line((width/2), 270, (width/2), 600);
    
    //Set the scene font to be right aligned
    textAlign(RIGHT);
    
    //Ask if the player wants to replay the game
    text("Play Again?", (int) ((0.8 * width) + (0.68 * replayButtonMask.width)), (int) (height - (1.75 * replayButtonMask.height)));
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls for the scene
  private void initializeGUI(){
    
    //Get the replay button sprite and mask
    PImage replayButtonImage = loadImage("/data/sprites/other/replaySprite.png");
    replayButtonMask = loadImage("/data/sprites/other/replayMask.png");
    
    //Initialize the replay button for the scene
    replaySprite = new ControllerSprite(sceneGUI, replayButtonImage, replayButtonMask.width, replayButtonMask.height);
    
    //Setup and enable the replay button mask
    replaySprite.setMask(replayButtonMask);
    replaySprite.enableMask();
  }
  
  //Helper method to find out who the winner is in the two player competition
  private int findWinner(ScoreTracker playerOneScore, ScoreTracker playerTwoScore){
    
    if(playerOneScore.getScore() > playerTwoScore.getScore()){
      //Player one wins
      return 1;
    
    }else if(playerOneScore.getScore() < playerTwoScore.getScore()){
      //Player two wins
      return 2;
      
    }else{
      //Else, both players ended with a draw
      return 0;
    }
  }
}
