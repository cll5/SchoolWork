/******************************************************
 A scene:
******************************************************/

class Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private PImage backgroundImage;      //Background image of the scene
  private PFont sceneFont;             //Font type used in the scene
  
  
    
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  Scene(){
    
    //The default background image for a scene is a red-cyan-white-black gradient
    backgroundImage = createImage(width, height, ARGB);
    backgroundImage.loadPixels();
    for(int i = 0; i < height; i++){
      for(int j = 0; j < width; j++){
        backgroundImage.pixels[(i*width) + j] = color(i, j, j);
      }
    }
    backgroundImage.updatePixels();
    
    //Set century gothic size 20 pixels as the default font for the scene
    sceneFont = loadFont("/data/fonts/CenturyGothic-20.vlw");
  }
  
  
  //Constructor to pass the background image name and
  //font file name as arguments
  Scene(String imageName, String fontFileName){
    
    //Defined settings
    backgroundImage = loadImage("/data/images/background/" + imageName);
    sceneFont = loadFont("/data/fonts/" + fontFileName);
  }

  
  
  //-- Setters: --//
  //--------------//
  
  //Set the background image of the scene
  public void setBackground(String imageName){
    backgroundImage = loadImage("/data/images/background/" + imageName);
  }
  
  //Set the text font for the scene
  public void setFont(String fontFileName){
    sceneFont = loadFont("/data/fonts/" + fontFileName);
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the font used for text in the current scene
  public PFont getFont(){
    return sceneFont;
  } 
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to display the loaded background image of the current scene
  public void showBackground(){
    image(backgroundImage, 0, 0);
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
}
