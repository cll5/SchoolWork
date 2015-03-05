//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 1
//
// Program written for assignment 1. This is the .cpp file for the Node class.
//
// Version: 1.0
// Last updated: Oct. 03, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#ifndef _NODE_CPP_
#define _NODE_CPP_

//Include external files
#include "Node.h"


//Constructor for a node
Node::Node(int element, Node* next_node) {
	data = element;
	next = next_node;
}

#endif