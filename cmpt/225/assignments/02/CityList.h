//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 2
//
// This is the definition file for the CityList class, CityList.h.
//
// Version: 1.5
// Last updated: Oct. 13, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#ifndef _CITYLIST_H_
#define _CITYLIST_H_

#pragma once
#include <cstdlib>
#include <stdexcept>
#include <iostream>
#include <fstream>
#include <string>
#include "City.h"
using namespace std;


//CityList class
class CityList{
public:

	//Constructor
	CityList(); //Default constructor
	CityList(const CityList &); //copy constructor

	//Destructor
	~CityList();

	//Method to search for a city given its name and the country's name
	City* search(string cityName, string countryName);

	//Method to sort the city array using quicksort algorithm
	void sort();

	//Method to read a file of cities into the city array
	void read(string cityFileName);

	//Method to display all city in the city array
	void printList();

	//Overloaded Operator
	void operator=(const CityList & aCityList); //assignment operator

private:

	//Variable declarations
	City* arr; //pointer for the underlying dynamic array
	int sz; //number of cities stored in the array
	int max_sz; //size of the underlying dynamic array
	bool sorted; //flag that keeps track of whether or not the list is sorted

	//Helper functions for the search method
	int linearSearch(City cityArray[], int numOfCity, string cityName, string countryName); //linear search
	int binarySearch(City cityArray[], int lowIndex, int highIndex, string cityName, string countryName); //binary search

	//Helper function for the sort method
	void quickSort(City cityArray[], int lowIndex, int highIndex); //quicksort algorithm
	int partition(City cityArray[], int lowIndex, int highIndex); //partition method for quicksort
};

#endif