class MusicBall extends Ball{
  float hueValue;
  float satValue;
  float transparency;
  float angle;
  float barLocation;
  float barLength;

  MusicBall(){
    super();
    position.x = 275;
    position.y = 200;
    hueValue = 122.0;
    satValue = 232.0;
  }
    
  void updateColour(float h, float s){
    hueValue = h;
    satValue = s;
  }
  
  void update(int i, int N, float band){
    angle = (i * TWO_PI)/N;
    
    barLocation = (230.0 * i) / N;
    barLength = (band/400.0) * 120.0;
    if(barLength > 120.0){
      barLength = 120.0;
    }
    
    ballSize = (band/400.0) * 200.0;
    if(ballSize > 200.0){
      ballSize = 210.0;
    }
    
    transparency = (band/400.0) * 255.0;
  }
   
  void draw(){
    colorMode(HSB, 399, 99, 99, 255);
    
    pushMatrix();
    
      //Rings
      pushMatrix();
        translate(position.x, position.y);
        stroke(hueValue, satValue, 99, transparency);
        
        if(ballSize <= 200.0){
          fill(hueValue, (satValue - 20), 99, (transparency - 230.0));
          ellipse(0, 0, ballSize, ballSize);
        }
        
        fill(10);
        ellipse(0, -ballSize/2, ballSize/4, ballSize/4);
        ellipse(0, ballSize/2, ballSize/4, ballSize/4);
      popMatrix();
      
      //Bars
      pushMatrix();
        translate(20, (15 + barLocation - 2));
        
        stroke(222, 36, 46);
        rect(0, 0, 120, 4);
        
        fill(20, 99, 99, (3 * transparency));
        stroke(3, 36, 46);
        rect(0, 0, barLength, 4);
      popMatrix();
      
      //Balls
      pushMatrix();
        translate(80, 320);
        rotate(angle);
        translate(25, 2);
        
        fill(hueValue, satValue, 99, (2.0 * transparency));
        for(int i = 0; i < 5; i++){
          ellipse((i * 10), 0, 4, 4);
        }
      popMatrix();
    popMatrix();
  }
}
