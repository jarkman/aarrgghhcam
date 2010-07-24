
// use an ASCII grey scale  .'~:;!>+=icjtJY56SXDQKHNWMM
// Takes Min pixel darkness and Max pixel brightness 
// Than implements a ASCII grey scale between them.
// Centre of 'MASS' for basically brightest point.

// SVN originated edit!

#include <Wire.h> 

#include "i2c_commands.h"


byte aargcamLinePosition = 23;  // the position value we will send over i2c when asked

// Pins to wire to the camera, MLX90255KWB-BAM 
// http://uk.rs-online.com/web/search/searchBrowseAction.html?method=getProduct&R=6843317
int clockPin=2;    // to pin 2 on camera
int SIPin=3;       // to pin 1 on camera 
int analogueIn=0;  // to pin 3 on camera

// Also connect:
// arduino ground to pin 5 of camera
// arduino +5v supply to pin 4 of camera
// You also need a 330 ohm pulldown resistor between camera pins 3 (output) and 5 (ground)

// Expected output range of the camera is 125mv (dark) to 2.5v (saturated) 


boolean toggle = false;

int pixels=128;          //128 pixels but need 133 clock cycles.
int line[133];
int counter=0;
int threshold=512;        //0-1024 threashold between Light and Dark.
int clockDelay=1;          //Microseconds of clock period (/2)
int thresholdPin=1;



int dark=0;
int bright=0;
int pixel=0;
int greyStep=0;
int temp=0;

int greyLength=28;
char grey[28]=" .'~:;!>+=icjtJY56SXDQKHNWM";

void setup() {
 initAargcamSlave();
 pinMode(clockPin,OUTPUT);
 pinMode(SIPin,OUTPUT);
 
 digitalWrite(clockPin,0);        //clock LOW
 digitalWrite(SIPin,0);            //Optical Sensor not selected
 
 //  Serial.begin(9600);

  Serial.begin(38400);
  Serial.println("Hello World!");
                            //Clear array
 for(counter=0;counter<=pixels;counter++) line[counter]=0;
}

void loop() {
/*
  //for (int N=0;N<128;N++){
  for (int N=128;N>0;N--){
  Serial.print(line[N]);
//   Serial.print(" ");
 */ 
// Serial.println();
//  Serial.println();
//  Serial.println();
 // delay(250);
//  eyeBlink;
//}

delay(125);
//void eyeBlink(){      //take a scan from the optical sensor

                          


//int counter=0;
  threshold= analogRead(thresholdPin);
//  Serial.print(threshold);
//  Serial.print("  ");
  Serial.print(dark);
  Serial.print("  ");
  Serial.print(bright);
  Serial.print("  ");
//  Serial.println();
 
for (int N=0;N<2;N++){                          
                                                // Need a activation on SI to be clocked into sensor
   digitalWrite(SIPin,1);                       //SI SET
   digitalWrite(clockPin,1);                    //clock HIGH
   digitalWrite(SIPin,0);                       //SI cleared ##MUST be cleared before next clock cycle!
   digitalWrite(clockPin,0);                    //clock LOW
                                                //Dummy pixel
   digitalWrite(clockPin,1);                    //clock HIGH
   digitalWrite(clockPin,0);                    //clock LOW
 
  dark=1000;bright=0;                                  //Reset dark and bright levels.
   
                                                //The active scan is from the 18th clock cycle of the precious scan to the start of the one you want.
                                                //Hence running a scan without analogue conversion to get the desired CCD integration period.
for(counter=0;counter<=pixels;counter++){
   digitalWrite(clockPin,1);     
   if (N==1){

   line[counter]= analogRead(analogueIn);
   
   if (dark>line[counter]){
      if (5<line[counter]) dark=line[counter];
   }
   
   if (bright<line[counter]) bright=line[counter];
   
   }
   digitalWrite(clockPin,0);                    
  
}
                                               //Dummy pixels
   digitalWrite(clockPin,1);                    //clock HIGH
   digitalWrite(clockPin,0);                    //clock LOW
   digitalWrite(clockPin,1);                    //clock HIGH
   digitalWrite(clockPin,0);                    //clock LOW
   digitalWrite(clockPin,1);                    //clock HIGH
   digitalWrite(clockPin,0);                    //clock LOW
   digitalWrite(clockPin,1);                    //clock HIGH
   digitalWrite(clockPin,0);                    //clock LOW
}

for(counter=0;counter<=pixels;counter++){

  /*
  temp=map(line[counter],bright,dark,0,greyLength-1);
  line[counter]=grey[temp];
  */
 // if (line[counter]>((bright+dark)/2)){//    line [counter]=1;
  if (line[counter]<170)  {
    line [counter]=1;
  aargcamLinePosition=counter;
  Serial.println(counter);
  break;
  }
  else    line [counter]=0;
  

  }


}

