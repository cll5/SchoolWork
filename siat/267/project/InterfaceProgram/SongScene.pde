/******************************************************
 Song selection scene:
******************************************************/

class SongScene extends Scene{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  
  //-- Constants --//
  //---------------//
  private static final int PREVIEW_DURATION = 15000 - SongTracker.VOLUME_SHIFT_INTERVAL;                 //The duration (in milliseconds) of a song preview
  private final String [][] SONG_NAME = {{"If I Were a Boy", "Oxford Comma", "Not Like the Movies"},     //Array to store the song names
                                         {"Love Forever", "Caramelo", "The One that Got Away"},
                                         {"Afrodeziak", "Hello", "Itsumo no Nakama to"}};
                                   
  
  //-- Variables --//
  //---------------//
  private Button prev, confirm;                                                //ControlP5 button variables for going to the previous scene or to confirm the game settings
  private Button prevSong, nextSong, playSong;                                 //ControlP5 button variables for choosing the previous or the next song, and to try the song
  
  private ControllerSprite prevSprite, confirmSprite;                          //ControlP5 sprite variables for custom scene button designs
  private ControllerSprite prevSongSprite, nextSongSprite, playSongSprite;     //ControlP5 sprite variables for custom song button designs
  
  private PImage prevButtonMask, confirmButtonMask;                            //Image buffers for the custom scene button sprites' masks   
  private PImage prevSongButtonMask, nextSongButtonMask, playSongButtonMask;   //Image buffers for the custom song button sprites' masks
  
  private boolean isPlaying;                 //Flag to indicate that the preview song is currently playing
  private int difficultyIndex, songIndex;    //Indices of SONG_NAME
  private int previewExpirationTime;         //Calculated time to stop previewing a song
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor to pass the background image name and
  //font file name as arguments
  SongScene(PApplet mainSketchInstance, String imageName, String fontFileName, DifficultyTracker difficultyLevelTracker){
    
    //Call the parent class's constructor
    super(imageName, fontFileName);
    
    //Initialize the GUI controls for the scene
    initializeGUI();
    
    //Initialize the preview song flag
    isPlaying = false;
    
    //Initialize SONG_NAME indices
    difficultyIndex = 1;
    songIndex = 0;
    
    //Initialize song variables
    previewExpirationTime = 0;
  }


  
  //-- Setters: --//
  //--------------//
  
  //-- Getters: --//
  //--------------//
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method for adding the GUI controls for the scene
  public void setupGUI(){
    
    //Create the buttons for selecting the previous or next scenes
    //Create a button to go to the previous scene and attach it with its custom button sprite
    //Also, set the button ID to be 4 (as in game scene #4)
    prev = sceneGUI.addButton("goBack", 0, (int) ((0.15 * width) - (0.5 * prevButtonMask.width)), (int) (height - (1.25 * prevButtonMask.height)), prevButtonMask.width, prevButtonMask.height);
    prev.setSprite(prevSprite);
    prev.setId(4);
    
    //Create a button to go to the next scene and attach it with its custom button sprite
    //Also, set the button ID to be 4 (as in game scene #4)
    confirm = sceneGUI.addButton("playGame", 0, (int) ((0.8 * width) - (0.5 * confirmButtonMask.width)), (int) (height - (1.25 * prevButtonMask.height)), confirmButtonMask.width, confirmButtonMask.height);
    confirm.setSprite(confirmSprite);
    confirm.setId(4);
    
    
    //Create the buttons for selecting the song
    //Create a button to select the previous song from the song list and attach it with its custom button sprite
    prevSong = sceneGUI.addButton("lastSong", 0, (int) ((0.2 * width) - (0.5 * prevSongButtonMask.width)), (int) (0.5 * (height - prevSongButtonMask.height)), prevSongButtonMask.width, prevSongButtonMask.height);
    prevSong.setSprite(prevSongSprite);
    
    //Create a button to select the next song from the song list and attach it with its custom button sprite
    nextSong = sceneGUI.addButton("nextSong", 0, (int) ((0.8 * width) - (0.5 * nextSongButtonMask.width)), (int) (0.5 * (height - nextSongButtonMask.height)), nextSongButtonMask.width, nextSongButtonMask.height);
    nextSong.setSprite(nextSongSprite);
    
    //Create a button to play the current song from the song list and attach it with its custom button sprite
    playSong = sceneGUI.addButton("playSong", 0, (int) ((0.5 * width) - (0.5 * playSongButtonMask.width)), (int) ((0.5 * height) + (2.5 * playSongButtonMask.height)), playSongButtonMask.width, playSongButtonMask.height);
    playSong.setSprite(playSongSprite);
  }
  
  
  //Method for removing all the GUI controls in the scene
  public void removeGUI(){
    sceneGUI.remove("goBack");    //Remove the go to previous scene button sprite
    sceneGUI.remove("playGame");  //Remove the confirm game setting button sprite
    sceneGUI.remove("lastSong");  //Remove the choose previous song button sprite
    sceneGUI.remove("nextSong");  //Remove the choose next song button sprite
    sceneGUI.remove("playSong");  //Remove the play current song button sprite
    sceneGUI.update();
  }
  
  
  //Method to display the scene's contents
  public void showContent(){
    
    //Load the scene's background image from the parent class
    super.showBackground();
    
    //Set the scene title's font to be size 70 pixels, 100% black, and center aligned
    fill(128, 255);
    textAlign(CENTER);
    super.setFont("CenturyGothic-70.vlw");
    textFont(super.getFont(), 70);
    
    //Display the scene title
    text("Song Selection", (width/2), (height/5));
    
    //Set the scene font to be size 25 pixels and right aligned
    textAlign(RIGHT);
    super.setFont("CenturyGothic-25.vlw");
    textFont(super.getFont(), 25);
    
    //Prompt the first player to get ready
    String getReady = "Are you ready, player 1?";
    text(getReady, (int) ((0.8 * width) + (0.5 * confirmButtonMask.width)), (int) (height - (1.75 * confirmButtonMask.height)));
  }
  
  
  //Method to update the display panel
  public void updateDisplayPanel(){
    drawDisplayPanel();
  }
  
  
  //Method to define the song sets based on the
  //game difficulty chosen in the difficulty scene
  public void loadSong(DifficultyTracker gameDifficulty, int songNumber, SongTracker song){
    
    //Update the SONG_NAME indices
    difficultyIndex = gameDifficulty.getDifficulty();
    songIndex = songNumber;
    
    //Find out the game difficulty, then load the song
    String songNum = nf((songNumber + 1), 2) + ".mp3";
    
    switch(difficultyIndex){
      case(0):
        //Difficulty level is easy
        song.loadSong("easy", songNum);
        break;
        
      case(1):
        //Difficulty level is normal
        song.loadSong("normal", songNum);
        break;
        
      case(2):
        //Difficulty level is hard
        song.loadSong("hard", songNum);
        break;
    }
  }
  
  
  //Method to preview the selected song
  public void playPreview(SongTracker song){
    
    //Set the song preview flag to true
    isPlaying = true;
    song.startPreview();
    
    //Calculate the previewExpirationTime
    previewExpirationTime = millis() + PREVIEW_DURATION;
  }
  
  
  //Method to gradually stop the preview song
  public void slowStopPreview(SongTracker song){
    song.endPreview();
  }
  
  
  //Method to suddenly stop the preview song
  public void quickStopPreview(SongTracker song){
    
    isPlaying = false;
    song.resetSong();
  }
  
  
  //Method to check if the preview duration is over
  public boolean isDonePreview(){
    if(isPlaying && (millis() > previewExpirationTime)){
      //The preview duration has ended
      isPlaying = false;
      return true;
    
    }else{
      //Still previewing the song
      return false;
    }
  }
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  
  //Helper method for initializing the GUI controls for the scene
  void initializeGUI(){
    
    //Local variables declaration
    PImage prevButtonImage, confirmButtonImage;                           //Image buffers for the custom scene button sprites
    PImage prevSongButtonImage, nextSongButtonImage, playSongButtonImage; //Image buffers for the custom song button sprites
    
    
    //Get the custom button sprites and masks for the scene
    prevButtonImage = loadImage("/data/sprites/other/backSprite.png");
    confirmButtonImage = loadImage("/data/sprites/other/confirmSprite.png");
    prevSongButtonImage = loadImage("/data/sprites/songScene/prevSongSprite.png");
    nextSongButtonImage = loadImage("/data/sprites/songScene/nextSongSprite.png");
    playSongButtonImage = loadImage("/data/sprites/songScene/playSongSprite.png");
    
    prevButtonMask = loadImage("/data/sprites/other/backMask.png");
    confirmButtonMask = loadImage("/data/sprites/other/confirmMask.png");
    prevSongButtonMask = loadImage("/data/sprites/songScene/prevSongMask.png");
    nextSongButtonMask = loadImage("/data/sprites/songScene/nextSongMask.png");
    playSongButtonMask = loadImage("/data/sprites/songScene/playSongMask.png");
    
    //Initialize the custom buttons for the scene
    prevSprite = new ControllerSprite(sceneGUI, prevButtonImage, prevButtonMask.width, prevButtonMask.height);
    confirmSprite = new ControllerSprite(sceneGUI, confirmButtonImage, confirmButtonMask.width, confirmButtonMask.height);
    prevSongSprite = new ControllerSprite(sceneGUI, prevSongButtonImage, prevSongButtonMask.width, prevSongButtonMask.height);
    nextSongSprite = new ControllerSprite(sceneGUI, nextSongButtonImage, nextSongButtonMask.width, nextSongButtonMask.height);
    playSongSprite = new ControllerSprite(sceneGUI, playSongButtonImage, playSongButtonMask.width, playSongButtonMask.height);
    
    //Setup and enable the go to previous scene button mask
    prevSprite.setMask(prevButtonMask);
    prevSprite.enableMask();
    
    //Setup and enable the go to next scene button mask
    confirmSprite.setMask(confirmButtonMask);
    confirmSprite.enableMask();
    
    //Setup and enable the choose previous song button mask
    prevSongSprite.setMask(prevSongButtonMask);
    prevSongSprite.enableMask();
    
    //Setup and enable the choose next song button mask
    nextSongSprite.setMask(nextSongButtonMask);
    nextSongSprite.enableMask();
    
    //Setup and enable the play the song button mask
    playSongSprite.setMask(playSongButtonMask);
    playSongSprite.enableMask();
  }
  
  
  //Helper method to draw the panel to display the preview song's name
  private void drawDisplayPanel(){
    
    //Local variables declaration for reducing computations; used for performance purposes
    int panelWidth = 500;
    int panelHeight = 100;
    int pW10px = panelWidth - 10;
    int pH10px = panelHeight - 10;
    
    pushMatrix();
      translate((width - panelWidth)/2, (height - panelHeight)/2);
      
      //Draw the display panel
      noStroke();
      fill(0);
      beginShape();
        vertex(0, 10);
        vertex(10, 0);
        vertex(pW10px, 0);
        vertex(panelWidth, 10);
        vertex(panelWidth, pH10px);
        vertex(pW10px, panelHeight);
        vertex(10, panelHeight);
        vertex(0, pH10px);
      endShape(CLOSE);
      
      //Draw the rounded corner of the display panel
      strokeWeight(4);
      stroke(255);
      arc(10, 10, 20, 20, -PI, -HALF_PI);
      arc(pW10px, 10, 20, 20, -HALF_PI, 0);
      arc(pW10px, pH10px, 20, 20, 0, HALF_PI);
      arc(10, pH10px, 20, 20, HALF_PI, PI);
      
      //Draw the outline of the display panel
      line(0, 10, 0, pH10px);
      line(panelWidth, 10, panelWidth, pH10px);
      line(10, 0, pW10px, 0);
      line(10, panelHeight, pW10px, panelHeight);
      
      //Update the name of the song
      fill(255);
      textAlign(CENTER);
      textFont(super.getFont(), 30);
      text(SONG_NAME[difficultyIndex][songIndex], (panelWidth/2), ((panelHeight/2) + 10));
    popMatrix();
  }
}
