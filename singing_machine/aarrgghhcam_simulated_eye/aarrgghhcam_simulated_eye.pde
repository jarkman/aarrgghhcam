#include <Wire.h> 



// This is a test frame that simulated aarrgghhcam_eye without the actual camera being present - it's really just an i2c slave and a tiny simulation routine

#define  DO_LOGGING

#include "i2c_commands.h"

byte lastCommand;
byte aargcamLinePosition = 23;

boolean toggle = false;

void setup ()
{
#ifdef DO_LOGGING
  Serial.begin (9600); // for debugging

  Serial.print ("setup\n");
#endif


  initAargcamSlave();
}



void loop ()
{
  delay(1000);
  
  aargcamLinePosition ++;
  if( aargcamLinePosition > 127)
    aargcamLinePosition = 0;
    
#ifdef DO_LOGGING
  Serial.print ("loop\n");
#endif
}


