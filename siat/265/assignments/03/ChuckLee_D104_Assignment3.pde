/*****************************************************************
 Assignment 3 - Objects and Inheritance
 
 This is the main code of the assignment.
 Some implemented features:
   - Press the "s" or "S" key will save a screenshot of the sketch into the screenshot folder,
     which is in the sketch folder
 
 Version: 1.0
 Last updated: Oct. 23, 2011 
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/


//--------------------------- Global Variables/Constants --------------------------------//

//Global constants:
int NUM_X_FLOWER = 9;
int NUM_Y_FLOWER = 11;

//Global arrays:
ArrayList<ReactiveFlower> flowers = new ArrayList<ReactiveFlower>(); //reactive flower array
ArrayList<Flower> smallFlowers = new ArrayList<Flower>(); //small static flower array

//Global variables:
//Screenshot handling variables
int numImg = 0; //counter to keeps track of how many screenshots have been saved
String savePath; //save path for screenshots of the sketch
//---------------------- End of Global Variables/Constants -------------------------------//


//----------------------------------- Main Code ------------------------------------------//

//Setup and variables initialization
void setup() {
  
  //Setup the save path for saving screenshots of the sketch:
  //The name of the screenshot folder has this format: "y-#_m-#_d-#_#hrs_#mins_#secs"
  //where # is the value of the current year, month, day, hour, minute, and second
  
  //Get the current date and time for the screenshot folder name
  String years = String.valueOf( year() );
  String months = String.valueOf( month() );
  String days = String.valueOf( day() );
  String hours = String.valueOf( hour() );
  String minutes = String.valueOf( minute() );
  String seconds = String.valueOf( second() );
  
  //Create the save path for the screenshots
  savePath = "screenshot/y-" + years + "_m-" + months + "_d-" + days + "_"
             + hours + "hrs_" + minutes + "mins_" + seconds + "secs/";
  //---------------------------------------------------------------//
  
  //Setup the drawing canvas:
  size(480, 620);
  smooth();
  
  //Initialize the reactive flower array
  for(int column = 0; column < NUM_Y_FLOWER; column++) {
    for(int row = 0; row < NUM_X_FLOWER; row++) {
      flowers.add( new ReactiveFlower( (width/NUM_X_FLOWER) * (row + 0.5), (height/NUM_Y_FLOWER) * (column + 0.5) ) );
    }
  }
  
  //Initialize the small static flower array
  for(int column = 0; column < (NUM_Y_FLOWER + 2); column++) {
    for(int row = 0; row < (NUM_X_FLOWER + 2); row++) {
      smallFlowers.add( new ReactiveFlower( (width/(NUM_X_FLOWER + 2)) * (row + 0.5), (height/(NUM_Y_FLOWER + 2)) * (column + 0.5) ) );
      smallFlowers.get((column * (NUM_X_FLOWER + 2)) + row).setRadius(width/(4 * (NUM_X_FLOWER + 2)));
    }
  }
}


//Main code
void draw() {
  colorMode(RGB, 255);
  
  //Clear the background
  background(255);
  
  pushMatrix();
    //Draw the small static flowers in the background
    for(int i = 0; i < smallFlowers.size(); i++) {
      smallFlowers.get(i).draw();
    }
    
    //Draw the reactive flowers
    for(int i = 0; i < flowers.size(); i++) {
      flowers.get(i).reactFlower();
      flowers.get(i).draw();
    }
  popMatrix();
  
  //Draw a border around the sketch
  drawBorder();
}
//--------------------------------- End of Main Code --------------------------------------//


//-------------------------------------- Methods ------------------------------------------//

//Drawing a sketch border method.
//Draws a dark gray border over the sketch
void drawBorder() {
  
  rectMode(CORNER);
  strokeWeight(2);
  stroke(64);
  noFill();
  rect(0, 0, width, height);
}
//--------------------------------- End of Methods ------------------------------------------//


//--------------------------------- Event Handlers ------------------------------------------//

//Event Handler for key pressing from the keyboard
void keyReleased() {
  
  //Screenshot event:
  //A screenshot of the sketch is saved into the screenshot folder whenever
  //the "s" or "S" key is pressed
  if( (key == 's') || (key == 'S') ) {
    
      //Increment the number of screenshots saved so far
      numImg++; 
      
      //Create the image name for the screenshot
      String imgName = "Screenshot_" + String.valueOf(numImg) + ".png";
      
      //Save the screenshot to the screenshot folder
      save( (savePath + imgName) );
      
      //Print a message on the console to inform the user of the saved screenshot
      println( ("A screenshot of the sketch, called '" + imgName + "', has been saved into the screenshot folder.") );
  }
}
//------------------------------ End of Event Handlers --------------------------------------//
//End of assignment 3
