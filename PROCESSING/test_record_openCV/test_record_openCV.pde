import processing.video.*;
import gab.opencv.*;
import com.hamoid.*;

VideoExport videoExport;


OpenCV opencv;
ArrayList<Contour> contours;
Capture cam; 

boolean recording = false; 
int imageIndex = 0;
int time = millis();
int wait = 100;
int threshy = 50;
int xx;
int yy;
int ww =960;
int hh = 540;

int FPS = 30;

PImage sobel;
PGraphics pg;

void setup(){
    size(960, 540);
//  size(640, 360); // half 720
//  size(800, 360);
 //   size(1280, 720); // 720p  HD
 //       size(1280, 390); // 720p  HD
 // size(1280, 680);
 // size(1280, 480);
 // fullScreen();
 

 
  frameRate(FPS);
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
    // cam = new Capture(this, cameras[3]);
    cam = new Capture(this, 960, 540, cameras[3]);

    cam.start();   
    cam.read();
    xx = (width - 960*2)/2;
    yy = (height - 540)/2;
   // image(cam, xx, yy);
  //  image(cam,0, 0, ww, hh);
  //  opencv = new OpenCV(this, cam);


    videoExport = new VideoExport(this, "camera.mp4", cam);
    videoExport.startMovie();
  
  
    delay(500);
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
    
  sobel = opencv.getSnapshot();

   //image(cam, 0, 0);
    image(cam, 0, 0, cam.width, cam.height);
 // image(sobel, 0, 0, cam.width, cam.height);
   blend(sobel, 0, 0, opencv.width, opencv.height, 0, 0, opencv.width, opencv.height, ADD);
  text("recording camera input", 100, 100);

   
  }
  
  videoExport.saveFrame();
  
}


/////////////////////////////////////////
void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
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
