/* 
 * File:   WordCount.h
 * Author: Benjamin
 *
 * Created on October 30, 2011, 3:02 PM
 */

#ifndef WORDCOUNT_H
#define	WORDCOUNT_H
#include <iostream>
#include <string>
#include <fstream>
#include <iterator>
#include <algorithm>
#include <vector>
#include <stdexcept>

using namespace std;

class WordCount {
public:
    //Default empty constructor
    WordCount();
    //Constructor take in word as string parameter 
    WordCount(string w);
    //Constructor take in word as string parameter and frequency as integer 
    //parameter
    WordCount(string w, int f);
    //function that decrement frequency
    void decrement();
    //function that increment frequency
    void increment();
    //Getters return information 
    string getWord();
    int getFrequency();

    //Overloaded Operators
    bool operator<(const WordCount & w) const;
    bool operator>(const WordCount & w) const;
    bool operator <=(const WordCount & w) const;
    bool operator >=(const WordCount & w) const; //done
    bool operator ==(const WordCount & w) const;
    bool operator !=(const WordCount & w) const;

    //Display the City parameters
    friend ostream & operator<<(ostream & os, const WordCount & w);

    //Destructor
    ~WordCount();
private:
    string word;
    int frequency;

};

#endif	/* WORDCOUNT_H */

