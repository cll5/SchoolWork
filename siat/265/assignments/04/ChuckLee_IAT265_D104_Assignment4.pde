/*****************************************************************
 Assignment 4 - Generative Art Poster
 
 This is the main code of the assignment. It is essentially a simple painting program with
 three different types of brushes to paint with.
 
 There are four brush classes and one canvas class:
 
   - BasicBrushHead (parent class):
       This class has setters and getters for changing the brush's size and colour. It also has
       a draw method that generates a regular circle brush. It also contains all it's children classes'
       overrided methods. In the GUI, the "BASIC" button under the "Brush Type:" controls represents 
       a brush of this class.       
       
   - AutomaticBrushHead (sub-class of BasicBrushHead):
       This class can generate a continuous gradient of colours and increases in size gradually based
       on the frameCount variable and the modulo operator. In the GUI, the "AUTO" toggle switch under
       the "Auto Brush Mode:" control represents a brush of this class.
       
   - ThinBrushHead (sub-class of BasicBrushHead):
       This class has two features. One of the feature is to allow user to draw a line that follows the
       mouse position. The second feature is a spreading out effect when the mouse is released, which can
       generate a flower-like effect by default. Each line that spreads out from this second feature is
       called a branch. The sliders under the "Thin Brush Settings:" controls in the GUI are used to
       manipulate the generation of the spreading effect. In particular, the "BRANCH" slider controls how
       many lines to generate, and the "SPREAD" slider controls how uniformly spread out the lines are. 
       In the GUI, the "THIN" button under the "Brush Type:" controls represents a brush of this class.
       
   - SplatterBrushHead (sub-class of AutomaticBrushHead):
       This class can generate a splatter effect, and the individual splattered drawings are called
       splattered "blobs", or just blobs. The "BRUSH SIZE", "TRANSPARENCY", and "BLOBS" sliders in the
       GUI under the "Brush Colour/Size:" and "Splatter Brush Setting:" controls are used to affect
       the generation of these blobs. The "BLOBS" slider is used to control how many blobs will generate
       per mouse click when the splatter type of brush is in use. In the GUI, the "SPLATTER" button under
       the "Brush Type:" controls represents a brush of this class.
       
   - Canvas:
       This class essentially draws the background of the entire program, including the white canvas and
       everything from the GUI except the colour preview window and the controlP5 controls.
   
 Note: The sliders under the "Brush Colour/Size:" controls in the GUI are used to manipulate the brush's
       colour and size for the basic and splatter types of brushes under the "Brush Type:" controls. The
       thin type of brush only has one size (hence, its name), and so the "BRUSH SIZE" slider will not
       affect it, but the colour sliders can affect its colour. The AutomaticBrushHead class brush can't
       be manipulated by these controls at all since it's colour and size are controlled internally 
       within the class through the frameCount variable.
 
 
 Some implemented hotkeys:
   - Press the "s" key will save a screenshot of the sketch and the image drawn
     on the drawing canvas into the saved_image folder, which is in the sketch folder.
   
   - Press the "d" key will clear the image drawn on the drawing canvas
   - Press the "a" key will turn on automatic brush mode
   - Press the "m" key will turn off automatic brush mode (i.e, turn on manual mode)
   - Press the "1" key will select the basic type of brush
   - Press the "2" key will select the thin type of brush
   - Press the "3" key will select the splatter type of brush

 
 a
 Version: 1.5
 Last updated: Nov. 6, 2011 
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/


//---------------------- Import libraries ----------------------//
//--------------------------------------------------------------//
import controlP5.*;


//---------------------- Global Constants ----------------------//
//--------------------------------------------------------------//

//Drawing canvas constants
int CANVAS_X = 20;
int CANVAS_Y = 10;

//Other constants
int BG_COLOUR = 196; //Colour of the GUI background
int NUM_BRUSHES = 4; //Number of brush heads used in drawing



//---------------------- Global Variables Declaration ----------------------//
//--------------------------------------------------------------------------//

//Drawing canvas object
Canvas drawingCanvas;

//Save drawing image variables
int saveCount; //Counter to keep track of how many images have been saved
PImage saveDrawing; //Object to hold the image drawn on the drawing canvas when saving

//GUI (ControlP5) variables
ControlP5 GUI;
int topMargin, bottomMargin, leftMargin, rightMargin;

//The different brush heads
BasicBrushHead [] brushType; //Array to store the different brushes to use
int typeIndex; //brushType array index
int manualModeIndex; //Keep track of which of the three types of brushes was used
                     //before automatic brush mode was switched on



//---------------------- Setup and Initializations ----------------------//
//-----------------------------------------------------------------------//
void setup(){
  
  //Variable definitions:
  //Some variables for the GUI controls' dimensions
  int sliderWidth = 60;
  int sliderHeight = 16;
  int buttonWidth = 50;
  int buttonHeight = 16;
  int toggleWidth = 30;
  int toggleHeight = 10;
  
  //Setup procedure:
  //Initialize sketch settings
  size(600, 820);
  frameRate(60);
  smooth();
  
  //Initial colour mode setting
  colorMode(RGB, 255);
  
  //GUI setups
  //Create the GUI controls (controlP5 settings)
  GUI = new ControlP5(this);
  
  //Initialize GUI dimensions
  leftMargin = CANVAS_X;
  rightMargin = width - CANVAS_X;
  topMargin = 690;
  bottomMargin = 810;
  
  //Change the GUI controls' colour settings
  GUI.setColorBackground(color(100));
  GUI.setColorForeground(color(180, 0, 0));
  GUI.setColorActive(color(255, 0, 0));
  GUI.setColorLabel(color(255));
  
  //Clear and save buttons
  GUI.addButton("Clear", 1, (rightMargin - 124), (bottomMargin - 60), buttonWidth, buttonHeight); //Clear canvas button
  GUI.addButton("Save", 1, (rightMargin - 54), (bottomMargin - 60), buttonWidth, buttonHeight); //Save the drawing button
  
  //Basic, thin, and splatter brush heads selectors
  GUI.addButton("Basic", 1, (leftMargin + 4), (bottomMargin - 100), buttonWidth, buttonHeight); //Basic brush head selector
  GUI.addButton("Thin", 1, (leftMargin + 4), (bottomMargin - 80), buttonWidth, buttonHeight); //Thin brush head selector
  GUI.addButton("Splatter", 1, (leftMargin + 58), (bottomMargin - 100), buttonWidth, buttonHeight); //Splatter brush head selector
  
  //RGBA colour channel sliders
  GUI.addSlider("Red", 0, 255, 100, (leftMargin + 140), (bottomMargin - 100), sliderWidth, sliderHeight); //Red or hue channel
  GUI.addSlider("Green", 0, 255, 0, (leftMargin + 140), (bottomMargin - 80), sliderWidth, sliderHeight); //Green or saturation channel
  GUI.addSlider("Blue", 0, 255, 0, (leftMargin + 140), (bottomMargin - 60), sliderWidth, sliderHeight); //Blue or brightness channel
  GUI.addSlider("Transparency", 1, 255, 255, (leftMargin + 140), (bottomMargin - 40), sliderWidth, sliderHeight); //Alpha channel
  
  //Brush size slider
  GUI.addSlider("Brush Size", 1, 300, 50, (leftMargin + 140), (bottomMargin - 20), sliderWidth, sliderHeight);
  
  //Number of branches, branch length, and spread angle sliders for the thin type of brush
  GUI.addSlider("Branch", 0, 100, 10, (leftMargin + 300), (bottomMargin - 100), sliderWidth, sliderHeight); //Manipulate the number of branches
  GUI.addSlider("Length", 0, 300, 100, (leftMargin + 300), (bottomMargin - 80), sliderWidth, sliderHeight); //Manipulate the length of each branch
  GUI.addSlider("Spread", 0, 1, 1, (leftMargin + 300), (bottomMargin - 60), sliderWidth, sliderHeight); //Manipulate how spread out the branches are
  
  //Slider for the number of splattered "blobs" generated per mouse pressed for the splatter type of brush
  GUI.addSlider("Blobs", 1, 20, 1, (rightMargin - 124), (bottomMargin - 100), sliderWidth, sliderHeight);
  
  //Switch for turning automatic brush mode on and off
  //If automatic brush mode is switched on, then the brush size and colour will be generated based
  //the frameCount variable (code is under the AutomaticBrushHead class)
  GUI.addToggle("Auto", false, (leftMargin + 4), (bottomMargin - 24), 30, 10);
  
  
  //Initialize the drawing canvas
  drawingCanvas = new Canvas(CANVAS_X, CANVAS_Y);
  drawingCanvas.clear();
  colourPreview(); //Show the colour preview window
  
  
  //Initialize the save variables
  saveCount = 0;
  saveDrawing = createImage(drawingCanvas.getWidth(), drawingCanvas.getHeight(), RGB);
  
  
  //Initialize the brush heads
  brushType = new BasicBrushHead[NUM_BRUSHES];
  brushType[0] = new BasicBrushHead();
  brushType[1] = new ThinBrushHead();
  brushType[2] = new SplatterBrushHead();
  brushType[3] = new AutomaticBrushHead();
  
  //Initialize brushType array indices
  typeIndex = 0;
  manualModeIndex = typeIndex;
  
  //Initial brush size and colour from the GUI initial settings
  applyColour();
  applySize();
  
  //Initial spread settings for the thin type of brush from GUI initial settings
  applySpread();
}



//---------------------- Draw ----------------------//
//--------------------------------------------------//
void draw(){}



//---------------------- Event Handlers ----------------------//
//------------------------------------------------------------//

//GUI controls
void controlEvent(ControlEvent aEvent){
  if(aEvent.isController()){
    
    //Save the image drawn on the drawing canvas
    if(aEvent.controller().name() == "Save"){
      saveImage();
    }
    
    //Clear the drawing canvas
    if(aEvent.controller().name() == "Clear"){
      clearCanvas();
    }
    
    //Basic brush head is selected
    if(aEvent.controller().name() == "Basic"){
      
      //Switch to the selected type of brush
      typeIndex = 0;
      
      //Apply the previous brush size and colour settings to the new type of brush
      applyColour();
      applySize();
    }
    
    //Thin brush head is selected
    if(aEvent.controller().name() == "Thin"){
      
      //Switch to the selected type of brush
      typeIndex = 1;
      
      //Apply the previous brush size and colour settings to the new type of brush
      applyColour();
      applySize();
      
      //Apply the spread settings to this type of brush, too
      applySpread();
    }
    
    //Splatter brush head is selected
    if(aEvent.controller().name() == "Splatter"){

      //Switch to the selected type of brush
      typeIndex = 2;
      
      //Apply the previous brush size and colour settings to the new type of brush
      applyColour();
      applySize();
    }
    
    //Update the brush colour
    if((aEvent.controller().name() == "Red") || (aEvent.controller().name() == "Green") ||
    (aEvent.controller().name() == "Blue") || (aEvent.controller().name() == "Transparency")){
      
      applyColour();
      colourPreview(); //Show a preview of the colour
    }
    
    //Update the brush size
    if(aEvent.controller().name() == "Brush Size"){
      applySize();
    }
    
    //Update the spread settings for the thin type of brush
    if((aEvent.controller().name() == "Branch") || (aEvent.controller().name() == "Length") ||
    (aEvent.controller().name() == "Spread")){
      
      applySpread();
    }
    
    //Update the number of splattered "blobs" for the splatter type of brush
    if(aEvent.controller().name() == "Blobs"){
      
      int numOfBlobs = (int) GUI.controller("Blobs").value();
      brushType[2].setUpperLimit(numOfBlobs);
    }
    
    //Check rather automatic brush mode is turned on
    if(aEvent.controller().name() == "Auto"){
      if(aEvent.controller().value() == 1){
        
        //Automatic brush mode is turned on
        manualModeIndex = typeIndex;
        typeIndex = 3;
        
      } else{
        
        //Automatic brush mode is turned off
        //(i.e, manual control over brush size and colour settings)
        typeIndex = manualModeIndex;
        
        //Apply the previous brush size and colour settings to the new type of brush
        applyColour();
        applySize();
      }
    }
  }
}

//Sub-method to apply the GUI colour settings on the current type of brush
//Used for minimizing the number of codes written in this file
void applyColour(){
  
  //Apply the GUI colour settings to the current type of brush
  float r = GUI.controller("Red").value();
  float g = GUI.controller("Green").value();
  float b = GUI.controller("Blue").value();
  float a = GUI.controller("Transparency").value();
  brushType[typeIndex].setBrushColour(r, g, b, a);
}

//Sub-method to apply the GUI brush size settings on the current type of brush
//Used for minimizing the number of codes written in this file
void applySize(){
  
  //Apply the GUI brush size settings to the current type of brush
  float theSize = GUI.controller("Brush Size").value();
  brushType[typeIndex].setBrushSize(theSize);
}

//Sub-method to apply the GUI spread settings for the thin type of brush
//Used for minimizing the number of codes written in this file
void applySpread(){
  
  //Apply the GUI spread settings to the thin type of brush
  int numBranch = (int) GUI.controller("Branch").value();
  float branchLen = GUI.controller("Length").value();
  float branchSpread = GUI.controller("Spread").value();
  brushType[1].setBranch(numBranch);
  brushType[1].setLength(branchLen);
  brushType[1].setSpread(branchSpread);
}

//Sub-method to show a preview of the colour selected in the GUI
//Used for minimizing the number of codes written in this file
void colourPreview(){
  
  float r = GUI.controller("Red").value();
  float g = GUI.controller("Green").value();
  float b = GUI.controller("Blue").value();
  
  pushMatrix();
    translate(260, 710);
    strokeWeight(3);
    stroke(196);
    fill(r, g, b, 255);
    rect(0, 0, 30, 30);
  popMatrix();
}


//Drawing (mouse) controls
void mousePressed(){
  //Tap the mouse to draw a spot
  drawHere();
}

void mouseDragged(){
  //Hold mouse to draw
  drawHere();
}

void mouseReleased(){
  
  //After releasing the mouse when using the thin type of brush, draw the spread lines
  if(typeIndex == 1){
    
    //Only draw if the mouse is within the drawing canvas
    if((mouseY < (CANVAS_Y + drawingCanvas.getHeight())) && (mouseX > leftMargin) &&
    (mouseX < rightMargin) && (mouseY > CANVAS_Y)){
      
      brushType[typeIndex].release();
      drawingCanvas.checkBoundary();
      colourPreview(); //Refresh the colour preview window
    }
  }
}


//Keyboard (hotkeys) controls
void keyPressed(){
  
  //Some hotkeys
  switch(key){
    
    case 's': //Save the drawing canvas and a screenshot of the sketch
      saveImage();
      break;
      
    case 'd': //Clear the drawing canvas
      clearCanvas();
      break;
      
    case '1': //Select the basic type of brush
      typeIndex = 0;
      applyColour();
      applySize();
      break;
      
    case '2': //Select the thin type of brush
      typeIndex = 1;
      applySpread();
      applyColour();
      applySize();
      break;
      
    case '3': //Select the splatter type of brush
      typeIndex = 2;
      applyColour();
      applySize();
      break;
    
    case 'a': //Turn on automatic brush mode
      //Turn on the "Auto" toggle and trigger its event handler
      GUI.controller("Auto").setValue(1);
      break;
      
    case 'm': //Turn off automatic brush mode (manual mode)
      //Turn off the "Auto" toggle and trigger its event handler
      GUI.controller("Auto").setValue(0);
      break;
  }
}



//---------------------- Other Methods ----------------------//
//-----------------------------------------------------------//

//Method to draw on the drawing canvas
void drawHere(){
  
  //Only draw if the mouse is within the drawing canvas
  if((mouseY < (CANVAS_Y + drawingCanvas.getHeight())) && (mouseX > leftMargin) &&
  (mouseX < rightMargin) && (mouseY > CANVAS_Y)){
    
    //Check if automatic brush mode has been turned on
    if(typeIndex == 3){
      brushType[typeIndex].generateColour();
      brushType[typeIndex].generateSize();
    }
  
    brushType[typeIndex].draw();
    drawingCanvas.checkBoundary();
    colourPreview(); //Refresh the colour preview window
  }
}


//Method to clear the drawing canvas
void clearCanvas(){
  drawingCanvas.clear();
  colourPreview(); //Refresh the colour preview window
}



//Method to save the image drawn on the drawing canvas
//and a screenshot of the sketch
void saveImage(){
  
  //Variables definition:
  //Increment the saved image counter and format it as a 3 digits string
  String imgNumber = nf(++saveCount, 3);
  
  //Make a sub-folder inside the saved_image folder to store the saved images.
  //Use today's date as the name of this sub-folder
  String date = nf(year(), 4) + "-" + nf(month(), 2) +  "-" + nf(day(), 2);

  //Variables for copying pixel arrays from sketch to saveDrawing
  int k = 0; //Create an index for the pixel array of saveDrawing instead of trying to 
             //mathematically calculate its index with the for loops' indices for performance
             //purposes
  int rowUpperLimit = CANVAS_Y + drawingCanvas.getHeight();
  int columnUpperLimit = CANVAS_X + drawingCanvas.getWidth();
  
  
  //Saving procedure:
  //Load the sketch's and saveDrawing's pixel arrays
  loadPixels();
  saveDrawing.loadPixels();
  
  //Copy the image drawn on the drawing canvas onto saveDrawing
  for(int i = CANVAS_Y; i < rowUpperLimit; i++){
    for(int j = CANVAS_X; j < columnUpperLimit; j++){
      saveDrawing.pixels[ k++ ] = pixels[ (i*width) + j ];
    }
  }
  
  //Update the pixel array of saveDrawing
  saveDrawing.updatePixels();
  
  //Save the image drawn on the drawing canvas
  saveDrawing.save("/saved_image/" + date + "/drawings/img-" + imgNumber + ".png");
  
  //Save a screenshot of the sketch
  save("/saved_image/" + date + "/screenshots/img-" + imgNumber + ".png");
  
  //Prompt the user that the image has been saved and where it is saveds
  println("\nThe drawing has been saved as 'img-" + imgNumber + ".png' in the saved_image folder.");
  println("Saved drawing path: .../saved_image/" + date + "/drawings/img-" + imgNumber + ".png");
  println("Saved screenshot path: .../saved_image/" + date + "/screenshots/ss-" + imgNumber + ".png");
}

//End of Assignment 4
