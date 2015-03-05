/*****************************************************************
 Assignment 3 - Objects and Inheritance
 
 This is the other reactive Shape class (part 3) of the assignment.
 STATUS: INCOMPLETE
 
 Version: 0.1
 Last updated: Oct. 23, 2011 
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/

class DoubleFlower extends ReactiveFlower {
  
  //--------------------------------- Constructors -------------------------------------//
  //Default constructor
  DoubleFlower() {
    //Use the parent class constructor
    super();
  }
  
  //Constructor with position parameters
  DoubleFlower(float xPosition, float yPosition) {
    //Use the parent class constructor
    super(xPosition, yPosition);
  }
  
  //--------------------------------- DoubleFlower methods ------------------------------------//
  //Draw methodto to override... THIS PART IS NOT YET COMPLETED
  //Conceptually, I would like to draw a double or even triple layers of different petal shapes for this flower,
  //but ...time constraint on my part -> remains only hypothetical
  public void draw() {
    //Colour mode setup
    colorMode(HSB, 399, 99, 99, 255);
    
    //Variables declaration
    float petalMidRadius = 0.6 * super.getRadius();
    float petalLowRadius = 0.21 * super.getRadius();;
    float petalArcLimit = (PI/5.05) * petalMidRadius;
    float petalPull = 1.25 * super.getRadius();;
    float centerDiameter = 2 * petalArcLimit;
    color lighterColour = super.getColour();
    color darkerColour = color(hue(lighterColour), saturation(lighterColour) + 20.0, brightness(lighterColour), alpha(lighterColour));
    
    pushMatrix();
      //Shape controls
      translate(super.getXPosition(), super.getYPosition()); //Center of shape placed at (xPos, yPos)
      //rotate(super.getAngle()); //Orient the shape to the specified angle

      noStroke();
      
      //Drawing the petals
      pushMatrix();
        for(int i = 0; i < 5; i++) {
          rotate(TWO_PI/5.0);
          
          //Drawing the outer sharp petals
          fill(lighterColour);
          beginShape();
              curveVertex(petalPull, super.getRadius());
              curveVertex(0, super.getRadius());
              curveVertex(-petalArcLimit, petalMidRadius);
              curveVertex(0, petalLowRadius);
              curveVertex(petalArcLimit, petalMidRadius);
              curveVertex(0, super.getRadius());
              curveVertex(-petalPull, super.getRadius());
          endShape();
        }
      popMatrix();
      
      //Drawing the flower's center
      fill(lighterColour);
      ellipse(0, 0, centerDiameter, centerDiameter);
    popMatrix();
  }
}
