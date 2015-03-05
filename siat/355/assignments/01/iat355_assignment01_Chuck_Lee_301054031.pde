final float RED_HUE = 0.0;
final float MIN_RED_SATURATION = 102.0;
final float RED_BRIGHTNESS = 255.0;
final float NAVY_BLUE_HUE = 173.5;
final float MIN_NAVY_BLUE_SATURATION = 102.0;
final float MIN_NAVY_BLUE_BRIGHTNESS = 127.0;
final float ORANGE_HUE = 32.0;
float CENTER_X;
float CENTER_Y;



void setup() {
  size(640, 480);
  colorMode(HSB);
  background(150);
  
  CENTER_X = width/2;
  CENTER_Y = height/2;
}



void draw() {
  drawStaticFacialElements();
  animateEyes();
  animateTeeth();
}



void drawStaticFacialElements() {
  drawFace(CENTER_X, CENTER_Y, 180, 240);
  drawNose(CENTER_X, CENTER_Y, 40, 100);
  drawRightEar(CENTER_X + 90, CENTER_Y, 30, 80);
  drawLeftEar(CENTER_X - 90, CENTER_Y, 30, 80);
}



// the eyes represent the passage of hours
// the eyes are closing from noon to midnight and opening from midnight to noon
// the colour of the eyes also transitions between red (between 6am - 6pm) and navy blue (between 6pm - 6am),
// where the colour saturation peaks around noon and midnight
void animateEyes() {
  color eyeColour;
  int currentHour = second();
  
  // map the hours to a sinusoidal space to give a non-linear transistion of the colour change
  float normalizedHour = abs(cos(((currentHour/24.0) * TWO_PI)));
  if ((currentHour >= 6) && (currentHour < 18)) {
    // it is day time now (6am - 6pm)
    float redSaturation = (normalizedHour * (255.0 - MIN_RED_SATURATION)) + MIN_RED_SATURATION;
    eyeColour = color(RED_HUE, redSaturation, RED_BRIGHTNESS);
  } else {
    // it is night time now (6pm - 6am)
    float navyBlueSaturation = (normalizedHour * (255.0 - MIN_NAVY_BLUE_SATURATION)) + MIN_NAVY_BLUE_SATURATION;
    float navyBlueBrightness = 255.0 - (normalizedHour * (255.0 - MIN_NAVY_BLUE_BRIGHTNESS));
    eyeColour = color(NAVY_BLUE_HUE, navyBlueSaturation, navyBlueBrightness);
  }
  
  float eyeHeight = 20.0 * ((currentHour < 12) ? (floor(currentHour/4.0) + 1)/4.0 : 1.0 - (floor((currentHour - 12)/4.0)/4.0));
  drawEyes(CENTER_X, CENTER_Y - 30, 50.0, eyeHeight, 100.0, eyeColour);
}



// the teeth represent the passage of minutes and seconds
// the growth of the teeth increments at every 2 seconds to indicate the second scale
// the colour of the teeth transistions from orange (near the start of the hour) to white (near the end of the hour), and
// it represents the minute scale
void animateTeeth() {
  int secondsCounter = floor(second()/2);
  float orangeSaturation = 255.0 * (59 - second())/59.0;
  color toothColour = color(ORANGE_HUE, orangeSaturation, 255.0);
  drawMouth(CENTER_X, CENTER_Y + 80, 80, 20, secondsCounter, toothColour);
}



void drawEyes(float x, float y, float eyeWidth, float eyeHeight, float gapBetweenEyes, color eyeColour) {
  final float noseEyeGap = gapBetweenEyes/2;
  
  strokeWeight(0.5);
  stroke(0);
  fill(eyeColour);
  pushMatrix();
    translate(x, y);
    pushMatrix();
      translate(noseEyeGap, 0);
      rect(-(eyeWidth/2), 0, eyeWidth, eyeHeight);
    popMatrix();
    
    pushMatrix();
      translate(-noseEyeGap, 0);
      rect(-(eyeWidth/2), 0, eyeWidth, eyeHeight);
    popMatrix();
  popMatrix();
}



void drawMouth(float x, float y, float mouthWidth, float mouthHeight, int teethShowingCounter, color teethColour) {
  final float HALF_WIDTH = mouthWidth/2;
  final float HALF_HEIGHT = mouthHeight/2;
  final float toothWidth = mouthWidth/7; // we want 6 teeth with half a tooth gap between the teeth and the mouth edges
  final float toothHeight = 1.2 * HALF_HEIGHT;
  
  stroke(0);
  pushMatrix();
    // drawing out the mouth
    translate(x, y);
    strokeWeight(2.0);
    fill(0);
    quad(-HALF_WIDTH, -HALF_HEIGHT, HALF_WIDTH, -HALF_HEIGHT, (5 * HALF_WIDTH/6), HALF_HEIGHT, -(5 * HALF_WIDTH/6), HALF_HEIGHT);
    
    // then draw the teeth
    translate(-(HALF_WIDTH - (0.5 * toothWidth)), -HALF_HEIGHT);
    strokeWeight(1.0);
    fill(teethColour);
    float numberOfFullTeeth = floor((teethShowingCounter/5.0));
    for (int toothIndex = 0; toothIndex < numberOfFullTeeth; toothIndex++) {
      rect((toothIndex * toothWidth), 0, toothWidth, toothHeight);
    }
    rect((numberOfFullTeeth * toothWidth), 0, toothWidth, ((teethShowingCounter % 5)/5.0) * toothHeight);
  popMatrix();
}



void drawNose(float x, float y, float noseWidth, float noseHeight) {
  final float HALF_WIDTH = noseWidth/2;
  final float HALF_HEIGHT = noseHeight/2;
  
  strokeWeight(1.5);
  stroke(0);
  fill(255);
  pushMatrix();
    translate(x, y);
    quad(-(HALF_WIDTH/4), -(HALF_HEIGHT/4), -(HALF_WIDTH/2), HALF_HEIGHT, (HALF_WIDTH/2), HALF_HEIGHT, (HALF_WIDTH/4), -(HALF_HEIGHT/4));
  popMatrix();
}



void drawRightEar(float x, float y, float earWidth, float earHeight) {
  final float HALF_HEIGHT = earHeight/2;
  
  strokeWeight(1.0);
  stroke(50);
  fill(255);
  pushMatrix();
    translate(x, y);
    quad(0, -HALF_HEIGHT, 0, HALF_HEIGHT, earWidth, (HALF_HEIGHT/4), earWidth, -(3 * HALF_HEIGHT/4));
  popMatrix();
}



void drawLeftEar(float x, float y, float earWidth, float earHeight) {
  final float HALF_HEIGHT = earHeight/2;
  
  strokeWeight(1.0);
  stroke(50);
  fill(255);
  pushMatrix();
    translate(x, y);
    quad(0, -HALF_HEIGHT, 0, HALF_HEIGHT, -earWidth, (HALF_HEIGHT/4), -earWidth, -(3 * HALF_HEIGHT/4));
  popMatrix();
}



void drawFace(float x, float y, float faceWidth, float faceHeight) {
  final float HALF_WIDTH = faceWidth/2;
  final float HALF_HEIGHT = faceHeight/2;
  
  strokeWeight(1.5);
  stroke(0);
  fill(255);
  pushMatrix();
    translate(x, y + (HALF_HEIGHT/4));
    beginShape();
      vertex(-(HALF_WIDTH/2), -HALF_HEIGHT);
      vertex(-HALF_WIDTH, -(3 * HALF_HEIGHT/4));
      vertex(-HALF_WIDTH, (HALF_HEIGHT/4));
      vertex(-(HALF_WIDTH/4), HALF_HEIGHT);
      vertex((HALF_WIDTH/4), HALF_HEIGHT);
      vertex(HALF_WIDTH, (HALF_HEIGHT/4));
      vertex(HALF_WIDTH, -(3 * HALF_HEIGHT/4));
      vertex((HALF_WIDTH/2), -HALF_HEIGHT);
    endShape(CLOSE);
  popMatrix();
}
