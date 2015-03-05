/* 
 * File:   RedBlackTree.h
 * Author: Benjamin
 *
 * Created on October 30, 2011, 3:02 PM
 */

#ifndef REDBLACKTREE_H
#define	REDBLACKTREE_H
#include "WordCount.h"
#include <string>


using namespace std;

class RedBlackTree {
public:
    RedBlackTree(); //Default empty constructor
    RedBlackTree(const RedBlackTree &rbt); //Deep copy Constructor
    
    ~RedBlackTree(); //Destructor
    
    //Mutators
    void insert(string str); 
    int remove(string str);
    int deletes(string str);
    int search(string str);
    void deleteAll();
    void inOrderPrint();
     
private:
    /**********************************************/
    class Node{
    public: 
        //Attributes
        WordCount data;
        Node *left;
        Node *right;
        Node *parent;
        bool isBlack; //True if black, false if red
        //Constructors
        Node() : data(), left(NULL), right(NULL), parent(NULL), isBlack(false)     {;}; //Default Constructor
        Node(string s) : data(s), left(NULL), right(NULL), parent(NULL), isBlack(false) {;}; //Constructor that takes in a string parameter
        void decrement(){
            data.decrement();
        };
        void increment(){
            data.increment();
        };
    }; 
    /**************************************************/
    //Attributes
    Node *root;
    int size; //Number of nodes in the tree.
    
    //Helpers
    void RightRotate(Node *x);               // performs right rotation at node x
    void LeftRotate(Node *x);               // performs left rotation at node x
    //void insertFix(Node *x);        // fixes tree if Red-BT rules are violated
    void insertBST(string str);
    void deleteFix(Node *x);
};



#endif	/* REDBLACKTREE_H */

