/******************************************************
 Menu scene:
******************************************************/

class MenuScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private Button onePlayerMode, twoPlayerMode;               //ControlP5 button variables for single or two player game mode selection
  private ControllerSprite onePlayerSprite, twoPlayerSprite; //ControlP5 sprite variables for custom button designs
  private PImage buttonMask;                                 //Image buffer for the custom button sprites' mask
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor to pass the background image name and
  //font file name as arguments
  MenuScene(PApplet mainSketchInstance, String imageName, String fontFileName){
    
    //Call the parent class's constructor
    super(imageName, fontFileName);
    
    //Initialize the GUI controls for the scene
    initializeGUI();
  }
  
  
  
  //-- Setters: --//
  //--------------//
  //None
  
  //-- Getters: --//
  //--------------//
  //None

  //-- Other Methods: --//
  //--------------------//
  
  //Method for adding the GUI controls for the scene
  public void setupGUI(){
    
    //Create a button for single player mode and attach it with its custom button sprite
    onePlayerMode = sceneGUI.addButton("singlePlayer", 0, (int) (0.5 * (width - buttonMask.width)), (int) (height - (4 * buttonMask.height)), buttonMask.width, buttonMask.height);
    onePlayerMode.setSprite(onePlayerSprite);
    
    //Create a button for two players mode and attach it with its custom button sprite
    twoPlayerMode = sceneGUI.addButton("twoPlayer", 0, (int) (0.5 * (width - buttonMask.width)), (int) (height - (2.5 * buttonMask.height)), buttonMask.width, buttonMask.height);
    twoPlayerMode.setSprite(twoPlayerSprite);
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(){
    sceneGUI.remove("singlePlayer"); //Remove the single player mode button sprite
    sceneGUI.remove("twoPlayer");    //Remove the two player mode button sprite
  }
  
  
  //Method for displaying the scene's contents
  public void showContent(){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the game title's font to be size 70 pixels, 25% black, and center aligned
    fill(64, 255);
    textAlign(CENTER);
    textFont(super.getFont(), 70);
    
    //Display the title
    text("BOOM BOOM BOOM!", (width/2), (height/5));
    
    //Set the scene font to be size 40 pixels and 28% black
    fill(72, 255);
    textSize(40);
    
    //Display the scene content
    text("Game Mode:", (width/2), (height - (4 * buttonMask.height) - 30));
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls for the scene
  void initializeGUI(){
    
    //Local variables declaration
    PImage onePlayerImage, twoPlayerImage; //Image buffers for the custom button sprites
    
    
    //Get the custom button sprites and masks for the scene
    onePlayerImage = loadImage("/data/sprites/menuScene/singlePlayerSprite.png");
    twoPlayerImage = loadImage("/data/sprites/menuScene/twoPlayerSprite.png");
    buttonMask = loadImage("/data/sprites/menuScene/buttonMask.png");
    
    //Initialize the custom buttons for the scene
    onePlayerSprite = new ControllerSprite(sceneGUI, onePlayerImage, buttonMask.width, buttonMask.height);
    twoPlayerSprite = new ControllerSprite(sceneGUI, twoPlayerImage, buttonMask.width, buttonMask.height);
    
    //Setup and enable the single player button mask
    onePlayerSprite.setMask(buttonMask);
    onePlayerSprite.enableMask();
    
    //Setup and enable the two player button mask
    twoPlayerSprite.setMask(buttonMask);
    twoPlayerSprite.enableMask();
  }
}
