/*****************************************************************
Assignment 1 - Shapes and Transformations
Part 2 - Drawing with Transformations

For part 2 of assignment 1, I decided to draw Doraemon (a Japanese
cartoon character that resembles a humanoid blue cat; images of 
Doraemon can be easily found on google by searching "Doraemon").

For your convenience, below is a list of shapes that I've used for
part 2 of the assignment:

- line()
- rect()
- ellipse()
- arc()
- curve()
- quad()
- custom shape using curveVertex()
- custom shape using vertex()


Version: 1.2
Last updated: Sept. 25, 2011

Written by: Chuck Lee
SFU ID No.: 301054031
Email: cll5@sfu.ca
Lab Section: D104
******************************************************************/


void setup() {
  //Initial setups
  size(768, 480);
  colorMode(RGB, 255); //set colour space to RGB
  smooth();
}


void draw() {
  //----------------------------- Some setups ----------------------------------//
  //Variable declarations: Doraemon's size parameters
  float bodyDiameter = 100.0;
  float innerBodyDiameter = (0.6 * bodyDiameter);
  float headDiameter = 120.0;
  float yOffset = (0.45 * bodyDiameter); //manual offset value to position Doraemon's neck about the origin
  
  translate(0, yOffset); //position the center of Doraemon (its neck) about the origin
  background(207, 230, 250); //redraw the background at the start of every draw loop
  //---------------------------- End of setups --------------------------------//
  
  
  //----------------------------- Doraemon's control functions ------------------------//
  //Doraemon's positioning control
  translate(width/2, height/2);
  
  //Doraemon's transformation control (formulae derived from using equation of a line)
  rotate( (float) (((HALF_PI * mouseX)/width) - QUARTER_PI) ); //linearly map the rotating angle range [-45 deg, 45 deg] to the x-coordinate range [0, width]
  scale( (float) (2 - ((1.5 * mouseY)/height)) ); //linearly map the scaling range [0.5, 2] to the y-coordinate range [0, height]
  //---------------------- End of Doraemon's control functions ------------------------//
  
  
/*
  //---------------------- Testing codes ---------------------------//
  //Create a 200x200 pixels bounding box around Doraemon for verification purposes
  stroke(255);
  strokeWeight(2);
  noFill();
  rectMode(CENTER);
  rect(0, -yOffset, 200, 200);
  rectMode(CORNER);
  //---------------------- End of testing codes --------------------//
*/
  
  
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
}

//End of assignment 1, part 2
