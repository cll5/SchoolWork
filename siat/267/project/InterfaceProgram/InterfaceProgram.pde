/**********************************************************
 IAT 267 - Introduction to Technological Systems
 Project Name: BOOM BOOM BOOM!
 
 D103, Team 16:
 Pearl Cao (301109013, caoyuec@sfu.ca)
 Susan Huang (301097372, ysh3@sfu.ca)
 Chuck Lee (301054031, cll5@sfu.ca)
 Alex Salaveria (301132524, asalaver@sfu.ca)
 
 
 File description: This file contains the main codes of our
 project.
 
 
 Version: 1.0
 Created on: Oct.29, 2011
 Last Updated: Dec.02, 2011
***********************************************************/
 
//-- Import Libraries ------------------------------------------//
//--------------------------------------------------------------//
import processing.serial.*;
import controlP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;



//-- Global Constants/Variables --------------------------------//
//--------------------------------------------------------------//

//Global Constants
final int NUM_PLAYER = 2;           //Maximum number of players for this game

//Indices for the four drum colours
final int GREEN_DRUM = 0;
final int RED_DRUM = 1;
final int BLUE_DRUM = 2;
final int YELLOW_DRUM = 3;



//Global Variables
Serial arduinoPort;                 //Serial port for communicating with Arduino

ControlP5 sceneGUI;                 //ControlP5 variable for creating the GUI of the game scene

MenuScene scene1;                   //An object to hold the game's menu scene
InstructionScene scene2;            //An object to hold the game's instruction scene
DifficultyScene scene3;             //An object to hold the game's difficulty level setting scene 
SongScene scene4;                   //An object to hold the game's song selection scene
GameScene [] scene5;                //Array to hold the scene where the player(s) play the game
ScoreScene [] scene6;               //Array to hold the scene where the player(s) see he/she/their game results
FinalScoreScene scene7;             //An object to hold the final score result scene in two player mode

ScoreTracker [] playerScore;        //Array to keep track of player one's and two's score points
DifficultyTracker gameDifficulty;   //Keeps track of the difficulty level of the game
SongTracker gameSong;               //Stores the player selected song

boolean [] sceneFlag;               //Keeps track of which scene the game is currently on
boolean [] animateScore;            //Keeps track of which of the four falling block columns to animate the scoring animation
boolean [] drumHit;                 //Flag to indicate if a drum is hit or not for triggering the drum hitting animation
boolean singlePlayerMode;           //Flag to see if the player has chosen single player game mode (flag set to true) or two player game mode (flag set to false)

int [] animationState;
int [] drumAnimationExpirationTime;
int player;                         //Index to keep track if the current player is player one or player two
int songNumber;                     //To store the song number in the song list
int addBlockExpirationTime;         //Waiting duration between adding new falling blocks

char prevDifficultyState;           //Keeps track of the previous game difficulty selection; used to detect changes in the
                                    //game difficulty selection to reduce the amount of background refreshing for performance purposes




//-- Setup and Draw Methods ------------------------------------//
//--------------------------------------------------------------//

//Setup and Global Variables Initialization
void setup(){
  
  //-- Sketch setups --//
  //-------------------//
  size(900, 680);
  smooth();
  strokeCap(SQUARE);
  
  
  
  //-- Initialize all non-scene arrays --//
  //-------------------------------------//
  sceneFlag = new boolean[7];
  drumHit = new boolean[4];
  animateScore = new boolean[4];
  animationState = new int[4];
  drumAnimationExpirationTime = new int[4];
  
  for(int i = 0; i < 7; i++){
    sceneFlag[i] = false;
  }
  
  sceneFlag[0] = true;
  
  for(int i = 0; i < 4; i++){
    drumHit[i] = false;
    animateScore[i] = false;
    animationState[i] = 0;
    drumAnimationExpirationTime[i] = 0;
  }
  
  
  
  //-- Initialize serial communication settings --//
  //----------------------------------------------//
  int usbPort = 1;      //USB COM Port from the "Serial Port" list shown in Arduino
  arduinoPort = new Serial(this, Serial.list()[usbPort], 9600);
  
  //Tell Arduino to stop detecting from any of its sensors, initially
  arduinoPort.write('N');
  
  
  
  
  //-- Initialize the GUI, scenes and tracker objects --//
  //----------------------------------------------------//
  
  //Initialize the game scenes' GUI
  sceneGUI = new ControlP5(this);
  
  //Initialize the tracker objects
  gameDifficulty = new DifficultyTracker();
  gameSong = new SongTracker(this);
  playerScore = new ScoreTracker[NUM_PLAYER];
  
  //Initialize the scenes
  scene1 = new MenuScene(this, "TitlePage.jpg", "CenturyGothic-70.vlw");
  scene2 = new InstructionScene("GameSettingPage.jpg", "CenturyGothic-70.vlw");
  scene3 = new DifficultyScene("GameSettingPage.jpg", "CenturyGothic-70.vlw");
  scene4 = new SongScene(this, "GameSettingPage.jpg", "CenturyGothic-70.vlw", gameDifficulty);
  scene5 = new GameScene[NUM_PLAYER];   //Initialize scene5's array
  scene6 = new ScoreScene[NUM_PLAYER];  //Initialize scene6's array
  scene7 = new FinalScoreScene("ScorePage.jpg", "CenturyGothic-70.vlw");
  
  //Initialize scene5, scene6, and the players' score trackers
  for(int index = 0; index < NUM_PLAYER; index++){
    playerScore[index] = new ScoreTracker();
    scene5[index] = new GameScene(this, "NormalLevel.jpg", "CenturyGothic-20.vlw");
    scene6[index] = new ScoreScene("ScorePage.jpg", "CenturyGothic-70.vlw");
  }
  
  
  
  
  //-- Initialize other game settings --//
  //------------------------------------//
  singlePlayerMode = true;           //Initialize the game mode as single player by default
  addBlockExpirationTime = 0;        //Initialize the waiting duration of inserting a new falling block
  songNumber = 0;                    //Initialize the song number as song number 1
  prevDifficultyState = 'N';         //Initialize the previous game difficulty selection as normal by default
  gameDifficulty.setDifficulty(1);   //Initialize the game difficulty to be normal by default

  
  
  //-- Start the game on the menu scene --//
  //--------------------------------------//
  scene1.setupGUI();                 //Setup the GUI controls for the menu scene
  scene1.showContent();              //Display the contents of the menu scene
}





//Draw Method
void draw(){
  
  //---- Difficulty Selection Scene ----//
  //------------------------------------//
  
  //Check if the difficulty scene is the current scene
  if(sceneFlag[2]){
    
    //Check if Arduino has sent anything through the port
    if(arduinoPort.available() > 0){

      //Read from the port until an '*' symbol is detected to indicate the end of the string
      String incomingMessage = arduinoPort.readStringUntil('*');
      
      //If the incoming message is not empty, then decode the message that Arduino had sent
      if(incomingMessage != null){
        //Split the incoming message into substrings containing only the encoded level of difficulty
        String [] splitMessage = splitTokens(incomingMessage, "*");
        String [] sliderSensor = splitTokens(splitMessage[0], "s");
        
        //Ignore the received message if it contains error and go to the next draw loop
        if(sliderSensor.length != 3){
          return;
        }

        //Only update the game difficulty and scene if theres a change from the slider sensor
        char currDifficultyState = sliderSensor[1].charAt(0);
        
        if(currDifficultyState != prevDifficultyState){
          
          if(currDifficultyState == 'E'){
            //Easy level is decoded
            gameDifficulty.setDifficulty(0);
                      
          }else if(currDifficultyState == 'N'){
            //Normal level is decoded
            gameDifficulty.setDifficulty(1);
  
          }else if(currDifficultyState == 'H'){
            //Hard level is decoded
            gameDifficulty.setDifficulty(2);
          }
          
          //Update the previous game difficulty selection tracking variable
          prevDifficultyState = currDifficultyState;
          
          //Redraw the scene's background
          scene3.showContent();
          
          //Draw the difficulty selector
          scene3.animateSelector(gameDifficulty.getDifficulty());
        }
      }
    }
  }
  
  
  
  //Check if the song selection scene is the current scene
  if(sceneFlag[3]){
    
    //Fade out the song as the preview duration is about to end
    if(scene4.isDonePreview()){
      scene4.slowStopPreview(gameSong);
    }
  }
  
  
  
  //---- Game Scene ----//
  //--------------------//
  
  //Check if the game scene is the current scene
  if(sceneFlag[4]){
    
    //If the game song is still playing, continue the game
    //The game ends when the song stop
    if(gameSong.isPlaying()){
    
      //-- Receive and decode the message sent from Arduino --//
      //------------------------------------------------------//
      
      //Check if Arduino has sent anything through the port
      if(arduinoPort.available() > 0){
  
        //Read from the port until an '*' symbol is detected to indicate the end of the string
        String incomingMessage = arduinoPort.readStringUntil('*');
        
        //If the incoming message is not empty, then decode the message that Arduino had sent
        if(incomingMessage != null){
          //String incomingMessage = new String(inBuffer);
          
          //Split the incoming message into substrings containing only the encoded level of difficulty
          String [] splitMessage = splitTokens(incomingMessage, "*");
          String [] touchSensor = splitTokens(splitMessage[0], "d");
  
          if(touchSensor.length != 3){
            return;
          }
  
          int drumAnimationInterval = 200;
          
          //Check if the green drum is hit
          if(touchSensor[1].charAt(0) == 'G'){
            
            //Green drum is hit
            drumHit[GREEN_DRUM] = true;
            drumAnimationExpirationTime[GREEN_DRUM] = millis() + drumAnimationInterval;
            
            //Check if the player has scored a point
            if(scene5[player].checkScore(GREEN_DRUM, playerScore[player])){
              //Player scored a point with a green block
              animateScore[GREEN_DRUM] = true;
            }
          }
          
          //Check if the red drum is hit
          if(touchSensor[1].charAt(0) == 'R'){
            
            //Red drum is hit
            drumHit[RED_DRUM] = true;
            drumAnimationExpirationTime[RED_DRUM] = millis() + drumAnimationInterval;
            
            //Check if the player has scored a point
            if(scene5[player].checkScore(RED_DRUM, playerScore[player])){
              //Player scored a point with a red block
              animateScore[RED_DRUM] = true;
            }
          }
  
          //Check if the blue drum is hit
          if(touchSensor[1].charAt(0) == 'B'){
            
            //Blue drum is hit
            drumHit[BLUE_DRUM] = true;
            drumAnimationExpirationTime[BLUE_DRUM] = millis() + drumAnimationInterval;
            
            //Check if the player has scored a point
            if(scene5[player].checkScore(BLUE_DRUM, playerScore[player])){
              //Player scored a point with a blue block
              animateScore[BLUE_DRUM] = true;
            }
          }
          
          //Check if the yellow drum is hit
          if(touchSensor[1].charAt(0) == 'Y'){
            
            //Yellow drum is hit
            drumHit[YELLOW_DRUM] = true;
            drumAnimationExpirationTime[YELLOW_DRUM] = millis() + drumAnimationInterval;
            
            //Check if the player has scored a point
            if(scene5[player].checkScore(YELLOW_DRUM, playerScore[player])){
              //Player scored a point with a yellow block
              animateScore[YELLOW_DRUM] = true;
            }
          }
        }
      }
      
      
      
      //-- Update the falling block queues and animation --//
      //---------------------------------------------------//
      
      if(millis() > addBlockExpirationTime){
        
        //Calculate a threshold to determine what colour blocks will be added in the current round
        gameSong.calculateFFT();
        float level = gameSong.getAvgBand();
        
        //Add a falling block to the green drum column
        if( ((level > 7.1) && (level < random(50.1, 101.4))) || ((level > random(201.0, 250.0)) && (level < 233.3)) ){
          scene5[player].addBlock(GREEN_DRUM);
        }
        
        //Add a falling block to the red drum column
        if( ((level > 22.5) && (level < random(35.6, 99.7))) || ((level > random(176.0, 211.0)) && (level < 233.3)) ){
          scene5[player].addBlock(RED_DRUM);
        }
        
        //Add a falling block to the blue drum column
        if( ((level > random(73.4, 99.3)) && (level < 109.6)) || ((level > 179.9) && (level < random(201.2, 231.9))) ){
          scene5[player].addBlock(BLUE_DRUM);
        }
        
        //Add a falling block to the yellow drum column
        if( ((level > random(86.1, 113.6)) && (level < 113.7)) || ((level > 119.1) && (level < random(205.1, 233.3))) ){
          scene5[player].addBlock(YELLOW_DRUM);
        }
        
        //Update the next expiration time for adding falling blocks
        addBlockExpirationTime = millis() + (1500 - (int) pow((gameDifficulty.getDifficulty() + 9), (gameDifficulty.getDifficulty() + 1)));
      }
      
      //Refresh the background of the gaming scene
      scene5[player].showContent(playerScore[player]);
  
      
      
      //--- Animation sequences ---//
      //---------------------------//
      
      //-- Animation for hitting a drum --//
      //----------------------------------//
      
      //Check if the green drum hit animation duration is expired or not
      //If not expired, continue the animation
      if(drumHit[GREEN_DRUM] == true){
        if(millis() > drumAnimationExpirationTime[GREEN_DRUM]){
          drumHit[GREEN_DRUM] = false;
        }else{
          scene5[player].drumHitAnimation(GREEN_DRUM);
        }
      }
      
      
      //Check if the red drum hit animation duration is expired or not
      //If not expired, continue the animation
      if(drumHit[RED_DRUM] == true){
        if(millis() > drumAnimationExpirationTime[RED_DRUM]){
          drumHit[RED_DRUM] = false;
        }else{
          scene5[player].drumHitAnimation(RED_DRUM);
        }
      }
      
      
      //Check if the blue drum hit animation duration is expired or not
      //If not expired, continue the animation
      if(drumHit[BLUE_DRUM] == true){
        if(millis() > drumAnimationExpirationTime[BLUE_DRUM]){
          drumHit[BLUE_DRUM] = false;
        }else{
          scene5[player].drumHitAnimation(BLUE_DRUM);
        }
      }
      
      
      //Check if the yellow drum hit animation duration is expired or not
      //If not expired, continue the animation
      if(drumHit[YELLOW_DRUM] == true){
        if(millis() > drumAnimationExpirationTime[YELLOW_DRUM]){
          drumHit[YELLOW_DRUM] = false;
        }else{
          scene5[player].drumHitAnimation(YELLOW_DRUM);
        }
      }
      
      
      
      //-- Animation for scoring a point --//
      //-----------------------------------//
      
      //Check if the score animation is currently in effect for the green drum
      if(animateScore[GREEN_DRUM] == true){
        
        //Display the current animation state
        scene5[player].scoreAnimation(GREEN_DRUM, animationState[GREEN_DRUM]);
        
        //Set the score animation flag to false to indicate the animation is completed
        if(animationState[GREEN_DRUM] == 4){
          animateScore[GREEN_DRUM] = false;
        }
        
        //Update the next animation state
        animationState[GREEN_DRUM] = (animationState[GREEN_DRUM] + 1) % 5;
      }
      
      
      //Check if the score animation is currently in effect for the red drum
      if(animateScore[RED_DRUM] == true){
        
        //Display the current animation state
        scene5[player].scoreAnimation(RED_DRUM, animationState[RED_DRUM]);
        
        //Set the score animation flag to false to indicate the animation is completed
        if(animationState[RED_DRUM] == 4){
          animateScore[RED_DRUM] = false;
        }
        
        //Update the next animation state
        animationState[RED_DRUM] = (animationState[RED_DRUM] + 1) % 5;
      }
      
      
      //Check if the score animation is currently in effect for the blue drum
      if(animateScore[BLUE_DRUM] == true){
        
        //Display the current animation state
        scene5[player].scoreAnimation(BLUE_DRUM, animationState[BLUE_DRUM]);
        
        //Set the score animation flag to false to indicate the animation is completed
        if(animationState[BLUE_DRUM] == 4){
          animateScore[BLUE_DRUM] = false;
        }
        
        //Update the next animation state
        animationState[BLUE_DRUM] = (animationState[BLUE_DRUM] + 1) % 5;
      }
      
      
      //Check if the score animation is currently in effect for the yellow drum
      if(animateScore[YELLOW_DRUM] == true){
        
        //Display the current animation state
        scene5[player].scoreAnimation(YELLOW_DRUM, animationState[YELLOW_DRUM]);
        
        //Set the score animation flag to false to indicate the animation is completed
        if(animationState[YELLOW_DRUM] == 4){
          animateScore[YELLOW_DRUM] = false;
        }
        
        //Update the next animation state
        animationState[YELLOW_DRUM] = (animationState[YELLOW_DRUM] + 1) % 5;
      }
    
    }else{
      
      //---- Setup for the score scenes ----//
      //------------------------------------//
      
      //Tell Arduino to stop detecting from any of its sensors
      arduinoPort.write('N');
      
      //The game song has stopped playing, and so go to the next scene (score scene for player one)
      //Update the scene flag
      sceneFlag[4] = false;
      
      //Setup the GUI and display the contents for the next scene
      if(!singlePlayerMode){
        
        //For two player mode:
        //Continue updating the scene flag
        sceneFlag[5] = true;
        
        if(player == 0){
          
          //After player one has just finished playing the game
          scene4.removeGUI();                            //Remove the song selection scene's GUI
        
        }else if(player == 1){
          
          //After player two has just finished playing the game
          scene6[(player-1)].removeGUI((player-1));      //Remove player one's score scene's GUI
        }
        
        scene6[player].setupGUI(player);                                    //Setup the GUI for player one's score scene
        scene6[player].showContent(player, playerScore[player]);            //Display the contents of the score scene
        
        //Show and set the GUI active after playing the game scene and setting up the next scene
        scene5[player].showGUI();
      
      }else{
        
        //For single player mode:
        //Continue updating the scene flag
        sceneFlag[6] = true;
        
        scene4.removeGUI();                       //Remove the song selection scene's GUI since the scene before the game scene was the song selection scene
        scene7.setupGUI();                        //Setup the GUI for player's score scene
        scene7.showContent(playerScore[player]);  //Display the contents of the score scene
        
        //Show and set the GUI active after playing the game scene
        scene5[player].showGUI();
      }
    }
  }
}



//-- Other Methods ---------------------------------------------//
//--------------------------------------------------------------//
//  None



//-- Event Handlers --------------------------------------------//
//--------------------------------------------------------------//

//Method to handle controlP5 events
void controlEvent(ControlEvent theEvent){
  if(theEvent.isController()){
    
    //An event has occured at the menu scene:
    //Either single player or two player mode has been selected
    if((theEvent.controller().name() == "singlePlayer") || (theEvent.controller().name() == "twoPlayer")){
      
      //Tell Arduino to stop detecting from any of its sensors
      arduinoPort.write('N');
      
      //Check which game mode the player has chosen
      if(theEvent.controller().name() == "singlePlayer"){
        
        //Single player mode has been selected
        singlePlayerMode = true;
      }
      else{ //Otherwise, (theEvent.controller().name() == "twoPlayer") is true
        
        //Two player mode has been selected
        singlePlayerMode = false;
      }
      
      //Player one is the first player to play
      player = 0;
      
      //Jump to the instruction scene
      scene1.removeGUI();   //Remove the GUI for the menu scene
      scene2.setupGUI();    //Setup the GUI for the instruction scene
      scene2.showContent(); //Display the contents of the instruction scene
    }
    
    
    //The player wants to go to the next scene
    //The NEXT button has been selected
    if(theEvent.controller().name() == "goNext"){
      
      //Check which is the current scene by comparing the button's ID
      switch(theEvent.controller().id()){
        
        case(2): //Current scene is the instruction scene
          
          //Tell Arduino to start detecting from its slider sensor
          arduinoPort.write('S');
          
          //Jump to the difficulty selection scene
          scene2.removeGUI();                                      //Remove the GUI for the instruction scene
          scene3.setupGUI();                                       //Setup the GUI for the difficulty selection scene
          scene3.showContent();                                    //Display the contents of the difficulty selection scene
          scene3.animateSelector(gameDifficulty.getDifficulty());  //Draw the difficulty selector
          
          //Update the scene flag
          sceneFlag[1] = false;
          sceneFlag[2] = true;
          break;
          
        case(3): //Current scene is the difficulty selection scene
          
          //Tell Arduino to stop detecting from any of its sensors
          arduinoPort.write('N');
          
          //Jump to the song selection scene
          scene3.removeGUI();                                     //Remove the GUI for the difficulty selection scene
          scene4.setupGUI();                                      //Setup the GUI for the song selection scene
          scene4.showContent();                                   //Display the contents of the song selection scene
          songNumber = 0;                                         //Set the default song as "01.mp3"
          scene4.loadSong(gameDifficulty, songNumber, gameSong);  //Load the default song into the scene for the selected game difficulty
          scene4.updateDisplayPanel();                            //Display the song display panel
          
          //Update the scene flag
          sceneFlag[2] = false;
          sceneFlag[3] = true;
          break;
          
        case(6):  //Current scene is player two's score scene
        
          //Tell Arduino to stop detecting from any of its sensors
          arduinoPort.write('N');
          
          //Jump to the final score scene
          scene6[player].removeGUI(player);                                   //Remove the GUI for player two's score scene
          scene7.setupGUI();                                                  //Setup the GUI for player's score scene
          scene7.showContent(playerScore[(player-1)], playerScore[player]);   //Display the contents of the score scene
          
          //Update the scene flag
          sceneFlag[5] = false;
          sceneFlag[6] = true;
          break;
      }
    }
    
    
    //The player wants to go back to the previous scene
    //The BACK button has been selected
    if(theEvent.controller().name() == "goBack"){
      
      //Check which is the current scene by comparing the button's ID
      switch(theEvent.controller().id()){
        
        case(2): //Current scene is the instruction scene
          
          //Tell Arduino to stop detecting from any of its sensors
          arduinoPort.write('N');
          
          //Jump to the menu scene
          scene2.removeGUI();   //Remove the GUI for the instruction scene
          scene1.setupGUI();    //Setup the GUI for the menu scene
          scene1.showContent(); //Display the contents of the menu scene
          
          //Update the scene flag
          sceneFlag[1] = false;
          sceneFlag[0] = true;
          break;
          
        case(3): //Current scene is the difficulty selection scene
          
          //Tell Arduino to stop detecting from any of its sensors
          arduinoPort.write('N');
          
          //Jump to the instruction scene
          scene3.removeGUI();   //Remove the GUI for the difficulty selection scene
          scene2.setupGUI();    //Setup the GUI for the instruction scene
          scene2.showContent(); //Display the contents of the instruction scene
          
          //Update the scene flag
          sceneFlag[2] = false;
          sceneFlag[1] = true;
          break;
          
        case(4): //Current scene is the song selection scene
        
          //Tell Arduino to start detecting from its slider sensor
          arduinoPort.write('S');
          
          //Stop the song if it is playing
          if(!scene4.isDonePreview()){
            scene4.quickStopPreview(gameSong);
          }
          
          //Jump to the difficulty selection scene
          scene4.removeGUI();                                      //Remove the GUI for the song selection scene
          scene3.setupGUI();                                       //Setup the GUI for the difficulty selection scene
          scene3.showContent();                                    //Display the contents of the difficulty selection scene
          scene3.animateSelector(gameDifficulty.getDifficulty());  //Draw the difficulty selector
          
          //Update the scene flag
          sceneFlag[3] = false;
          sceneFlag[2] = true;
          break;
      }
    }
    
    
    //The current scene is the song selection scene
    //Player clicked on the previous song button
    if(theEvent.controller().name() == "lastSong"){
      
      //Check if the preview song is still playing
      if(!scene4.isDonePreview()){
        //Quickly stop the current preview song when going through the song list
        scene4.quickStopPreview(gameSong);
      }
      
      //Update the song number to indicate the previous song in the list
      songNumber = songNumber - 1;
      if(songNumber < 0){
        songNumber = 2;
      }
      
      //Load the song and update the song display panel
      scene4.loadSong(gameDifficulty, songNumber, gameSong);
      scene4.updateDisplayPanel();
    }
    
    
    //The current scene is the song selection scene
    //Player clicked on the next song button
    if(theEvent.controller().name() == "nextSong"){
      
      //Check if the preview song is still playing
      if(!scene4.isDonePreview()){
        //Quickly stop the current preview song when going through the song list
        scene4.quickStopPreview(gameSong);
      }
      
      songNumber = (songNumber + 1) % 3;                      //Update the song number to indicate the next song in the list
      scene4.loadSong(gameDifficulty, songNumber, gameSong);  //Load the new song
      scene4.updateDisplayPanel();                            //Update the song display panel
    }
    
    
    //The current scene is the song selection scene
    //The PREVIEW SONG button has been selected
    if(theEvent.controller().name() == "playSong"){
      
      //Reset the song to the beginning before previewing
      scene4.quickStopPreview(gameSong);
      scene4.playPreview(gameSong);
    }
    
    
    //The player wants to start playing the game
    //The START button in the song selection scene or player one's score scene has been selected
    if(theEvent.controller().name() == "playGame"){
      
      //Tell Arduino to start detecting from its drums (touch sensors)
      arduinoPort.write('D');
      
      
      if(theEvent.controller().id() == 4){
        
        //Player one's turn to play the game
        //Stop the song if it is playing
        if(!scene4.isDonePreview()){
          scene4.quickStopPreview(gameSong);
        }
        
        //Hide and set the GUI inactive before playing in the game scene
        scene5[player].hideGUI();

        //Update the scene flag
        sceneFlag[3] = false;
        
        
      }else if(theEvent.controller().id() == 6){
        
        //Player two's turn to play the game
        //Hide and set the GUI inactive before playing in the game scene
        scene5[player].hideGUI();
        
        //Set the player tracker to player two
        player = 1;
        
        //Update the scene flag
        sceneFlag[5] = false;
      }
      
      //Continue updating the scene flag
      sceneFlag[4] = true;
      
      //Jump to the game scene
      scene5[player].setupGUI();                        //Setup the GUI for the game scene
      scene5[player].showContent(playerScore[player]);  //Display the contents of the game scene
      scene5[player].setDifficulty(gameDifficulty);     //Update the game difficulty to the game scene
        
      //Reset the selected song and start playing it
      gameSong.resetSong();
      gameSong.playSong();
      
      //Update the next expiration time for adding a new falling block
      addBlockExpirationTime = millis() + (1500 - (int) pow((gameDifficulty.getDifficulty() + 9), (gameDifficulty.getDifficulty() + 1)));
    }
    
    
    //The current scene is the final score scene
    //The player wants to replay the game after the final score scene
    //The REPLAY button in the final score scene has been selected
    if(theEvent.controller().name() == "replayGame"){
      
      //Tell Arduino to stop detecting from any of its sensors
      arduinoPort.write('N');
      
      //Update the scene flag
      sceneFlag[6] = false;
      sceneFlag[0] = true;
      
      //Jump to the manu scene
      scene7.removeGUI();        //Remove the GUI for the final score scene
      scene1.setupGUI();         //Setup the GUI for the menu scene
      scene1.showContent();      //Display the contents of the menu scene
      
      //Reset the two players' score points
      for(int i = 0; i < NUM_PLAYER; i++){
        playerScore[i].resetScore();
      }
    }
  }
}

//End of file
