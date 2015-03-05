/****************************************************
IAT 336 - PoppyClock Program

Welcome to the PoppyClock Program. You can adjust the
PoppyClock by changing the hour and minute variables 
that are listed below.

Created by:
Chuck Lee, Jacky Ma, Justine Shillibeer, Sandy Wang 
****************************************************/
#include <Servo.h>

/**********************************************************************/
//Adjust the time by choosing a desired hour (1 to 12)
//and minute (1 to 60). Then click on the upload button at the top
//(it's the circle with the right arrow, or go to File > Upload)

//Ex. This will setup the time to 2:45
//int hour = 2;
//int minute = 45;

int hour = 1;  //Replace the number with any hour between 1 and 12
int minute = 60;  //Replace the number with any minute between 1 and 60

/***********************************************************************/

/*****************************/
//Demo Special Function
//Fast Mode
boolean fastMode = false;
/*****************************/

//Digital pins
const int ledCtrl[12] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
const int servoCtrl = 13;

//Other constants
const unsigned long SERVO_ACTIVE_PERIOD = 24;      //Duration for the servo motor to move
const unsigned long MINUTE_ADJUSTMENT_PAUSES = 48; //Duration to pause during minute adjustment
const int SERVO_SPEED = 86;                        //Speed of the servo motor
const int NUM_OF_HOURS = 12;                       //Total number of hours
const int NUM_OF_MINUTES = 60;                     //Total number of minutes

//PoppyVariables
unsigned long oneMinuteDelay;    //Delay constant for one minute
Servo minuteHand;                //Servo object
int hourCounter;                 //Keeps track of the current hour
int minuteCounter;               //Keeps track of the current minute




void setup(){
  
  //Check if the hour and minute values are error free
  //Check if the hour value is out of range
  if(hour < 1){
    hour = 1;
  }else if(hour > 12){
    hour = 12;
  }
  
  //Check if the minute value is out of range
  if(minute < 1){
    minute = 1;
  }else if(minute > 60){
    minute = 60;
  }
  
  //Check if fast mode is active
  if(fastMode == false){
    //Normal time rate for one minute
    oneMinuteDelay = 59973;
  }else{
    //Fast time rate for demo
    oneMinuteDelay = 473;
  }
  
  //Setup the LED control pins
  for(int index = 0; index < NUM_OF_HOURS; index++){
    pinMode(ledCtrl[index], OUTPUT);
  }
  
  //Setup the LEDs to represent the current hour
  for(int index = 0; index < NUM_OF_HOURS; index++){
    if(index < hour){
      digitalWrite(ledCtrl[index], HIGH);
    }else{
      digitalWrite(ledCtrl[index], LOW);
    }
  }
  
  hourCounter = hour - 1;  //Setup the hour counter to the current hour
  
  //Setup the servo motor to represent the current minute
  minuteHand.write(SERVO_SPEED);  //Initialize the speed of the servo motor
  
  
  //Move the minute hand to the desired minute
  for(int i = 0; i < (minute % NUM_OF_MINUTES); i++){
    minuteHand.attach(servoCtrl);
    delay(SERVO_ACTIVE_PERIOD);
    minuteHand.detach();            
    delay(MINUTE_ADJUSTMENT_PAUSES);  
  }
  minuteCounter = minute - 1;  //Setup the minute counter to the current minute
}




void loop(){
  
  if(minuteCounter == 0){
    //Hour (LEDs) control
    if(hourCounter == 0){
      //Reset the LEDs, switching from 12 hours to 1 hour
      for(int index = 1; index < NUM_OF_HOURS; index++){
        digitalWrite(ledCtrl[index], LOW);
      }
    }else{
      //Turn ON the next adjacent LED to increment the hour
      digitalWrite(ledCtrl[hourCounter], HIGH);
    }
    hourCounter = (hourCounter + 1) % NUM_OF_HOURS;  //Increment the hour
  }
  
  //Minute (Servo motor) control
  minuteHand.attach(servoCtrl);  //Get the servo motor to move to the next minute
  delay(SERVO_ACTIVE_PERIOD);    //Duration for the servo motor to move to the next minute
  minuteHand.detach();           //Stop the servo motor
  delay(oneMinuteDelay);         //Wait until the next minute arrives
  minuteCounter = (minuteCounter + 1) % NUM_OF_MINUTES;  //Increment the minute counter
}
