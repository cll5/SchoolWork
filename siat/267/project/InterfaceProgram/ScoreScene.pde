/******************************************************
 Score scene:
******************************************************/

class ScoreScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private Button confirm, next;                        //ControlP5 button variables for confirming the score results and going to the next scene
  private ControllerSprite confirmSprite, nextSprite;  //ControlP5 sprite variables for the confirm and go to the next scene button designs
  private PImage confirmButtonMask, nextButtonMask;    //Image buffer for the confirm button and go to the next scene button sprites' masks  
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  ScoreScene(){
    
    //Call the parent class's constructor
    super();
    
    //Initialize the GUI controls for the scene
    initializeGUI();
  }
  
  
  //Constructor to pass the background image name and
  //font file name as arguments
  ScoreScene(String imageName, String fontFileName){
    
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
  public void setupGUI(int thePlayer){
    
    if(thePlayer == 0){
      //Player one has just finished playing the game
      //Create a button to go to the next scene and attach it with its custom button sprite
      //Also, set the button ID to be 6 (as in game scene #6)
      confirm = sceneGUI.addButton("playGame", 0, (int) ((0.8 * width) - (0.2 * confirmButtonMask.width)), (int) (height - (1.5 * confirmButtonMask.height)), confirmButtonMask.width, confirmButtonMask.height);
      confirm.setSprite(confirmSprite);
      confirm.setId(6);
    
    }else if(thePlayer == 1){
      //Player two has just finished playing the game
      //Create a button to go to the next scene and attach it with its custom button sprite
      //Also, set the button ID to be 6 (as in game scene #6)
      next = sceneGUI.addButton("goNext", 0, (int) ((0.85 * width) - (0.5 * nextButtonMask.width)), (int) (height - (1.25 * nextButtonMask.height)), nextButtonMask.width, nextButtonMask.height);
      next.setSprite(nextSprite);
      next.setId(6);
    }
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(int thePlayer){
    
    if(thePlayer == 0){
      //Player one has just finished playing the game
      sceneGUI.remove("playGame");  //Remove the confirm score results button sprite
      
    }else if(thePlayer == 1){
      //Player two has just finished playing the game
      sceneGUI.remove("goNext");    //Remove the go to next scene button sprite
    }
  }
  
  
  //Method to display the scene's contents
  public void showContent(int thePlayer, ScoreTracker playerScore){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the scene title's font to be size 70 pixels, 25% black, and right aligned
    fill(64, 255);
    textAlign(RIGHT);
    super.setFont("CenturyGothic-70.vlw");
    textFont(super.getFont(), 70);
    
    //Display the scene title
    String title = "Player " + str((thePlayer + 1)) + "\nScore Results";
    text(title, 874, 74);
    
    //Set the scene font to be size 40 pixels and 28% black
    fill(72, 255);
    super.setFont("CenturyGothic-40.vlw");
    textFont(super.getFont(), 40);
    
    //Display the player's score result
    String scoreResult = "Score Points:\n" + str(playerScore.getScore());
    text(scoreResult, 874, (height/2));
    
    
    //If the first player has finished playing
    if(thePlayer == 0){
      //Set the scene font to be size 25 pixels
      super.setFont("CenturyGothic-25.vlw");
      textFont(super.getFont(), 25);

      //Prompt the second player to get ready
      String getReady = "Are you ready, player 2?";
      text(getReady, 874, (int) (height - (1.75 * confirmButtonMask.height)));
    }
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls for the scene
  void initializeGUI(){
    
    //Local variables declaration
    PImage confirmButtonImage, nextButtonImage; //Image buffers for the custom button sprites
    
    //Get the custom button sprites and masks for the scene
    confirmButtonImage = loadImage("/data/sprites/other/confirmSprite.png");
    nextButtonImage = loadImage("/data/sprites/other/nextSprite.png");
    confirmButtonMask = loadImage("/data/sprites/other/confirmMask.png");
    nextButtonMask = loadImage("/data/sprites/other/nextMask.png");
    
    //Initialize the custom buttons for the scene
    confirmSprite = new ControllerSprite(sceneGUI, confirmButtonImage, confirmButtonMask.width, confirmButtonMask.height);
    nextSprite = new ControllerSprite(sceneGUI, nextButtonImage, nextButtonMask.width, nextButtonMask.height);
    
    //Setup and enable the confirm button mask
    confirmSprite.setMask(confirmButtonMask);
    confirmSprite.enableMask();
    
    //Setup and enable the go to next scene button mask
    nextSprite.setMask(nextButtonMask);
    nextSprite.enableMask();
  }
}
