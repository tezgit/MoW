import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Histogram grayHist, rHist, gHist, bHist;

PImage img;

Capture cam; 

void setup() {
  size(640, 400);
  //frameRate(30);
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


//////////////////////////////////////////////
void draw() {
  background(0);
   cam.read();
    opencv = new OpenCV(this, cam);
    
  grayHist = opencv.findHistogram(opencv.getGray(), 256);
  rHist = opencv.findHistogram(opencv.getR(), 256);
  gHist = opencv.findHistogram(opencv.getG(), 256);
  bHist = opencv.findHistogram(opencv.getB(), 256);
    
    
  image(cam, 0, 0, 300, 200);
  
  

  stroke(125); noFill();  
  rect(320, 10, 310, 180);
  
  fill(125); noStroke();
  grayHist.draw(320, 10, 310, 180);

  stroke(255, 0, 0); noFill();  
  rect(10, height - 190, 200, 180);
  
  fill(255, 0, 0); noStroke();
  rHist.draw(10, height - 190, 200, 180);

  stroke(0, 255, 0); noFill();  
  rect(220, height - 190, 200, 180);
  
  fill(0, 255, 0); noStroke();
  gHist.draw(220, height - 190, 200, 180);

  stroke(0, 0, 255); noFill();  
  rect(430, height - 190, 200, 180);
  
  fill(0, 0, 255); noStroke();
  bHist.draw(430, height - 190, 200, 180);
}
