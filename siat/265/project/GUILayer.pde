/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: GUILayer
 
 Description:
 This class forms the GUI of the application. It also contains
 the position and dimension of the GUI box. This class is a sub-class
 of the CanvasLayer class.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class GUILayer extends Layer{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  //Dimension and position constants of the GUI layer
  public static final int GUI_ORIGIN_X = 610;
  public static final int GUI_ORIGIN_Y = 10;
  public static final int GUI_WIDTH = 280;
  public static final int GUI_HEIGHT = 780;
  
  //Dimension constants of the song control buttons
  private final int SONG_BUTTON_WIDTH = 40;
  private final int SONG_BUTTON_HEIGHT = 20;
  
  //Dimension constants of the clear contents buttons
  private final int CLEAR_BUTTON_WIDTH = 240;
  private final int CLEAR_BUTTON_HEIGHT = 30;
  
  //Dimension constants of the save generated art button
  private final int SAVE_BUTTON_WIDTH = 240;
  private final int SAVE_BUTTON_HEIGHT = 60;
  
  //Dimension constants of the slider control
  private final int SLIDER_WIDTH = 230;
  private final int SLIDER_HEIGHT = 8;
  
  //Dimension constants of the toggle control
  private final int TOGGLE_SIZE = 14;
  
  
  //-- Variables: --//
  //----------------//
  private PFont titleFont;           //The font for the art application title
  private PFont regularFont;         //The font for the name of the GUI controls
  private String songName;           //Name of the current song on the playlist
  private boolean songChanged;       //Flag to indicate rather a different song has been selected by the user;
                                     //This flag is also used to prevent any "flickering" effect from the song name display panel during runtime 
                             
  
  //ControlP5 slider object
  private Slider sliderController;                        //For controlling the velocity of the reactive circles
  private PImage sliderBar, sliderTip;                    //Sprites for creating the slider
  private float prevSliderValue;                          //Used as a flag to indicate when to update the slider controller sprite
  
  //ControlP5 toggle object
  private Toggle circleLayerSwitch, fractalLayerSwitch;   //For turning the circle layer and/or fractal layer ON/OFF
  private PImage layerOn, layerOff;                       //Sprites for creating the layer visibility switch
  private float prevCircleLayerVisibleState;              //Used as a flag to indicate when to update the layer visibility switch sprite
  private float prevFractalLayerVisibleState;             //Used as a flag to indicate when to update the layer visibility switch sprite
  
  //ControlP5 button objects
  private Button playSong, pauseSong, stopSong;           //For manipulating the current song
  private Button prevSong, nextSong;                      //For selecting the current song
  private Button clearCircle, clearFractal, clearAll;     //For clearing the contents drawn on the CircleLayer and/or FractalLayer classes
  private Button saveArt;                                 //For saving the generated art
  
  //ControlP5 sprite objects
  private ControllerSprite playSongSprite, pauseSongSprite, stopSongSprite;        //For the song manipulating buttons' designs
  private ControllerSprite prevSongSprite, nextSongSprite;                         //For the song selecting buttons' designs
  private ControllerSprite clearCircleSprite, clearFractalSprite, clearAllSprite;  //For the clear content buttons' designs
  private ControllerSprite saveArtSprite;                                          //For the save generative art button design
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  //
  //Input parameter:
  //  sketchInstance - Instance of the main sketch
  //  songTracker    - The object that stores all the song for this art application
  //
  //Output parameter:
  //  None
  GUILayer(PApplet sketchInstance, SongTracker songTracker){
    
    //Pass an instance of the main sketch into the Layer class's constructor as required by the Layers library
    super(sketchInstance);
    
    //Limit the dimension of the GUI controls layer by using the Layer class's clipping variables
    //The GUI controls layer will start at (610, 10) with dimensions 280px by 780px
    super.clipX = GUI_ORIGIN_X;
    super.clipY = GUI_ORIGIN_Y;
    super.clipWidth = GUI_WIDTH;
    super.clipHeight = GUI_HEIGHT;
    
    //Initialize all the fonts
    titleFont = loadFont("/data/fonts/CenturyGothic-Bold-40.vlw");
    regularFont = loadFont("/data/fonts/CenturyGothic-12.vlw");
    
    //Setup the sprites for the custom slider controller
    sliderBar = loadImage("/data/sprites/sliderBarSprite.png");          //Load the slider bar sprite
    sliderTip = loadImage("/data/sprites/sliderTipSprite.png");          //Load the slider selecting tip sprite
    PImage sliderTipMask = loadImage("/data/sprites/sliderTipMask.png"); //Load the mask for the slider selecting tip
    sliderTip.mask(sliderTipMask);                                       //Mask the slider selecting tip with its mask
    
    //Setup the sprites for the custom toggle controller
    layerOn = loadImage("/data/sprites/toggleOnSprite.png");    //Load the layer visibility on sprite
    layerOff = loadImage("/data/sprites/toggleOffSprite.png");  //Load the layer visibility off sprite
    
    //Get the current song name from the song tracker and initialize the songChanged flag
    songName = songTracker.getSongName();
    songChanged = true;
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Updates the song name display panel when selecting a new song in the song list
  //
  //Input parameter:
  //  songTracker - The object that stores all the song for this art application
  //
  //Output parameter:
  //  None
  public void updateDisplayPanel(SongTracker songTracker){
    
    //Get the new song name and update the songChanged flag
    songName = songTracker.getSongName();
    songChanged = true;
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the value of the custom slider controller
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  The value of the slider controller (i.e., a value in the range [0.0, 1.0])
  //
  public float getSliderValue(){
    return sliderController.value();
  }
  
  
  //-- Essential Methods: (Required by Layers library) --//
  //-----------------------------------------------------//
  
  //Setup method for this layer
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void setup(){
    
    this.smooth();
    
    //Initialize and setup the GUI controls
    initializeGUI();
    setupGUI();
    
    //Initialize any GUI control flags
    prevSliderValue = 1.0;
    prevCircleLayerVisibleState = 0.0;
    prevFractalLayerVisibleState = 0.0;
  }
  
  
  //Draw method for this layer; used for drawing only the foreground contents
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void draw(){ 
    
    //Set the colour mode of this layer to be RGB with the range [0.0, 255.0]
    this.colorMode(RGB, 255.0);
    
    //Update the song name display panel if a different song has been selected
    if(songChanged == true){
    
      //Draw the song name display panel
      drawDisplayPanel();
      
      //Display the song name on the display panel
      displaySongName();
      
      //Reset the songChanged flag to false to indicate that the display panel has been updated
      songChanged = false;
    }
    
    //Draw the custom slider controller when the slider value changes
    if(sliderController.value() != prevSliderValue){
      drawSliderController();
      prevSliderValue = sliderController.value();
    }
    
    //Draw the custom toggle switches when the layer visibility switch states are changed
    if( (circleLayerSwitch.value() != prevCircleLayerVisibleState) || (fractalLayerSwitch.value() != prevFractalLayerVisibleState) ){
      drawLayerVisibilityToggle();
      prevCircleLayerVisibleState = circleLayerSwitch.value();
      prevFractalLayerVisibleState = fractalLayerSwitch.value();
    }
    
    //Display the text for certain controllers
    displayControllerText();
    
    //Display the application's title
    displayTitle();
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  //  None
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void initializeGUI(){
    
    //Local PImage objects for initializing the song control buttons
    PImage playSongImage;      //Image of the play button
    PImage pauseSongImage;     //Image of the pause button
    PImage stopSongImage;      //Image of the stop button
    PImage nextSongImage;      //Image of the "select next song" button
    PImage prevSongImage;      //Image of the "select previous song" button
    PImage clearCircleImage;   //Image of the "clear circle layer" button
    PImage clearFractalImage;  //Image of the "clear fractal layer" button
    PImage clearAllImage;      //Image of the "clear all layer" button
    PImage saveArtImage;       //Image of the "save art" button
    
    
    
    //-- GUI controls for clearing the contents on the canvas layers --//
    //-----------------------------------------------------------------//
    
    //Get the clear contents buttons' sprites
    clearCircleImage = loadImage("/data/sprites/clearCircleSprite.png");
    clearFractalImage = loadImage("/data/sprites/clearFractalSprite.png");
    clearAllImage = loadImage("/data/sprites/clearAllSprite.png");
    
    //Initialize the clear contents buttons' sprites
    clearCircleSprite = new ControllerSprite(guiControl, clearCircleImage, CLEAR_BUTTON_WIDTH, CLEAR_BUTTON_HEIGHT);
    clearFractalSprite = new ControllerSprite(guiControl, clearFractalImage, CLEAR_BUTTON_WIDTH, CLEAR_BUTTON_HEIGHT);
    clearAllSprite = new ControllerSprite(guiControl, clearAllImage, CLEAR_BUTTON_WIDTH, CLEAR_BUTTON_HEIGHT);
    
    
    //-- GUI controls for saving the generated art --//
    //-----------------------------------------------//
    
    //Get the save generative art button's sprite
    saveArtImage = loadImage("/data/sprites/saveSprite.png");

    //Initialize the save button's sprite
    saveArtSprite = new ControllerSprite(guiControl, saveArtImage, SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT);

    
    //-- GUI controls for the song player --//
    //--------------------------------------//
    
    //Get the song control buttons' sprites
    playSongImage = loadImage("/data/sprites/playSprite.png");
    pauseSongImage = loadImage("/data/sprites/pauseSprite.png");
    stopSongImage = loadImage("/data/sprites/stopSprite.png");
    nextSongImage = loadImage("/data/sprites/nextSongSprite.png");
    prevSongImage = loadImage("/data/sprites/prevSongSprite.png");
    
    //Initialize the song control buttons' sprites
    playSongSprite = new ControllerSprite(guiControl, playSongImage, SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    pauseSongSprite = new ControllerSprite(guiControl, pauseSongImage, SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    stopSongSprite = new ControllerSprite(guiControl, stopSongImage, SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    nextSongSprite = new ControllerSprite(guiControl, nextSongImage, SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    prevSongSprite = new ControllerSprite(guiControl, prevSongImage, SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
  }
  
  
  //Helper method to create the GUI controls
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void setupGUI(){
    
    //-- GUI control for the slider that reacts with the circles --//
    //-------------------------------------------------------------//
    
    //Note on the slider positions:
    //  25 is the distance between the GUI layer's edge and the slider's edge
    
    //Create the circle's speed controlling slider and hide its caption label behind its sprite
    sliderController = guiControl.addSlider("sliderControl", 0.0, 1.0, 0.0, (int) (GUI_ORIGIN_X + 25), (int) (GUI_ORIGIN_Y + (0.35 * GUI_HEIGHT)), SLIDER_WIDTH, SLIDER_HEIGHT);
    sliderController.captionLabel().style().setMarginLeft(-SLIDER_WIDTH);
    
    
    //-- GUI controls for turning layers ON/OFF --//
    //--------------------------------------------//
    
    //Note on the toggle switches positions:
    //  20 is the distance between the GUI layer's edge and the toggles' edges
    //  25 is the distance between the two toggle switches
    
    //Create the two layer visibility toggle switches
    circleLayerSwitch = guiControl.addToggle("circleLayerVisibility", true, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.2 * GUI_HEIGHT)), TOGGLE_SIZE, TOGGLE_SIZE);
    fractalLayerSwitch = guiControl.addToggle("fractalLayerVisibility", true, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.2 * GUI_HEIGHT) + 25), TOGGLE_SIZE, TOGGLE_SIZE);
    
    
    //-- GUI controls for clearing the contents on the canvas layers --//
    //-----------------------------------------------------------------//
    
    //Note on the button positions:
    //  20 is the distance between the GUI layer's edge and the clear buttons' edges
    //  4 is the distance between any two adjacent clear buttons
    
    //Create the clear circle layer button and attach it with its custom button sprite
    clearCircle = guiControl.addButton("clearCircleLayer", 0, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.45 * GUI_HEIGHT)), CLEAR_BUTTON_WIDTH, CLEAR_BUTTON_HEIGHT);
    clearCircle.setSprite(clearCircleSprite);
    
    //Create the clear fractal layer button and attach it with its custom button sprite
    clearFractal = guiControl.addButton("clearFractalLayer", 0, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.45 * GUI_HEIGHT) + (4 + CLEAR_BUTTON_HEIGHT)), CLEAR_BUTTON_WIDTH, CLEAR_BUTTON_HEIGHT);
    clearFractal.setSprite(clearFractalSprite);
    
    //Create the clear all layer button and attach it with its custom button sprite
    clearAll = guiControl.addButton("clearAllLayer", 0, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.45 * GUI_HEIGHT) + (2 * (4 + CLEAR_BUTTON_HEIGHT))), CLEAR_BUTTON_WIDTH, CLEAR_BUTTON_HEIGHT);
    clearAll.setSprite(clearAllSprite);
    
    
    //-- GUI controls for saving the generated art --//
    //-----------------------------------------------//
    
    //Note on the button positions:
    //  20 is the distance between the GUI layer's edge and the save button's edge
    
    //Create the save generative art button and attach it with its custom button sprite
    saveArt = guiControl.addButton("save", 0, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.62 * GUI_HEIGHT)), SAVE_BUTTON_WIDTH, SAVE_BUTTON_HEIGHT);
    saveArt.setSprite(saveArtSprite);

    
    //-- GUI controls for the song player --//
    //--------------------------------------//
    
    //Note on the button positions:
    //  20 is the distance between the GUI layer's edge and the nearest song button
    //  10 is the distance between any two adjacent song button
    //  35 is the distance between the center of the song name display panel and the top edge of the song buttons
    
    //Create the select previous song button and attach it with its custom button sprite
    prevSong = guiControl.addButton("prevSong", 0, (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT) + 35), SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    prevSong.setSprite(prevSongSprite);
    
    //Create the play button and attach it with its custom button sprite
    playSong = guiControl.addButton("playSong", 0, (int) (GUI_ORIGIN_X + 20 + (SONG_BUTTON_WIDTH + 10)), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT) + 35), SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    playSong.setSprite(playSongSprite);
    
    //Create the pause button and attach it with its custom button sprite
    pauseSong = guiControl.addButton("pauseSong", 0, (int) (GUI_ORIGIN_X + 20 + (2 * (SONG_BUTTON_WIDTH + 10))), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT) + 35), SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    pauseSong.setSprite(pauseSongSprite);
    
    //Create the stop button and attach it with its custom button sprite
    stopSong = guiControl.addButton("stopSong", 0, (int) (GUI_ORIGIN_X + 20 + (3 * (SONG_BUTTON_WIDTH + 10))), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT) + 35), SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    stopSong.setSprite(stopSongSprite);
    
    //Create the select next song button and attach it with its custom button sprite
    nextSong = guiControl.addButton("nextSong", 0, (int) (GUI_ORIGIN_X + 20 + (4 * (SONG_BUTTON_WIDTH + 10))), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT) + 35), SONG_BUTTON_WIDTH, SONG_BUTTON_HEIGHT);
    nextSong.setSprite(nextSongSprite);
  }
  
  
  //Helper method to draw the circle speed's slider controller
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void drawSliderController(){
    
    //Notes on the values -20, -5, -2:
    //  These values are the offsets with respect to the coordinate point (630, 244)
    
    pushMatrix();
      //Translate to the point ( (int) (GUI_ORIGIN_X + 25), (int) (GUI_ORIGIN_Y + (0.35 * GUI_HEIGHT) ), which is point (635, 283)
      translate(635, 283);
      
      //Cover the ControlP5 slider with a rectangle that is the same colour as the GUI background
      noStroke();
      fill(196);
      rect(-20, -5, 280, 20);  //280px x 20px should be sufficient to cover the ControlP5 slider object on the screen
      
      //Draw the slider bar
      image(sliderBar, 0, 0, sliderBar.width, sliderBar.height);
      
      //Draw the slider selector tip based on the tip of the ControlP5 slider, which is the same as its value on the defined sliding range [0.0, 1.0]
      float sliderTipPosition = map(sliderController.value(), 0.0, 1.0, 2, 232);
      image(sliderTip, sliderTipPosition, -2, sliderTip.width, sliderTip.height);
    popMatrix();
  }
  
  
  //Helper method to draw the layers' visibility toggles
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void drawLayerVisibilityToggle(){
    
    //Note on the value 24:
    //  This value is the distance between the upper and lower toggle switches
    
    pushMatrix();
      //Translate to the point ( (int) (GUI_ORIGIN_X + 20), (int) (GUI_ORIGIN_Y + (0.2 * GUI_HEIGHT)) ), which is point (630, 166)
      translate(630, 166);
      
      //Cover the ControlP5 toggle objects with a rectangle that is the same colour as the GUI background
      noStroke();
      fill(196);
      rect(0, 0, 100, 60);  //100px x 60px is needed to cover the ControlP5 toggle objects on the screen
      
      //Draw the layer visibility switch for the circle layer
      if(circleLayerSwitch.value() == 0.0){
        image(layerOff, 0, 0, layerOff.width, layerOff.height);  //Draw the layer invisible state
      }else{
        image(layerOn, 0, 0, layerOn.width, layerOn.height);     //Draw the layer visible state
      }
      
      //Draw the layer visibility switch for the fractal layer
      if(fractalLayerSwitch.value() == 0.0){
        image(layerOff, 0, 24, layerOff.width, layerOff.height);  //Draw the layer invisible state
      }else{
        image(layerOn, 0, 24, layerOn.width, layerOn.height);     //Draw the layer visible state
      }
    popMatrix();
  }
  
  
  //Helper method to draw the song name display panel
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void drawDisplayPanel(){
    
    //Local constants for the display panel's dimensions
    int PANEL_HALF_WIDTH = 120;
    int PANEL_HALF_HEIGHT = 25;
    
    pushMatrix();
      //Translate to the center of the display panel
      //Translate to the point ( (int) (GUI_ORIGIN_X + (0.5 * GUI_WIDTH)), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT)) ), which is the same as (750, 634)
      translate(750, 634);
      
      //Set the colour of the display panel to 75% black
      fill(62);
      
      //Draw the base of the display panel
      beginShape();
        vertex( -PANEL_HALF_WIDTH, -(PANEL_HALF_HEIGHT - 5) );
        vertex( -(PANEL_HALF_WIDTH - 5), -PANEL_HALF_HEIGHT );
        vertex( (PANEL_HALF_WIDTH - 5), -PANEL_HALF_HEIGHT );
        vertex( PANEL_HALF_WIDTH, -(PANEL_HALF_HEIGHT - 5) );
        vertex( PANEL_HALF_WIDTH, (PANEL_HALF_HEIGHT - 5) );
        vertex( (PANEL_HALF_WIDTH - 5), PANEL_HALF_HEIGHT );
        vertex( -(PANEL_HALF_WIDTH - 5), PANEL_HALF_HEIGHT );
        vertex( -PANEL_HALF_WIDTH, (PANEL_HALF_HEIGHT - 5) );
      endShape(CLOSE);
      
      //Set the display panel's outline thickness to 4 pixels
      strokeCap(SQUARE);
      strokeWeight(4);
      stroke(234);    //RGB, 92% white
      
      //Draw the round corners of the display panel
      arc( -(PANEL_HALF_WIDTH - 5), -(PANEL_HALF_HEIGHT - 5), 10, 10, -PI, -HALF_PI );
      arc( (PANEL_HALF_WIDTH - 5), -(PANEL_HALF_HEIGHT - 5), 10, 10, -HALF_PI, 0.0 );
      arc( (PANEL_HALF_WIDTH - 5), (PANEL_HALF_HEIGHT - 5), 10, 10, 0.0, HALF_PI );
      arc( -(PANEL_HALF_WIDTH - 5), (PANEL_HALF_HEIGHT - 5), 10, 10, HALF_PI, PI );
      
      //Draw the remaining outline of the display panel
      line( -PANEL_HALF_WIDTH, -(PANEL_HALF_HEIGHT - 5), -PANEL_HALF_WIDTH, (PANEL_HALF_HEIGHT - 5) );
      line( -(PANEL_HALF_WIDTH - 5), PANEL_HALF_HEIGHT, (PANEL_HALF_WIDTH - 5), PANEL_HALF_HEIGHT );
      line( PANEL_HALF_WIDTH, (PANEL_HALF_HEIGHT - 5), PANEL_HALF_WIDTH, -(PANEL_HALF_HEIGHT - 5) );
      line( (PANEL_HALF_WIDTH - 5), -PANEL_HALF_HEIGHT, -(PANEL_HALF_WIDTH - 5), -PANEL_HALF_HEIGHT );
    popMatrix();
  }
  
  
  //Helper method to display the song name on the display panel
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void displaySongName(){
    pushMatrix();
      //Translate to the center of the display panel at point ( (int) (GUI_ORIGIN_X + (0.5 * GUI_WIDTH)), (int) (GUI_ORIGIN_Y + (0.8 * GUI_HEIGHT)) ), which is the same as (750, 634)
      translate(750, 634);
      
      //Setup the text style properties: alignment, size and colour
      textAlign(CENTER);
      textFont(regularFont, 12);
      fill(234);    //RGB, 92% white
      
      //Display the song name
      text(songName, 0, 4);
    popMatrix();
  }
  
  
  //Helper method to display the text for the controllers
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void displayControllerText(){
    
    //Setup the text style properties: alignment, size and colour
    textAlign(LEFT);
    textFont(regularFont, 12);
    fill(234);  //RGB, 92% white
    
    //Slider controller texts
    pushMatrix();
      //Translate 10px above the slider controller, which is the point (630, 273)
      translate(630, 273);
      
      //Display the text for the circle speed controller
      text("CIRCLE SPEED CONTROL", 5, 0);
      
      //Display the slider value range
      pushMatrix();
        translate(7, 40);
        text("0", 0, 0);
        text("1", 233, 0);
      popMatrix();
    popMatrix();
    
    //Toggle switch texts
    pushMatrix();
      //Translate 10px above the top toggle switch, which is the point (630, 156)
      translate(630, 156);
      
      //Display the text for the layer visibility switches
      text("LAYER VISIBILITY", 0, 0);
      
      //Display the layer names next to the switches
      pushMatrix();
        translate(24, 22);
        text("Circle Layer", 0, 0);
        text("Fractal Layer", 0, 24);
      popMatrix();
    popMatrix();
  }
  
  
  //Helper method to display the application title
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void displayTitle(){
    
    //Setup the text style properties: alignment, size and colour
    textAlign(LEFT);
    textFont(titleFont, 40);
    fill(234);  //RGB, 92% white
    
    pushMatrix();
      //Translate to the point ( (GUI_ORIGIN_X + 60), (GUI_ORIGIN_Y + 70) ), which is the point (670, 80)
      translate(670, 80);
      
      text("GEN-ART", 0, 0);
    popMatrix();
  }
}
