//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 1
//
// Program written for assignment 1. This is the .h file for the Node class.
//
// Version: 1.0
// Last updated: Oct. 03, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#ifndef _NODE_H_
#define _NODE_H_


//Node class for singly linked list implementations
class Node
{
public:
	int data; //data parameter of the node
	Node* next; //pointer to the next node
	
	Node(int element, Node* next_node); //default constructor

	//Note: Destructor is not needed since we will manually
	//use the delete operator to deallocate a node in the queue
};

#endif