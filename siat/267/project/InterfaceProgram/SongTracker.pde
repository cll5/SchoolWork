/******************************************************
 Game song tracker:
******************************************************/

class SongTracker{
 
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  
  //-- Constants --//
  //---------------//
  private static final int VOLUME_SHIFT_INTERVAL = 4000;    //The duration (in milliseconds) to change the volume of the song when starting and ending it
  
  
  //-- Variables --//
  //---------------//
  private Minim minim;                    //Minim class; used to allow playing of sound files
  private AudioPlayer song;               //Song buffer to store the selected song
  private FFT fft;
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor to pass an instance of the sketch for
  //initializing the Minim class
  SongTracker(PApplet mainSketchInstance){
    minim = new Minim(mainSketchInstance);
    song = minim.loadFile("/data/songs/normal/01.mp3", 2048);
    fft = new FFT(song.bufferSize(), song.sampleRate());
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Load a selected song
  public void loadSong(String gameDifficulty, String songFileName){
    
    //Remove the song that is currently loaded into the song buffer
    song.close();

    //Load the new song
    String songFilePath = "/data/songs/" + gameDifficulty + "/" + songFileName;
    song = minim.loadFile(songFilePath, 2048);
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Get the FFT band based on the current frameCount
  public float getAvgBand(){
    float avgBand = 0.0;
    for(int i = 0; i < song.bufferSize(); i++){
      avgBand += fft.getBand(i);
    }
    avgBand /= song.bufferSize();
    
    return map(avgBand, 0.0, 2.0, 0.0, 100.0);
    //return fft.getBand( (frameCount % song.bufferSize()) );
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to start a preview song
  public void startPreview(){
    //Start the song's volume at -40dB (basically silent)
    song.setGain(-40.0);
    
    //Start the song and raise the volume to 0dB within the pre-defined duration, creating a fade in effect
    song.play();
    song.shiftGain(song.getGain(), 0.0, VOLUME_SHIFT_INTERVAL);
  }
  
  
  //Method to end a preview song
  public void endPreview(){
    //Lower the volume by 40dB within the pre-defined duration, creating a fade out effect
    song.shiftGain(song.getGain(), -40.0, VOLUME_SHIFT_INTERVAL);
  }
  
  
  //Method to quickly stop a preview song
  public void resetSong(){
    //Stop and reset the song
    song.pause();
    song.rewind();
  }
  
  
  //Method to play a game song
  public void playSong(){
    song.play();
  }
  
  
  //Method to check if a game song is currently playing
  public boolean isPlaying(){
    return (song.isPlaying());
  }
  
  
  //Method to calculate the forward FFT
  public void calculateFFT(){
    fft.forward(song.mix);
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
}
