import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
ArrayList<Contour> contours;
Capture theCap; 
Capture cam; 

boolean recording = false; 
int imageIndex = 0;
int time = millis();
int wait = 100;
int threshy = 50;
int xx;
int yy;
int ww =800;
int hh = 600;

void setup(){
  
//  size(640, 360); // half 720
//  size(800, 360);
 //   size(1280, 720); // 720p  HD
        size(1280, 390); // 720p  HD
 // size(1280, 680);
 // size(1280, 480);
 // fullScreen();
 

 
  frameRate(60);
  background(0);
  
  
  // OSC INIT             
  oscP5 = new OscP5(this, 7777);  /* start oscP5, listening for incoming messages at port 7777 */
  myRemoteLocation = new NetAddress("127.0.0.1", 7777);/* address of destination server and port */
  maxAddress = new NetAddress("127.0.0.1", 8888);/* address of destination server and port */

  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[4]);
    cam.start();   
    cam.read();
    xx = (width - 640*2)/2;
    yy = (height - 480)/2;
   // image(cam, xx, yy);
  //  image(cam,0, 0, ww, hh);
  //  opencv = new OpenCV(this, cam);
    delay(1000);
  }
}

//// LOOP ////
void draw(){

   cam.read();
  if (millis() - time >= wait){
    time = millis(); 
    //image(cam, 0, 0);
  //  image(cam, 640, 360);
    opencv = new OpenCV(this, cam);
    opencv.gray();
    opencv.threshold(threshy); 
    contours = opencv.findContours();
   // image(cam, 0, 0);
   // image(cam, 640, 480);

    for (Contour contour : contours) {
      stroke(0, 0, 150);
      contour.draw();
    }

// image(cam, 640 + xx, 0 + yy);
   image(cam, width/2, 0, ww, hh);
   
  }
}
