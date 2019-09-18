import processing.video.*;
import gab.opencv.*;


Capture cam; 
int[] hist = new int[256];
// PImage piCam;
/////////////////////////////////////
void setup(){
  
  size(800, 600);
  frameRate(30);
  background(0);

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

    image(cam,cam.width, cam.height);
   // image(cam, 640, 360);
  //  opencv = new OpenCV(this, cam);
    delay(1000);
  }
  
        
}


///////////////////////////////////////////////
void draw(){
  
  cam.read();
  image(cam, 0, 0);
  
  // piCam = cam;
  
    // Calculate the histogram
    for (int i = 0; i < cam.width; i++) {
      for (int j = 0; j < cam.height; j++) {
        int bright = int(brightness(get(i, j)));
        hist[bright]++; 
      }
    }
    
    // Find the largest value in the histogram
    int histMax = max(hist);
    
    stroke(255, 0, 0);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < cam.width; i += 2) {
      // Map i (from 0..img.width) to a location in the histogram (0..255)
      int which = int(map(i, 0, cam.width, 0, 255));
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist[which], 0, histMax, cam.height, 0));
      line(i, cam.height, i, y);
    }

}



/*
void draw(){
    // Calculate the histogram
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        int bright = int(brightness(get(i, j)));
        hist[bright]++; 
      }
    }
    
    // Find the largest value in the histogram
    int histMax = max(hist);
    
    stroke(255);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < img.width; i += 2) {
      // Map i (from 0..img.width) to a location in the histogram (0..255)
      int which = int(map(i, 0, img.width, 0, 255));
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist[which], 0, histMax, img.height, 0));
      line(i, img.height, i, y);
    }

}

*/
