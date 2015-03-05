/*****************************************************************
 Final Project - Generative Fractal Vector Art
 
 Class Name: ComplexNumber
 
 Description:
 This class represents a complex number or variable. It contains methods
 to manipulate between two complex variables.
 
 
 Version: 1.0
 Created: Nov. 13, 2011
 Last updated: Dec. 07, 2011
 
 Written by: Chuck Lee
 SFU ID No.: 301054031
 Email: cll5@sfu.ca
 Lab Section: D104
 ******************************************************************/



class ComplexNumber{
  
  //-- Fields --------------------------------//
  //------------------------------------------//
  
  //-- Constants: --//
  //----------------//
  //  None
  
  //-- Variables: --//
  //----------------//
  private PVector z;    //The complex number, z
  
  
  
  //-- Public Methods --------------------------------//
  //--------------------------------------------------//
  
  //-- Constructor: --//
  //------------------//
  
  //Constructor to pass the real and imaginary parts of the complex number, z as arguments such that
  //z = realPart + (j * imaginaryPart), where j is the imaginary number (i.e., j = square root of -1)
  //
  //Input parameters:
  //  realPart      - the real part of the complex number
  //  imaginaryPart - the imaginary part of the complex number
  //
  //Output parameter:
  //  None
  ComplexNumber(float realPart, float imaginaryPart){
    z = new PVector(realPart, imaginaryPart);
  }
  
  
  
  //-- Setters: --//
  //--------------//
  
  //Sets the real part of the complex number, z
  //
  //Input parameter:
  //  realPart - the real part of the complex number, z
  //
  //Output parameter:
  //  None
  public void setRealPart(float realPart){
    z.x = realPart;
  }
  
  
  //Sets the imaginary part of the complex number, z
  //
  //Input parameter:
  //  imaginaryPart - the imaginary part of the complex number, z
  //
  //Output parameter:
  //  None
  public void setImaginaryPart(float imaginaryPart){
    z.y = imaginaryPart;
  }
  
  
  
  //-- Getters: --//
  //--------------//
  
  //Returns the real part of the complex number, z
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Real part of the complex number
  public float getRealPart(){
    return z.x;
  }
  
  
  //Returns the imaginary part of the complex number, z
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Imaginary part of the complex number
  public float getImaginaryPart(){
    return z.y;
  }
  
  
  //Returns the magnitude of the complex number, z
  //Magnitude of z = square root of ( (real part)^2 + (imaginary part)^2 )
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Magnitude of the complex number
  public float getMagnitude(){
    return sqrt(sq(z.x) + sq(z.y));
  }
  
  
  //Returns the argument of the complex number, z (i.e., the angle of z)
  //Argument of z = arctangent of ( imaginary part / real part )
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Argument of the complex number, z
  public float getArgument(){
    return atan2(z.y, z.x);
  }
  
  
  
  //-- Other Methods: --//
  //--------------------//
  
  //Add operation for complex number, z
  //Sum of two complex number = (sum of the real parts)  +  j*(sum of the imaginary parts)
  //
  //Input parameter:
  //  aComplexNumber - the complex number to add to z
  //
  //Output parameter:
  //  Returns the sum of the two complex numbers
  public ComplexNumber add(ComplexNumber aComplexNumber){
    ComplexNumber result = new ComplexNumber( (z.x + aComplexNumber.getRealPart()), (z.y + aComplexNumber.getImaginaryPart()) );
    return result;
  }
  
  
  //Squaring operation for the complex number, z
  //Square of z = ( (real part of z)^2 - (imaginary part of z)^2 )  +  j*(2 * real part of z * imaginary part of z)
  //
  //Input parameter:
  //  None
  //Output parameter:
  //  Returns the square of z
  public ComplexNumber squared(){
    ComplexNumber result = new ComplexNumber( (sq(z.x) - sq(z.y)), (2 * z.x * z.y) );
    return result;
  }
  
  
  
  //-- Private Methods -------------------------------//
  //--------------------------------------------------//
  //  None
}
