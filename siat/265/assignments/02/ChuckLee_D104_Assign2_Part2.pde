/*****************************************************************
 Assignment 2 - Transformations, Loops, Logic
 Part 2 - Animation
 
 The Doraemon character method from my assignment 1 is used for
 this assignment. The code is slightly modified from assignment 1 
 to allow character animation. The scene for this drawing is a
 starry night sky.
 
 In this part of the assignment, the parameters for moving Doraemon
 around the screen are initialized with random arguments. The algorithm
 to detect collision is referenced off from Lab 4. Unforunately, the
 collision algorithm only works for 0 radian. Hence, the angle 
 argument for Doraemon is hard coded to 0 radian.
 
 
 Version: 1.1
 Last updated: Oct. 09, 2011 
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/

//Constants Declarations
float DORAEMON_XOFFSET = 8;
float DORAEMON_YOFFSET = -45;
float DORAEMON_HALF_WIDTH = 158/2;
float DORAEMON_HALF_HEIGHT = 198/2;
float DORAEMON_ANGLE = 0.0;

//Global Variable Declarations
//Variables for Doraemon movements
float xPos, yPos, xVel, yVel;
float scaleFactor, xBoundary, yBoundary;

//Arrays for scene method
float [] starXPos = new float[50];
float [] starYPos = new float[50];
float [] cloudScale = new float[30];
int [] cloudShade = new int[10];



//Canvas Setup and Global Variables Initialization
void setup() {
  size(768, 480);
  smooth();
  
  //Initialize global variables 
  //Initialize Doraemon movement controls
  xPos = random(DORAEMON_HALF_WIDTH, (width - DORAEMON_HALF_WIDTH));
  yPos = random(DORAEMON_HALF_HEIGHT, (height - DORAEMON_HALF_HEIGHT));
  xVel = random(-5, 5);
  yVel = random(-5, 5);
  scaleFactor = random(0.5, 0.9);
  xBoundary = 0.0;
  yBoundary = 0.0;
  
  //Initialize the position of the star field
  for(int i = 0; i < 50; i++) {
    starXPos[i] = random(0, width);
    starYPos[i] = random(0, (0.75 * height));
  }
  
  //Initialize random scale factors for the cloud field
  for(int i = 0; i < 30; i++) {
    cloudScale[i] = random(1, 2);
  }
  
  //Initialize random shades for the cloud field
  for(int i = 0; i < 10; i++) {
    cloudShade[i] = (int) random(180, 205);
  }
}


//Main Drawing Loop
void draw() {
  //Draw the scene
  drawScene();

  //Collision detecting algorithm based on a rectangle bounding box that surrounds the outside of Doraemon
  //If any edge of the bounding box is detected to be outside the screen window size, then reverse the velocity vectors
  
  //Calculate the x- and y- boundaries of the bounding box
  xBoundary = DORAEMON_HALF_WIDTH * scaleFactor;
  yBoundary = DORAEMON_HALF_HEIGHT * scaleFactor;
  
  //Check if the x-boundary is outside the screen
  if( ((xPos + (DORAEMON_XOFFSET * scaleFactor)) < xBoundary) || ((xPos + (DORAEMON_XOFFSET * scaleFactor)) > (width - xBoundary )) ){
    xVel = -xVel;
  }
  
  //Check if the y-boundary is outside the screen
  if( ((yPos + (DORAEMON_YOFFSET * scaleFactor)) < yBoundary) || ((yPos + (DORAEMON_YOFFSET * scaleFactor)) > (height - yBoundary)) ){
    yVel = -yVel;
  } //end of collision algorithm
  
  //Update the position of Doraemon
  xPos += xVel;
  yPos += yVel;
  
  //Draw Doraemon
  drawDoraemon(xPos, yPos, DORAEMON_ANGLE, scaleFactor, (frameCount/10) % 6);
}



/***************************** Methods *****************************/

//Drawing Scene method
void drawScene() {
  colorMode(HSB, 359, 99, 99);
  
  //Variable declarations
  float RECT_YMIN = height/4;
  float HEIGHT_FACTOR = (3 * height)/(4 * 40.0);
  float starDiameter, moonDiameter;
  float CLOUD_XSTEP = width/10;
  float CLOUD_YSTEP = height/15;
  
  pushMatrix();
    background(240, 99, 64);
    
    //Gradient for background
    rectMode(CORNER);
    noStroke();
    for (int i = 64; i > 24; i -= 4) {
      fill(240, 99, i);
      rect(0, (((64 - i) * HEIGHT_FACTOR) + RECT_YMIN), width, ((i - 24) * HEIGHT_FACTOR));
    }
  
  
    //Draw random glowy star field
    for(int i = 0; i < 50; i++) {
      //random fill and diameter creates glowing effect for the star field
      fill(random(245, 255));
      starDiameter = random(1, 4);
      
      ellipse(starXPos[i], starYPos[i], starDiameter, starDiameter);
    }
  
  
    //Draw moon
    pushMatrix();
      translate((0.8 * width), (0.2 * height));
      
      for(int i = 99; i > 0; i -= 30) {
        fill(220, i, 80);
        moonDiameter = ( (((i * 0.02)/99.0)) + 0.18 ) * height;
        ellipse(0, 0, moonDiameter, moonDiameter);
      }
      fill(0, 0, 99);
      ellipse(0, 0, (0.175 * height), (0.175 * height));
    popMatrix();
    
    
    //Draw clouds
    //Drawing the cloud field on the lower part of the screen
    for(int i = 0; i < 10; i++) {
      for(int j = 0; j < 3; j++) {
        drawCloud((i*CLOUD_XSTEP), (height - (j*CLOUD_YSTEP)), cloudScale[i + (j*10)], (i + j) % 2, (int) (cloudShade[i] + (j*25)));
      }
    }
    
    //Drawing clouds under the moon
    drawCloud((0.77 * width), (0.27 * height), 0.5, 1, 200);
    drawCloud((0.75 * width), (0.26 * height), 0.3, 0, 225);
    drawCloud((0.82 * width), (0.28 * height), 0.5, 0, 235);
  popMatrix();
}


//Drawing Cloud method
void drawCloud(float xPos, float yPos, float scaleFactor, int cloudType, int shades) {
  /**********************************
   Input parameters definition:
   xPos - x-coordinate for position of cloud
   yPos - y-coordinate for position of cloud
   
   scaleFactor - scaling factor for scaling the cloud
   cloudType - controls which of the two type of clouds to draw
   shades - controls the shade of the cloud
  ***********************************/
  
  //Setups
  colorMode(RGB, 255);
  fill(shades);
  noStroke();
  
  pushMatrix();
    translate(xPos, yPos);
    scale(scaleFactor);
    
    //Draw one type of cloud
    switch(cloudType) {
      case 0:
        ellipse(0, 0, (0.2 * width), (0.05 * height));
        ellipse((0.05 * width), -(0.03 * height), (0.16 * width), (0.04 * height));
        break;
      case 1:
        ellipse(0, 0, (0.1 * width), (0.07 * height));
        ellipse((0.05 * width), 0, (0.13 * width), (0.1 * height));
        ellipse((0.02 * width), -(0.02 * height), (0.1 * width), (0.1 * height));
        ellipse((0.04 * width), (0.01 * height), (0.12 * width), (0.1 * height));
        break;
    }
    
  popMatrix();
}


//Drawing Doraemon method
void drawDoraemon(float xPos, float yPos, float angle, float scaleFactor, int characterState) {
  /**********************************
   Input parameters definition:
   xPos - x-coordinate for translating Doraemon's position
   yPos - y-coordinate for translating Doraemon's position
   
   angle - angle in radians for rotating Doraemon
   scaleFactor - scaling factor for scaling Doraemon
   
   characterState - controls which animation state should Doraemon be
   ***********************************/


  pushMatrix(); //prevent this method from changing the location of the origin of the caller
  //----------------------------- Some setups ----------------------------------//
  //Variable declarations: Doraemon's size parameters
  float bodyDiameter = 100.0;
  float innerBodyDiameter = (0.6 * bodyDiameter);
  float headDiameter = 120.0;

  colorMode(RGB, 255); //set colour space to RGB
  //---------------------------- End of setups --------------------------------//


  //----------------------------- Doraemon's control functions ------------------------//
  //Doraemon's positioning control
  translate(xPos, yPos);

  //Doraemon's transformation control
  rotate(angle);
  scale(scaleFactor);
  //---------------------- End of Doraemon's control functions ------------------------//


  //------------------------ Drawing Doraemon -----------------------------//
  //Drawing Doraemon's blue head
  pushMatrix();
    //draw outer head
    translate(0, -( (0.5 * bodyDiameter) + (0.25 * headDiameter) ));
    stroke(0);
    strokeWeight(0.5);
    fill(64, 190, 255); //blue
    ellipse(0, 0, headDiameter, headDiameter);
  popMatrix(); //end of Doraemon's blue head
  
  
  //Drawing Doraemon's tail
  pushMatrix();
    //Draw the base of the tail
    noStroke();
    fill(0);
    quad(0, -(0.15 * bodyDiameter), (0.6 * bodyDiameter), (0.18 * bodyDiameter), (0.6 * bodyDiameter), (0.22 * bodyDiameter), 0, (0.02 * bodyDiameter));
  
    //Tip of Doraemon's tail
    translate((0.58 * bodyDiameter), (0.2 * bodyDiameter));
    stroke(0);
    strokeWeight(1);
    fill(230, 40, 40);
    ellipse(0, 0, (0.15 * headDiameter), (0.15 * headDiameter));
  popMatrix(); //end of Doraemon's tail
  
  
  //Drawing Doraemon's blue body
  fill(64, 190, 255);    
  stroke(0);
  strokeWeight(0.5);
  beginShape();
    vertex(-(0.308 * bodyDiameter), -(0.32 * bodyDiameter));
    vertex(-(0.38 * bodyDiameter), -(0.2 * bodyDiameter));
    vertex(-(0.38 * bodyDiameter), (0.4 * bodyDiameter));
    vertex(-(0.06 * bodyDiameter), (0.4 * bodyDiameter));
    vertex(-(0.03 * bodyDiameter), (bodyDiameter/3));
    vertex(0, (0.4 * bodyDiameter));
    vertex((0.38 * bodyDiameter), (0.4 * bodyDiameter));
    vertex((0.38 * bodyDiameter), -(0.2 * bodyDiameter));
    vertex((0.302 * bodyDiameter), -(0.32 * bodyDiameter));
  endShape(); //leave the path open so that the head and body looks like a single shape when the neck strap is not drawn
  //end of Doraemon's blue body
  
  
  //Drawing Doraemon's right arm and hand
  pushMatrix();
    //Doraemon's right arm
    translate(-(0.38 * bodyDiameter), -(0.2 * bodyDiameter));
    strokeCap(SQUARE); //prevent stroke overlapping onto Doraemon's blue body
    stroke(0);
    strokeWeight(1);
    fill(64, 190, 255);

    beginShape();
      curveVertex((0.1 * bodyDiameter), 0);
      curveVertex(0, 0);
      curveVertex(-(0.05 * bodyDiameter), (0.1 * bodyDiameter));
      curveVertex(-(0.05 * bodyDiameter), (0.4 * bodyDiameter));
      curveVertex(-(0.05 * bodyDiameter), (0.4 * bodyDiameter));
      vertex(0, (0.4 * bodyDiameter));
    endShape(); //leave path open to allow body overlap the arm

    //Doraemon's right hand
    translate(0, (0.375 * bodyDiameter));
    strokeWeight(1.5);
    fill(255);
    arc(0, 0, (0.18 * bodyDiameter), (0.18 * bodyDiameter), HALF_PI, (TWO_PI - HALF_PI));
  popMatrix(); //end of Doraemon's right arm and hand
  
  
  //Drawing Doraemon's feet
  pushMatrix();
    translate(-(0.05 * innerBodyDiameter), (0.6 * innerBodyDiameter));
    stroke(0);
    strokeWeight(1);
    fill(255);
  
    //Doraemon's right foot
    pushMatrix();
      translate(-(0.1 * innerBodyDiameter), 0);
      beginShape();
        curveVertex(0, (0.2 * innerBodyDiameter));
        curveVertex(0, 0);
        curveVertex(-(0.6 * innerBodyDiameter), 0);
        curveVertex(-(0.65 * innerBodyDiameter), (0.15 * innerBodyDiameter));
        curveVertex(-(0.4 * innerBodyDiameter), (0.25 * innerBodyDiameter));
        curveVertex(-(0.1 * innerBodyDiameter), (0.2 * innerBodyDiameter));
        curveVertex((0.05 * innerBodyDiameter), (0.1 * innerBodyDiameter));
        curveVertex(0, 0);
        curveVertex(-(0.6 * innerBodyDiameter), -(0.2 * innerBodyDiameter));
      endShape(CLOSE);
    popMatrix();
  
    //Doraemon's left foot (reflection of the right foot)
    pushMatrix();
      translate((0.1 * innerBodyDiameter), 0);
      beginShape();
        curveVertex(0, (0.2 * innerBodyDiameter));
        curveVertex(0, 0);
        curveVertex((0.6 * innerBodyDiameter), 0);
        curveVertex((0.65 * innerBodyDiameter), (0.15 * innerBodyDiameter));
        curveVertex((0.4 * innerBodyDiameter), (0.25 * innerBodyDiameter));
        curveVertex((0.1 * innerBodyDiameter), (0.2 * innerBodyDiameter));
        curveVertex(-(0.05 * innerBodyDiameter), (0.1 * innerBodyDiameter));
        curveVertex(0, 0);
        curveVertex((0.6 * innerBodyDiameter), -(0.2 * innerBodyDiameter));
      endShape(CLOSE);
    popMatrix();
  popMatrix(); //end of Doraemon's feet
  
  
  //Drawing Doraemon's inner body
  pushMatrix();
    //Draw the inner body
    translate(-(0.05 * bodyDiameter), 0);
    stroke(0);
    strokeWeight(1.5);
    fill(255);
    ellipse(0, 0, innerBodyDiameter, innerBodyDiameter);
  
    //Drawing Doraemon's magic pouch
    translate(-(0.02 * bodyDiameter), 0);
    strokeWeight(1);
    arc(0, 0, (0.8 * innerBodyDiameter), (0.8 * innerBodyDiameter), 0, PI);
    fill(0);
    arc(0, 0, (0.8 * innerBodyDiameter), (0.1 * innerBodyDiameter), 0, PI);
  popMatrix(); //end of Doraemon's inner body and magic pouch
  
  
  //Drawing Doraemon's entire face
  pushMatrix();
    //Draw the face
    translate(-(0.075 * headDiameter), -( (0.5 * bodyDiameter) + (0.25 * headDiameter) ));
    strokeWeight(1.5);
    fill(255);
    ellipse(0, 0, (0.75 * headDiameter), (0.75 * headDiameter)); //face
  
    //Drawing Doraemon's eyes
    pushMatrix();
      //Drawing the right eye, pupil and highlight
      translate(-(0.16 * headDiameter), -(0.3 * headDiameter)); //location of Doraemon's right eye
      pushMatrix();
        //Doraemon's right eye
        stroke(0);
        strokeWeight(1);
        ellipse(0, 0, (0.2 * headDiameter), (0.3 * headDiameter));
      
        //Doraemon's right pupil
        translate((0.025 * headDiameter), (0.025 * headDiameter));
        noStroke();
        fill(0);
        ellipse(0, 0, (0.05 * headDiameter), (0.1 * headDiameter));
      
        //Doraemon's right pupil highlight
        translate(0, (0.01 * headDiameter));
        fill(255);
        ellipse(0, 0, (0.025 * headDiameter), (0.05 * headDiameter));
      popMatrix();
  
  
      //Drawing the left eye, pupil and highlight
      translate((0.2 * headDiameter), 0); //location of Doraemon's left eye
      pushMatrix();
        //Doraemon's left eye
        stroke(0);
        ellipse(0, 0, (0.2 * headDiameter), (0.3 * headDiameter));
      
        //Doraemon's left pupil
        translate(-(0.025 * headDiameter), (0.025 * headDiameter));
        noStroke();
        fill(0);
        ellipse(0, 0, (0.05 * headDiameter), (0.1 * headDiameter));
      
        //Doraemon's right pupil highlight
        translate(0, (0.01 * headDiameter));
        fill(255);
        ellipse(0, 0, (0.025 * headDiameter), (0.05 * headDiameter));
      popMatrix();
    popMatrix(); //end of Doraemon's face and eyes
  
  
    //Drawing Doraemon's nose
    pushMatrix();
      //Draw the line under nose
      translate(-(0.0625 * headDiameter), -(0.1 * headDiameter));
      stroke(0);
      strokeWeight(1);
      curve((0.15 * headDiameter), -(0.15 * headDiameter), 0, (0.075 * headDiameter), 0, (0.25 * headDiameter), (0.15 * headDiameter), (0.15 * headDiameter));
    
      //Draw the nose
      fill(230, 40, 40);
      ellipse(0, 0, (0.15 * headDiameter), (0.15 * headDiameter));
    popMatrix(); //end of Doraemon's nose


    //Drawing Doraemon's mouth
    pushMatrix();
      translate(-(0.0625 * headDiameter), (0.15 * headDiameter));
      noFill();
      curve(-(0.4 * headDiameter), -(0.4 * headDiameter), -(0.2 * headDiameter), 0, 0, 0, 0, -(0.3 * headDiameter));
      curve(0, -(0.3 * headDiameter), 0, 0, (0.2 * headDiameter), 0, (0.4 * headDiameter), -(0.4 * headDiameter));
    popMatrix(); //end of Doraemon's mouth


    //Drawing Doraemon's whiskers
    pushMatrix();
      //Draw the first two (horizontal) whiskers
      translate(0, (0.1 * headDiameter));
      line(-(0.3 * headDiameter), 0, -(0.5 * headDiameter), 0);
      line((0.2 * headDiameter), 0, (0.45 * headDiameter), 0);
    
      //Rotate the same first two whiskers (lines) by PI/10
      rotate(PI/10);
      line(-(0.3 * headDiameter), 0, -(0.5 * headDiameter), 0);
      line((0.2 * headDiameter), 0, (0.45 * headDiameter), 0);
    
      //Rotate the same first two whiskers (lines) by -PI/10 
      rotate(-PI/5); //rotating by -PI/10 two times from PI/10 is equivalent to rotating by -PI/5 from PI/10 (i.e. PI/10 - PI/5 = -PI/10)
      line(-(0.3 * headDiameter), 0, -(0.5 * headDiameter), 0);
      line((0.2 * headDiameter), 0, (0.45 * headDiameter), 0);
    popMatrix();
  popMatrix(); //end of Doraemon's entire face
  
  
  //Drawing Doraemon's neck strap
  pushMatrix();
    //Draw the red neck strap
    translate(0, -(0.5 * innerBodyDiameter));
    noStroke();
    fill(230, 40, 40);
    rectMode(CENTER); //the next rect() function is easier to specify by the center point rather than the corner point
    rect(0, 0, (1.1 * innerBodyDiameter), (0.1 * innerBodyDiameter));
  
    stroke(0);
    strokeCap(ROUND); //smooth out the path connection between the arcs and lines
    strokeWeight(1);
    arc((0.55 * innerBodyDiameter), 0, (0.1 * innerBodyDiameter), (0.1 * innerBodyDiameter), -HALF_PI, HALF_PI);
    arc(-(0.55 * innerBodyDiameter), 0, (0.1 * innerBodyDiameter), (0.1 * innerBodyDiameter), HALF_PI, (TWO_PI - HALF_PI));
    line(-(0.55 * innerBodyDiameter), -(0.05 * innerBodyDiameter), (0.55 * innerBodyDiameter), -(0.05 * innerBodyDiameter));
    line(-(0.55 * innerBodyDiameter), (0.05 * innerBodyDiameter), (0.55 * innerBodyDiameter), (0.05 * innerBodyDiameter));

    //Drawing Doraemon's yellow bell on the neck strap
    pushMatrix();
  
      //Draw the bell
      translate(-(0.1 * bodyDiameter), 0);
      fill(255, 229, 77);
      ellipse(0, 0, (0.25 * innerBodyDiameter), (0.25 * innerBodyDiameter));
    
      //Draw the bell's details
      translate(-(0.01 * bodyDiameter), (0.025 * innerBodyDiameter));
      strokeWeight(1.25);
      fill(0);
      line(0, 0, 0, (0.1 * innerBodyDiameter));
      noStroke();
      ellipse(0, 0, (0.1 * innerBodyDiameter), (0.1 * innerBodyDiameter));
    popMatrix();
  popMatrix(); //end of Doraemon's neck strap and bell
  
  
  //Drawing Doraemon's left arm and hand
  //Also, this is the animation state control section
  pushMatrix();
    translate((0.34 * bodyDiameter), -(0.2 * bodyDiameter));
    
    //Doraemon's animation state control for the left arm
    if (characterState == 1) {
      //Rotate left arm by -60 degree
      rotate(-PI/3);
    } 
    else if (characterState == 2) {
      //Rotate left arm by -120 degree
      rotate(-(2*PI)/3);
    } 
    else if (characterState == 3) {
      //Rotate left arm by 180 (same as -180) degree
      rotate(PI);
    } 
    else if (characterState == 4) {
      //Rotate left arm by 120 (same as -240) degree
      rotate((2*PI)/3);
    } 
    else if (characterState == 5) {
      //Rotate left arm by 60 (same as -300) degree
      rotate(PI/3);
    } //Else if characterState == 0; Don't rotate left arm (same as rotating by 0 or -360 degree, or don't do anything)
    //This state is implicitly defined by the default drawing codes below
  
  
    //Doraemon's left arm
    stroke(0);
    strokeWeight(1);
    fill(64, 190, 255);
    beginShape();
      curveVertex(-(0.05 * bodyDiameter), (0.35 * bodyDiameter));
      curveVertex(-(0.05 * bodyDiameter), (0.35 * bodyDiameter));
      curveVertex(-(0.07 * bodyDiameter), (0.1 * bodyDiameter));
      curveVertex(-(0.04 * bodyDiameter), 0);
      curveVertex((0.04 * bodyDiameter), 0);
      curveVertex((0.07 * bodyDiameter), (0.1 * bodyDiameter));
      curveVertex((0.05 * bodyDiameter), (0.35 * bodyDiameter));
      curveVertex((0.05 * bodyDiameter), (0.35 * bodyDiameter));
    endShape(CLOSE);
  
    //Doraemon's left hand
    translate(0, (0.4 * bodyDiameter));
    strokeWeight(1.5);
    fill(255);
    ellipse(0, 0, (0.2 * bodyDiameter), (0.2 * bodyDiameter));
  popMatrix(); //end of Doraemon's left arm and hand

  //--------------------------- End of drawing Doraemon ----------------------------//
  popMatrix();
}

