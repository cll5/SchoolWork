#pragma once
#include <cstdlib>
#include "City.h"
using namespace std;

int main(){
	
	try{
		City a;
		City b("Vancouver", "Canada", 15.7, -45.3);
		City c("London", "Britain");
		City d("Vancouver", "Canada", -0.00, 0.00);

		cout << "City d: " << d << endl << endl;

		cout << "a.getName(): " << a.getName() << endl;
		cout << "a.getCountry(): " << a.getCountry() << endl;
		cout << "a.getLatitude(): " << a.getLatitude() << endl;
		cout << "a.getLongitude(): " << a.getLongitude() << endl;
		cout << endl;

		cout << "City a: " << a;
		cout << "City b: " << b;
		cout << "City c: " << c;
		cout << "City d: " << d << endl;

		if(a != b){
			cout << "a != b: City a is not city b." << endl;
		}

		if(!(a == b)){
			cout << "!(a == b): City a is not city b." << endl;
		}

		if(c != b){
			cout << "c != b: City c is not city b." << endl;
		}

		if(!(c == b)){
			cout << "!(c == b): City c is not city b." << endl;
		}

		if(b >= c){
			cout << "b >= c: City b is greater than or equal to city c." << endl;
		}

		if(!(b < c)){
			cout << "!(b < c): City b is greater than or equal to city c." << endl;
		}

		if(a != c){
			cout << "a != c: City a is not city c." << endl;
		}

		if(!(a == c)){
			cout << "!(a == c): City a is not city c." << endl;
		}

		if(b > c){
			cout << "b > c: City b is greater than city c." << endl;
		}

		if(!(b <= c)){
			cout << "!(b <= c): City b is greater than city c." << endl;
		}

		if(b == d){
			cout << "b == d: City b is city d." << endl;
		}

		if(!(b != d)){
			cout << "!(b != d): City b is city d." << endl;
		}
	}
	catch(invalid_argument errorMsg){
		cout << "Invalid argument: " << errorMsg.what() << endl;
	}


	char stuff;
	cin >> stuff;

	return 0;
}