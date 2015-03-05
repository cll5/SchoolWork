/*****************************************************************
 Assignment 3 - Objects and Inheritance
 
 This is the reactive Shape class (part 2) of the assignment.
 
 Version: 1.0
 Last updated: Oct. 23, 2011 
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/

class ReactiveFlower extends Flower {
  
  //--------------------------------- Constructors -------------------------------------//
  //Default constructor
  ReactiveFlower() {
    //Use the parent class constructor
    super();
  }
  
  
  //Constructor with position parameters
  ReactiveFlower(float xPosition, float yPosition) {
    //Use the parent class constructor
    super(xPosition, yPosition);
  }
  
  //--------------------------------- Reactive methods ------------------------------------//
  //Method to react the flower based on the mouse position
  public void reactFlower() {
    
    //Variable declarations
    float dX = mouseX - super.getXPosition(); //distance between the mouse's x-coordinate and the flower's x-coordinate
    float dY = mouseY - super.getYPosition(); //distance between the mouse's y-coordinate and the flower's y-coordinate
    float distance = sqrt(sq(dX) + sq(dY)); //distance between the mouse's position and the flower's position
    float maxWidth;
    float maxHeight;
    float maxDistance;
    float distanceFactor;
    
    //Some pre-calculation for finding out the distanceFactor variable
    if( abs(width - super.getXPosition()) >= super.getXPosition() ) {
      maxWidth = abs(width - super.getXPosition());
    } else {
      maxWidth = super.getXPosition();
    }
    
    if( abs(height - super.getYPosition()) >= super.getYPosition() ) {
      maxHeight = abs(height - super.getYPosition());
    } else {
      maxHeight = super.getYPosition();
    }
    
    maxDistance = sqrt(sq(maxWidth) + sq(maxHeight)) + 1.0;
    distanceFactor = 1 - (distance/maxDistance);
    
    //Reactive settings:
    //Set the rotation angle based on the mouse's position relative to the flower's position
    super.setAngle( atan2(dY, dX) );
    
    //Set the colour based on the distance between the mouse's position and the flower's position
    super.setColour((distanceFactor * 399.0), (distanceFactor * 20.0), 99.0);
    
    //Set the radius based on the distance between the mouse's position and the flower's position
    super.setRadius( (distanceFactor + 0.1) * (width/(2 * NUM_X_FLOWER)) );
    
    //Set the transparency of the flower based on the distance between the mouse's position and the flower's position
    super.setTransparency( (distanceFactor + 0.25) * 150.0 );
  }
}
