//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 2
//
// This is the implementation file for the City class, City.cpp.
//
// Version: 2.0
// Last updated: Oct. 14, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#include "City.h"


//Constructor: Default constructor
//Sets the city and country names as empty strings
//Sets the latitude and longitude values as 0 degrees
City::City(){

	//Initialize default attributes
	name = "";
	country = "";
	latitude = 0.0;
	longitude = 0.0;
}


//Constructor: Contructor for setting the city and country names, and the latitude and longitude values
City::City(string cityName, string countryName, double latitudeValue, double longitudeValue){
	
	//Check if the latitude and longitude values are within the required range 
	if(fabs(latitudeValue) > 90){
		
		//Latitude must be in the range [-90 degrees, 90 degrees].
		//Positive angles represent north latitudes and negative angles represent
		//south latitudes
		throw invalid_argument("Latitude is not between -90 and 90 degrees.");

	} else if(fabs(longitudeValue) > 180){
		//Longitude must be in the range [-180 degrees, 180 degrees].
		//Positive angles represent east longitudes and negative angles represent
		//west longitudes
		throw invalid_argument("Longitude is not between -180 and 180 degrees.");
	}

	//Assign the attributes with the given parameters
	name = cityName;
	country = countryName;

	if(latitudeValue == -0.0){
		//If the latitude value is given as -0, then remove the 
		//negative sign to prevent any potential confusion for the user
		latitude = fabs(latitudeValue);
	} else{
		latitude = latitudeValue;
	}

	if(longitudeValue == -0.0){
		//If the latitude value is given as -0, then remove the 
		//negative sign to prevent any potential confusion for the user
		longitude = fabs(longitudeValue);
	} else{
		longitude = longitudeValue;
	}
}


//Constructor: Constructor for setting the city and country names
//Sets the latitude and longitude to 0 degrees by default
City::City(string cityName, string countryName){

	//Assign the string attributes with the given parameters
	name = cityName;
	country = countryName;

	//Initialize default attributes
	latitude = 0.0;
	longitude = 0.0;
}


//Destructor: Default destructor
City::~City(){
}


//Getter Method: Returns the city name
string City::getName() const{
	return name;
}


//Getter Method: Returns the country name
string City::getCountry() const{
	return country;
}


//Getter Method: Returns the latitude value
double City::getLatitude() const{
	return latitude;
}


//Getter Method: Returns the longitude value
double City::getLongitude() const{
	return longitude;
}


//Overloaded Operator: "Less than" operator
//Check if the calling city (and country) name is alphabetically 
//less than the name of anotherCity (and its country)
bool City::operator<(const City & anotherCity) const{

	//First, check if either the calling city or anotherCity is undefined
	//(i.e. as empty strings initialized from the default constructor)
	if(name.empty() || anotherCity.name.empty()){

		//Throw an invalid_argument error if at least one of the cities are empty
		//because comparing an undefined city with another city is not meaningful
		throw invalid_argument("Can't compare with an undefined city.");

	} else if(name < anotherCity.name){
		//If both cities are defined, then compare the two cities
		return true;

	} else if((name == anotherCity.name) && (country < anotherCity.country)){
		//If the two cities match, then compare their oountries
		return true;

	} else{
		//Otherwise, the calling city is >= anotherCity
		return false;
	}
}


//Overloaded Operator: "Greater than" operator
//Check if the calling city (and country) name is alphabetically 
//greater than the name of anotherCity (and its country)
bool City::operator>(const City & anotherCity) const{

	//First, check if either the calling city or anotherCity is undefined
	//(i.e. as empty strings initialized from the default constructor)
	if(name.empty() || anotherCity.name.empty()){

		//Throw an invalid_argument error if at least one of the cities are empty
		//because comparing an undefined city with another city is not meaningful
		throw invalid_argument("Can't compare with an undefined city.");

	} else if(name > anotherCity.name){
		//If both cities are defined, then compare the two cities
		return true;

	} else if((name == anotherCity.name) && (country > anotherCity.country)){
		//If the two cities match, then compare their oountries
		return true;

	} else{
		//Otherwise, the calling city is <= anotherCity
		return false;
	}
}


//Overloaded Operator: "Less than or equal to" operator
//Check if the calling city (and country) name is alphabetically less than
//or the same as the name of anotherCity (and its country)
bool City::operator<=(const City & anotherCity) const{

	//The negation of "<=" is ">". So use the same implementation of
	//the ">" operator, but negate all the return statements

	//First, check if either the calling city or anotherCity is undefined
	//(i.e. as empty strings initialized from the default constructor)
	if(name.empty() || anotherCity.name.empty()){

		//Throw an invalid_argument error if at least one of the cities are empty
		//because comparing an undefined city with another city is not meaningful
		throw invalid_argument("Can't compare with an undefined city.");

	} else if(name > anotherCity.name){

		//If both cities are defined, then compare the two cities
		return false;

	} else if((name == anotherCity.name) && (country > anotherCity.country)){
		//If the two cities match, then compare their oountries
		return false;

	} else{
		//Otherwise, the calling city is <= anotherCity
		return true;
	}
}


//Overloaded Operator: "Greater than or equal to" operator
//Check if the calling city (and country) name is alphabetically greater than
//or the same as the name of anotherCity (and its country)
bool City::operator>=(const City & anotherCity) const{

	//The negation of ">=" is "<". So use the same implementation of
	//the "<" operator, but negate all the return statements

	//First, check if either the calling city or anotherCity is undefined
	//(i.e. as empty strings initialized from the default constructor)
	if(name.empty() || anotherCity.name.empty()){

		//Throw an invalid_argument error if at least one of the cities are empty
		//because comparing an undefined city with another city is not meaningful
		throw invalid_argument("Can't compare with an undefined city.");

	} else if(name < anotherCity.name){
		//If both cities are defined, then compare the two cities
		return false;

	} else if((name == anotherCity.name) && (country < anotherCity.country)){
		//If the two cities match, then compare their oountries
		return false;

	} else{
		//Otherwise, the calling city is >= anotherCity
		return true;
	}
}


//Overloaded Operator: "Equal to" operator
//Checks if the two cities (and countries) are the same place
bool City::operator==(const City & anotherCity) const{
	
	//If only one of the two cities are undefined (i.e. as empty strings 
	//initialized from the default constructor), then the two cities
	//count as not equivalent to each other. However, if both cities are
	//undefined, then throw an invalid_argument error as the comparison
	//is inconclusive
	if(name.empty() && anotherCity.name.empty()){
		//Both cities are undefined
		throw invalid_argument("Unable to compare between two undefined cities.");

	} else if( (name == anotherCity.name) && (country == anotherCity.country) ){
		//Check if the cities and countries match up
		return true;

	} else{
		//Otherwise, the two cities are not the same
		return false;
	}
}


//Overloaded Operator: "Not equal to" operator
//Checks if the two cities (and countries) are different places
bool City::operator!=(const City & anotherCity) const{

	//The negation of "!=" is "==". So use the same implementation of
	//the "==" operator, but negate all the return statements

	//If only one of the two cities are undefined (i.e. as empty strings 
	//initialized from the default constructor), then the two cities
	//count as not equivalent to each other. However, if both cities are
	//undefined, then throw an invalid_argument error as the comparison
	//is inconclusive
	if(name.empty() && anotherCity.name.empty()){
		//Both cities are undefined
		throw invalid_argument("Unable to compare between two undefined cities.");
	
	} else if( (name == anotherCity.name) && (country == anotherCity.country) ){
		//Check if the cities and countries match up
		return false;

	} else{
		//Otherwise, the two cities are not the same
		return true;
	}
}


//Overloaded Operator: Displays the city's location and name
//Prints the city attributes as "<name>, <country> <latitude> N/S, <longitude> W/E"
ostream & operator<<(ostream & os, const City & aCity){

	if(aCity.name.empty()){
		
		//If aCity is not defined (i.e. as empty strings initialized from the default constructor),
		//then save the message "Unknown location: Undefined city and country names." to the output stream
		os << "Unknown location: Undefined city and country names." << endl;

	} else {

		//Save the city and country names to the output stream
		os << aCity.name << ", " << aCity.country << " ";

		//Save the latitude value to the output stream
		os << aCity.latitude << " ";
		if(aCity.latitude >= 0.0){
			//Prints out North for positive (zero included) latitude values
			os << "N, ";
		} else{
			//Prints out South for negative latitude values
			os << "S, ";
		}

		//Save the longitude value to the output stream
		os << aCity.longitude << " ";
		if(aCity.longitude >= 0.0){
			//Prints out East for positive (zero included) longitude values
			os << "E" << endl;
		} else{
			//Prints out West for negative longitude values
			os << "W" << endl;
		}
	}

	//Returns the output stream
	return os;
}