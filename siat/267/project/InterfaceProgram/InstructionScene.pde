/******************************************************
 Instruction scene:
******************************************************/

class InstructionScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private Button prev, next;                             //ControlP5 button variables for going to the previous or to the next scene
  private ControllerSprite prevSprite, nextSprite;       //ControlP5 sprite variables for custom button designs
  private PImage prevButtonMask, nextButtonMask;         //Image buffers for the custom button sprites' masks
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor to pass the background image name and
  //font file name as arguments
  InstructionScene(String imageName, String fontFileName){
    
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
    
    //Create a button to go to the previous scene and attach it with its custom button sprite
    //Also, set the button ID to be 2 (as in game scene #2)
    prev = sceneGUI.addButton("goBack", 0, (int) ((0.15 * width) - (0.5 * prevButtonMask.width)), (int) (height - (1.25 * prevButtonMask.height)), prevButtonMask.width, prevButtonMask.height);
    prev.setSprite(prevSprite);
    prev.setId(2);
    
    //Create a button to go to the next scene and attach it with its custom button sprite
    //Also, set the button ID to be 2 (as in game scene #2)
    next = sceneGUI.addButton("goNext", 0, (int) ((0.85 * width) - (0.5 * nextButtonMask.width)), (int) (height - (1.25 * nextButtonMask.height)), nextButtonMask.width, nextButtonMask.height);
    next.setSprite(nextSprite);
    next.setId(2);
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(){
    sceneGUI.remove("goBack"); //Remove the go to previous scene button sprite
    sceneGUI.remove("goNext"); //Remove the go to next scene button sprite
  }
  
  
  //Method to display the scene's contents
  public void showContent(){
    
    //Local variable declaration
    //Load the instruction diagram
    PImage instructionDiagram = loadImage("/data/images/instructionScene/instructionDiagram.png");
    
    //Create a string variable to temporarily store the instructions 
    String instLine1 = "Choose level of difficulty:\n";
    String instLine2 = "      - Use the slider on the base to select.\n\n";
    String instLine3 = "Hit the drums according to the falling squares.\n";
    String instLine4 = "Each color on the screen represents different drums.\n\n";
    String instLine5 = "You must hit the drums at the exact time the square with\n";
    String instLine6 = "the corresponding color hits the bottom.\n\n";
    String instLine7 = "Scoring:\n";
    String instLine8 = "      - When the colored square is entirely within the gray\n";
    String instLine9 = "        bar, you get 3 points. If it is partially inside the bar, \n";
    String instLine10 = "        you get 1 point.";
    String instructions = instLine1 + instLine2 + instLine3 + instLine4 + instLine5 + instLine6 + instLine7 + instLine8 + instLine9 + instLine10;
    
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the scene title's font to be size 70 pixels, 50% black, and left aligned
    fill(128, 255);
    textAlign(RIGHT);
    super.setFont("CenturyGothic-70.vlw");
    textFont(super.getFont(), 70);
    
    //Display the scene title
    text("Instruction", 874, 74);
    
    //Draw a box to around the instructions
    stroke(196);
    fill(255, 96);
    rect(30, 100, 840, 440);
    
    //Set the text alignment to left for the remaining text in the scene
    textAlign(LEFT);
    
    //Display the instruction diagram
    pushMatrix();
    image(instructionDiagram, 40, 110, instructionDiagram.width, instructionDiagram.height);
    
    //Set the instructions' font to be size 20 pixels and 100% black
    fill(0, 255);
    super.setFont("CenturyGothic-20.vlw");
    textFont(super.getFont(), 20);

    //Diaplay the instructions
    text(instructions, 290, 130);
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls for the scene
  void initializeGUI(){
    
    //Local variables declaration
    PImage prevButtonImage, nextButtonImage; //Image buffers for the custom button sprites
    
    
    //Get the custom button sprites and masks for the scene
    prevButtonImage = loadImage("/data/sprites/other/backSprite.png");
    nextButtonImage = loadImage("/data/sprites/other/nextSprite.png");
    prevButtonMask = loadImage("/data/sprites/other/backMask.png");
    nextButtonMask = loadImage("/data/sprites/other/nextMask.png");
    
    //Initialize the custom buttons for the scene
    prevSprite = new ControllerSprite(sceneGUI, prevButtonImage, prevButtonMask.width, prevButtonMask.height);
    nextSprite = new ControllerSprite(sceneGUI, nextButtonImage, nextButtonMask.width, nextButtonMask.height);
    
    //Setup and enable the go to previous scene button mask
    prevSprite.setMask(prevButtonMask);
    prevSprite.enableMask();
    
    //Setup and enable the go to next scene button mask
    nextSprite.setMask(nextButtonMask);
    nextSprite.enableMask();
  }
}
