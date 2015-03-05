/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Description:
 This application generates fractal shapes and circles based on inputs
 from the mouse and keyboard. Clicking anywhere on the drawing canvas
 with the mouse will generate a fractal shape. There are 30 keys that
 can generate a circle in 30 different locations on the drawing canvas.
 
 The 30 keys are: 'q' to 'p', 'a' to ';', 'z' to '/'.
 
 There is also a music player on the GUI that allows the user to select
 a song to play. The circles are reactive to the song when it is playing
 and to the slider bar labelled "CIRCLE SPEED CONTROL".
 
 The save button allows the user to save a copy of the drawing canvas into
 the save folder that is within the sketch folder.
 
 The main sketch contains the event handlers and bridges between the different
 layer classes.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



//-- Import Libraries ------------------------------------------//
//--------------------------------------------------------------//
import controlP5.*;                         //ControlP5 Library
import com.nootropic.processing.layers.*;   //Layers Library

import ddf.minim.*;                         //Minim Library
import ddf.minim.signals.*;                 //Minim Sub-Library
import ddf.minim.analysis.*;                //Minim Sub-Library
import ddf.minim.effects.*;                 //Minim Sub-Library



//-- Global Constants/Variables --------------------------------//
//--------------------------------------------------------------//

//-- Constants: --//
//----------------//

//Layers objects' constants
final int NUM_LAYERS = 3;         //Number of layers for the drawing canvas
final int CANVAS_BACKGROUND = 0;  //Index 0 of the CanvasLayer array list, canvasLayers
final int CIRCLE_LAYER = 1;       //Index 1 of the CanvasLayer array list, canvasLayers
final int FRACTAL_LAYER = 2;      //Index 2 of the CanvasLayer array list, canvasLayers

//Constants related to the current song
final int FIVE_SECONDS_DELAY = 5000;  //5 seconds delay between each forward FFT calculation of the current song


//-- Variables: --//
//----------------//

//ControlP5 object
ControlP5 guiControl;                  //ControlP5 object for the GUI controls

//Layers objects
AppletLayers layers;                   //AppletLayers object for the using the Layers library
CanvasLayer [] canvasLayers;           //Array list to store the drawing canvas layers
GUILayer guiControlLayer;              //Layer to maintain the GUI controls and foreground contents

//Tracker (data storage) objects
FractalOriginTracker fractalOrigin;    //Keeps track of all the generated fractals' origins that exist on the drawing canvas
SongTracker songList;                  //Stores and manipulates a defined list of songs

//Variables related to the current song
int fftWaitDuration;                   //Timer to keep track of when to trigger the next forward FFT calculation of the current song

//Save operation variable
int saveCount;                         //Counter to keep track of how many generative arts have been saved



//-- Essential Methods ------------------------------------//
//---------------------------------------------------------//

//-- Setup Method: --//
//-------------------//

//Setup method for the main sketch
//
//Input parameter:
//  None
//Output parameter:
//  None
void setup(){
  
  //Basic setups
  size(900, 800);                           //Sketch dimension
  background(128);                          //Background colour of the sketch
  smooth();                                 //Set all shapes with anti-alias edges
  
  //Initialize the save counter
  saveCount = 0;
  
  //Initialize the forward FFT timer variable
  fftWaitDuration = 0;
  
  //Initialize the global GUI control object
  guiControl = new ControlP5(this);
  
  //Initialize all tracker (data storage) objects
  fractalOrigin = new FractalOriginTracker();
  songList = new SongTracker(this);
  
  //Initialize the drawing canvas and GUI control layers
  canvasLayers = new CanvasLayer[NUM_LAYERS];
  canvasLayers[CANVAS_BACKGROUND] = new CanvasBackground(this);  //The background layer of the drawing canvas; used for controlling the colour of the drawing canvas's background
  canvasLayers[CIRCLE_LAYER] = new CircleLayer(this);            //Bottom layer on the drawing canvas is the circle layer
  canvasLayers[FRACTAL_LAYER] = new FractalLayer(this);          //Top layer on the drawing canvas is the fractal layer
  guiControlLayer = new GUILayer(this, songList);                //GUI controls layer; independent from the drawing canvas layer
  
  //Initialize the Layers library 
  layers = new AppletLayers(this);
  
  //Add the three initialized layers into the Layer class to process them
  layers.addLayer(canvasLayers[CANVAS_BACKGROUND]);
  layers.addLayer(canvasLayers[CIRCLE_LAYER]);
  layers.addLayer(canvasLayers[FRACTAL_LAYER]);
  layers.addLayer(guiControlLayer);

  
  //Draw the canvas and GUI layers' shadow
  drawLayerShadow();
}


//-- Essential Method to Initialize the Layers Library Properly: --//
//-----------------------------------------------------------------//
void paint(java.awt.Graphics graphicBuffer){
  if(layers != null){
    layers.paint(this);
  }
  else{
    super.paint(graphicBuffer);
  }
}


//-- Draw Method: --//
//------------------//

//Draw method for the main sketch; used for drawing the GUI background and looping the current song
//Through testing, I speculate that ControlP5 objects are only drawn at the end of the main sketch's draw method
//Because the Layers library draws all the custom made layers above the main sketch, drawing the GUI background in the GUILayer class's draw method
//will cover the ControlP5 objects that are drawn within the main sketch
//Hence, in order to avoid having the ControlP5 objects covered, the GUI background is drawn here in the main sketch
//
//Input parameter:
//  None
//Output parameter:
//  None
void draw(){
  
  //Set the colour mode of the main sketch to be RGB with the channel range, [0.0, 255.0]
  colorMode(RGB, 255.0);
  
  //Fill the background of the GUI in order to avoid drawing over the GUI controls
  fill(196);  //RGB, 77% white
  rect(GUILayer.GUI_ORIGIN_X, GUILayer.GUI_ORIGIN_Y, GUILayer.GUI_WIDTH, GUILayer.GUI_HEIGHT);
  
  //Loop the current song if it has finished playing
  if(songList.isNearEndOfSong()){
    songList.loopSong();
  }

  //Perform a forwardFFT on the current song every 5 seconds when it is playing
  if( (songList.isPlaying()) && (millis() > fftWaitDuration) ){
    songList.forwardFFT();
    fftWaitDuration = millis() + FIVE_SECONDS_DELAY;
  }
}



//-- Other Methods ---------------------------------------------//
//--------------------------------------------------------------//

//Draw the background layer
//
//Input parameter:
//  None
//Output parameter:
//  None
void drawLayerShadow(){
  
  noStroke();
  fill(0);                  //RGB, 100% black
  rect(14, 14, 580, 780);   //Draw the drawing canvas's shadow
  rect(614, 14, 280, 780);  //Draw the GUI control box's shadow
}


//Method to save the generative art into the save folder
//
//Input parameter:
//  None
//Output parameter:
//  None
void saveArt(){
  
  //Local variables for forming the save path
  String date = nf(year(), 4) + "-" + nf(month(), 2) +  "-" + nf(day(), 2);  //Use today's date as the name of a sub-folder
  String saveDirectory = "/save/" + date + "/";                              //Save directory
  String saveFileName = "GenerativeArt-" + nf(++saveCount, 3);               //Filename of the art to save
  String saveFormat = ".png";                                                //File format of the art to save
  String saveFilePath = saveDirectory + saveFileName + saveFormat;           //The file path of the generative art to save
  
  //Local variable for combining the drawing canvas layers
  PImage combinedImage = createImage(CanvasLayer.CANVAS_WIDTH, CanvasLayer.CANVAS_HEIGHT, RGB);
  
  
  //-- Flatten the three drawing canvas layers onto the combinedImage --//
  //--------------------------------------------------------------------//
  
  //Algorithm: Since the canvas background layer is defined to be white, then the pixels for this layer does not need to be loaded
  //           Instead, the colour white will be directly assigned to the combinedImage pixels
  //           Thus, this can free up 25% of memory space as opposed to if all three layers and the combinedImage pixels were loaded together
  
  
  //First, set the colour mode to be RGB with the channel range, [0.0, 255.0]
  colorMode(RGB, 255.0);
  
  //Load the pixels of the circle and fractal layers and the combinedImage
  combinedImage.loadPixels();                 //Load the combinedImage pixels
  canvasLayers[CIRCLE_LAYER].loadPixels();    //Load the circle layer pixels
  canvasLayers[FRACTAL_LAYER].loadPixels();   //Load the fractal layer pixels
  
  
  //Setups before copying the two layers' pixels onto the combinedImage
  int combinedImageIndex = 0;                                            //Index variable of the combinedImage pixel array
  int rowLimit = CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_HEIGHT;  //Upper limit of the outer for loop
  int colLimit = CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_WIDTH;   //Upper limit of the inner for loop
  
  //Copying the two layers' pixels onto the combinedImage
  for(int row = CanvasLayer.CANVAS_ORIGIN; row < rowLimit; row++){
    for(int col = CanvasLayer.CANVAS_ORIGIN; col < colLimit; col++){
      
      //Calculate the pixel index
      int index = (row * width) + col;

      //Method for combining drawing canvas layers
      if( alpha(canvasLayers[FRACTAL_LAYER].pixels[index]) > 0 ){
        //If the transparency of current pixel in the fractal layer is 100%, then there is something drawn on it
        combinedImage.pixels[combinedImageIndex++] = canvasLayers[FRACTAL_LAYER].pixels[index];
        
      }else if( alpha(canvasLayers[CIRCLE_LAYER].pixels[index]) > 0 ){
        //Else if the transparency of current pixel in the circle layer is 100%, then there is something drawn on it
        combinedImage.pixels[combinedImageIndex++] = canvasLayers[CIRCLE_LAYER].pixels[index];
      
      }else{
        //Otherwise, there is nothing drawn at the current pixel in the circle and fractal layers
        //So, assign this pixel of the combinedImage with white to represent the pixel in the background layer of the drawing canvas
        combinedImage.pixels[combinedImageIndex++] = color(255);
      }
    }
  }
  
  //Update the pixels of the combinedImage
  combinedImage.updatePixels();
  
  //Save the generative art to the defined file path
  combinedImage.save(saveFilePath);
}



//-- Event Handlers --------------------------------------------//
//--------------------------------------------------------------//

//Handling the GUI controls
void controlEvent(ControlEvent theEvent){
  if(theEvent.isController()){
    
    //-- Events for selecting the speed of the reactive circles --//
    //------------------------------------------------------------//
    
    //The speed controlling slider has been selected
    if(theEvent.controller().name() == "sliderControl"){
      
      //Get the value of the slider from the GUI layer
      float speedFactor = guiControlLayer.getSliderValue();
      
      //If the slider value is less than 0.1, then reset the position of the reactive circle and pull the value down to 0
      if(speedFactor < 0.1){
        canvasLayers[CIRCLE_LAYER].resetPosition();
        speedFactor = 0.0;
      }
      
      //Set the slider value into the circle layer
      canvasLayers[CIRCLE_LAYER].setSpeedFactor(speedFactor);
    }

    
    //-- Events for turning the canvas layers ON/OFF --//
    //-------------------------------------------------//
    
    //The toggle switch for turning the circle layer's visibility ON/OFF has been selected
    else if(theEvent.controller().name() == "circleLayerVisibility"){

      if(theEvent.controller().value() == 0.0){
        canvasLayers[CIRCLE_LAYER].turnLayerOff();  //Turn the layer off
      }else{
        canvasLayers[CIRCLE_LAYER].turnLayerOn();   //Turn the layer on
      }
    }
    
    //The toggle switch for turning the fractal layer's visibility ON/OFF has been selected
    else if(theEvent.controller().name() == "fractalLayerVisibility"){

      if(theEvent.controller().value() == 0.0){
        canvasLayers[FRACTAL_LAYER].turnLayerOff();  //Turn the layer off
      }else{
        canvasLayers[FRACTAL_LAYER].turnLayerOn();   //Turn the layer on
      }
    }
    
    
    //-- Events for clearing the contents of the drawing canvas layers --//
    //-------------------------------------------------------------------//
    
    //The clear button for the circle layer has been selected
    else if(theEvent.controller().name() == "clearCircleLayer"){
      canvasLayers[CIRCLE_LAYER].clearContent();  //Clear the contents on the circle layer
    }
    
    //The clear button for the fractal layer has been selected
    else if(theEvent.controller().name() == "clearFractalLayer"){
      canvasLayers[FRACTAL_LAYER].clearContent();  //Clear the contents on the fractal layer
      
      //Remove all the generated fractal origins stored in the fractal starting position tracker
      fractalOrigin.removeAll();
    }
    
    //The clear button for all generative shape layers has been selected
    else if(theEvent.controller().name() == "clearAllLayer"){
      
      //Clear the contents on both the circle and fractal layers
      canvasLayers[CIRCLE_LAYER].clearContent();
      canvasLayers[FRACTAL_LAYER].clearContent();
      
      //Remove all the generated fractal origins stored in the fractal starting position tracker
      fractalOrigin.removeAll();
    }
    
    
    //-- Events for saving the art generated on the drawing canvas --//
    //---------------------------------------------------------------//
    
    //The save button has been selected
    else if(theEvent.controller().name() == "save"){
      saveArt();  //Save the generative art into the save folder
    }
    
    
    //-- Events for selecting and manipulating the current song --//
    //------------------------------------------------------------//
    
    //The play song button has been clicked
    else if(theEvent.controller().name() == "playSong"){
      songList.playSong();                              //Play the current song
      fftWaitDuration = millis() + FIVE_SECONDS_DELAY;  //Update the forward FFT timer variable
    }
    
    //The pause song button has been clicked
    else if(theEvent.controller().name() == "pauseSong"){
      songList.pauseSong();  //Pause the current song
    }
    
    //The stop song button has been clicked
    else if(theEvent.controller().name() == "stopSong"){
      songList.stopSong();  //Stop and reset the current song
    }
    
    //The select next song button has been clicked
    else if(theEvent.controller().name() == "nextSong"){
      
      //Get the current song's track number
      int trackNumber = songList.getTrackNumber();
      
      //Loop the tracker number forward by 1
      trackNumber = (trackNumber + 1) % songList.getNumberOfSongs();
      
      //Select the new song
      songList.selectSong(trackNumber);
      
      //Update the song name on the display panel of the GUI
      guiControlLayer.updateDisplayPanel(songList);
    }
    
    //The select previous song button has been clicked
    else if(theEvent.controller().name() == "prevSong"){
      
      //Get the current song's track number
      int trackNumber = songList.getTrackNumber();
      
      //Loop the track number backward by 1
      trackNumber = (trackNumber - 1);
      if(trackNumber < 0){
        trackNumber = (songList.getNumberOfSongs() - 1);
      }
      
      //Select the song specified by the new track number
      songList.selectSong(trackNumber);
      
      //Update the song name on the display panel of the GUI
      guiControlLayer.updateDisplayPanel(songList);
    }
  }
}


//Handling mouse clicked inputs
void mousePressed(){
  
  //Capture the mouse position
  float xMousePosition = mouseX;
  float yMousePosition = mouseY;
  
  //Create a new fractal only if the mouse is clicked inside the drawing canvas
  if( (xMousePosition > CanvasLayer.CANVAS_ORIGIN) && (xMousePosition < (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_WIDTH)) && (yMousePosition > CanvasLayer.CANVAS_ORIGIN) && (yMousePosition < (CanvasLayer.CANVAS_ORIGIN + CanvasLayer.CANVAS_HEIGHT)) ){
    
    //Create a new fractal at the mouse position
    canvasLayers[FRACTAL_LAYER].createFractal(xMousePosition, yMousePosition, fractalOrigin);
  }
}


//Handling keyboard inputs
//Used if statements rather than switch statements to compact the circle generation code
void keyPressed(){
  
  //Hotkeys for selecting the music
  //Selecting the first song in the list of songs
  if(key == '1'){
    songList.stopSong();                              //Stop and reset the current song
    songList.selectSong(0);                           //Select the first song in the song list
    songList.playSong();                              //Play the selected song
    fftWaitDuration = millis() + FIVE_SECONDS_DELAY;  //Update the forward FFT timer variable
    guiControlLayer.updateDisplayPanel(songList);     //Update the song name in the GUI display panel
  }
  
  //Selecting the second song in the list of songs
  else if(key == '2'){
    songList.stopSong();                              //Stop and reset the current song
    songList.selectSong(1);                           //Select the second song in the song list
    songList.playSong();                              //Play the selected song
    fftWaitDuration = millis() + FIVE_SECONDS_DELAY;  //Update the forward FFT timer variable
    guiControlLayer.updateDisplayPanel(songList);     //Update the song name in the GUI display panel
  }
  
  
  //Generating a circle on the drawing canvas
  //Row 1 circles
  else if(key == 'q'){ canvasLayers[CIRCLE_LAYER].generate(0, 0, songList, fractalOrigin); }  //Column 1 circle
  else if(key == 'w'){ canvasLayers[CIRCLE_LAYER].generate(0, 1, songList, fractalOrigin); }  //Column 2 circle
  else if(key == 'e'){ canvasLayers[CIRCLE_LAYER].generate(0, 2, songList, fractalOrigin); }  //Column 3 circle
  else if(key == 'r'){ canvasLayers[CIRCLE_LAYER].generate(0, 3, songList, fractalOrigin); }  //Column 4 circle
  else if(key == 't'){ canvasLayers[CIRCLE_LAYER].generate(0, 4, songList, fractalOrigin); }  //Column 5 circle
  
  //Row 2 circles
  else if(key == 'a'){ canvasLayers[CIRCLE_LAYER].generate(1, 0, songList, fractalOrigin); }  //Column 1 circle
  else if(key == 's'){ canvasLayers[CIRCLE_LAYER].generate(1, 1, songList, fractalOrigin); }  //Column 2 circle
  else if(key == 'd'){ canvasLayers[CIRCLE_LAYER].generate(1, 2, songList, fractalOrigin); }  //Column 3 circle
  else if(key == 'f'){ canvasLayers[CIRCLE_LAYER].generate(1, 3, songList, fractalOrigin); }  //Column 4 circle
  else if(key == 'g'){ canvasLayers[CIRCLE_LAYER].generate(1, 4, songList, fractalOrigin); }  //Column 5 circle
  
  //Row 3 circles
  else if(key == 'z'){ canvasLayers[CIRCLE_LAYER].generate(2, 0, songList, fractalOrigin); }  //Column 1 circle
  else if(key == 'x'){ canvasLayers[CIRCLE_LAYER].generate(2, 1, songList, fractalOrigin); }  //Column 2 circle
  else if(key == 'c'){ canvasLayers[CIRCLE_LAYER].generate(2, 2, songList, fractalOrigin); }  //Column 3 circle
  else if(key == 'v'){ canvasLayers[CIRCLE_LAYER].generate(2, 3, songList, fractalOrigin); }  //Column 4 circle
  else if(key == 'b'){ canvasLayers[CIRCLE_LAYER].generate(2, 4, songList, fractalOrigin); }  //Column 5 circle
  
  //Row 4 circles
  else if(key == 'y'){ canvasLayers[CIRCLE_LAYER].generate(3, 0, songList, fractalOrigin); }  //Column 1 circle
  else if(key == 'u'){ canvasLayers[CIRCLE_LAYER].generate(3, 1, songList, fractalOrigin); }  //Column 2 circle
  else if(key == 'i'){ canvasLayers[CIRCLE_LAYER].generate(3, 2, songList, fractalOrigin); }  //Column 3 circle
  else if(key == 'o'){ canvasLayers[CIRCLE_LAYER].generate(3, 3, songList, fractalOrigin); }  //Column 4 circle
  else if(key == 'p'){ canvasLayers[CIRCLE_LAYER].generate(3, 4, songList, fractalOrigin); }  //Column 5 circle
  
  //Row 5 circles
  else if(key == 'h'){ canvasLayers[CIRCLE_LAYER].generate(4, 0, songList, fractalOrigin); }  //Column 1 circle
  else if(key == 'j'){ canvasLayers[CIRCLE_LAYER].generate(4, 1, songList, fractalOrigin); }  //Column 2 circle
  else if(key == 'k'){ canvasLayers[CIRCLE_LAYER].generate(4, 2, songList, fractalOrigin); }  //Column 3 circle
  else if(key == 'l'){ canvasLayers[CIRCLE_LAYER].generate(4, 3, songList, fractalOrigin); }  //Column 4 circle
  else if(key == ';'){ canvasLayers[CIRCLE_LAYER].generate(4, 4, songList, fractalOrigin); }  //Column 5 circle
  
  //Row 6 circles
  else if(key == 'n'){ canvasLayers[CIRCLE_LAYER].generate(5, 0, songList, fractalOrigin); }  //Column 1 circle
  else if(key == 'm'){ canvasLayers[CIRCLE_LAYER].generate(5, 1, songList, fractalOrigin); }  //Column 2 circle
  else if(key == ','){ canvasLayers[CIRCLE_LAYER].generate(5, 2, songList, fractalOrigin); }  //Column 3 circle
  else if(key == '.'){ canvasLayers[CIRCLE_LAYER].generate(5, 3, songList, fractalOrigin); }  //Column 4 circle
  else if(key == '/'){ canvasLayers[CIRCLE_LAYER].generate(5, 4, songList, fractalOrigin); }  //Column 5 circle
}


//End of File
