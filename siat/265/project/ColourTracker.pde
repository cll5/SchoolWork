/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: ColourTracker
 
 Description:
 This class stores the colours that define the colour scheme of this
 application.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class ColourTracker{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  private final int NUM_COLOUR = 5;  //Number of colours in the defined colour schemes
  private color [] redPalette;       //Array to store the first defined colour scheme for this generative art application
  private color [] bluePalette;      //Array to store the second defined colour scheme for this generative art application
  
  
  //-- Variables: --//
  //----------------//
  //  None
  

  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  ColourTracker(){
    
    //Setup the color mode prior to defining the colour paletter array to avoid confusing it with RGB setup
    //colorMode(HSB, 399.0, 99.0, 99.0);
    colorMode(RGB, 255.0);
    
    //Initialize the colour palette arrays
    redPalette = new color[NUM_COLOUR];
    bluePalette = new color[NUM_COLOUR];
    
    //Define the colour palette arrays
    redPalette[0] = bluePalette[0] = color(255, 246, 235);  //A percentage of tan
    redPalette[1] = bluePalette[1] = color(255, 234, 210);  //A percentage of tan
    redPalette[2] = bluePalette[2] = color(240, 226, 208);  //A percentage of tan
    
    redPalette[3] = color(244, 185, 175);  //A percentage of red
    redPalette[4] = color(255, 227, 221);  //A percentage of red
    
    bluePalette[3] = color(191, 207, 240);  //A percentage of blue
    bluePalette[4] = color(63, 96, 163);    //A percentage of blue
  }
  
  
  
  //-- Setters: --//
  //--------------//
  //  None
  
  //-- Getters: --//
  //--------------//
  
  //Returns the number of colours in the defined colour scheme
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  NUM_COLOUR - The size of the palette array (i.e., the number of colours of the defined colour scheme)
  //
  public int getSize(){
    return NUM_COLOUR;
  }
  
  
  //Returns the index'th colour of the chosen colour palette array
  //
  //Input parameter:
  //  index - The desired index to look up in the chosen colour palette array
  //
  //Output parameter:
  //  The colour in the chosen colour palette array, specified at location index
  //
  public color getColour(int index, int colourScheme){
    
    if(colourScheme == 0){
      //Return a colour from the red colour palette if the colourScheme is 0
      return redPalette[index];
      
    }else{
      //Return a colour from the blue colour palette if the colourScheme is 1
      return bluePalette[index];
    }
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  //  None
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
