/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: FractalOriginTracker
 
 Description:
 This class keeps track of the origins of all the generated fractal
 shapes that currently exist on the drawing canvas.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class FractalOriginTracker{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  //  None
  
  //-- Variables: --//
  //----------------//
  private ArrayList<PVector> origin;  //Dynamic array to store the origins of all generated fractals on the drawing canvas (i.e., the origin of each generated fractal)
  

  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default Constructor
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  FractalOriginTracker(){
    
    //Initialize the origin array list
    origin = new ArrayList<PVector>();
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Add the origin coordinate of a new generated fractal into the origin array list
  //
  //Input parameter:
  //  xPos - The x-coordinate of the generated fractal's origin
  //  yPos - The y-coordinate of the generated fractal's origin
  //
  //Output parameter:
  //  None
  public void addOrigin(float xPos, float yPos){
    origin.add( new PVector(xPos, yPos) );
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the size of the origin array list
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  origin.size() - The size of the origin array list
  //
  public int getSize(){
    return origin.size();
  }
  
  
  //Returns the desired fractal's origin from the origin array list
  //
  //Input parameter:
  //  index - The index of the origin array list for the desired fractal's origin
  //
  //Output parameter:
  //  currOrigin - The desired fractal's origin
  //
  public PVector getOrigin(int index){
    PVector currOrigin = new PVector(origin.get(index).x, origin.get(index).y);
    return currOrigin;
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Remove all the origin coordinates of the generated fractals
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void removeAll(){
    origin.clear();
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
