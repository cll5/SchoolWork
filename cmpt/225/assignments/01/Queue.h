//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 1
//
// Program written for assignment 1. This is the .h file for the Queue class.
//
// Version: 1.0
// Last updated: Oct. 03, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#ifndef _QUEUE_H_
#define _QUEUE_H_

//Include external files
#include <stdlib.h>
#include <stdexcept>
#include "Node.h"
using namespace std;


//Queue class for integers:
//Implemented using singly linked list
class Queue {
	public:
		Queue(); //constructor for an empty queue
		Queue(const Queue & aQueue); //copy constructor
		~Queue(); //destructor

		void insert(int element); //Method to insert an integer at the back of the queue
		int remove(); //Method to remove an integer from the front of the queue
		int peek() const; //Method to get the integer at the front of the queue
		int size() const; //Method to get the size of the queue

	private:
		int queueSize; //counter for the size of the queue
		Node* frontOfQueue; //pointer to the front of the queue
		Node* backOfQueue; //pointer to the back of the queue

		//void copyQueue(const Queue & aQueue); //function to copy a queue for the copy constructor
};

#endif