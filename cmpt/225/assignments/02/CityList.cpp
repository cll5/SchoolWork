//*************************************************************************************//
// CMPT 225 - ASSIGNMENT 2
//
// This is the implementation file for the CityList class, CityList.cpp.
//
// Version: 3.0
// Last updated: Oct. 22, 2011
//
// Written by: Chuck Lee
// SFU ID#: 301054031
// SFU ID: cll5
// Lab Section: D204
//*************************************************************************************//

#include "CityList.h"


//Constructor: Default constructor
CityList::CityList(){

	//Default attribute settings
	arr = NULL;
	sz = 0;
	max_sz = 0;
	sorted = false;
}


//Copy Constructor: Make a deep copy of the given City list
CityList::CityList(const CityList & aCityList){

	//Make a copy of the original City list's attributes
	sz = aCityList.sz;
	max_sz = aCityList.max_sz;
	sorted = aCityList.sorted;
	
	//Create a new empty City array of the same size as the original City list
	arr = new City[max_sz];

	//Copy the elements from the original City list to the new City array
	for(int index = 0; index < sz; index++){
		arr[index] = aCityList.arr[index];
	}
}


//Destructor: De-allocates dynamic memory allocated to the underlying array
CityList::~CityList(){

	//De-allocate the dynamic array
	delete[] arr;

	//Reset the other attributes to default settings
	sz = 0;
	max_sz = 0;
	sorted = false;
}


//Search Method: Searches a city from the underlying array
//Implemented with recursive binary search and iteractive linear search
City* CityList::search(string cityName, string countryName){

	//If the sorted flag is true, then use binary search algorithm
	//to find the city. Otherwise, use the linear search algorithm
	//to find the city
	int cityIndex; //declare an array index for the city to find
	if(sorted == true){
		cityIndex = binarySearch(arr, 0, (sz - 1), cityName, countryName);
	} else{ //sorted == false
		cityIndex = linearSearch(arr, sz, cityName, countryName);
	}

	if(cityIndex == -1){
		//Given city does not exist in the array, return NULL to represent false
		return NULL;
	} else{
		//Given city was found at the cityIndex'th slot of the array, return its address
		return & arr[cityIndex];
	}
}


//Sorting Method: Sorts all the cities stored in the underlying array in alphabetical order
//Implemented with the quicksort algorithm
void CityList::sort(){

	//Check if the underlying array is sorted or not.
	//If unsorted, then sort the array. Otherwise, don't do anything
	if(sorted == false){

		//Perform quicksort on the underlying array
		quickSort(arr, 0, (sz - 1));

		//Set the sorted flag to be true after sorting the underlying array
		sorted = true;
	}
}


//Import CityList Method: Reads a file of cities into the city array
//Invalid_argument errors are thrown if the file does not exist in the directory or
//if the file is not formatted properly
void CityList::read(string cityFileName){

	//Variable Declarations: Used to read the file content as inputs
	string cityName;
	string countryName;
	double latitudeValue;
	double longitudeValue;


	//First, de-allocate any dynamic memory allocated to the underlying array
	delete[] arr;
	max_sz = 0;
	sorted = false;

	//Then, create the file stream object with the given file name
	ifstream cityFile(cityFileName.c_str());

	//Check if the city file exist. Throw an invalid_argument error 
	//if the file is not found
	if(cityFile.fail()){
		throw invalid_argument("File not found in the directory.");
	}

	//Read the file first to get the size for the underlying array
	while(!cityFile.eof()){

		//Read the file one line at a time and increment max_sz
		cityFile >> cityName >> countryName >> latitudeValue >> longitudeValue;
		max_sz++;
		
		//Check if the current line is formatted incorrectly, If so,
		//throw an invalid_argument error
		if(!cityFile){
			throw invalid_argument("Invalid file format.");
		}
	}

	//Close the city file and clear the stream before reading it again
	cityFile.close();
	cityFile.clear();

	//Assign the sz attribute with max_sz and allocate dynamic memory
	//for the underlying array
	sz = max_sz;
	arr = new City[max_sz];

	//Re-open the city file for reading
	cityFile.open(cityFileName.c_str());

	//Read the file contents into the underlying array
	for(int index = 0; index < sz; index++){
		cityFile >> cityName >> countryName >> latitudeValue >> longitudeValue;
		arr[index] = City(cityName, countryName, latitudeValue, longitudeValue);
	}

	//Close the city file
	cityFile.close();
}


//Print Method: Displays all city in the city array
//Prints out one city per line using the City class overloaded operator
void CityList::printList(){

	//Print a starting message
	cout << "The list of cities are:" << endl;
	
	//Print the cities iteratively
	for(int index = 0; index < sz; index++){
		cout << arr[index];
	}

	//Print a blank space for clarity purposes
	cout << endl;
}


//Overloaded Operator: Assignment operator
//Makes a deep copy of the calling City list
void CityList::operator=(const CityList & aCityList){

	//First, de-allocate any dynamic memory that is allocated to the underlying array
	delete[] arr;

	//Copy the attributes of the calling City list
	sz = aCityList.sz;
	max_sz = aCityList.max_sz;
	sorted = aCityList.sorted;

	//Allocate dynamic memory for the new City array
	arr = new City[max_sz];
	
	//Copy the elements from the calling City list to the new City array
	for(int index = 0; index < sz; index++){
		arr[index] = aCityList.arr[index];
	}
}


//Linear Search Function:
//Implemented for the iterative approach
int CityList::linearSearch(City cityArray[], int numOfCity, string cityName, string countryName){

	//Perform linear search
	for(int index = 0; index < numOfCity; index++){
		if((cityArray[index].getName() == cityName) && (cityArray[index].getCountry() == countryName)){
			
			//Found the desired City
			return index;
		}
	}

	//City was not found in the array
	return -1;
}


//Binary Search Function:
//Implemented for the recursive approach
int CityList::binarySearch(City cityArray[], int lowIndex, int highIndex, string cityName, string countryName){

	//Calculate the middle index between lowIndex and highIndex
	int midIndex = (lowIndex + highIndex)/2;

	//Perform binary search
	if(lowIndex > highIndex){
		//Base case #1: City not found in the array
		return -1;

	} else if((cityArray[midIndex].getName() == cityName) && (cityArray[midIndex].getCountry() == countryName)){
		//Base case #2: City found
		return midIndex;
	
	} else if(cityName > cityArray[midIndex].getName()){
		//Branch to the indices [(midIndex + 1), highIndex] for the next search
		return binarySearch(cityArray, (midIndex + 1), highIndex, cityName, countryName);

	} else{ //cityName < cityArray[midIndex].getName()
		//Branch to the indices [lowIndex, (midIndex - 1)] for the next search
		return binarySearch(cityArray, lowIndex, (midIndex - 1), cityName, countryName);
	}
}


//Quicksort Function:
//Implemented using recursion
void CityList::quickSort(City cityArray[], int lowIndex, int highIndex){

	//Declare the pivot index variable
	int pivot;

	//Recursive case
	if(lowIndex < highIndex){
		//Partition the current sub-array with the format [less than pivot, pivot, greater than pivot]
		pivot = partition(cityArray, lowIndex, highIndex);

		//Perform quicksort to the sub-array on the left of the pivot
		quickSort(cityArray, lowIndex, (pivot - 1));

		//Perform quicksort to the sub-array on the right of the pivot
		quickSort(cityArray, (pivot + 1), highIndex);
	}
	//Implicit base case: if lowIndex >= highIndex, do nothing
}


//Partition Function for Quicksort:
//Implemented iteratively
int CityList::partition(City cityArray[], int lowIndex, int highIndex){
	
	//Variable declarations
	//Array index variables
	int low = lowIndex;
	int high = highIndex - 1;
	int pivot = highIndex;

	//Temporary storage when swapping array elements
	City temp;

	//Perform partitioning
	while(low < high){
		
		if(cityArray[low] <= cityArray[pivot]){
			
			//Increment index low by one if its city is alphabetically less than or equal to that at index pivot
			low++;
		
		} else if((cityArray[low] > cityArray[pivot]) && (cityArray[high] > cityArray[pivot])){
			
			//Otherwise, decrement index high by one if its city is alphabetically greater than that at index index pivot
			high--;
		
		} else if((cityArray[low] > cityArray[pivot]) && (cityArray[high] <= cityArray[pivot])){
			
			//Swapping condition is met:
			//The city at index low is alphabetically greater than that at index pivot, and
			//the city at index high is alphabetically less than or equal to that at index pivot.
			//Swap the city at index low with that at index high
			temp = cityArray[low];
			cityArray[low] = cityArray[high];
			cityArray[high] = temp;

			//Then increment index low by one
			low++;
		}
	}

	//Now, index low equals index high.
	//Keep incrementing the low index until its city is alphabetically greater than that at index pivot
	while( (cityArray[low] <= cityArray[pivot]) && (low < pivot) ){

		//Increment index low by one if its city is alphabetically less than or equal to that at index pivot
		low++;
	}

	if(cityArray[low] > cityArray[pivot]){
		//The city at index low is alphabetically greater than that at index pivot.
		//Thus, swap the city at index low with that at index pivot
		temp = cityArray[pivot];
		cityArray[pivot] = cityArray[low];
		cityArray[low] = temp;
		
		//Update the pivot index
		pivot = low;
	} 
	//Else, the city at index low is alphabetically less than or equal to that 
	//at index pivot. Thus, don't do anything.

	//Return the new pivot index
	return pivot;
}