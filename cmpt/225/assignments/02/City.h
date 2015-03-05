//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 2
//
// This is the definition file for the City class, City.h.
//
// Version: 1.4
// Last updated: Oct. 14, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#ifndef _CITY_H_
#define _CITY_H_

#pragma once
#include <cmath>
#include <stdexcept>
#include <iostream>
#include <string>
using namespace std;


//City class
class City{
public:

	//Constructors
	City(); //default constructor
	City(string cityName, string countryName, double latitudeValue, double longitudeValue); //second constructor
	City(string cityName, string countryName); //third constructor
	
	//Destructor
	~City();

	//Setters
	//None

	//Getter Methods
	string getName() const;
	string getCountry() const;
	double getLatitude() const;
	double getLongitude() const;

	//Overloaded Operators:
	//Comparison Operators for city and country names
	bool operator<(const City & anotherCity) const; //less than
	bool operator>(const City & anotherCity) const; //greater than
	bool operator<=(const City & anotherCity) const; //less than or equal to
	bool operator>=(const City & anotherCity) const; //greater than or equal to
	bool operator==(const City & anotherCity) const; //is equal to
	bool operator!=(const City & anotherCity) const; //is not equal to

	//Display Operator
	friend ostream & operator<<(ostream & os, const City & aCity);

private:
	
	//City and country names
	string name; //name of the city
	string country; //name of the country where the city belongs to
	
	//Latitude and longitude values. Latitude and longitude requirements
	//are explained in the implementation of the second constructor
	double latitude; //latitude of the city in degrees
	double longitude; //longitude of the city in degrees
};

#endif