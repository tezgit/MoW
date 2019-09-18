import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Histogram grayHist, rHist, gHist, bHist;

PImage  canny, scharr, sobel;
boolean vmode = true; 
Capture cam; 

void setup() {
  size(960, 540);
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
    cam = new Capture(this, cameras[3]);
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
  // background(0);
   cam.read();
   opencv = new OpenCV(this, cam);
    
    //opencv.findCannyEdges(20,75);
    //canny = opencv.getSnapshot();
    ////
    //opencv.findScharrEdges(OpenCV.HORIZONTAL);
    //scharr = opencv.getSnapshot();
    ////
    opencv.findSobelEdges(1,0);
    sobel = opencv.getSnapshot();
    //
 
 
 image(cam, 0, 0, cam.width, cam.height);
 // image(sobel, 0, 0, cam.width, cam.height);
 blend(sobel, 0, 0, opencv.width, opencv.height, 0, 0, opencv.width, opencv.height, ADD);
 
 
    /*
  if (vmode == true){
    image(cam, 0, 0, cam.width, cam.height);
  }else{
    image(sobel, 0, 0, cam.width, cam.height);
  }
   delay(10);
   vmode = !(vmode);
  */
  

}


/*
BLEND - linear interpolation of colors: C = A*factor + B
ADD - additive blending with white clip: C = min(A*factor + B, 255)
SUBTRACT - subtractive blending with black clip: C = max(B - A*factor, 0)
DARKEST - only the darkest color succeeds: C = min(A*factor, B)
LIGHTEST - only the lightest color succeeds: C = max(A*factor, B)
DIFFERENCE - subtract colors from underlying image.
EXCLUSION - similar to DIFFERENCE, but less extreme.
MULTIPLY - Multiply the colors, result will always be darker.
SCREEN - Opposite multiply, uses inverse values of the colors.
OVERLAY - A mix of MULTIPLY and SCREEN. Multiplies dark values, and screens light values.
HARD_LIGHT - SCREEN when greater than 50% gray, MULTIPLY when lower.
SOFT_LIGHT - Mix of DARKEST and LIGHTEST. Works like OVERLAY, but not as harsh.
DODGE - Lightens light tones and increases contrast, ignores darks. Called "Color Dodge" in Illustrator and Photoshop.
BURN - Darker areas are applied, increasing contrast, ignores lights. Called "Color Burn" in Illustrator and Photoshop.
*/
