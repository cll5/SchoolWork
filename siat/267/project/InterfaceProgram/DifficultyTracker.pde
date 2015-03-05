/******************************************************
 Difficulty level tracker:
******************************************************/

class DifficultyTracker{
  
  //-- Private Fields --------------------------------//
  //--------------------------------------------------//
  private int difficulty;         //Difficulty level tracker(0 = easy, 1 = normal, 2 = hard)
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Default constructor
  DifficultyTracker(){
    //The default difficulty level is 1 (= normal)
    difficulty = 1;
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Set the difficulty level
  public void setDifficulty(int difficultyLevel){
    difficulty = difficultyLevel;
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the difficulty level of the scene
  public int getDifficulty(){
   return difficulty;
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  //  None
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
