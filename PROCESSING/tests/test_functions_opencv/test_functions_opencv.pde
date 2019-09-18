import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Histogram grayHist, rHist, gHist, bHist;

PImage  canny, scharr, sobel, timage;
boolean vmode = true; 
Capture cam; 

ArrayList<Line> lines;

void setup() {
  size(640,360);
//  frameRate(30);
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
    //image(cam,640,360);
    delay(200);
  }


}


//////////////////////////////////////////////
void draw() {
 // background(0,0,90);
   cam.read();
   image(cam,0,0);
/*
 timage = cam.get(0, 0, 640, 360); 
  opencv = new OpenCV(this, timage);
    
  //// opencv.updateBackground();
 // timage = opencv.getSnapshot();
  
  //opencv.dilate();
  //opencv.erode();
    noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
     canny=opencv.getSnapshot();
    image(canny,0,0);

  

 // blend(timage, 0, 0, opencv.width, opencv.height, 0, 0, opencv.width, opencv.height, ADD);

*/
}


/////////////////////
void LineDetect(){
 
   image(opencv.getOutput(), 0, 0);
  strokeWeight(3);
  
  for (Line line : lines) {
    // lines include angle in radians, measured in double precision
    // so we can select out vertical and horizontal lines
    // They also include "start" and "end" PVectors with the position
    if (line.angle >= radians(0) && line.angle < radians(1)) {
      stroke(0, 255, 0);
      line(line.start.x, line.start.y, line.end.x, line.end.y);
    }

    if (line.angle > radians(89) && line.angle < radians(91)) {
      stroke(255, 0, 0);
      line(line.start.x, line.start.y, line.end.x, line.end.y);
    }
  }
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
