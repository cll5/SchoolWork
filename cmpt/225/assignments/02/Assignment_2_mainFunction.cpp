//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 2
//
// This file contains the main function for the assignment.
//
// Version: 3.0
// Last updated: Oct. 22, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#pragma once
#include "CityList.h"

//Forward Declaration
void continueRunning(string printMsg);
void searchCity(const CityList & aCityList, string cityName, string countryName);
CityList readFile();

//Main function
int main(){

	//Continue and Exit Print Messages Declaration
	string continueMsg = "Please press any key and hit the ENTER key to continue: ";
	string exitMsg = "Please press any key and hit the ENTER key to exit: ";

	try{

		//Variable Declarations
		CityList aCityList;

		//Print an introduction message
		cout << "*********************************************" << endl;
		cout << "CMPT 225 - Assignment 2" << endl << endl;
		cout << "Written by: Chuck Lee" << endl;
		cout << "*********************************************" << endl << endl;

		//Task 1: Prompt the user to enter the name of a file containing city data and read it
		aCityList = readFile();

		//Task 2: Print the list
		aCityList.printList();
		continueRunning(continueMsg);

		//Task 3: Search the unsorted list for Vancouver, Canada
		cout << "Searching Vancouver, Canada:" << endl;
		searchCity(aCityList, "Vancouver", "Canada");

		//Task 4: Search the unsorted list for Bradford, UK
		cout << "Searching Bradford, UK:" << endl;
		searchCity(aCityList, "Bradford", "UK");

		//Task 5: Search the sorted list for DolAmroth, Gondor
		cout << "Searching DolAmroth, Gondor:" << endl;
		searchCity(aCityList, "DolAmroth", "Gondor");
		continueRunning(continueMsg);
		
		//Task 6: Sort the list
		cout << "Sorting the list of cities...";
		aCityList.sort();
		cout << " COMPLETED.";
		continueRunning(continueMsg);

		//Task 7: Search the sorted list for Paris, France
		cout << "Searching Paris, France:" << endl;
		searchCity(aCityList, "Paris", "France");

		//Task 8: Search the sorted list for Edoras, Rohan
		cout << "Searching Edoras, Rohan:" << endl;
		searchCity(aCityList, "Edoras", "Rohan");

		//Task 9: Search the sorted list for Dresden, Germany
		cout << "Searching Dresden, Germany:" << endl;
		searchCity(aCityList, "Dresden", "Germany");
		continueRunning(continueMsg);
		
		//Task 11: Print the entire sorted list
		aCityList.printList();

		//Print an exit message
		cout << endl << "Assignment 2 Completed.";
	}
	catch(invalid_argument errorMsg){
		//Print out the error message
		cout << "Invalid argument: " << errorMsg.what() << endl << endl;
	}

	continueRunning(exitMsg);
	return 0;
}


//Continue Running Function: 
//Used to pause between each major section of the program
//and ask the user to press any key to continue to the next section
void continueRunning(string printMsg){

	//Variable declaration
	char anyKey;

	//Prompt user to press any key to continue
	cout << endl << printMsg;
	cin >> anyKey; //wait for user input something to continue on

	cout << endl << endl; //add extra blank spaces for clarity purposes
}


//Search a City Function:
//Searches a city based on the given city and country names, and either
//inform the user that the city was not found or print out its location if it
//was found
void searchCity(const CityList & aCityList, string cityName, string countryName){

	//Variable declaration
	City* cityPointer;
	CityList copyCityList = aCityList; //make a copy of the referenced city list

	//Search for the city
	cityPointer = copyCityList.search(cityName, countryName);
		
	//If the city was not found in the list of cities, inform the user.
	//Otherwise, print out the city and its location
	if(cityPointer == NULL){
		cout << cityName << ", " << countryName << " was not found in the list of cities." << endl << endl;
	} else{
		cout << *cityPointer << endl;
	}
}


//Read a City List File Function:
//Prompt the user to enter the name of a file containing the city data
//and read this file into a CityList object
CityList readFile(){

	//Variables Declaration
	CityList aCityList;
	string fileName;

	//Prompt the user to input the name of the city data file
	cout << "Please type in the name of the file containing the city data:" << endl;
	cin >> fileName;
	cout << endl << endl; //add extra blank spaces for clarity purposes

	//Read the file
	aCityList.read(fileName);

	//Return the CityList object
	return aCityList;
}