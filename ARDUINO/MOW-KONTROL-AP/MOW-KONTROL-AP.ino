///////////////////////////////////////////////////////////////////////
// MoW Kontrol // Memory of Water project //  TeZ V 1.2. 21-08-2019  //
///////////////////////////////////////////////////////////////////////

#include "AiEsp32RotaryEncoder.h"
#include "Arduino.h"
#include <Adafruit_NeoPixel.h>
#include "WiFi.h"
#include <WiFiUdp.h>
#include <OSCMessage.h>
#include "NETWORK.h"

// ROTARY ENCODER PINS
#define ROTARY_ENCODER_A_PIN 32   // CLK
#define ROTARY_ENCODER_B_PIN 21   // DT
#define ROTARY_ENCODER_BUTTON_PIN 25   // SW
#define ROTARY_ENCODER_VCC_PIN 27 /*put -1 of Rotary encoder Vcc is connected directly to 3,3V; else you can use declared output pin for powering rotary encoder */
AiEsp32RotaryEncoder rotaryEncoder = AiEsp32RotaryEncoder(ROTARY_ENCODER_A_PIN, ROTARY_ENCODER_B_PIN, ROTARY_ENCODER_BUTTON_PIN, ROTARY_ENCODER_VCC_PIN);
int test_limits = 2;
int encoderclick = 0;

// DRV8825 GPIO Pins
#define M1_STEP 23 // 3 // 23
#define M1_DIR 22 // 4 // 22
#define M1_EN  18 // TTGO 18  // ESP32 19  

#define PHOTOSTOPIN 36 // VP pin on ESP32 //  Photo Interruptor pin
int endstop = 0;

#define SWITCHPIN 34 // GPIO34 on TTGO // GPIO39 on ESP32 VN // BUTTON PIN
int buttonswitch = 0;
int buttonvalue = 0;

#define uSEC 100
// #define MAXSTEPS 10000
int MOVESTEPS = 10;
int block = 0;

#define NEOPIXPIN 9 // GPI09 on TTGO  // GPIO17 = TX2 on ESP32
#define NUMPIXELS 25 //  NeoPixel ring size
Adafruit_NeoPixel pixels(NUMPIXELS, NEOPIXPIN, NEO_GRB + NEO_KHZ800);
int pixrand = 0; 
int rrx, ggx, bbx;




////////////////////////////////////
void Motorlooptest() {

   digitalWrite(M1_DIR, HIGH);  
  
  MOVESTEPS = 10000;

//  Serial.println("start DIR HIGH");
  for(int x=0; x<MOVESTEPS; x++){
    checkEndstop();
    if(endstop==0){digitalWrite(M1_STEP, HIGH);}  
    delayMicroseconds(uSEC);
    digitalWrite(M1_STEP, LOW);  
    delayMicroseconds(uSEC);   
  }

     delay(1000);

//  Serial.print("start DIR LOW");    
   digitalWrite(M1_DIR, LOW);  

  for(int x=0; x<MOVESTEPS; x++){
    
    digitalWrite(M1_STEP, HIGH);  
    delayMicroseconds(uSEC);
    digitalWrite(M1_STEP, LOW);  
    delayMicroseconds(uSEC);   
  }


     MOVESTEPS = 10;
     
     delay(500);

}



////////////////////////////
void rotary_onButtonClick() {


  if(encoderclick>=2){
    encoderclick = 0;
  }else{
    encoderclick++;
  }

  if(encoderclick == 0){
    MOVESTEPS = 5;
  }else if(encoderclick == 1){
    MOVESTEPS = 100;
  }else if(encoderclick == 2){
    MOVESTEPS = 1000;
  }

   Serial.println((String)"encoderclick: " + encoderclick + " STEPS: " + MOVESTEPS);

 
  //rotaryEncoder.reset();
  //rotaryEncoder.disable();
  //  rotaryEncoder.setBoundaries(-test_limits, test_limits, false);
  //  test_limits *= 2;
}

////////////////////////////
void rotary_loop() {
  //first lets handle rotary encoder button click
  if (rotaryEncoder.currentButtonState() == BUT_RELEASED) {
    //we can process it here or call separate function like:
    rotary_onButtonClick();
  }

  //lets see if anything changed
  int16_t encoderDelta = rotaryEncoder.encoderChanged();
  
  //optionally we can ignore whenever there is no change
  if (encoderDelta == 0) return;
  

  
  //if value is changed compared to our last read
  if (encoderDelta!=0) {
    //read current value
    int16_t encoderValue = rotaryEncoder.readEncoder();
  //  Serial.print("Value: ");
  //  Serial.println(encoderValue);
  } 

  if (encoderDelta>0){
    Serial.println("+");
    StepMotorDown();
  }
  
  if (encoderDelta<0){
    Serial.println("-");
     StepMotorUp();   
  }

  
}

////////////////////////////////////
void StepMotorDown(){

    digitalWrite(M1_DIR, LOW);  // direction
    
    for(int x=0; x<MOVESTEPS; x++){
        digitalWrite(M1_STEP, HIGH);  
        delayMicroseconds(uSEC);
        digitalWrite(M1_STEP, LOW);  
        delayMicroseconds(uSEC);   
    }

}
////////////////////////////////////
void StepMotorUp(){
    digitalWrite(M1_DIR, HIGH);  // direction
    
    for(int x=0; x<MOVESTEPS; x++){
        if(endstop==0){digitalWrite(M1_STEP, HIGH); } 
        delayMicroseconds(uSEC);
        digitalWrite(M1_STEP, LOW);  
        delayMicroseconds(uSEC);   
    }
}
////////////////////////////////
void whitey(){

   for(int i=0; i<NUMPIXELS; i++) { // For each pixel...
    pixels.setPixelColor(i, pixels.Color(150, 150, 150));
    pixels.show();   // Send the updated pixel colors to the hardware.
    delay(50); // Pause before next pass through loop
  }
  
}

//////////////////////////////////
void blacky(){

    pixels.clear();
    delay(100);
   for(int i=0; i<NUMPIXELS; i++) { // For each pixel...
      pixels.setPixelColor(i, pixels.Color(0, 0, 0));
    }
      pixels.show();  
      delay(100); 
}


///////////////////////////////
void on_motorup(OSCMessage &msg, int addrOffset) {

  StepMotorUp();
  
}

///////////////////////////////
void on_motordown(OSCMessage &msg, int addrOffset) {

  StepMotorDown();
  
}

///////////////////////////////
void on_motorx5(OSCMessage &msg, int addrOffset) {
  MOVESTEPS = 5;
}

///////////////////////////////
void on_motorx100(OSCMessage &msg, int addrOffset) {
  MOVESTEPS = 100;
}

///////////////////////////////
void on_motorx1000(OSCMessage &msg, int addrOffset) {
  MOVESTEPS = 1000;
}


///////////////////////////////
void on_motormove(OSCMessage &msg, int addrOffset) {

    int nn, ss;

    if(msg.isInt(0)){
      ss = msg.getInt(1);
      MOVESTEPS = ss;
    }  

    
    if(msg.isInt(1)){
      nn = msg.getInt(0);
          if(nn == 0){
              StepMotorDown();
           }else{
              StepMotorUp();
           }   
    }

  Serial.println("OSC MESSAGE netmotor/move" && ss &&" " && nn);
 

}

///////////////////////////////
void on_motorblock(OSCMessage &msg, int addrOffset) {
 
// if(msg.isInt(0)){
//      block = msg.getInt(0);
//      // block = msg.getFloat(0);
//    }

    if(msg.isFloat(0)){
      block = msg.getFloat(0);
      // block = msg.getFloat(0);
    }

    if(block == 0){
      digitalWrite(M1_EN, HIGH);  // HIGH = OFF    
    }else{
      digitalWrite(M1_EN, LOW);  // LOW = ON
    }

    Serial.println("OSC MESSAGE netmotor/motorblock" + block);
 
}


///////////////////////////////
void on_pixel(OSCMessage &msg, int addrOffset) {

    int nn, rr, gg, bb;

    if(msg.isInt(0)){
      nn = msg.getInt(0);
    }

    if(msg.isInt(1)){
      rr = msg.getInt(1);
    }
        
    if(msg.isInt(2)){
      gg = msg.getInt(2);
    }

    if(msg.isInt(3)){
      bb = msg.getInt(3);
    }

 //   Serial.println("OSC MESSAGE netpixe/pixel" + nn +" " + nrr +" "+ gg +" "+ bb );
    
   Serial.println("OSC MESSAGE netpixe/ring" && nn &&" " && rr &&" " &&gg  &&" "&& bb );
  
    pixrand = false;
    pixels.setPixelColor(nn, pixels.Color(rr, gg, bb));
    pixels.show();   // Send the updated pixel colors to the hardware.

}


///////////////////////////////
void on_ring_r(OSCMessage &msg, int addrOffset) {
    float var;
    if(msg.isFloat(0)){
      var = msg.getFloat(0);
    }
     
    pixrand = false;
    if(var == 0.){ringcolor(200,0,0);}
    
}

///////////////////////////////
void on_ring_g(OSCMessage &msg, int addrOffset) {
    float var;
    if(msg.isFloat(0)){
      var = msg.getFloat(0);
    }
    
    pixrand = false;
    if(var == 0.){ringcolor(0,200,0);}
}


///////////////////////////////
void on_ring_b(OSCMessage &msg, int addrOffset) {
    float var;
    if(msg.isFloat(0)){
      var = msg.getFloat(0);
    }
    
    pixrand = false;
    if(var == 0.){ringcolor(0,0,200);}
}


///////////////////////////////
void on_ring_d(OSCMessage &msg, int addrOffset) {
    float var;
    if(msg.isFloat(0)){
      var = msg.getFloat(0);
    }
    
    pixrand = false;
    if(var == 0.){ringcolor(0,0,0);}
}

///////////////////////////////
void on_ring_w(OSCMessage &msg, int addrOffset) {
    float var;
    if(msg.isFloat(0)){
      var = msg.getFloat(0);
    }
    
    pixrand = false;
    if(var == 0.){ringcolor(200,200,200);}
}


///////////////////////////////
void on_ring(OSCMessage &msg, int addrOffset) {

    int rr, gg, bb;

    if(msg.isInt(0)){
      rr = msg.getInt(0);
    }
        
    if(msg.isInt(1)){
      gg = msg.getInt(1);
    }

    if(msg.isInt(2)){
      bb = msg.getInt(2);
    }


    if(msg.isFloat(0)){
      rr = int(msg.getFloat(0));
    }
        
    if(msg.isFloat(1)){
      gg =int(msg.getFloat(1));
    }

    if(msg.isFloat(2)){
      bb = int(msg.getFloat(2));
    }



    Serial.println("OSC MESSAGE netpixel/ring" && rr &&" " &&gg  &&" "&& bb );

    // assign to global
    rrx = rr;
    ggx = gg;
    bbx = bb;
  
    
    pixrand = false;
    pixels.clear(); // Set all pixel colors to 'off'
    for(int nn=0; nn<24;nn++){
        pixels.setPixelColor(nn, pixels.Color(rrx, ggx, bbx));
       // pixels.setPixelColor(nn, pixels.Color(rr, gg, bb));
        delay(10);
        pixels.show();   // Send the updated pixel colors to the hardware.

    }
    pixels.show();   // Send the updated pixel colors to the hardware.

}


///////////////////////////////
void on_rand(OSCMessage &msg, int addrOffset) {
 
 if(msg.isInt(0)){
      pixrand = msg.getInt(0);
    }

    Serial.println("OSC MESSAGE netpixel/rand" + pixrand);
 
  
}



///////////////////////////////
void randpix(){
    pixels.clear(); // Set all pixel colors to 'off'
    for(int nn=0; nn<24;nn++){
      int rn=random(25);
      int rr=random(255);
      int gg=random(255);
      int bb=random(255);
      
      pixels.setPixelColor(rn, pixels.Color(rr, gg, bb));
      pixels.show();   // Send the updated pixel colors to the hardware.
      delay(10);

    }

}


///////////////////////////////
void ringcolor(int rr, int gg, int bb){
    pixels.clear(); // Set all pixel colors to 'off'
    for(int nn=0; nn<24;nn++){
      pixels.setPixelColor(nn, pixels.Color(rr, gg, bb));
      pixels.show();   // Send the updated pixel colors to the hardware.
      delay(10);
    }

    // assign to globals
    rrx = rr;
    ggx = gg;
    bbx = bb;
    

}


///////////////////////////////
void testring(){

   pixels.clear(); // Set all pixel colors to 'off'

  delay(100);
 
  ringcolor(200, 0, 0);
  delay(1000);
  ringcolor(0, 200, 0);
  delay(1000);
  ringcolor(0, 0, 200);
  delay(1000);
  ringcolor(0, 0, 0);
  delay(1000);
  
}

////////////////////////
/// READ OSC MESSAGES ///
void osc_message_pump() {  
  OSCMessage in;
  int size;

  if( (size = Udp.parsePacket()) > 0)
  {
    Serial.println("processing OSC package");
    // parse incoming OSC message
    while(size--) {
      in.fill( Udp.read() );
    }

    if(!in.hasError()) {
      in.route("/netpixel/pixel", on_pixel);
      in.route("/netpixel/ring", on_ring);
      in.route("/netpixel/ring_r", on_ring_r);
      in.route("/netpixel/ring_g", on_ring_g);
      in.route("/netpixel/ring_b", on_ring_b);
      in.route("/netpixel/ring_d", on_ring_d);
      in.route("/netpixel/ring_w", on_ring_w);
      in.route("/netpixel/rand", on_rand);
      in.route("/netmotor/move", on_motormove);
      in.route("/netmotor/block", on_motorblock);
      in.route("/netmotor/up", on_motorup);
      in.route("/netmotor/down", on_motordown);
      in.route("/netmotor/x5", on_motorx5);
      in.route("/netmotor/x100", on_motorx100);
      in.route("/netmotor/x1000", on_motorx1000);     
    }

     Serial.println("OSC MESSAGE RECEIVED");
     
  } // if

 
  
}


////////////////////////////////////
void checkEndstop() {
  
  float readpin= analogRead(PHOTOSTOPIN); // photo interruptor check
  // Serial.println(endstop);
  if(readpin > 3000){
    endstop = 1;
    // Serial.println("ENDSTOP TRUE");
  }else{
    endstop = 0;
    // Serial.println("ENDSTOP FALSE");
  }

}

////////////////////////////////////
void checkButtonswitch() {
  
  float readpin= analogRead(SWITCHPIN); // photo interruptor check
 // Serial.println(readpin);
  if(readpin > 3000){
    buttonswitch = 1;
   //  Serial.println("buttonswitch TRUE");
  }else{
    buttonswitch = 0;
   //  Serial.println("buttonswitch FALSE");    
  }

  if(buttonswitch != buttonvalue){
    buttonvalue = buttonswitch;
    if (buttonvalue == 1){
      digitalWrite(M1_EN, HIGH);  // HIGH = OFF
    }else{
      digitalWrite(M1_EN, LOW);  // LOW = ON
    }
  }
  
  

}
////////////////////////////////////
void setup() {
  // put your setup code here, to run once:

  // put your setup code here, to run once:
  Serial.begin(115200);

  pinMode(NEOPIXPIN, OUTPUT);
  pinMode(PHOTOSTOPIN, INPUT);
  pinMode(SWITCHPIN, INPUT);
  
  pinMode(M1_DIR, OUTPUT);
  pinMode(M1_STEP, OUTPUT);
  pinMode(M1_EN, OUTPUT);
  digitalWrite(M1_DIR, LOW);   
  digitalWrite(M1_STEP, LOW); 
  digitalWrite(M1_EN, LOW);  // LOW = ON

  rotaryEncoder.begin();
  rotaryEncoder.setup([]{rotaryEncoder.readEncoder_ISR();});
  //optionally we can set boundaries and if values should cycle or not
  rotaryEncoder.setBoundaries(0, 9999, true); //minValue, maxValue, cycle values (when max go to min and vice versa)


  rrx = ggx = bbx = 0;
  
  pixels.begin();
  pixels.clear(); // Set all pixel colors to 'off'
  pixels.show();  
  blacky();

  // WiFiConnect(); // connect to Wifi
 
  APConnect();
  Udp.begin(rxport);

  testring(); // test LEDs
  whitey(); // mild white LEDs
  Motorlooptest(); // test motor

}



////////////////////////////////////
void loop() {

  rotary_loop(); // rotary encoder check 

  checkEndstop();
  checkButtonswitch();
  
  osc_message_pump(); // check for OSC messages
  // only if OSC message "rand" = true
  if( pixrand == true){
    randpix();
    delay(100);     
  }


 // delay(10);
  
}
