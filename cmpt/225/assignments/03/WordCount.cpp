/* 
 * File:   WordCount.cpp
 * Author: Benjamin
 * 
 * Created on October 30, 2011, 3:02 PM
 */

#include "WordCount.h"

using namespace std;

//Default empty Constructor sets word/frequency to ("" and 0)
WordCount::WordCount() {
    word = "";
    frequency = 1;
}

//Constructor that set word as a string parameter.
WordCount::WordCount(string w) {
    word = w;
    frequency = 1;
}

//Constructor that set word as a string parameter and frequency as an integer
//parameter
WordCount::WordCount(string w, int f) {
    word = w;
    try {
        if (f < 0) {
            throw std::invalid_argument("Frequency value cannot be negative");
        }
    } catch (std::invalid_argument errorMessageVariable) {
        cout << errorMessageVariable.what() << endl;
    }
    frequency = f;
}

//Decrement the frequency parameter every time its called
//Runtime error occurs when frequency is less than 0
void WordCount::decrement(){
    frequency--;
    try {
        if (frequency <0) {
            throw std::runtime_error("Frequency value is 0, it cannot be decremented");
        }
    } catch (std::invalid_argument errorMessageVariable) {
        cout << errorMessageVariable.what() << endl;
    }
}

//Increment the frequency parameter every time its called
void WordCount::increment(){
    frequency++;
}

//Return value of word parameter
string WordCount::getWord(){
    return word;
}

//Return value of frequency parameter
int WordCount::getFrequency(){
    return frequency;
}

//Overloaded Operators

//Overloaded operator < returns true/false given conditions
bool WordCount::operator <(const WordCount& w) const{
    if (word >= w.word)
    {
        return false;
    }
    else{
        return true;
    }
}

//Overloaded operator > returns true/false given conditions
bool WordCount::operator >(const WordCount& w) const{
    if (word <= w.word){
        return false;
    }
    else{
        return true;
    }
}

//Overloaded operator <= returns true/false given conditions
bool WordCount::operator <=(const WordCount& w) const{
    if (word > w.word){
        return false;
    }
    else{
        return true;
    }
}

//Overloaded operator >= returns true/false given conditions
bool WordCount::operator >=(const WordCount& w) const{
    if (word < w.word){
        return false;
    }
    else{
        return true;
    }
}

//Overloaded operator == returns true/false given conditions
bool WordCount::operator ==(const WordCount& w) const{
    if (word == w.word){
        return true;
    }
    else{
        return false;
    }
}

//Overloaded operator != returns true/false given conditions
bool WordCount::operator !=(const WordCount& w) const{
    if (word != w.word){
        return true;
    }
    else{
        return false;
    }
}

//Overload operator << return false/true depending on conditions
ostream & operator<<(ostream & os, const WordCount & w){
    //Condition where empty constructor is used. No word attribute defined.
    if (w.word.empty()){
        os << "Invalid, no parameters given." << endl;
    }
    //Print the words to the output console.
    else {
        os << w.word << " ";
        //Print the distinguish latitude position (N/S) to the output console.
        os << w.frequency << " ";
    }
}

WordCount::~WordCount() { 
}

