class ThinBrushHead extends BasicBrushHead{
  
  //Private Fields
  private final float LINE_THICKNESS = 1.0;
  private float spreadAngle;
  private float branchLength;
  private int numOfBranch;
  
  //Constructor
  ThinBrushHead(){
    super();
    spreadAngle = 0.0;
    branchLength = 0.0;
    numOfBranch = 0;
  }
  
  //---------------------- Methods ----------------------//
  
  //-- Setters: --//
  //--------------//
  
  //Set the number of branches
  public void setBranch(int n){
    numOfBranch = n;
  }
  
  //Set how much spread is the branches going to have
  //Branches spaced more closely if percentage is near 0
  //Branches spread more uniformly if percentage is near 1
  public void setSpread(float percentage){
    spreadAngle = TWO_PI/numOfBranch;
    spreadAngle *= percentage;
  }
  
  //Set how far each branch will extend
  public void setLength(float theLength){
    branchLength = theLength;
  }
  
  //Set brush head size
  public void setBrushSize(float theSize){
    super.setBrushSize(theSize);
  }
  
  //Set the brush colour
  public void setBrushColour(float r, float g, float b, float transparency){
    super.setBrushColour(r, g, b, transparency);
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Get the brush head size
  public float getBrushSize(){
    return super.getBrushSize();
  }
  
  //Get the brush colour
  public color getBrushColour(){
    return super.getBrushColour();
  }
  
  
  //-- Other Public Methods: --//
  //---------------------------//
  
  //Method to draw a line that follows the mouse
  public void draw(){
    strokeWeight(LINE_THICKNESS);
    stroke(super.getBrushColour());
    noFill();
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
  
  //Method to generate a spreading effect once the mouse is release
  public void release(){
    
    //Local variables definition: 
    //Get the previous and current mouse positions
    int currMouseX = mouseX;
    int currMouseY = mouseY;
    int prevMouseX = pmouseX;
    int prevMouseY = pmouseY;
    
    //Temporary variables for controlling the transparency of the spread lines
    color strokeColour = super.getBrushColour();
    float transparency = alpha(strokeColour);
    float dampFactor = 0.6;
    
    //Temporary variables for controlling the speed of the spread lines
    float prevBranchPos = 0.0;
    float branchPos = branchLength/60;
    float branchVel = branchLength/100;
    float branchAcc = branchLength/2;
    
    //Control the initial direction of the spread lines
    float initialAngle = atan2( (currMouseY - prevMouseY), (currMouseX - prevMouseX) );
    
    
    //If the number of branches is non-zero, then create the spreading lines effect
    if(numOfBranch > 0){
      
      strokeWeight(LINE_THICKNESS);
      while(branchPos < branchLength){
        
        //Fade the spread lines as they expand outwards
        stroke(red(strokeColour), green(strokeColour), blue(strokeColour), transparency);
        pushMatrix();
          //Spread the lines 
          translate(currMouseX, currMouseY);
          rotate(initialAngle);
          line(prevBranchPos, 0, branchPos, 0);
          
          for(int i = 0; i < numOfBranch; i++){
            rotate(spreadAngle);
            line(prevBranchPos, 0, branchPos, 0);
          }
        popMatrix();
        
        //Update the spread speed and the fading
        prevBranchPos = branchPos;
        branchVel = max( 0.01, branchVel - branchAcc);
        branchPos += max(0.00001, branchPos + branchVel);
        transparency *= dampFactor;
      }
    }
  }
  
  
  
  //-- Private Methods: --//
  //----------------------//
  //None
}
