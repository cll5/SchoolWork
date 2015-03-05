/******************************************************
 Player's score tracker:
******************************************************/

class ScoreTracker{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private int playerScore;    //Keep tracks of the player's score points
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  ScoreTracker(){
    playerScore = 0;
  }
  


  //-- Setters: --//
  //--------------//
  //None
  
  //-- Getters: --//
  //--------------//
  
  //Returns the player's current score point
  public int getScore(){
    return playerScore;
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Method to update the player's score point
  public void updateScore(int scorePoints){
    playerScore += scorePoints;
  }
  
  
  //Method to reset the player's score points to 0
  public void resetScore(){
    playerScore = 0;
  }
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //None
}
