//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 1
//
// Program written for assignment 1. This file contains the main function and the 
// solutions to parts 2, 3 and 4 of the assignment.
//
// Version: 1.0
// Last updated: Oct. 03, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//


//Include external files
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include "Queue.h"
using namespace std;


//Forward declaration
void part2();
void part3();
void part4();
void continueRunning();
Queue randomTrackGenerator(int sizeOfQueue);
void fairAlgorithmSimulator(int numOfTracks);
void printPlayers(const Queue & playerQueue);


//Main function
int main() {
	
	//Print a title
	cout << "*********************************************" << endl;
	cout << "CMPT 225 - Assignment 1" << endl << endl;
	cout << "Written by: Chuck Lee" << endl;
	cout << "Version: 1.0" << endl;
	cout << "*********************************************" << endl << endl;

	//Start assignment
	cout << "BEGIN ASSIGNMENT 1" << endl << endl << endl;


	//Test function
	part2();
	
	
	//Disk Queues function
	continueRunning(); //wait for user to begin next part
	cout << endl << endl; //print more spaces between each part of the assignment for clarity purposes
	part3();
	
	
	//Survivors function
	continueRunning(); //wait for user to begin next part
	cout << endl << endl; //print more spaces between each part of the assignment for clarity purposes
	part4();
	

	//Finish assignment
	cout << "END OF ASSIGNMENT 1" << endl;
	continueRunning(); //wait for user to end program
	return 0;
}



//Test function for the queue class implementation
void part2() {

	//Variable declaration
	int test5Array[5] = {-1, -100, 33, -50, 15}; //integers to insert into queue in test case #5


	//Contain test cases #1 through #7:
	//	Test #1: Creating an empty queue
	//	Test #2: Inserting 1 to 10 into the queue
	//	Test #3: Removing 3 integers from the queue
	//	Test #4: Removing the rest of the integers from the queue
	//	Test #5: Insert and Remove the numbers {-1, -100, 33, -50, 15}
	//	Test #6: Copy Constructor Test
	//	Test #7: Destructor Test
	try {
		cout << "BEGIN QUEUE TEST" << endl << endl;
		cout << "Nine main test cases will be conducted below." << endl;
		continueRunning(); //wait for the user to start the test cases

		
		//Test #1: Creating an empty queue
		//
		//Test prediction: Size of queue is 0
		cout << "TEST 1: Creating an empty queue." << endl;
		cout << "Test prediction: Size of queue = 0." << endl << endl; //test prediction
		
		cout << "Test Results:" << endl;
		Queue testQueue;
		cout << "Created a new queue. It has " << testQueue.size() << " integers." << endl;

		//Compare the test result to the test prediction
		if( testQueue.size() == 0 ) {
			cout << "The queue is empty." << endl;
			cout << "TEST 1 Completed Successfully." << endl;
		}
		else {
			//The queue is not empty
			cout << "TEST 1 FAILED." << endl;
		} 
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #1
		



		//Test #2: Inserting 1 to 10 into the queue
		//
		//Test predictions: At the front of the queue is 1
		//				    Size of queue is 10
		cout << "TEST 2: Insert integers 1 to 10 into the queue." << endl;
		cout << "Test predictions: Integer at front of queue = 1." << endl;
		cout << "                  Size of queue = 10." << endl << endl; //test predictions
		
		cout << "Test Results:" << endl;
		for(int i = 1; i <= 10; i++) {
			//Inserting the integers 1 to 10 in this for loop and print out the size of the queue at every step
			testQueue.insert(i);
			cout << "Inserting " << i << ". The size of the queue is now " << testQueue.size() << "." << endl;

			//Check if integers is inserted into the queue successfully by comparing the size of the queue with the loop index
			if( testQueue.size() != i ) {
				//An integer did not get inserted properly, forcefully break out of the for loop
				i = 10;
			}
		}
		cout << "The integer at the front of the queue is " << testQueue.peek() << "." << endl; //peek at the front of the queue
		
		//Compare the test results to the test predictions
		if( (testQueue.peek() == 1) && (testQueue.size() == 10) ) {
			cout << "TEST 2 Completed Successfully." << endl;
		}
		else {
			cout << "TEST 2 FAILED." << endl;
		}
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #2
		
		


		//Test #3: Removing 3 integers from the queue
		//
		//Test predictions: At the front of the queue is 4
		//				    Size of queue is 7
		cout << "TEST 3: Removing 3 integers from the queue." << endl;
		cout << "Test Predictions: Integer at front of queue = 4." << endl; //test predictions
		cout << "                  Size of queue = 7." << endl << endl;
		
		cout << "Test Results:" << endl;
		for(int i = 0; i < 3; i++) {
			//Removing an integer from the front of the queue each step
			cout << "Removing " << testQueue.peek() << " from the queue." << endl;

			//Check if the inserted integers are removed in the expected order
			if( testQueue.remove() != (i + 1) ) {
				//An integer did not get removed in the expected order, forcefully break out of the for loop
				i = 3;
			}
		}
		cout << "The integer at the front of the queue is " << testQueue.peek() << "." << endl; //peek at the front of the queue
		cout << "The size of the queue is now " << testQueue.size() << "." << endl; //check the size of the queue
		
		//Compare the test results to the test predictions
		if( (testQueue.peek() == 4) && (testQueue.size() == 7) ) {
			cout << "TEST 3 Completed Successfully." << endl;
		}
		else {
			cout << "TEST 3 FAILED." << endl;
		}
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #3
		



		//Test #4: Removing the rest of the integers from the queue
		//
		//Test prediction: Size of queue is 0
		cout << "TEST 4: Emptying the queue." << endl;
		cout << "Test prediction: Size of queue = 0." << endl << endl; //test prediction
		
		cout << "Test Results:" << endl;
		for(int i = 0; i < 7; i++) {
			//Removing an integer from the front of the queue each step
			cout << "Removing " << testQueue.peek() << " from the queue." << endl;

			//Check if the inserted integers are removed in the expected order
			if( testQueue.remove() != (i + 4) ) {
				//An integer did not get removed in the expected order, forcefully break out of the for loop
				i = 7;
			}
		}
		cout << "The size of the queue is now " << testQueue.size() << "." << endl; //check the size of the queue
		
		//Compare the test result to the test prediction
		if( testQueue.size() == 0 ) {
			cout << "TEST 4 Completed Successfully." << endl;
		}
		else {
			cout << "TEST 4 FAILED." << endl;
		}
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #4




		//Test #5: Insert and Remove the numbers {-1, -100, 33, -50, 15}
		cout << "TEST 5: Inserting and removing the numbers -1, -100, 33, -50, 15 into the queue." << endl;

		//Test #5a: Insert the numbers {-1, -100, 33, -50, 15}
		//
		//Test predictions: At the front of the queue is -1
		//				    Size of queue is 5
		cout << "TEST 5a: Inserting the numbers -1, -100, 33, -50, 15 into the queue." << endl;
		cout << "Now performing the insertion operations." << endl; //inserting integers into the queue
		cout << "Insertion test prediction: Integer at front of queue = -1." << endl; //test predictions
		cout << "                           Size of queue = 5." << endl << endl;
		
		cout << "Test Results:" << endl;
		for(int i = 0; i < 5; i++) {
			//Inserting the integers {-1, -100, 33, -50, 15} into the queue one at a time
			//and print out the size of the queue at each step
			testQueue.insert( test5Array[i] );
			cout << "Inserting " << test5Array[i] << " into the queue. The size of the queue is " << testQueue.size() << endl;

			//Check if integers is inserted into the queue successfully by comparing the size of the queue with the loop index
			if( testQueue.size() != (i + 1) ) {
				//An integer did not get inserted properly, forcefully break out of the for loop
				i = 5;
			}
		}
		cout << "The integer at the front of the queue is " << testQueue.peek() << "." << endl; //peek at the front of the queue
		
		//Compare the test results to the test predictions
		if( (testQueue.peek() == -1) && (testQueue.size() == 5) ) {
			cout << "TEST 5a Completed Successfully." << endl;
			cout << endl << endl; //print spacing for clarity purposes
		}
		else {
			cout << "TEST 5a FAILED." << endl;
			cout << endl << endl; //print spacing for clarity purposes
		}


		//Test #5b: Emptying the queue
		//
		//Test prediction: Size of queue is 0
		cout << "TEST 5b: Emptying the queue." << endl; //removing integers from the queue
		cout << "Removal test prediction: Size of queue = 0." << endl << endl; //test prediction
		
		cout << "Test Results:" << endl;
		for(int i = 0; i < 5; i++) {
			//Removing an integer from the front of the queue
			cout << "Removing " << testQueue.peek() << " from the queue." << endl;
			
			//Check if the inserted integers are removed in the expected order
			if( testQueue.remove() != test5Array[i] ) {
				//An integer did not get removed in the expected order, forcefully break out of the for loop
				i = 5;
			}
		}
		cout << "The size of the queue is now " << testQueue.size() << "." << endl; //check the size of the queue
		
		//Compare the test result to the test prediction
		if( testQueue.size() == 0 ) {
			cout << "TEST 5b Completed Successfully." << endl;
		}
		else {
			cout << "TEST 5b FAILED." << endl;
		}
		cout << "TEST 5 Complete." << endl;
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #5




		//Test #6: Copy Constructor Test
		cout << "TEST 6: COPY CONSTRUCTOR TEST" << endl << endl;
		
		//Test #6a: Copy an empty queue
		//
		//Test predictions: Size of copiedQueue is 0
		//					Size of testQueue is 1
		cout << "TEST 6a: Copy an empty queue and insert an integer into the original queue." << endl;
		cout << "Test prediction: Size of the original queue is 1." << endl; //test predictions
		cout << "                 Size of the copied queue is 0." << endl << endl;
		
		cout << "Test Results:" << endl;
		//Test queue is already emptied from previous test
		Queue copiedQueue(testQueue); //make a copy of the empty test queue
		testQueue.insert(1); //insert an integer into the test queue and see if the size of the copied queue has changed
		cout << "Inserting 1 into the original queue." << endl;
		cout << "The size of the original queue is " << testQueue.size() << "." << endl;
		if( (copiedQueue.size() == 0) && (testQueue.size() == 1) ) {
			//Copied queue remains empty, so copying an empty queue is successful
			cout << "The size of the copied queue is 0. Made a copy of an empty queue." << endl;
			cout << "TEST 6a Completed Successfully." << endl;
			cout << endl << endl; //print spacing for clarity purposes
		}
		else {
			cout << "The size of the copied queue is " << copiedQueue.size() << ". Failed to copy an empty queue." << endl;
			cout << "TEST 6a FAILED." << endl;
			cout << endl << endl; //print spacing for clarity purposes
		}
		testQueue.remove(); //empty the test queue for the next test




		//Test #6b: Inserting -1 to 2 into the copied queue
		//
		//Test predictions: Size of testQueue is 0
		//					Size of copiedQueue is 4
		//					At the front of the copiedQueue is -1
		cout << "TEST 6b: Inserting -1 to 2 into the copied queue " << endl;
		cout << "         and leave the original queue empty." << endl;
		cout << "Test prediction: Size of original queue is 0." << endl; //test predictions
		cout << "                 Size of copied queue is 4." << endl;
		cout << "                 At the front of the copied queue is -1." << endl << endl;

		cout << "Test Results:" << endl;
		for(int i = 0; i < 4; i++) {
			//Inserting an integer into the copied queue and print out the copied queue size at each step
			copiedQueue.insert( (i - 1) );
			cout << "Inserted " << (i - 1) << " into the copied queue. The size of the copied queue is now " << copiedQueue.size() << "." << endl;
		}
		cout << "The integer at the front of the copied queue is " << copiedQueue.peek() << "." << endl;
		cout << "The size of the original queue is " << testQueue.size() << "." << endl;

		if( (testQueue.size() == 0) && (copiedQueue.size() == 4) && (copiedQueue.peek() == -1) ) {
			cout << "TEST 6b Completed Successfully." << endl;
			cout << endl << endl; //print spacing for clarity purposes
		}
		else {
			cout << "Test 6b FAILED." << endl;
			cout << endl << endl; //print spacing for clarity purposes
		}



		//Test #6c: Removing 2 integers from the copied queue
		//
		//Test predictions: Size of testQueue is 0
		//					Size of copiedQueue is 2
		//					At the front of the copiedQueue is 1
		cout << "TEST 6c: Removing 2 integers from the copied queue." << endl;
		cout << "Test prediction: Size of original queue is 0." << endl; //test predictions
		cout << "                 Size of copied queue is 2." << endl;
		cout << "                 At the front of the copied queue is 1." << endl << endl;

		cout << "Test Results:" << endl;
		for(int i = 0; i < 2; i++) {
			//Removing an integer from the front of the queue
			cout << "Removing " << copiedQueue.peek() << " from the copied queue." << endl;
			
			//Check if the inserted integers are removed in the expected order
			if( copiedQueue.remove() != (i - 1) ) {
				//An integer did not get removed in the expected order, forcefully break out of the for loop
				i = 2;
			}
		}
		cout << "The size of the original queue is " << testQueue.size() << "." << endl;
		cout << "The size of the copied queue is " << copiedQueue.size() << "." << endl;
		cout << "The integer at the front of the copied queue is " << copiedQueue.peek() << "." << endl;

		if( (testQueue.size() == 0) && (copiedQueue.size() == 2) && (copiedQueue.peek() == 1) ) {
			cout << "TEST 6c Completed Successfully." << endl;
		}
		else {
			cout << "TEST 6c FAILED." << endl;
		}
		cout << "TEST 6 Complete." << endl;
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #6



		//Test #7: Destructor Test
		//
		//Test predictions: Size of testQueue is 0
		//					Size of copiedQueue is 0
		cout << "TEST 7: DESCTRUCTOR TEST." << endl;
		cout << "Test prediction: Size of original queue is 0." << endl; //test predictions
		cout << "                 Size of copied queue is 0." << endl << endl;
		
		cout << "Test Results:" << endl;
		//Deallocate the test and copy queues
		testQueue.~Queue();
		copiedQueue.~Queue();

		cout << "The size of the original queue is " << testQueue.size() << "." << endl;
		cout << "The size of the copied queue is " << copiedQueue.size() << "." << endl;

		if( (testQueue.size() == 0) && (copiedQueue.size() == 0) ) {
			cout << "TEST 7 Completed Successfully." << endl;
		}
		else {
			cout << "TEST 7 FAILED." << endl;
		}
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #7
	}
	catch(invalid_argument errorMsg) {
		//Error handling for removing or peeking at an empty queue
		cout << "Invalid argument: " << errorMsg.what() << endl;
		cout << "Error occured in test cases #1 through #7." << endl << endl;
	}


	//Contain test case #8
	try {
		//Test #8: Attempt to peek into an empty queue
		//
		//Test prediction: Print an invalid argument for attempting to peek into an empty queue

		Queue testQueue; //create an empty queue
		cout << "TEST 8 (ERROR HANDLING): Attempting to peek into an empty queue." << endl;
		cout << "Test prediction: Display an invalid argument for an empty queue." << endl << endl;
		
		cout << "Test Results:" << endl;
		cout << "The size of the queue is now " << testQueue.size() << "." << endl;
		cout << "Now attempting to peek into the empty queue... " << endl;
		testQueue.peek();
	}
	catch(invalid_argument errorMsg) {
		//Error handling for removing or peeking at an empty queue
		cout << "Invalid argument: " << errorMsg.what() << endl;
		cout << "TEST 8 Completed Successfully." << endl;
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #8
	}


	//Contain test case #9
	try {
		//Test #9: Attempt to remove from an empty queue
		//
		//Test prediction: Print an invalid argument for attempting to remove from an empty queue

		Queue testQueue; //create an empty queue
		cout << "TEST 9 (ERROR HANDLING): Attempting to remove from an empty queue." << endl;
		cout << "Test prediction: Display an invalid argument for an empty queue." << endl << endl;
		
		cout << "Test Results:" << endl;
		cout << "The size of the queue is now " << testQueue.size() << "." << endl;
		cout << "Now attempting to remove from the empty queue... " << endl;
		testQueue.remove();
	}
	catch(invalid_argument errorMsg) {
		//Error handling for removing or peeking at an empty queue
		cout << "Invalid argument: " << errorMsg.what() << endl;
		cout << "TEST 9 Completed Successfully." << endl;
		cout << endl << endl << endl; //print spacing for clarity purposes
		//End of Test #9
	}

	cout << "END OF QUEUE TEST" << endl;
} //End of test function



//Disk Queues funuction
void part3() {

	//Start message for this part
	cout << "BEGIN THE DISK QUEUES SIMULATION" << endl;
	continueRunning(); //wait for users to continue

	//Perform 10 different simulations
	fairAlgorithmSimulator(1);
	fairAlgorithmSimulator(11);
	fairAlgorithmSimulator(2);
	fairAlgorithmSimulator(7);
	fairAlgorithmSimulator(23);
	fairAlgorithmSimulator(13);
	fairAlgorithmSimulator(31);
	fairAlgorithmSimulator(17);
	fairAlgorithmSimulator(37);
	fairAlgorithmSimulator(19);

	//End message for this part
	cout << "END OF THE DISK QUEUES SIMULATION" << endl;
} //End of disk queues function



//Survivors function
void part4() {

	try {
		//Variable declaration
		Queue survivorQueue; //create an empty survivor queue
		int numOfSurvivors = 41; //total number of players for the survivor game
		int firstPlayer, secondPlayer; //the first two players in the front of the survivor queue
		char chooseToPrintPlayers; //used to let the user to 


		//Initializing the survivor queue by inserting players into it
		for(int player = 1; player <= numOfSurvivors; player++) {
			survivorQueue.insert(player);
		}

		//Announcement for the game to start
		cout << "BEGIN SURVIVOR GAME FOR " << numOfSurvivors << " PLAYERS" << endl;
		continueRunning(); //wait for user to start the game

		//Print out the list of players in the beginning
		printPlayers(survivorQueue);

		//Let user to decide rather to keep printing the list of players at each round or not
		cout << endl << endl;
		cout << "Do you wish to see the list of players printed in order in the following rounds?" << endl;
		cout << "Enter y or Y if yes. Otherwise, enter any other key if no." << endl;
		cout << "Please enter here: ";
		cin >> chooseToPrintPlayers;
		cout << endl << endl;
		

		//Check rather the user want to print the list of players at each round or not
		switch(chooseToPrintPlayers) {
			
			//The list of players will be printed at each round
			case 'y':
			case 'Y':

				//Play through the survivor game until one player remains
				while(survivorQueue.size() > 1) {
					//Remove the first two players from the front of the survivor queue
					firstPlayer = survivorQueue.remove();
					secondPlayer = survivorQueue.remove();

					//Insert these two players to the back of the survivor queue
					survivorQueue.insert(firstPlayer);
					survivorQueue.insert(secondPlayer);

					//Remove the third player from the front of the survivor queue
					cout << "Player " << survivorQueue.remove() << " is removed from the game this round." << endl;
					
					//Print out the list of players for the current round
					printPlayers(survivorQueue);
				}
				break;


			//The list of players will not be printed at each round
			default:

				//Play through the survivor game until one player remains
				while(survivorQueue.size() > 1) {
					//Remove the first two players from the front of the survivor queue
					firstPlayer = survivorQueue.remove();
					secondPlayer = survivorQueue.remove();

					//Insert these two players to the back of the survivor queue
					survivorQueue.insert(firstPlayer);
					survivorQueue.insert(secondPlayer);

					//Remove the third player from the front of the survivor queue
					survivorQueue.remove();
				}
				break;
		}

		//Announce the winner of the survivor game
		cout << endl;
		cout << "The survivor game has ended. The winner is player " << survivorQueue.peek() << "!" << endl;
		cout << "CONGRATULATIONS player " << survivorQueue.peek() << "!" << endl << endl;


		//Deallocate the survivor queue
		survivorQueue.~Queue();
	}
	catch(invalid_argument errorMsg) {
		//Error handling for removing or peeking at an empty queue
		cout << "Invalid argument: " << errorMsg.what() << endl;
	}

	//Announcement for finishing the game
	cout << "END OF SURVIVORS GAME" << endl << endl << endl;
} //End of survivors function



//Prints a "Press any key to continue: " message to the screen, requesting
//users to continue to the next section of the program
void continueRunning() {

	//Variable declaration
	char anyKey; //used for continuing through "Press any key to continue: " messages
	
	//Print out the wait message to inform the user
	cout << endl << "Press any key and hit the ENTER key to continue: ";
	cin >> anyKey; //wait for user to enter something
	cout << endl << endl;
}



//Part 3 - Disk Queues subfunction:
//Random track generator
Queue randomTrackGenerator(int sizeOfQueue) {
	
	//Variable declaration
	Queue trackQueue; //create an empty track queue
	int randomTrack; //holds a random track number to insert into the track queue
	

	//Use the time function to generate a random seed for the random generator
	srand( time(NULL) );

	//Fill the track queue with random integers in the range 0 to 10,000
	for(int i = 0; i < sizeOfQueue; i++) {
		//Generate a random integer in the range 0 to 10,000 (using the modulo
		//operator) for the hard disk track and insert it into the track queue
		randomTrack = rand() % (10000 + 1);
		trackQueue.insert(randomTrack);
	}

	//Return a copy of the track queue
	return trackQueue;
}



//Part 3 - Disk Queues subfunction:
//Simulator that performs the "fair algorithm" described on the assignment instructions
void fairAlgorithmSimulator(int numOfTracks) {

	//Variable declaration
	double seekTime = 0.001; //the seek time in milliseconds (ms)
	double totalTime = 0.0; //the total time for moving through all the tracks
	double moveTime = 0.0; //the time to move from the previous track to the next track
	int previousTrack = 0; //holds the previous track number
	Queue trackNumbers = randomTrackGenerator(numOfTracks); //generate the random list of tracks


	//Initial print message
	cout << "Simulation begin:" << endl;
	cout << "Disk head starts at track " << previousTrack << "." << endl << endl;
	
	//Begin simulation
	for(int i = 0; i < numOfTracks; i++) {
		//Calculate the absolute time it takes to move from the previous track to the next track
		moveTime = fabs( ((trackNumbers.peek() - previousTrack) * seekTime) );

		//Print out the current track status
		cout << "Disk head is moving from track " << previousTrack << " to track " << trackNumbers.peek() << ". ";
		cout << "Moving took " << moveTime << " ms." << endl;

		//Update the total time of the simulation
		totalTime = totalTime + moveTime;

		//Update the previous track to the current track
		previousTrack = trackNumbers.remove();
	}
	//Print out which track the disk head is on at the end of the simulation
	cout << "The disk head has ended on track " << previousTrack << "." << endl;

	//Print the total simulation time
	cout << endl << "Total time = " << totalTime << " ms." << endl;

	//Print the completion message
	cout << "Simulation completed." << endl;
	cout << endl << endl; //print spaces for clarity purposes

	//Deallocate the track number queue
	trackNumbers.~Queue();
}



//Part 4 - Survivors subfunction:
//Prints out the list of players in order for the current round
void printPlayers(const Queue & playerQueue) {
	
	//Variable declaration
	Queue printQueue(playerQueue); //copy the queue with the list of players for printing purposes
	

	//Print out the first player at the front of the queue
	cout << "The current order of players are:" << endl;
	cout << printQueue.remove(); 

	//Print out the rest of the players in the queue
	for(int i = 1; i < playerQueue.size(); i++) {
		cout << " " << printQueue.remove();
	}
	cout << endl << endl;
}
//End of CMPT 225 - Assignment 1