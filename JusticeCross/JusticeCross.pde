#include <Tlc5940.h>


/*
    Basic Pin setup:
 ------------                                  ---u----
 ARDUINO   13|-> SCLK (pin 25)           OUT1 |1     28| OUT channel 0
 12|                           OUT2 |2     27|-> GND (VPRG)
 11|-> SIN (pin 26)            OUT3 |3     26|-> SIN (pin 11)
 10|-> BLANK (pin 23)          OUT4 |4     25|-> SCLK (pin 13)
 9|-> XLAT (pin 24)             .  |5     24|-> XLAT (pin 9)
 8|                             .  |6     23|-> BLANK (pin 10)
 7|                             .  |7     22|-> GND
 6|                             .  |8     21|-> VCC (+5V)
 5|                             .  |9     20|-> 2K Resistor -> GND
 4|                             .  |10    19|-> +5V (DCPRG)
 3|-> GSCLK (pin 18)            .  |11    18|-> GSCLK (pin 3)
 2|                             .  |12    17|-> SOUT
 1|                             .  |13    16|-> XERR
 0|                           OUT14|14    15| OUT channel 15
 ------------                                  --------
 
 -  Put the longer leg (anode) of the LEDs in the +5V and the shorter leg
 (cathode) in OUT(0-15).
 -  +5V from Arduino -> TLC pin 21 and 19     (VCC and DCPRG)
 -  GND from Arduino -> TLC pin 22 and 27     (GND and VPRG)
 -  digital 3        -> TLC pin 18            (GSCLK)
 -  digital 9        -> TLC pin 24            (XLAT)
 -  digital 10       -> TLC pin 23            (BLANK)
 -  digital 11       -> TLC pin 26            (SIN)
 -  digital 13       -> TLC pin 25            (SCLK)
 -  The 2K resistor between TLC pin 20 and GND will let ~20mA through each
 LED.  To be precise, it's I = 39.06 / R (in ohms).  This doesn't depend
 on the LED driving voltage.
 - (Optional): put a pull-up resistor (~10k) between +5V and BLANK so that
 all the LEDs will turn off when the Arduino is reset.
 
 If you are daisy-chaining more than one TLC, connect the SOUT of the first
 TLC to the SIN of the next.  All the other pins should just be connected
 together:
 BLANK on Arduino -> BLANK of TLC1 -> BLANK of TLC2 -> ...
 XLAT on Arduino  -> XLAT of TLC1  -> XLAT of TLC2  -> ...
 The one exception is that each TLC needs it's own resistor between pin 20
 and GND.
 
 This library uses the PWM output ability of digital pins 3, 9, 10, and 11.
 Do not use analogWrite(...) on these pins.
 */
 
int ledArray[11];
unsigned long ledLong1[6]; 
unsigned long ledLong2[6]; 
int button1 = 1;
int buttonLoop = 0;


void setup()
{
  Tlc.init();
  Serial.begin(9600);
  
  pinMode(4, INPUT);  
}



void loop(){
  

button1 = digitalRead(4);    

if (button1 == 0){
 displayMenu(); 
}

//delay(100);

if (buttonLoop == 0){
  ledOn();
} else if (buttonLoop == 1){
  ledTwinkleFew(1);
} else if (buttonLoop == 2){
  ledExplode();
} else if (buttonLoop == 3){
  ledRotate();
} else if (buttonLoop == 4){
  ledDownUp(); 
  ledUpDown();
} else if (buttonLoop == 5){
  ledTwinkle(1);
} else if (buttonLoop == 6){
  ledMatrix();
} else if (buttonLoop == 7){
  ledOnOff(1000);
} else if (buttonLoop == 8){
  ledOnOff(100);
} else if (buttonLoop == 9){
  ledOnOff(50);
} else if (buttonLoop == 10){
  ledFadeInOut();
} else if (buttonLoop == 11){
  ledTwinkleFew(3); 
  ledDownUp(); 
  ledUpDown();
  ledMatrix();
  ledMatrix();
  ledExplode();
} 

}

void displayMenu(){
  
 
 int maxLoop = 12;
 int waitTime = 0;
 buttonLoop = 0;
 
 button1 = digitalRead(4);
 
 ledMenu(1);
 
 Serial.print(button1); 
 Serial.print("\n   "); 
 
 while (waitTime < 40){
  while (button1 == 0){ //while the button is pressed
   //wait for the button to stop being pressed 
    button1 = digitalRead(4);
  }
  
  button1 = digitalRead(4);
  
  //if the buton is pressed again
  if (button1 == 0){
    waitTime = 0;
    buttonLoop++;
    
    if (buttonLoop == maxLoop){
     buttonLoop = 0; 
    }
    
    ledMenu(buttonLoop+1);
   
  }
  
  waitTime++;
  delay(120);
  
 }
  
  
  
}

void ledDownUp(){
    int ledArrLoop = 0;
    int ledArrNum = 11;
        
    while (ledArrLoop < ledArrNum){
     
      ledArray[ledArrLoop] = 0xff;
      ledArray[ledArrLoop - 1] = 0;
      
      ledDisplay(0);
      delay(100);
      
      ledArrLoop++; 
    } 
}

void ledUpDown(){
    int ledArrLoop = 11;
        
    while (ledArrLoop > 0){
     
      ledArray[ledArrLoop - 2] = 0xff;
      ledArray[ledArrLoop - 1] = 0;
      
      ledDisplay(0);
      delay(100);
      
      ledArrLoop--; 
    } 
}

void ledOff(){
  
  int displayDelay = 100;
       
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
      delay(displayDelay);
      
}

void ledOn(){
  
  int displayDelay = 100;
       
      ledArray[9] = B00001100;
      ledArray[8] = B00001100;
      ledArray[7] = B00111111;
      ledArray[6] = B00111111;
      ledArray[5] = B00001100;
      ledArray[4] = B00001100;
      ledArray[3] = B00001100;
      ledArray[2] = B00001100;
      ledArray[1] = B00001100;
      ledArray[0] = B00001100;
      ledDisplay(1);
      delay(displayDelay);
      
}



void ledExplode(){
  
  int displayDelay = 100;
       
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00001100;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00001100;
      ledArray[5] = B00001100;
      ledArray[4] = B00001100;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00001100;
      ledArray[6] = B00011110;
      ledArray[5] = B00000000;
      ledArray[4] = B00001100;
      ledArray[3] = B00001100;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00001100;
      ledArray[7] = B00011110;
      ledArray[6] = B00110011;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00001100;
      ledArray[2] = B00001100;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00001100;
      ledArray[8] = B00001100;
      ledArray[7] = B00110011;
      ledArray[6] = B00100001;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00001100;
      ledArray[1] = B00001100;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00001100;
      ledArray[8] = B00000000;
      ledArray[7] = B00100001;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00001100;
      ledArray[0] = B00001100;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00001100;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
}

void ledMatrix(){
  
  int displayDelay = 100;
       
      ledArray[9] = B00001000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000010;
      ledArray[6] = B00100000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000100;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00001000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000010;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000100;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00001000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000100;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00001000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000100;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000100;
      ledArray[8] = B00000000;
      ledArray[7] = B00000001;
      ledArray[6] = B00000000;
      ledArray[5] = B00001000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000100;
      ledArray[7] = B00000000;
      ledArray[6] = B00000001;
      ledArray[5] = B00000000;
      ledArray[4] = B00001000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00010100;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00001000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00010100;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00001000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000100;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00001000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00100000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000100;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00001000;
      ledDisplay(0);
      delay(displayDelay);
      
}

void ledRotate(){
  
  int displayDelay = 100;
       
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00001010;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000001;
      ledArray[5] = B00001000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000001;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00001000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000010;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00001000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000100;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00001000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000100;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00001000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000100;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00001000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00001000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000100;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00001000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000100;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00001000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000100;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00010000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000100;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00100000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000100;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00100000;
      ledArray[5] = B00000100;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00010100;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      

      
}

void ledRotate4(){
  
  int displayDelay = 100;
       
      ledArray[9] = B00001000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00001010;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000100;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00001000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000001;
      ledArray[5] = B00001000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000100;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00001001;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00001000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000100;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00010010;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00001100;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00100100;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000100;
      ledArray[3] = B00000000;
      ledArray[2] = B00001000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000100;
      ledArray[7] = B00000000;
      ledArray[6] = B00100000;
      ledArray[5] = B00000100;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00001000;
      ledArray[0] = B00000000;
      ledDisplay(0);
      delay(displayDelay);
      
      ledArray[9] = B00000100;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00010100;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00001000;
      ledDisplay(0);
      delay(displayDelay);
      

      
}

void ledOnOff(int time){
      ledArray[9] = B00001100;
      ledArray[8] = B00001100;
      ledArray[7] = B00111111;
      ledArray[6] = B00111111;
      ledArray[5] = B00001100;
      ledArray[4] = B00001100;
      ledArray[3] = B00001100;
      ledArray[2] = B00001100;
      ledArray[1] = B00001100;
      ledArray[0] = B00001100;
      ledDisplay(1);
      delay(time);
      
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
      delay(time);
}

void ledTwinkle(int totalNum){
  
   int totalLoop = 0;
   int ledArrLoop = 0;
   int ledArrNum = 11;
   
   while (totalLoop < totalNum){
     
     ledArrLoop = 0;
     while (ledArrLoop < ledArrNum){
       ledArray[ledArrLoop] = random(256);       
       ledArrLoop++; 
     }
     ledDisplay(0);
     delay(100);  
     
     totalLoop++;  
   }
}

void ledTwinkleFew(int totalNum){
  
   int totalLoop = 0;
   int ledArrLoop = 0;
   int ledArrNum = 11;
   
   while (totalLoop < totalNum){
     
     ledArrLoop = 0;
     while (ledArrLoop < ledArrNum){
       ledArray[ledArrLoop] = random(256);       
       ledArrLoop++; 
     }
     ledDisplay(0);
     delay(100);  
     
     ledArrLoop = 0;
     while (ledArrLoop < ledArrNum){
       ledArray[ledArrLoop] = random(0);       
       ledArrLoop++; 
     }
     ledDisplay(0);
     delay(100);  
     
     ledArrLoop = 0;
     while (ledArrLoop < ledArrNum){
       ledArray[ledArrLoop] = random(0);       
       ledArrLoop++; 
     }
     ledDisplay(0);
     delay(100);  
     
     ledArrLoop = 0;
     while (ledArrLoop < ledArrNum){
       ledArray[ledArrLoop] = random(0);       
       ledArrLoop++; 
     }
     ledDisplay(0);
     delay(100);  
     
     totalLoop++;  
   }
}


void ledMenu(int number){
  
 if (number == 1){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000100;
      ledDisplay(1);
 } else if (number == 2){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00001000;
      ledDisplay(1);
 } else if (number == 3){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000100;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 4){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00001000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 5){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000100;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 6){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00001000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 7){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000100;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 8){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000000;
      ledArray[3] = B00001000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 9){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00000100;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 10){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000000;
      ledArray[4] = B00001000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 11){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00000100;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 } else if (number == 12){
      ledArray[9] = B00000000;
      ledArray[8] = B00000000;
      ledArray[7] = B00000000;
      ledArray[6] = B00000000;
      ledArray[5] = B00001000;
      ledArray[4] = B00000000;
      ledArray[3] = B00000000;
      ledArray[2] = B00000000;
      ledArray[1] = B00000000;
      ledArray[0] = B00000000;
      ledDisplay(1);
 }
  
}

void ledFadeInOut(){

  //takes the variables from the array, and puts them onto the cross
  int thisLed = 0;
  int ledLoop = 0;
  int ledNum = 16;
 
  int fadeMax = 200;
  int fadeLoop = 0;
  
  delay(500);
  
  while (fadeLoop < fadeMax){
    ledLoop = 0;
    while (ledLoop < ledNum){
  
       Tlc.set(ledLoop, (fadeLoop * 10)); 
       Tlc.set(ledLoop + 16, (fadeLoop * 10));
       ledLoop++; 
    }
    Tlc.update();
    delay(10);
    fadeLoop++;
    
  }
  
  while (fadeLoop > 0){
    ledLoop = 0;
    while (ledLoop < ledNum){
  
       Tlc.set(ledLoop, (fadeLoop * 10)); 
       Tlc.set(ledLoop + 16, (fadeLoop * 10));
       ledLoop++; 
    }
    Tlc.update();
    delay(10);
    fadeLoop--;
    
  }
  
  ledOff();
 
}

void ledDisplay(int now){

  //takes the variables from the array, and puts them onto the cross
  int thisLed = 0;
  int ledLoop = 0;
  int ledNum = 16;
 
  int fadeLoop = 4;
  
  ledLong1[0] = 0;
  ledLong2[0] = 0;
  
  //mapping onto the cross
  ledLong1[0] |= ((ledArray[0] >> 2) & 0x00000003);
  ledLong1[0] |= ((ledArray[1] ) & 0x0000000c);  
  ledLong1[0] |= ((ledArray[2] << 2) & 0x00000030); 
  ledLong1[0] |= ((ledArray[3] << 4) & 0x000000c0); 
  ledLong1[0] |= ((ledArray[4] << 6) & 0x00000300); 
  ledLong1[0] |= ((ledArray[5] << 8) & 0x00000c00); 
  ledLong1[0] |= ((ledArray[6] << 12) & 0x0000f000); 
  ledLong2[0] |= ((ledArray[6] >> 4) & 0x00000003); 
  ledLong2[0] |= ((ledArray[7] << 2) & 0x000000fc); 
  ledLong2[0] |= ((ledArray[8] << 6) & 0x00000300); 
  ledLong2[0] |= ((ledArray[9] << 8) & 0x00000c00); 
  
  if (now == 0){
    //make the changes with a fade
    while (fadeLoop > 0){
       
      ledLong1[fadeLoop] = ledLong1[fadeLoop - 1];
      ledLong2[fadeLoop] = ledLong2[fadeLoop - 1];
     
      fadeLoop--; 
    }
  } 
  
  while (ledLoop < ledNum){
    
    if (now == 0){
    //make the changes with a fade
      if ((ledLong1[4] >> ledLoop) & 0x01){ Tlc.set(ledLoop, 0); }
      if ((ledLong2[4] >> ledLoop) & 0x01){ Tlc.set(ledLoop + 16, 0); }
      
      if ((ledLong1[3] >> ledLoop) & 0x01){ Tlc.set(ledLoop, 400); }
      if ((ledLong2[3] >> ledLoop) & 0x01){ Tlc.set(ledLoop + 16, 800); }
      
      if ((ledLong1[2] >> ledLoop) & 0x01){ Tlc.set(ledLoop, 1000); }
      if ((ledLong2[2] >> ledLoop) & 0x01){ Tlc.set(ledLoop + 16, 1600); }
      
      if ((ledLong1[1] >> ledLoop) & 0x01){ Tlc.set(ledLoop, 2000); }
      if ((ledLong2[1] >> ledLoop) & 0x01){ Tlc.set(ledLoop + 16, 2500); }
      
      if ((ledLong1[0] >> ledLoop) & 0x01){ Tlc.set(ledLoop, 4095); }
      if ((ledLong2[0] >> ledLoop) & 0x01){ Tlc.set(ledLoop + 16, 4095); }
    } else {
     //not fading
       if ((ledLong1[0] >> ledLoop) & 0x01){ Tlc.set(ledLoop, 4095); } else { Tlc.set(ledLoop, 0); }
       if ((ledLong2[0] >> ledLoop) & 0x01){ Tlc.set(ledLoop + 16, 4095); } else { Tlc.set(ledLoop + 16, 0); }
     
    } 
    
  
    ledLoop++; 

  }
  
  Tlc.update();
}