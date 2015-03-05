/*****************************************************************
Assignment 1 - Shapes and Transformations
Part 3 - Drawing in a Method

Various locations and transformations of Doraemon on the scene.


Version: 1.0
Last updated: Sept. 25, 2011 

Written by: Chuck Lee
SFU ID No.: 301054031
Email: cll5@sfu.ca
Lab Section: D104
******************************************************************/


void setup() {
  size(768, 480);
  smooth();
}

void draw() {
  //Calling the drawing scene method
  drawScene();
  
  //Calling the drawing Doraemon method
  drawDoraemon(100, 400, 0, 1.5); //located at (100, 400), no rotation, scaled by 1.5x
  drawDoraemon(100, 100, 165, 0.25); //located at (100, 100), rotated by 165 degress, scaled by 0.25x
  drawDoraemon(200, 450, 15, 0.5); //located at (200, 450), rotated by 15 degress, scaled by 0.5x
  drawDoraemon(660, 400, 0, 1); //located at (660, 400), no rotation, no scaling
  drawDoraemon(width/2, height/2, -59.15, 0.75); //located at center of screen, rotated by -59.15 degress, scaled by 0.75x
  drawDoraemon(600, 150, 180, 0.5); //located at (600, 150), rotated by 180 degress, scaled by 0.5x
  drawDoraemon(680, 150, -45, -0.5); //located at (680, 150), rotated by -45 degress, scaled by -0.5x
  drawDoraemon(700, 90, 90, 0.4); //located at (700, 90), rotated by 90 degress, scaled by 0.4x
  drawDoraemon(660, 60, 45, 0.25); //located at (660, 60), rotated by 45 degress, scaled by 0.25x
}



//Drawing scene method
void drawScene() {
  //Variable declarations
  float sunDiameter = (0.2 * height); //diameter of the sun in the background
  float bgGradExpansion = 35.0; //used to expand or shrink the amount of gradient covering the background; the smaller the value is, the larger the gradient will expand over the screen  
  float ufoLength = (0.8 * sunDiameter);
  float ufoHeight = (0.2 * sunDiameter);
  float ufoOneX = (0.3 * width); //x-coordinate for positioning the gray UFO
  float ufoOneY = (0.25 * height); //y-coordinate for positioning the gray UFO
  float ufoTwoX = (0.6 * width); //x-coordinate for positioning the red UFO
  float ufoTwoY = (0.1 * height); //y-coordinate for positioning the red UFO
  float treeWidth = (0.3 * width);
  float treeHeight = (0.4 * height);
  

  //------------------------------- Drawing background -------------------------------//
  colorMode(HSB, 359, 99, 99); //choosing HSB colour mode for the background and using the same HSB ranges in the color selector
  rectMode(CORNER); //specify the location of rectangles by their corners
  
  //Drawing the gradient for the background
  noStroke();
  for(int sat = 99; sat > 0; sat = sat - 1) {
    fill(43, sat, 99);
    ellipse((0.75 * width), 0, ((sat/bgGradExpansion) * width), ((sat/bgGradExpansion) * height));
  } 
  
  //Drawing a sun
  pushMatrix();
    noStroke();
    translate((0.8 * width), (0.18 * height));
    
    //Gradient for the sun
    for(int sat = 90; sat > 20; sat = sat - 15) {
      fill(50, sat, 99);
      ellipse(0, 0, ((sat/90.0) * sunDiameter), ((sat/90.0) * sunDiameter));
    }
    
    //Outline the sun
    stroke(30, 87, 93, 70);
    strokeWeight(1);
    noFill();
    ellipse(0, 0, sunDiameter, sunDiameter);
    
    //Drawing the sun rays
    stroke(46, 99, 96, 128);
    strokeWeight(2.5);
    fill(50, 88, 99);
    triangle(0, (0.8 * sunDiameter), (0.1 * sunDiameter), (0.6 * sunDiameter), -(0.1 * sunDiameter), (0.6 * sunDiameter)); //initial sun ray
    
    //Duplicate and rotate the rest of the sun rays with 45 degree increments
    for(int angle = 0; angle < 360; angle = angle + 45) {
      rotate( (TWO_PI * (angle/360.0)) );
      triangle(0, (0.8 * sunDiameter), (0.1 * sunDiameter), (0.6 * sunDiameter), -(0.1 * sunDiameter), (0.6 * sunDiameter));
    }
  popMatrix();
  //---------------------------- End of drawing background --------------------------//
  
  
  
  //--------------------------- Drawing scene (foreground) --------------------------//
  colorMode(RGB, 255); //switch colour mode to RGB for foreground objects
  
  //Drawing two UFO's in the sky
    stroke(0);
    
    //Drawing the first UFO
    strokeWeight(1.5);
    curve(ufoOneX, (ufoOneY - (0.25 * ufoHeight)), ufoOneX, (ufoOneY - ufoHeight), (ufoOneX + (0.25 * ufoLength)), (ufoOneY - (1.5 * ufoHeight)), (ufoOneX + (1.25 * ufoLength)), (ufoOneY - (1.5 * ufoHeight)));
    
    strokeWeight(0.75);
    fill(255, 74, 64);
    ellipse((ufoOneX + (0.25 * ufoLength)), (ufoOneY - (1.5 * ufoHeight)), (0.5 * ufoHeight), (0.5 * ufoHeight));
    
    fill(219);
    arc(ufoOneX, (ufoOneY - (0.5 * ufoHeight)), (0.4 * ufoLength), ufoHeight, PI, TWO_PI);
    ellipse(ufoOneX, ufoOneY, ufoLength, ufoHeight);
    
    fill(137, 232, 255);
    quad((ufoOneX - (0.1 * ufoLength)), ufoOneY, ufoOneX, (ufoOneY - (0.3 * ufoHeight)), (ufoOneX + (0.1 * ufoLength)), ufoOneY, ufoOneX, (ufoOneY + (0.3 * ufoHeight)));
    //end of first UFO
    
    //Drawing the second UFO
    fill(206, 192, 167);
    quad(ufoTwoX, (ufoTwoY - (0.3 * ufoHeight)), (ufoTwoX + (0.3 * ufoLength)), (ufoTwoY - (0.6 * ufoHeight)), (ufoTwoX + (0.3 * ufoLength)), ufoTwoY, ufoTwoX, ufoTwoY);
    
    fill(185, 71, 67);
    triangle(ufoTwoX, (ufoTwoY - (0.75 * ufoHeight)), (ufoTwoX + (0.1 * ufoLength)), ufoTwoY, (ufoTwoX - (0.4 * ufoLength)), ufoTwoY);
    
    fill(255, 178, 152);
    quad((ufoTwoX - (0.4 * ufoLength)), ufoTwoY, (ufoTwoX + (0.4 * ufoLength)), ufoTwoY, (ufoTwoX + (0.25 * ufoLength)), (ufoTwoY + (0.9 * ufoHeight)), (ufoTwoX - (0.25 * ufoLength)), (ufoTwoY + (0.9 * ufoHeight)));
    
    fill(255);
    ellipse((ufoTwoX - (0.2 * ufoLength)), (ufoTwoY + (0.45 * ufoHeight)), (0.3 * ufoHeight), (0.3 * ufoHeight));
    ellipse(ufoTwoX, (ufoTwoY + (0.45 * ufoHeight)), (0.3 * ufoHeight), (0.3 * ufoHeight));
    ellipse((ufoTwoX + (0.2 * ufoLength)), (ufoTwoY + (0.45 * ufoHeight)), (0.3 * ufoHeight), (0.3 * ufoHeight));
    //end of second UFO
    
  
  
  //Drawing mountains
    noStroke();
    //right mountain
    fill(110, 145, 167);
    triangle((0.9 * width), (0.6 * height), (0.68 * width), height, (1.1 * width), height);
    
    //left mountain
    fill(101, 170, 214);
    triangle((0.75 * width), (0.5 * height), (0.65 * width), height, (0.85 * width), height);
    
    //middle mountain
    fill(46, 164, 240);
    triangle((0.8 * width), (0.7 * height), (0.7 * width), height, (0.9 * width), height);
  
  
  
  //Drawing trees
    pushMatrix();
      translate((0.3 * width), (0.85 * height));
      
      stroke(113, 78, 8);
      strokeWeight(2);
      fill(173, 122, 21);
      rect((0.15 * treeWidth), 0, (0.2 * treeWidth), (0.5 * treeHeight)); //right trunk
      rect(-(0.05 * treeWidth), 0, (0.1 * treeWidth), (0.5 * treeHeight)); //left trunk
      
      stroke(38, 124, 21);
      strokeWeight(3.5);
      fill(65, 175, 44);
      arc((0.25 * treeWidth), 0, (0.5 * treeWidth), treeHeight, PI, TWO_PI); //right tree
      line(0, 0, (0.5 * treeWidth), 0);
      arc(0, 0, (0.25 * treeWidth), (1.75 * treeHeight), PI, TWO_PI); //left tree
      line(-(0.125 * treeWidth), 0, (0.125 * treeWidth), 0);
    popMatrix();
  
  
  
  //Drawing house
    stroke(128);
    strokeWeight(2);
    
    //house
    fill(237, 173, 43);
    rect((0.55 * width), (0.8 * height), (0.15 * width), (0.2 * height));
    
    //door
    fill(200);
    rect((0.58 * width), (0.9 * height), (0.025 * width), (0.1 * height));
    
    //window
    fill(255);
    rect((0.65 * width), (0.85 * height), (0.025 * width), (0.025 * width));
    line((0.6625 * width), (0.85 * height), (0.6625 * width), ((0.85 * height) + (0.025 * width)));
    line((0.65 * width), ((0.85 * height) + (0.0125 * width)), (0.675 * width), ((0.85 * height) + (0.0125 * width)));
    
    //roof
    fill(191, 230, 255);
    quad((0.55 * width), (0.8 * height), (0.7 * width), (0.8 * height), (0.65 * width), (0.75 * height), (0.6 * width), (0.75 * height));
    line((0.6 * width), (0.765 * height), (0.65 * width), (0.765 * height));
    line((0.58 * width), (0.78 * height), (0.67 * width), (0.78 * height));
  
  
  
  //Drawing hill
    noStroke();
    //center hill
    fill(65, 175, 44);
    rect((0.3 * width), (0.97 * height), (0.6 * width), (0.1 * height));
    stroke(38, 124, 21);
    strokeWeight(2);
    line((0.3 * width), (0.97 * height), (0.9 * width), (0.97 * height));
    line((0.5 * width), (0.98 * height), (0.7 * width), (0.98 * height));
    line((0.6 * width), (0.99 * height), (0.8 * width), (0.99 * height));
    
    //left hill
    arc((0.25 * width), (1.1 * height), (0.7 * width), (0.35 * height), PI, TWO_PI);
    noFill();
    curve(0, (1.2 * height), (0.05 * width), (0.97 * height), (0.45 * width), (0.97 * height), (0.5 * width), (1.2 * height));
    curve((0.05 * width), (1.2 * height), (0.1 * width), (0.99 * height), (0.4 * width), (0.99 * height), (0.45 * width), (1.2 * height));
    
    //right hill
    fill(65, 175, 44);
    arc((0.95 * width), (1.1 * height), (0.5 * width), (0.5 * height), PI, TWO_PI);
    noFill();
    curve((0.8 * width), (0.92 * height), (0.93 * width), (0.9 * height), (0.98 * width), (0.94 * height), (0.98 * width), (0.97 * height));
    curve((0.7 * width), (0.95 * height), (0.88 * width), (0.93 * height), (0.98 * width), (0.97 * height), (0.98 * width), height);
    curve((0.65 * width), (0.97 * height), (0.83 * width), (0.95 * height), (0.98 * width), (0.99 * height), (0.98 * width), (1.02 * height));
    curve((0.8 * width), (1.1 * height), (0.85 * width), (0.99 * height), (0.96 * width), (0.9 * height), (1.2 * width), (0.86 * height));
    curve((0.96 * width), (1.1 * height), (0.9 * width), (0.99 * height), (0.99 * width), (0.9 * height), (1.3 * width), (0.86 * height));

    
    //Drawing rock in front of house
    stroke(128);
    strokeWeight(2);
    fill(215);
    arc((0.65 * width), (0.97 * height), (0.04 * width), (0.03 * width), PI, TWO_PI);
    line((0.63 * width), (0.97 * height), (0.67 * width), (0.97 * height));
  //----------------------------- End of drawing scene ------------------------------//
}





//Drawing Doraemon method
void drawDoraemon(int xPos, int yPos, float angle, float scaleConst) {
  /**********************************
  Input parameters definition:
    xPos - x-coordinate in pixels (an integer) for translating Doraemon's position 
    yPos - y-coordinate in pixels (an integer) for translating Doraemon's position
    
    angle - angle in degrees for rotating Doraemon
    scaleConst - scaling constant for scaling Doraemon
  ***********************************/
  
  
  pushMatrix(); //prevent method from changing the original origin
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
  rotate( (TWO_PI * (angle/360)) );
  scale(scaleConst);
  //---------------------- End of Doraemon's control functions ------------------------//
  
  
  //------------------------ Drawing Doraemon -----------------------------//
  //Drawing Doraemon's blue head
  pushMatrix();
    stroke(0);
    strokeWeight(0.5);
    fill(64, 190, 255); //blue
    translate(0, -( (0.5 * bodyDiameter) + (0.25 * headDiameter) ));
    ellipse(0, 0, headDiameter, headDiameter); //outer head
  popMatrix(); //end of Doraemon's blue head
  
  
  //Drawing Doraemon's tail
  pushMatrix();
    noStroke();
    fill(0);
    quad(0, -(0.15 * bodyDiameter), (0.6 * bodyDiameter), (0.18 * bodyDiameter), (0.6 * bodyDiameter), (0.22 * bodyDiameter), 0, (0.02 * bodyDiameter));
    
    stroke(0);
    strokeWeight(1);
    fill(230, 40, 40);
    translate((0.58 * bodyDiameter), (0.2 * bodyDiameter));
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
  
  
  //Drawing Doraemon's arms
  pushMatrix();
    stroke(0);
    
    //Doraemon's left arm
    pushMatrix();
      strokeWeight(1);
      fill(64, 190, 255);
      translate((0.34 * bodyDiameter), -(0.2 * bodyDiameter));
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
      
      strokeWeight(1.5);
      fill(255);
      translate(0, (0.4 * bodyDiameter));
      ellipse(0, 0, (0.2 * bodyDiameter), (0.2 * bodyDiameter)); //Doraemon's left hand
    popMatrix();
    
    //Doraemon's right arm
    pushMatrix();
      strokeCap(SQUARE); //prevent stroke overlapping onto Doraemon's blue body
      strokeWeight(1);
      fill(64, 190, 255);
      translate(-(0.38 * bodyDiameter), -(0.2 * bodyDiameter));
      beginShape();
        curveVertex((0.1 * bodyDiameter), 0);
        curveVertex(0, 0);
        curveVertex(-(0.05 * bodyDiameter), (0.1 * bodyDiameter));
        curveVertex(-(0.05 * bodyDiameter), (0.4 * bodyDiameter));
        curveVertex(-(0.05 * bodyDiameter), (0.4 * bodyDiameter));
        vertex(0, (0.4 * bodyDiameter));
      endShape(); //leave path open to allow body overlap the arm
      
      strokeWeight(1.5);
      fill(255);
      translate(0, (0.375 * bodyDiameter));
      arc(0, 0, (0.18 * bodyDiameter), (0.18 * bodyDiameter), HALF_PI, (TWO_PI - HALF_PI)); //Doraemon's right hand
    popMatrix();
  popMatrix(); //end of Doraemon's arms and hands
  
  
  //Drawing Doraemon's feet
  pushMatrix();
    stroke(0);
    strokeWeight(1);
    fill(255);
    translate(-(0.05 * innerBodyDiameter), (0.6 * innerBodyDiameter));
    
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
    stroke(0);
    strokeWeight(1.5);
    fill(255);
    translate(-(0.05 * bodyDiameter), 0);
    ellipse(0, 0, innerBodyDiameter, innerBodyDiameter); //inner body
    
    //Drawing Doraemon's magic pouch
    strokeWeight(1);
    translate(-(0.02 * bodyDiameter), 0);
    arc(0, 0, (0.8 * innerBodyDiameter), (0.8 * innerBodyDiameter), 0, PI);
    fill(0);
    arc(0, 0, (0.8 * innerBodyDiameter), (0.1 * innerBodyDiameter), 0, PI);
  popMatrix(); //end of Doraemon's inner body and magic pouch
  
  
  //Drawing Doraemon's face
  pushMatrix();
    strokeWeight(1.5);
    fill(255);
    translate(-(0.075 * headDiameter), -( (0.5 * bodyDiameter) + (0.25 * headDiameter) ));
    ellipse(0, 0, (0.75 * headDiameter), (0.75 * headDiameter)); //face
    
    //Drawing Doraemon's eyes
    pushMatrix();
      //Drawing the right eye, pupil and highlight
      translate(-(0.16 * headDiameter), -(0.3 * headDiameter)); //location of Doraemon's right eye
      pushMatrix();
        stroke(0);
        strokeWeight(1);
        ellipse(0, 0, (0.2 * headDiameter), (0.3 * headDiameter)); //Doraemon's right eye
        
        noStroke();
        fill(0);
        translate((0.025 * headDiameter), (0.025 * headDiameter));
        ellipse(0, 0, (0.05 * headDiameter), (0.1 * headDiameter)); //Doraemon's right pupil
        
        fill(255);
        translate(0, (0.01 * headDiameter));
        ellipse(0, 0, (0.025 * headDiameter), (0.05 * headDiameter)); //Doraemon's right pupil highlight
      popMatrix();

      
      //Drawing the left eye, pupil and highlight
      translate((0.2 * headDiameter), 0); //location of Doraemon's left eye
      pushMatrix();
        stroke(0);
        ellipse(0, 0, (0.2 * headDiameter), (0.3 * headDiameter)); //Doraemon's left eye
        
        noStroke();
        fill(0);
        translate(-(0.025 * headDiameter), (0.025 * headDiameter));
        ellipse(0, 0, (0.05 * headDiameter), (0.1 * headDiameter)); //Doraemon's left pupil
        
        fill(255);
        translate(0, (0.01 * headDiameter));
        ellipse(0, 0, (0.025 * headDiameter), (0.05 * headDiameter)); //Doraemon's right pupil highlight
      popMatrix();
    popMatrix(); //end of Doraemon's face and eyes
    
    
    //Drawing Doraemon's nose
    pushMatrix();
      stroke(0);
      strokeWeight(1);
      translate(-(0.0625 * headDiameter), -(0.1 * headDiameter));
      curve((0.15 * headDiameter), -(0.15 * headDiameter), 0, (0.075 * headDiameter), 0, (0.25 * headDiameter), (0.15 * headDiameter), (0.15 * headDiameter)); //line under nose

      fill(230, 40, 40);
      ellipse(0, 0, (0.15 * headDiameter), (0.15 * headDiameter)); //nose
    popMatrix(); //end of Doraemon's nose
    
    
    //Drawing Doraemon's mouth
    pushMatrix();
      noFill();
      translate(-(0.0625 * headDiameter), (0.15 * headDiameter));
      curve(-(0.4 * headDiameter), -(0.4 * headDiameter), -(0.2 * headDiameter), 0, 0, 0, 0, -(0.3 * headDiameter));
      curve(0, -(0.3 * headDiameter), 0, 0, (0.2 * headDiameter), 0, (0.4 * headDiameter), -(0.4 * headDiameter));
    popMatrix(); //end of Doraemon's mouth
    
    
    //Drawing Doraemon's whiskers
    pushMatrix();
      translate(0, (0.1 * headDiameter));
      line(-(0.3 * headDiameter), 0, -(0.5 * headDiameter), 0);
      line((0.2 * headDiameter), 0, (0.45 * headDiameter), 0);
      
      rotate(PI/10);
      line(-(0.3 * headDiameter), 0, -(0.5 * headDiameter), 0);
      line((0.2 * headDiameter), 0, (0.45 * headDiameter), 0);
      
      rotate(-PI/5); //rotating by -PI/10 two times from PI/10 is equivalent to rotating by -PI/5 from PI/10 (i.e. PI/10 - PI/5 = -PI/10)
      line(-(0.3 * headDiameter), 0, -(0.5 * headDiameter), 0);
      line((0.2 * headDiameter), 0, (0.45 * headDiameter), 0);
    popMatrix();
  popMatrix(); //end of Doraemon's face
  

  //Drawing Doraemon's neck strap
  pushMatrix();
    noStroke();
    fill(230, 40, 40);
    translate(0, -(0.5 * innerBodyDiameter));
    rectMode(CENTER); //the next rect() function is easier to specify by the center point rather than the corner point
    rect(0, 0, (1.1 * innerBodyDiameter), (0.1 * innerBodyDiameter));
    
    stroke(0);
    strokeCap(ROUND); //smooth out the path connection between the arcs and lines
    strokeWeight(1);
    arc((0.55 * innerBodyDiameter), 0, (0.1 * innerBodyDiameter), (0.1 * innerBodyDiameter), -HALF_PI, HALF_PI);
    arc(-(0.55 * innerBodyDiameter), 0, (0.1 * innerBodyDiameter), (0.1 * innerBodyDiameter), HALF_PI, (TWO_PI - HALF_PI));
    line(-(0.55 * innerBodyDiameter), -(0.05 * innerBodyDiameter), (0.55 * innerBodyDiameter), -(0.05 * innerBodyDiameter));
    line(-(0.55 * innerBodyDiameter), (0.05 * innerBodyDiameter), (0.55 * innerBodyDiameter), (0.05 * innerBodyDiameter));
    
    //Drawing Doraemon's neck bell
    pushMatrix();
      fill(255, 229, 77);
      translate(-(0.1 * bodyDiameter), 0);
      ellipse(0, 0, (0.25 * innerBodyDiameter), (0.25 * innerBodyDiameter)); //the bell
      
      //Drawing the bell's details
      strokeWeight(1.25);
      fill(0);
      translate(-(0.01 * bodyDiameter), (0.025 * innerBodyDiameter));
      line(0, 0, 0, (0.1 * innerBodyDiameter));
      noStroke();
      ellipse(0, 0, (0.1 * innerBodyDiameter), (0.1 * innerBodyDiameter));
    popMatrix();
  popMatrix(); //end of Doraemon's neck strap and bell
  
  //--------------------------- End of drawing Doraemon ----------------------------//
  popMatrix();
}

//End of assignment 1, part 3
