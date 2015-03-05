/*****************************************************************
Assignment 1 - Shapes and Transformations
Part 1 - Drawing Directly

For part 1 of assignment 1, I decided to draw a house in the
country side with UFO's on a sunny afternoon as my scene.


Version: 1.0
Last updated: Sept. 25, 2011 

Written by: Chuck Lee
SFU ID No.: 301054031
Email: cll5@sfu.ca
Lab Section: D104
******************************************************************/


void setup() {
  //Initial setups
  size(768, 480);
  smooth();

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

//End of assignment 1, part 1
