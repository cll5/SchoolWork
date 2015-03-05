#pragma once
#include "CityList.h"

int main(){

	try{
		//Variables
		City* winnipeg;
		CityList operatorList;

		//Create an empty
		CityList newList;

		//Read in a file
		newList.read("Sample.txt");

		//Copy constructor
		CityList copyList(newList);

		//Print the list
		newList.printList();

		//Search for Winnipeg, Canada
		winnipeg = newList.search("Winnipeg", "Canada");
		if(winnipeg == NULL){
			cout << "Winnipeg, Canada was not found." << endl << endl;
		} else {
			cout << *winnipeg << endl << endl;
		}


		//Sort the cities
		newList.sort();

		//Print the sorted list
		newList.printList();

		//Search for Winnipeg, Canada
		winnipeg = newList.search("Winnipeg", "Canada");
		if(winnipeg == NULL){
			cout << "Winnipeg, Canada was not found." << endl << endl;
		} else {
			cout << *winnipeg << endl << endl;
		}

		//Print copyList
		copyList.printList();

		//Test assignment operator
		operatorList = newList;

		//Print operatorList
		operatorList.printList();

		//Test assignment operator
		operatorList = copyList;

		//Print operatorList
		operatorList.printList();
	}
	catch(invalid_argument errorMsg){
		cout << "Invalid argument: " << errorMsg.what() << endl;
	}

	char stuff;
	cin >> stuff;
	return 0;
}