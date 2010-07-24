#include <Wire.h> 

#include "i2c_commands.h"


// This file is talking to i2c_master.pde in the aarrgghhcam_singer project


byte lastCommand = 0;
boolean toggle = false;

void initAargcamSlave(void)
{
  pinMode(13, OUTPUT);//Status led

  Wire.begin(AARGCAM_I2C_ADDRESS); // start i2c as master
  // Arduino analog input 5 - I2C SCL
  // Arduino analog input 4 - I2C SDA

  Wire.onRequest(i2cRequestEvent); // register event
  Wire.onReceive(i2CReceiveEvent); 

}


void i2cRequestEvent() // called when master asks for bytes
{
  if( lastCommand == AARGCAM_I2C_READ_COMMAND )
  {
    Wire.send(aargcamLinePosition); // respond with number of bytes
    // as expected by master


    digitalWrite(13,toggle); //Status LED...
    toggle = ! toggle;

  }
#ifdef DO_LOGGING
  Serial.print ("i2cRequestEvent\n");
#endif
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void i2CReceiveEvent(int howMany)
{
  if( Wire.available() > 0)
  {
    lastCommand = Wire.receive();

    howMany --; // is howMany the number the master wants or the number the master is sending ?
  } 
  // This is just to flush any remaining data
  while( Wire.available() > 1) 
  {
    char c = Wire.receive(); // receive byte as a character
    //Serial.print(c);         // print the character
  }

}
