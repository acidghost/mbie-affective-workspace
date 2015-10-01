/*
 Reads two analog input pins; a T000020 Accelerometer Module with the x-axis connected to I0 pin
 the y-axis connected to the I1 pin, uses the result to set the brightness of two T010111 LED Module 
 connected on O0 and O1. Also prints the results to the serial monitor.
 http://www.tinkerkit.com/accelerometer/
 
 created on Dec 2011
 by Federico Vanzati
 modified in Jul 2013 
 by Matteo Loglio
 This example code is in the public domain.
 */

// include the TinkerKit library
#include <TinkerKit.h>

TKAccelerometer accelerometer(I0, I1);  // creating the object 'accelerometer' that belongs to the 'TKAccelerometer' class 
                                  // and giving the values to the desired input pins

float xAxisValue = 0;           // a variable to store the accelerometer's x value
float yAxisValue = 0;           // a variable to store the accelerometer's y value
int angleXY = 0;

void setup() 
{
  // initialize serial communications at 9600 bps
  Serial.begin(9600);
}

void loop()
{
  // read the both joystick axis values:
  xAxisValue = accelerometer.readXinG();  
  yAxisValue = accelerometer.readYinG(); 
  
  // angleXZ = 180*atan2(x,z)/PI;
  angleXY = 180 * atan2(xAxisValue, yAxisValue) / PI;
  // angleYZ = 180*atan2(y,z)/PI;

  // print the results to the serial monitor:
  Serial.print("Accelerometer X = " );                       
  Serial.print(xAxisValue);   
  Serial.print("\t Accelerometer Y = " );                       
  Serial.print(yAxisValue);
  Serial.print("\t Angle = ");
  Serial.println(angleXY);

  // wait 100 milliseconds before the next loop
  delay(100);    
}

