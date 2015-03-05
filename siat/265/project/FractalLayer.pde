/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: FractalLayer
 
 Description:
 This class represents the layer where all the fractal shapes will
 be generated into. It is a sub-class of the CanvasLayer class.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class FractalLayer extends CanvasLayer{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  private final int delay500Msec = 500;  //500 ms delay (for testing)
  
  
  //-- Variables: --//
  //----------------//
  private ArrayList<Fractal> fractalsArray;  //Array list to store all the generative fractal shapes
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  //
  //Input parameter:
  //  sketchInstance - Instance of the main sketch
  //
  //Output parameter:
  //  None
  FractalLayer(PApplet sketchInstance){
    
    //Call the parent class's constructor and pass in an instance of the main sketch
    super(sketchInstance);
    
    //Initialize the array list that stores generative fractal shapes
    fractalsArray = new ArrayList<Fractal>();
  }
  
  
  
  //-- Setters: --//
  //--------------//
  //  None
  
  //-- Getters: --//
  //--------------//
  //  None
  
  //-- Essential Methods: (Required by Layers library) --//
  //-----------------------------------------------------//
  
  //Setup method for this layer
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void setup(){}
  
  
  //Draw method for this layer; used for drawing the fractals
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void draw(){
    
    //Set the colour mode of this layer to be RGB with channel range:  [0.0, 255.0]
    this.colorMode(RGB, 255.0);
    
    //Draw the fractals
    if(fractalsArray.size() > 0){
      for(int i = 0; i < fractalsArray.size(); i++){
        if(fractalsArray.get(i).getNumberOfPixelsLeft() > 0){
          fractalsArray.get(i).update();
          fractalsArray.get(i).checkCollision();
          fractalsArray.get(i).colourPixel(this);
        }else{
          fractalsArray.remove(i);
        }
      }
    }
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to turn the current layer off
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void turnLayerOff(){
    
    //Turn off the current layer by calling the parent class's turnLayerOff method
    super.turnLayerOff();
  }
  
  
  //Method to turn the current layer on
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void turnLayerOn(){
    
    //Turn on the current layer by calling the parent class's turnLayerOn method
    super.turnLayerOn();
  }
  
  
  //Method to clear the current layer's contents
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void clearContent(){
    
    //Clear the current layer's contents by calling the parent class's clearContent method
    super.clearContent();
  }
  
  
  //Method to create a new fractal
  //
  //Input parameter:
  //  xMousePosition       - The x-position of where the mouse was clicked
  //  yMousePosition       - The y-position of where the mouse was clicked
  //  fractalStartPosition - The tracker object that keeps track of all the starting positions of the generated fractals
  //
  //Output parameter:
  //  None
  public void createFractal(float xMousePosition, float yMousePosition, FractalOriginTracker fractalStartPosition){
    
    //Add the new coordinate of this new generating fractal to the fractal origin tracking object
    fractalStartPosition.addOrigin(xMousePosition, yMousePosition);
    
    //Add a new fractal into the fractal array list
    fractalsArray.add(new Fractal(random(5.0, 10.0), random(5.0, 10.0), 100));
    fractalsArray.get(fractalsArray.size()-1).setOrigin(xMousePosition, yMousePosition);
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
