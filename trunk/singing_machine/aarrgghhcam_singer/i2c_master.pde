#include <Wire.h> 

#include "i2c_commands.h"


int i2c_read_8(int slaveAddress, int command) ;
boolean toggle = false;

void initAargcamMaster(void)
{
  pinMode(13, OUTPUT);//Status led
  #ifndef SIMULATE_AARGCAM
  Wire.begin(); // start i2c as master
  // Arduino analog input 5 - I2C SCL
  // Arduino analog input 4 - I2C SDA
  #endif


}


void readAargcam(void)
{
  #ifdef SIMULATE_AARGCAM
    int p  = simulateAargcam();
    if( p >  0 )
      aargcamLinePosition = p;
      
  #else
    aargcamLinePosition = i2c_read_8( AARGCAM_I2C_ADDRESS, AARGCAM_I2C_READ_COMMAND ) ;
  #endif
  
  
  digitalWrite(13,toggle); //Status LED...
  toggle = ! toggle;
   
  #ifdef DO_LOGGING
     Serial.print ("read_aargcam - pos: ");

    Serial.print (aargcamLinePosition); 
    Serial.print ("\n");
     
   #endif
   
  
}

#ifdef SIMULATE_AARGCAM


int simulateAargcam()
{
  static long nextGPSSimTime = 0;
  static int nextPos = 0;
  
  long now = millis();
  
  if( now < nextGPSSimTime )
    return -1; 
    
 
   
  nextPos ++;
  
   if( nextPos > 127 )
   {
     nextPos = 0;
    
   }

  
  nextGPSSimTime = now + 1000; // millisecs between simulated positions

  return nextPos;
    
}
#endif

// from http://www.neufeld.newton.ks.us/electronics/?p=241



int i2c_read_8(int slaveAddress, int command) 
{
  int data = 0;

  //  Send input register address
  Wire.beginTransmission(slaveAddress);
  Wire.send(command);
  Wire.endTransmission();

  //  Connect to device and request two bytes
  //Wire.beginTransmission(address);  Compass hat didn't need this
  Wire.requestFrom(slaveAddress, 1); // asking for 1 bytes

  if (Wire.available()) 
    data = Wire.receive();
  else
    data= -1;
  
  /*
  if (Wire.available()) {
    data |= Wire.receive() << 8;
  }
*/
  //Wire.endTransmission();

  return data;
}

