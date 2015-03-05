/**********************************************************
 IAT 267 - Introduction to Technological Systems
 Project Name: BOOM BOOM BOOM!
 
 D103, Team 16:
 Pearl Cao (301109013, caoyuec@sfu.ca)
 Susan Huang (301097372, ysh3@sfu.ca)
 Chuck Lee (301054031, cll5@sfu.ca)
 Alex Salaveria (301132524, asalaver@sfu.ca)
 
 
 File description: This file contains the codes for detecting
 the sensor inputs. Values from detected sensors will be
 encoded and sent to Processing.
 
 
 Version: 3.0
 Created on: Oct.29, 2011
 Last Updated: Nov.28, 2011
***********************************************************/

//--------------------------------------------------------------//
//----------------------- Global Constants ---------------------//
//--------------------------------------------------------------//

//Analog input pins
int sliderPin = 0;       //Analog input pin number of the slider sensor
int redDrumPin = 1;      //Analog input pin number of the red drum's touch sensor
int blueDrumPin = 2;     //Analog input pin number of the blue drum's touch sensor
int greenDrumPin = 3;    //Analog input pin number of the green drum's touch sensor
int yellowDrumPin = 4;   //Analog input pin number of the yellow drum's touch sensor

//Digital output pins
int redLedPin = 4;       //Digital output pin number of the red drum's LED's
int blueLedPin = 5;      //Digital output pin number of the blue drum's LED's
int greenLedPin = 6;     //Digital output pin number of the green drum's LED's
int yellowLedPin = 7;    //Digital output pin number of the yellow drum's LED's

//Indices of the sensors for the samplingTime array declared under Global Variables
int redDrum = 0;         //Red drum
int blueDrum = 1;        //Blue drum
int greenDrum = 2;       //Green drum
int yellowDrum = 3;      //Yellow drum
int slider = 5;          //Slider sensor

//Delay interval constants
unsigned long ledInterval = 200;         //Length of time (in milliseconds) to keep the LEDs ON
unsigned long samplingInterval = 100;    //Length of time (in milliseconds) between each sensor sampling
unsigned long serialReadInterval = 100;  //Length of time (in milliseconds) for the next serial communication reading



//--------------------------------------------------------------//
//----------------------- Global Variables ---------------------//
//--------------------------------------------------------------//

//Time tracking variables
unsigned long expireTime[4];        //Array of calculated time (in milliseconds) for when the LEDs switch ON interval ends
unsigned long samplingTime[5];      //Array of calculated time (in milliseconds) for when the sensor sampling interval ends
unsigned long nextReadTime;         //Calculated time (in milliseconds) for when to read the serial communication channel

//State variables
boolean ledOn[4];     //Array of flags to indicate if one of the four drum's LEDs are switched ON
boolean checkSlider;  //Flag to indicate when the slider sensor needs to be check
boolean checkDrums;   //Flag to indicate when the drums (touch sensors) need to be check



//--------------------------------------------------------------//
//-------------------- Setup and Loop Methods ------------------//
//--------------------------------------------------------------//

//Setup
void setup(){
  
  //Initialize the output pins
  pinMode(redLedPin, OUTPUT);
  pinMode(blueLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  
  //Initialize time tracking variables
  //Initialize the LEDs time tracking arrays
  for(int i = 0; i < 4; i++){
    expireTime[i] = 0;
    ledOn[i] = false;
  }
  
  //Initialize the sampling interval tracking array
  for(int i = 0; i < 5; i++){
    samplingTime[i] = 0;
  }
  
  //Initialize the serial communication channel delay time tracker
  nextReadTime = 0;
  
  
  //Initialize the sensor check flags
  checkSlider = false;
  checkDrums = false;
  
  //Start serial communication at 9600 bps
  Serial.begin(9600);
}



//Loop Method
void loop(){
  
  //Listen to the serial communication channel to see if Processing has sent any event
  if( (Serial.available() > 0) && (millis() > nextReadTime) ){
    
    //Read the buffer from the communication channel
    char incomingValue = Serial.read();
    
    //Event receieved from Processing
    if(incomingValue == 'S'){
      //Processing wants Arduino to detect from the slider sensor only
      checkSlider = true;
      checkDrums = false;
    
    }else if(incomingValue == 'D'){
      //Processing wants Arduino to detect from the drums (touch sensors) only
      checkDrums = true;
      checkSlider = false;
        
    }else if(incomingValue == 'N'){
      //Processing wants Arduino to stop detecting any of the sensors
      checkSlider = false;
      checkDrums = false;
    }
    
    //Clear the communication channel buffer
    Serial.flush();
    
    //Update the next time to read the serial communication channel
    nextReadTime = millis() + serialReadInterval;
  }
  
  
  
  //Check the slider sensor if Processing tells Arduino to check it
  if(checkSlider == true){
    
    //Read and send the slider sensor's state after the sampling interval
    if(millis() > samplingTime[slider]){
      //Being sending packet
      Serial.print('s');
      
      //Read the value of the slider sensor
      int sliderValue = analogRead(sliderPin);
      
      //Encode and send the state of the slider sensor to Processing according to the sensor value
      if( (sliderValue >= 0) && (sliderValue < 341) ){
        //If the slider sensor reads from 0 to 1/3 of max input value, then send 'E' for easy mode
        Serial.print('E');
      }else if( (sliderValue >= 341) && (sliderValue < 682) ){
        //If the slider sensor reads from 1/3 to 2/3 of max input value, then send 'N' for normal mode
        Serial.print('N');
      }else if( (sliderValue >= 682) && (sliderValue <= 1023) ){
        //If the slider sensor reads from 2/3 to max input value, then send 'H' for hard mode
        Serial.print('H');
      }
      
      //Finish sending packet
      Serial.print('s');
      Serial.println();
      Serial.print('*');
      Serial.println();  //Print carriage return and newline
      
      
      //Update the sampling interval
      samplingTime[slider] = millis() + samplingInterval;
    }
  }
  
  
  
  //Check the drums if Processing tells Arduino to check it
  if(checkDrums == true){
    
    //-- Turn off any LEDs that are currently turned on and has passed its expiration time --//
    //---------------------------------------------------------------------------------------//
    
    //Turn off the red LEDs if it is on
    if(ledOn[redDrum] == true){
      switchLedOff(redDrum, redLedPin);
    }
    
    //Turn off the blue LEDs if it is on
    if(ledOn[blueDrum] == true){
      switchLedOff(blueDrum, blueLedPin);
    }
    
    //Turn off the green LEDs if it is on
    if(ledOn[greenDrum] == true){
      switchLedOff(greenDrum, greenLedPin);
    }
    
    //Turn off the yellow LEDs if it is on
    if(ledOn[yellowDrum] == true){
      switchLedOff(yellowDrum, yellowLedPin);
    }
    
    
    
    //-- Detect if any drum is hit --//
    //-------------------------------//
    //Check the red drum
    if(millis() > samplingTime[redDrum]){
      detectDrumHit(redDrum, redDrumPin, redLedPin);
    }
    
    //Check the blue drum
    if(millis() > samplingTime[blueDrum]){
      detectDrumHit(blueDrum, blueDrumPin, blueLedPin);
    }
    
    //Check the green drum
    if(millis() > samplingTime[greenDrum]){
      detectDrumHit(greenDrum, greenDrumPin, greenLedPin);
    }
    
    //Check the yellow drum
    if(millis() > samplingTime[yellowDrum]){
      detectDrumHit(yellowDrum, yellowDrumPin, yellowLedPin);
    }
  }
}




//----------------------------------------------//
//-------------- Other methods -----------------//
//----------------------------------------------//

//Method to detect if a drum is hit
void detectDrumHit(int drumIndex, int drumPin, int ledPin){
  
  //Check if the current drum is hit
  if(analogRead(drumPin) == 0){
    
    //Encode which is the current drum and send to Processing 
    Serial.print('d');
    
    //Figure out which is the current drum
    if(drumIndex == redDrum){
      //Current drum colour is red
      Serial.print('R');
      
    }else if(drumIndex == blueDrum){
      //Current drum colour is blue
      Serial.print('B');
      
    }else if(drumIndex == greenDrum){
      //Current drum colour is green
      Serial.print('G');
      
    }else if(drumIndex == yellowDrum){
      //Current drum colour is yellow
      Serial.print('Y');
    }
    
    //Finish sending the packet
    Serial.print('d');
    Serial.println();
    Serial.print('*');
    Serial.println();  //Print carriage return and newline
    
    
    //Turn ON the LEDs
    digitalWrite(ledPin, HIGH);
    ledOn[drumIndex] = true;
    
    //Measure the current time (in milliseconds)
    unsigned long currTime = millis();
    
    //Calculate the next expiration time for the LEDs to turn OFF and for the sensor to detect again
    expireTime[drumIndex] = currTime + ledInterval;
    samplingTime[drumIndex] = currTime + samplingInterval;
  }
}


//Method to turn OFF any LEDs that has passed its expiration time
void switchLedOff(int drumIndex, int ledPin){
  
  //Turn OFF the desired drum's LEDs if it has passed its expiration time
  if(millis() > expireTime[drumIndex]){
    digitalWrite(ledPin, LOW);
    ledOn[drumIndex] = false;
  }
}

//End of file
