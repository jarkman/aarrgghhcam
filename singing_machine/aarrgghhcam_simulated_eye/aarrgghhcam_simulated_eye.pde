#include <Wire.h> 



// This is a test frame that simulated aarrgghhcam_eye without the actual camera being present - it's really just an i2c slave and a tiny simulation routine

#define  DO_LOGGING

byte aargcamLinePosition = 0;  // the position value we will send over i2c in response to AARGCAM_I2C_READ_COMMAND

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


