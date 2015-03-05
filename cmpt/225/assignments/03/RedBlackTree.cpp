/* 
 * File:   RedBlackTree.cpp
 * Author: Benjamin
 * 
 * Created on October 30, 2011, 3:02 PM
 */

#include "RedBlackTree.h"

RedBlackTree::RedBlackTree() {
    root = NULL;
    size =0;
}

RedBlackTree::RedBlackTree(const RedBlackTree& rbt) {
    
}

RedBlackTree::~RedBlackTree(){
    
}

void RedBlackTree::insert(string str){
    Node *x = new Node(str);
    int z = RedBlackTree::search(str); 
    
    if (z = 0){
        RedBlackTree::insertBST(str);
        // y  = left or right uncle of z  
        Node *y;
        while (x->parent->isBlack){
        if(x->parent == x->parent->parent->left){
            y = x->parent->parent->right;
            if(y->isBlack){
                x->parent->isBlack = true;
                y->isBlack = true;
                x->parent->parent->isBlack = false;
                x = x->parent->parent;
            }
            else{
                if( x == x->parent->right){
                    x = x->parent;
                    RedBlackTree::LeftRotate(x);
                }
                x->parent->isBlack = true;
                x->parent->parent->isBlack = false;
                RedBlackTree::RightRotate(x);
            }
        }
        else{
            y = x->parent->parent->left;
            if(y->isBlack){
                x->parent->isBlack = true;
                y->isBlack = true;
                x->parent->parent->isBlack = false;
                x = x->parent->parent;
            }
            else
            {
                if( x == x->parent->left)
                {
                    x = x->parent;
                    RedBlackTree::RightRotate(x);
                }
                x->parent->isBlack = true;
                x->parent->parent->isBlack = false;
                RedBlackTree::LeftRotate(x);
            }
        }
    }
    root->isBlack = true;
}
    //There is already a node containing str, therefore we increment
    //the frequency count
    else {
        x->data.increment();
    }
    
}

int RedBlackTree::remove(string str){
    
}

int RedBlackTree::deletes(string str){
    
}

//Searches the tree for a node that contains str and return its frequency
//returns 0 if the search is unsuccessful
int RedBlackTree::search(string str){
    Node * p = root;
    //Check if the root is a leaf/parent
    while(p != NULL){
        //check if it is left child
        if (str < p->data.getWord()){
            p = p->left;
        }
        //Check if it is right child
        else if(str > p->data.getWord()){
            p = p-> right;
        }
        //Target found
        else {
            return p->data.getFrequency();
        }
    }
    return 0;
}

void RedBlackTree::deleteAll(){
    
}

void RedBlackTree::inOrderPrint(){
    
}

//Helpers
void RedBlackTree::insertBST(string str){
	Node* newNode = new Node(str); //create new node
	// Tree is empty
	if(root == NULL){
		root = newNode;
	}
	else{ //tree not empty
		Node* parent = root;
		bool inserted = false;
		// Find correct position and insert node
		while(!inserted){
			if(str < parent->data.getWord()){ //go left
				if(parent->left == NULL){ //found a leaf
					parent->left = newNode;
					inserted = true;
				}else{
					parent = parent->left; //progress down tree
				}
			} // end if(s < parent->data)
			else { // s >= parent->data i.e. go right
				if(parent->right == NULL){ //found a leaf
					parent->right = newNode;
					inserted = true;
				}else{
					parent = parent->right; //progress down tree
				}
			}// end else (s >= parent->data)
		}// end while
	}// end if root ... else
	size++;
        //insert
}

//Method that performs a left rotation on the parameter of node x. 
void RedBlackTree::LeftRotate(Node* x){
    //Temp pointer holder for x's right child
    Node *y; 
    y = x->right;
    x->right = y->left;
    if (y->left != NULL) {y->left->parent = x;}
    y->parent = x->parent;
    if (x->parent == NULL) {root = y;}
    else{
        if (x == x->parent->left) {x->parent->left = y;}
        else {x->parent->right = y;}
    }
    y->left = x;
    x->parent = y;
}

//Method that performs a right rotation on the parameter of node x.
void RedBlackTree::RightRotate(Node* x){
    //Temp pointer holder for x's left child
    Node *y;
    y = x->left;
    x->left = y->right;
    if (y->right != NULL) {y->right->parent = x;}
    y->parent = x->parent;
    if (x->parent == NULL) {root = y;}
    else{
        if (x == x->parent->right) {x->parent->right = y;}
        else {x->parent->left = y;}
    }
    y->right = x;
    x->parent = y;
}
