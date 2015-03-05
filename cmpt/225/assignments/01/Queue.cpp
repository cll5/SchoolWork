//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 1
//
// Program written for assignment 1. This is the .cpp file for the Queue class.
//
// Version: 1.0
// Last updated: Oct. 03, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#ifndef _QUEUE_CPP_
#define _QUEUE_CPP_

//Include external files
#include "Queue.h"
using namespace std;


//Constructor:
//Creates an empty queue
Queue::Queue() {

	//Initialize the queue attributes for an empty queue
	frontOfQueue = NULL;
	backOfQueue = NULL;
	queueSize = 0;
}


//Copy constructor:
//Makes a deep copy of a queue
Queue::Queue(const Queue & aQueue) {

	//copyQueue(aQueue);
	//Initialize the copy queue as an empty queue
	frontOfQueue = NULL;
	backOfQueue = NULL;
	queueSize = aQueue.queueSize;

	//Make a copy if the given queue is not empty
	//Otherwise, an empty queue is already made above
	if(queueSize > 0) {
		//Copy the 
		Node* originalQueue = aQueue.frontOfQueue;

		//Copy the front of the queue
		Node* copyQueue = new Node(originalQueue->data, NULL);
		frontOfQueue = copyQueue;

		//Then copy the rest of the queue
		while(originalQueue->next != NULL) {
			originalQueue = originalQueue->next;
			copyQueue->next = new Node(originalQueue->data, NULL);
			copyQueue = copyQueue->next;
		}

		//Assign the last node to the back of the queue
		backOfQueue = copyQueue;
	}
}


//Destructor:
//Deallocates dynamic memory allocated by the queue
Queue::~Queue() {
	
	//Create a dummy pointer to traverse through the queue
	Node* temp = frontOfQueue;

	//Starting from the front of the queue, traverse through the entire queue 
	//and deallocate the nodes one by one until the back of the queue is reached
	while(temp != NULL) {
		frontOfQueue = frontOfQueue->next;
		delete temp;
		temp = frontOfQueue;
	}
	delete temp; //temp is NULL

	//The queue is deallocated and so, set the default setting for an empty queue
	frontOfQueue = NULL;
	backOfQueue = NULL;
	queueSize = 0;
}


//Insert method:
//Inserts an integer at the back of the queue
void Queue::insert(int element) {

	//Create a new node and link it to the back of the queue
	Node* temp = new Node(element, NULL);
	

	if(queueSize == 0) {
		//If the queue is empty, then link the new node to the front and back of the queue
		frontOfQueue = temp;
		backOfQueue = frontOfQueue; //same as backOfQueue = temp;
	}
	else {
		//Otherwise, link the new node to the back of the queue
		backOfQueue->next = temp;
		backOfQueue = backOfQueue->next; //same as backOfQueue = temp;
	}
	

	//Increase the number of elements in the queue by 1
	queueSize = queueSize + 1;
}


//Remove method:
//Removes and returns the integer from the front of the queue
int Queue::remove() {

	//If the queue is empty, throw an invalid_argument error
	if(queueSize == 0) {
		throw invalid_argument("Queue is empty.");	
	}

	//Store the first element of the queue to a temporary space and return it later
	int element = frontOfQueue->data;
	
	//Removing the first node of the queue
	Node* temp = frontOfQueue;
	frontOfQueue = frontOfQueue->next;
	delete temp;

	//The back and front of the queue are the same when the queue is empty
	if(queueSize == 1) {
		backOfQueue = frontOfQueue;
	}
	
	//Decrease the number of elements in the queue by 1
	queueSize = queueSize - 1;

	//Return the first element of the queue
	return element;
}


//Peek method:
//Returns the integer at the front of the queue without removing it from the queue
int Queue::peek() const {

	//If the queue is empty, throw an invalid_argument error
	if(queueSize == 0) {
		throw invalid_argument("Queue is empty.");
	}

	
	//Return the first element of the queue
	int element = frontOfQueue->data;
	return element;
}


//Size method:
//Returns the number of elements in the queue
int Queue::size() const {

	return queueSize;
}

#endif