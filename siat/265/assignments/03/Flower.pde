/*****************************************************************
 Assignment 3 - Objects and Inheritance
 
 This is the Shape class (part 1) of the assignment.
 
 Version: 1.0
 Last updated: Oct. 23, 2011 
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/

class Flower {
  
  //Fields (Private) declaration
  private PVector position;
  private float angle;
  private float flowerRadius;
  private color lighterColour;
  private color darkerColour;
  
  //--------------------------------- Constructors -------------------------------------//
  //Default constructor
  Flower() {
    //Set the position, rotation angle, and radius of the flower
    position = new PVector(random(width), random(height));
    angle = random(-PI, PI);
    
    if(width <= height) {
      flowerRadius = floor( (width/NUM_X_FLOWER) - (floor(width/NUM_X_FLOWER) % 10) )/2.0;
    } else {
      flowerRadius = floor( (height/NUM_Y_FLOWER) - (floor(height/NUM_Y_FLOWER) % 10) )/2.0;
    }
    
    
    //Set the colour scheme for the flower
    colorMode(HSB, 399, 99, 99);
    lighterColour = color(random(255), random(20), 99);
    darkerColour = color(hue(lighterColour), saturation(lighterColour) + 20.0, 99);
  }
  
  
  //Constructor with position parameters
  Flower(float xPosition, float yPosition) {
    //Set the position, rotation angle, and radius of the flower
    position = new PVector(xPosition, yPosition);
    angle = random(-PI, PI);
    
    if(width <= height) {
      flowerRadius = floor( (width/NUM_X_FLOWER) - (floor(width/NUM_X_FLOWER) % 10) )/2.0;
    } else {
      flowerRadius = floor( (height/NUM_Y_FLOWER) - (floor(height/NUM_Y_FLOWER) % 10) )/2.0;
    }
    
    //Set the colour scheme for the flower
    colorMode(HSB, 399, 99, 99);
    lighterColour = color(random(255), random(20), 99);
    darkerColour = color(hue(lighterColour), saturation(lighterColour) + 20.0, 99);
  }
  
  //--------------------------------- Setter methods ------------------------------------//
  //Set the flower's position
  public void setPosition(float xPos, float yPos) {
    position.x = xPos;
    position.y = yPos;
  }
  
  
  //Set the flower's rotation angle in radians
  public void setAngle(float rot) {
    angle = rot;
  }
  
  
  //Set the flower's radius (size)
  public void setRadius(float rad) {
    flowerRadius = rad;
  }
  
  
  //Set the flower's colour
  public void setColour(float theHue, float theSaturation, float theBrightness) {
    lighterColour = color(theHue, theSaturation, theBrightness);
    darkerColour = color(theHue, theSaturation + 20.0, theBrightness);
  }
  
  
  //Set the flower's alpha values
  public void setTransparency(float alphaValue) {
    color temp = lighterColour;
    lighterColour = color(hue(temp), saturation(temp), brightness(temp), alphaValue);
    darkerColour = color(hue(temp), saturation(temp) + 20.0, brightness(temp), alphaValue);
  }
  
  //--------------------------------- Getter methods ------------------------------------//
  //Get the x-coordinate of the flower's center
  public float getXPosition() {
    return position.x;
  }
  
  
  //Get the y-coordinate of the flower's center
  public float getYPosition() {
    return position.y;
  }
  
  
  //Get the radius of the flower
  public float getRadius() {
    return flowerRadius;
  }
  
  
  //Get the lighter colour of the flower
  public color getColour() {
    return lighterColour;
  }
  
  //--------------------------------- Flower methods ------------------------------------//
  //Reactive method: This method is overrided in the ReactiveFlower class
  public void reactFlower() {};
  
  
  //Draw method
  public void draw() {
    //Colour mode setup
    colorMode(HSB, 399, 99, 99, 255);
    
    //Variables declaration
    float petalMidRadius = 0.6 * flowerRadius;
    float petalLowRadius = 0.21 * flowerRadius;
    float petalArcLimit = (PI/5.05) * petalMidRadius;
    float petalPull = 1.25 * flowerRadius;
    float centerDiameter = 2 * petalArcLimit;
    
    pushMatrix();
      //Shape controls
      translate(position.x, position.y); //Center of shape placed at (xPos, yPos)
      rotate(angle); //Orient the shape to the specified angle

      noStroke();
      
      //Drawing the petals
      pushMatrix();
        for(int i = 0; i < 5; i++) {
          rotate(TWO_PI/5.0);
          
          //Drawing the outer petals
          fill(darkerColour);
          beginShape();
              curveVertex(petalPull, flowerRadius);
              curveVertex(0, flowerRadius);
              curveVertex(-petalArcLimit, petalMidRadius);
              curveVertex(0, petalLowRadius);
              curveVertex(petalArcLimit, petalMidRadius);
              curveVertex(0, flowerRadius);
              curveVertex(-petalPull, flowerRadius);
          endShape();
          
          //Drawing the inner petals
          fill(lighterColour);
          beginShape();
              curveVertex(petalPull, flowerRadius);
              curveVertex(0, (0.85 * flowerRadius));
              curveVertex(-(0.75 * petalArcLimit), (0.9 * petalMidRadius));
              curveVertex(0, petalLowRadius);
              curveVertex((0.75 * petalArcLimit), (0.9 * petalMidRadius));
              curveVertex(0, (0.85 * flowerRadius));
              curveVertex(-petalPull, flowerRadius);
          endShape();
        }
      popMatrix();
      
      //Drawing the flower's center
      //Drawing the outer layer of the flower's center
      fill(darkerColour);
      ellipse(0, 0, centerDiameter, centerDiameter);
      
      //Drawing the inner layer of the flower's center
      fill(lighterColour);
      ellipse(0, 0, (0.7 * centerDiameter), (0.7 * centerDiameter));
      fill(darkerColour);
      ellipse(0, 0, (0.5 * centerDiameter), (0.5 * centerDiameter));
    popMatrix();
  }
}
