import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

int NUM_BALLS = 20;
ArrayList<MusicBall> balls;

Minim minim;
AudioPlayer song;
FFT fft;

void setup(){
  size(400, 400);
  smooth();
  
  minim = new Minim(this);
  song = minim.loadFile("Gyakuten Sekai.mp3", 2048);
  song.loop();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  balls = new ArrayList<MusicBall>();
  for(int i=0; i < NUM_BALLS; i++){
    balls.add(new MusicBall());
  }

}

void draw(){
  colorMode(RGB, 255);
  background(10);
  drawBox();
  fft.forward(song.mix);

  for(int i = 0; i < balls.size(); i++){
    balls.get(i).update(i, balls.size(), fft.getBand(i));
    balls.get(i).updateColour((fft.getBand(i) / 4), sq( fft.getBand(i) ));
    balls.get(i).draw();
  }
}

void drawBox(){
  noFill();
  stroke(100);
  rect(10, 10, 140, 230); //top left box
  rect(10, (height - 150), 140, 140); //bottom left box
  rect((width - 240), 10, 230, 380); //right box
}
