/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: SongTracker
 
 Description:
 This class manipulates and stores the list of songs used for this
 application.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class SongTracker{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  private final int NUM_SONGS = 2;                      //Number of songs in the song list
  private final int BUFFER_SIZE = 8192;                 //The size of the buffer that the current song get loaded into
  private final String songDirectory = "/data/songs/";  //The path name of the songs folder
  private final String songFormat = ".mp3";             //The format of the song files
  
  //Array to store the song names of a pre-defined list of songs
  private final String [] songNames = {"Royksopp - Remind Me",
                                       "Park Hye Kyung - Lemon Tree"};
                                       
  
  //-- Variables: --//
  //----------------//
  private Minim minim;               //Minim class object
  private FFT fft;                   //FFT object for reacting with the reactive circles
  private float [] normalizedFFT;    //A normalized version of the FFT band array
  private AudioPlayer selectedSong;  //Stores the selected song; used to manipulate (i.e., play, stop) the selected song
  private int currentSong;           //Index of the songNames array for the currently selected song
  
  

  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  //
  //Input parameter:
  //  sketchInstance - Instance of the main sketch
  //
  //Output parameter:
  //  None
  SongTracker(PApplet sketchInstance){
    
    //Initialize the Minim class object
    minim = new Minim(sketchInstance);
    
    //Initialize the currentSong index as 0 by default
    currentSong = 0;
    
    //Load the default song as specified by the default currentSong index
    String selectedSongFilePath = songDirectory + songNames[currentSong] + songFormat;
    selectedSong = minim.loadFile(selectedSongFilePath, BUFFER_SIZE);

    //Initialize the FFT object and the normalized FFT band array
    fft = new FFT(selectedSong.bufferSize(), selectedSong.sampleRate());
    normalizedFFT = new float[selectedSong.bufferSize()];
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Select a song from the list of songs as the next current song
  //
  //Input parameter:
  //  index - The location of the selected song in the songNames array
  //
  //Output parameter:
  //  None
  public void selectSong(int index){
    
    //Pause the current song if it is playing
    if(selectedSong.isPlaying()){
      selectedSong.pause();
    }
    
    //Update the currentSong index and load the new song
    currentSong = index;
    resetSong();
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the name of the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  songNames[currentSong] - The name of the current song from the list of songs
  //
  public String getSongName(){
    return songNames[currentSong];
  }
  
  
  //Returns the location of the current song in the list of songs (i.e., track number)
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  currentSong - The index of the current song in the songNames array
  //
  public int getTrackNumber(){
    return currentSong;
  }
  
  
  //Returns the number of songs in the list of defined songs
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  NUM_SONGS - The total number of defined songs in the songNames array
  //
  public int getNumberOfSongs(){
    return NUM_SONGS;
  }
  
  
  //Returns the playing status of the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Returns true if the song is currently playing, else returns false
  //
  public boolean isPlaying(){
    return selectedSong.isPlaying();
  }
  
  
  //Returns a random amplitude from the normalized FFT band array of the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  normalizedFFT[randomIndex] - A random amplitude from the normalized FFT band array of the current song
  //
  public float getRandomBand(){
    int randomIndex = ((int) random(millis() + frameCount)) % selectedSong.bufferSize();  //Random index controlled by the millis() method and the frameCount variable
    return normalizedFFT[randomIndex];
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to play the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void playSong(){
    
    //Play the song
    selectedSong.play();
  }
  
  
  //Method to pause the current song when playing
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void pauseSong(){
    
    //Pause the song
    selectedSong.pause();
  }
  
  
  //Method to stop playing the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void stopSong(){
    
    //Pause and reset the song
    selectedSong.pause();
    resetSong();
  }
  
  
  //Method to loop the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void loopSong(){

    //If the song has stopped playing, then loop it by rewinding and playing it again
    if( !selectedSong.isPlaying() ){
      selectedSong.rewind();
      selectedSong.play();
    }
  }
  
  
  //Method to check if the end of the song is near
  //"Near" as within 1.5 seconds before the current song's total length is reached
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Returns true if there is less than 1.5 seconds left in the song, else returns false
  //
  public boolean isNearEndOfSong(){

    //If the current song position is within 1500 milliseconds (i.e., 1.5 seconds) before the song's length is reached, then it is considered as near the end of the song
    if( selectedSong.position() >= (selectedSong.length() - 1500) ){
      return true;
    }else{
      return false;
    }
  }
  
  
  //Method to perform a normalized forward transformation of the current song
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  public void forwardFFT(){

    //Calculate the forward FFT of the current song's mix channel
    fft.forward(selectedSong.mix);
    
    //Create a temporary array to sort the forward FFT in order to get the minimum and maximum bands
    float [] sortedFFT = new float[selectedSong.bufferSize()];
    
    //Copy the FFT band array to the temporary array
    for(int i = 0; i < selectedSong.bufferSize(); i++){
      sortedFFT[i] = fft.getBand(i);
    }
    
    //Sort the temporary array
    sortedFFT = sort(sortedFFT);
    
    //Now, normalize the FFT band array in the range: 5% to 80% of the drawing canvas width (i.e., 29.0 to 464.0)
    float minBand = sortedFFT[0];
    float maxBand = sortedFFT[(selectedSong.bufferSize() - 1)];
    for(int i = 0; i < selectedSong.bufferSize(); i++){
      normalizedFFT[i] = map(fft.getBand(i), minBand, maxBand, 29.0, 464.0);
    }
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method to reset the current song without any unwanted noise after pausing the song
  //Playing the song after pausing and rewinding tends to unflush the AudioPlayer buffer
  //This method is to ensure that the AudioPlayer buffer gets flushed when a song reset operation is desired
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  None
  private void resetSong(){

    //Close the current song
    selectedSong.close();
    
    //Load the current song
    String selectedSongFilePath = songDirectory + songNames[currentSong] + songFormat;
    selectedSong = minim.loadFile(selectedSongFilePath, BUFFER_SIZE);
  }
}
