/******************************************************
 Difficulty setting scene:
******************************************************/

class DifficultyScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private Button prev, next;                             //ControlP5 button variables for going to the previous or to the next scene
  private ControllerSprite prevSprite, nextSprite;       //ControlP5 sprite variables for custom button designs
  private PImage prevButtonMask, nextButtonMask;         //Image buffers for the custom button sprites' masks
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor to pass the background image name and font file name as arguments
  DifficultyScene(String imageName, String fontFileName){
    
    //Call the parent class's constructor
    super(imageName, fontFileName);
    
    //Initialize the GUI controls for the scene
    initializeGUI();
  }


  
  //-- Setters: --//
  //--------------//
  
  //Set the difficulty level for the game
/*  public void setDifficulty(int difficultyLevel, DifficultyTracker difficultyLevelTracker){
    difficultyLevelTracker.setDifficulty(difficultyLevel);
  }*/
  
  
  
  //-- Getters: --//
  //--------------//
  //  None
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method for adding the GUI controls for the scene
  public void setupGUI(){
    
    //Create a button to go to the previous scene and attach it with its custom button sprite
    //Also, set the button ID to be 3 (as in game scene #3)
    prev = sceneGUI.addButton("goBack", 0, (int) ((0.15 * width) - (0.5 * prevButtonMask.width)), (int) (height - (1.25 * prevButtonMask.height)), prevButtonMask.width, prevButtonMask.height);
    prev.setSprite(prevSprite);
    prev.setId(3);
    
    //Create a button to go to the next scene and attach it with its custom button sprite
    //Also, set the button ID to be 3 (as in game scene #3)
    next = sceneGUI.addButton("goNext", 0, (int) ((0.85 * width) - (0.5 * nextButtonMask.width)), (int) (height - (1.25 * nextButtonMask.height)), nextButtonMask.width, nextButtonMask.height);
    next.setSprite(nextSprite);
    next.setId(3);
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(){
    sceneGUI.remove("goBack"); //Remove the go to previous scene button sprite
    sceneGUI.remove("goNext"); //Remove the go to next scene button sprite
  }
  
  
  //Method to display the scene's contents
  public void showContent(){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the scene title's font to be size 70 pixels, 100% black, and center aligned
    fill(128, 255);
    textAlign(CENTER);
    textFont(super.getFont(), 70);
    
    //Display the scene title
    text("Difficulty Selection", (width/2), (height/5));
    
    //Draw the difficulty level slider image
    drawSlider();
  }
  
  
  //Method to animate the difficulty level selector
  public void animateSelector(int state){
    
    strokeWeight(4);
    stroke(96);
    
    switch(state){
      case 0:  //Easy mode
        fill(0, 0, 255);
        drawSelector((11.0 * width / 15.0), (0.6 * height));
        break;
        
      case 1:  //Normal mode
        fill(255, 255, 0);
        drawSelector((width/2), (0.6 * height));
        break;
      
      case 2:  //Hard mode
        fill(255, 0, 0);
        drawSelector((4.0 * width / 15.0), (0.6 * height));
        break; 
    }
  }
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls for the scene
  private void initializeGUI(){
    
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
  
  
  //Helper method to draw the difficulty level selector main body
  private void drawSlider(){
    
    float sliderWidth = 0.7 * width;
    float oneThirdSliderWidth = sliderWidth/3;
    float sliderHeight = 0.1 * height;
    
    textAlign(CENTER);
    textFont(super.getFont(), 30);
    
    pushMatrix();
      translate(((width - sliderWidth)/2), ((height - sliderHeight)/2));
      
      noStroke();
      fill(255, 0, 0);
      rect(0, 0, oneThirdSliderWidth, sliderHeight);
      
      fill(128);
      text("Hard", (oneThirdSliderWidth/2), (0.65 * sliderHeight));
      
      pushMatrix();
        translate(oneThirdSliderWidth, 0);
        
        fill(255, 255, 0);
        rect(0, 0, oneThirdSliderWidth, sliderHeight);
        
        fill(128);
        text("Normal", (oneThirdSliderWidth/2), (0.65 * sliderHeight));
      
        pushMatrix();
          translate(oneThirdSliderWidth, 0);
          
          fill(0, 0, 255);
          rect(0, 0, oneThirdSliderWidth, sliderHeight);
          
          fill(128);
          text("Easy", (oneThirdSliderWidth/2), (0.6 * sliderHeight));
        popMatrix();
      popMatrix();
      
      strokeWeight(4);
      stroke(255);
      noFill();
      rect(0, 0, sliderWidth, sliderHeight);
      line(oneThirdSliderWidth, 0, oneThirdSliderWidth, sliderHeight);
      translate(oneThirdSliderWidth, 0);
      line(oneThirdSliderWidth, 0, oneThirdSliderWidth, sliderHeight);
    popMatrix();
  }
  
  
  //Helper method to draw the difficulty level selector
  private void drawSelector(float xPosition, float yPosition){
    
    pushMatrix();
      translate(xPosition, yPosition);
      triangle(0, 0, 25, 50, -25, 50);
    popMatrix();
  }
}
