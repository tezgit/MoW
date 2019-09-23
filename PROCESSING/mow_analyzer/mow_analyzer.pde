import gab.opencv.*;
import processing.video.*;
import com.hamoid.*;
import java.util.*;  // needed for List
// import at.mukprojects.imageloader.image.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;

VideoExport videoExport;
boolean LIVECAMERA =false;
boolean newFrame=false;

OpenCV opencv, cvquad;
Histogram grayHist, rHist, gHist, bHist;
PImage imgz, sobel, videobuffer, zoomquad, zq, histMask;
Capture cam; 
Movie myMovie;
boolean mp = true;
boolean vidposFlag = false;
boolean imgFlag = true;
boolean blobFlag = false;

PFont f;
int jumpunit = 20;


boolean histoFlag = false;
String sketchPath = "";
boolean helpFlag = false;
int helpMargin = 100;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;
boolean contourFlag = false;
int cdraw = 1;
int sdraw = 1;
int ldraw = 0;
int threshy = 150;
boolean trsdir = true;

int marginX, marginY;

PVector point;

boolean edgesFlag = false;
int blendmodes[] = {BLEND,ADD,SUBTRACT,DARKEST,LIGHTEST,DIFFERENCE,EXCLUSION,MULTIPLY,SCREEN,OVERLAY,HARD_LIGHT,SOFT_LIGHT,DODGE,BURN};
String blendstrings[] = {"BLEND","ADD","SUBTRACT","DARKEST","LIGHTEST","DIFFERENCE","EXCLUSION","MULTIPLY","SCREEN","OVERLAY","HARD_LIGHT","SOFT_LIGHT","DODGE","BURN"};
int currblend = 0;
String edgemodes[] = {"SOBEL","SCHARR","CANNY"};
int curredge = 0;
int cannyprm1 = 10;
int cannyprm2 = 10;

boolean avgFlag = false;

int zzx = 600;
int zzy = 300;
int zw = 200;
int zh = 200;
float zoomfactor = 2;
boolean zoomFlag = false;

boolean recording = false; 

Mat skinHistogram;


void setup() {
 // ---- HD SCALED SIZES ------ 
 // size(1920, 1080);
 // size(1280, 720);
 // size(1138, 640);
 // size(1067, 600);
 // size(853, 480);
 // size(711, 400);
 // size(640, 360);
  // 745v  576
 
 fullScreen();
  // frameRate(25);
  
  // PATH INIT 
  sketchPath = sketchPath("");
  println("======================");
  println(sketchPath);
  println("======================");
  
  // SCREEN INIT 
  //frameRate(30);
  background(0);
  textSize(32);
  
  // FONT INIT 
  f = createFont(sketchPath + "fonts/" + "FirstInLine-1VzB.ttf",16,true); // Arial, 16 point, anti-aliasing on
 
   // GUI SETUP
  cp5 = new ControlP5(this);
  initPgui();
  hideControls();
 
 // CAMERA INIT 
  if(LIVECAMERA){
    String[] cameras = Capture.list();
        if (cameras.length == 0) {
          println("There are no cameras available for capture.");
          exit();
        } else {
          println("Available cameras:");
          for (int i = 0; i < cameras.length; i++) {
            println(cameras[i]);
          }
        
        } 
  }

  // OSC INIT             
  oscP5 = new OscP5(this, 7777);  // start oscP5, listening for incoming messages at port 7777 
  myRemoteLocation = new NetAddress("127.0.0.1", 7777);// address of destination server and port 
  maxAddress = new NetAddress("127.0.0.1", 8888);// address of destination server and port  
  oscPLite = new OscP5(this, 9999);  // start oscP5, listening for incoming messages at port 7777 
  LiteAddress = new NetAddress("192.168.1.255", 54321);// address of destination server and port 

  for(int i=1; i<=3; i++){
     OscLite(0,0,250);
     delay(250);
     OscLite(0,0,0);
     delay(250);
  }
   
  // MOVE INIT
  if (!LIVECAMERA){
      myMovie = new Movie(this, sketchPath+"MOW_720.mp4");
      myMovie.loop();
      opencv = new OpenCV(this, myMovie.width, myMovie.height);
      cvquad = new OpenCV(this, zw, zh);
      // opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
      
      // Prepare for video recording
       videoExport = new VideoExport(this, "record-movie.mp4");
       videoExport.setFrameRate(25);
       videoExport.startMovie();
 
    }
  
   marginX=(width - myMovie.width) / 2;
   marginY=(height - myMovie.height) / 2;
   
   videobuffer = new PImage(myMovie.width, myMovie.height);
   videobuffer.loadPixels();
   videobuffer.pixels = myMovie.pixels;  
   videobuffer.updatePixels();
   
   zoomquad = new PImage(800, 800);
  
   initBlobby();
   
}


//////////////////////////////////////////////
void draw() {
    background(0);

  if(myMovie.time() > 0){
    
   // loadPixels();
   myMovie.loadPixels(); // Make its pixels[] array available
   myMovie.updatePixels();

 
   videobuffer.pixels = myMovie.pixels;     
    
  //   image( opencv.getOutput(), 0, 0);
   
  // if(LIVECAMERA){cam.read();}
   // DISPLAY MOVIE
       translate(0,0);
       int x = (width - myMovie.width) / 2;
       int y = (height - myMovie.height) / 2;   
       if(imgFlag){image(myMovie, x, y);} // display movie
  
    
      loadPixels();
     //opencv.loadImage(myMovie); 
      opencv = new OpenCV(this, myMovie);
  
    if(console){translate(0,0); showConsole();}
 
       if(contourFlag){displayContour();} // display openCV CONTOUR
       
  //     translate(marginX,marginY);
                       
       if(edgesFlag){displayEdges();} // display openCV EDGES
       
       if(vidposFlag){displayVideoPos();} // display video position
       
       if(histoFlag){drawHisto();} // display openCV HISTOGRAM

       if(blobFlag){blobby();} // display BLOBS
       
       if(avgFlag){ DrawAvgColor();} // display Average Color
       
       if(zoomFlag){zoomy();} // display zooming rectangles
       
       if(helpFlag){displayHelp(); displayVideoPos();} // display HELP

 
          if(recording){
            videoExport.saveFrame();// record video
            //videoExport.saveFrame();// record video
            //videoExport.saveFrame();// record video
            }    
  }
  
  
  

}

/////////////////////////////////////
void displayHelp(){
  
  translate(0,0);
  
  
   // --- HELP window ---
  noStroke();
  fill(0,0,60,150); 
  rect(helpMargin, helpMargin, width-helpMargin*2,height-helpMargin*2);
  
  String helptext = "";
  
  textFont(f,24);  
  fill(200,200,200,150); 
  helptext = "HELP";
  text(helptext, helpMargin + 50, helpMargin + 50); 
  
  textFont(f,16);
  fill(0,250,0,250); 
  
  helptext = "H  :::  Help toggle on/off";
  text(helptext, helpMargin + 50, helpMargin + 100); 
  
  helptext = "v  :::  video position";
  text(helptext, helpMargin + 50, helpMargin + 130); 

  helptext = "p  :::  video pause/play";
  text(helptext, helpMargin + 50, helpMargin + 160); 
  
  helptext = "r  :::  video random position play";
  text(helptext, helpMargin + 50, helpMargin + 190); 

  helptext = " ->  :::  video skip forward";
  text(helptext, helpMargin + 50, helpMargin + 220); 

  helptext = " <-  :::  video skip backward";
  text(helptext, helpMargin + 50, helpMargin + 250); 
  
    helptext = " 0  :::  video recording toggle on/off";
  text(helptext, helpMargin + 50, helpMargin + 280); 

 // ------- OpenCV  help
 
  helptext = "i  :::  Hystograms  // OpenCV";
  text(helptext, helpMargin + 450, helpMargin + 100); 

  helptext = "c :::  Contour  // OpenCV";
  text(helptext, helpMargin + 450, helpMargin + 130); 
  
  helptext = "e :::  Edges  // OpenCV";
  text(helptext, helpMargin + 450, helpMargin + 160); 

  // rectangle for openCV params GUI
  noStroke();
  fill(0,0,0,30); 
  rect(width-helpMargin*3, helpMargin, helpMargin*2,height-helpMargin*2);


}


////////////////////////
void displayVideoPos(){
  translate(0,0);
  
  textFont(f,16);
  fill(200,200,200, 250);
  String vidpos = "pos (sec):  " + String.valueOf(myMovie.time());
  text(vidpos, helpMargin + marginX + 60,  height - helpMargin - 20); 
 //<>//
}

////////////////////////
void displayContour(){
    
 //   opencv.gray();
    opencv.threshold(threshy); 
    contours = opencv.findContours();

   int x = (width - myMovie.width) / 2;
   int y = (height - myMovie.height) / 2; 
   
   if(!helpFlag){translate(x, y);}

    for (Contour contour : contours) {
      
      if(cdraw > 0){fill(0,0,0,150); contour.draw();}
          ///
         
          if(sdraw > 0){ beginShape();}
          
           stroke(150, 150, 150);

           for (PVector point : contour.getPolygonApproximation().getPoints()) {
           vertex(point.x, point.y);

              
              if(ldraw > 0){  // DRAW LINES
                    stroke(150, 150, 150, random(99)+20);
                    translate(0, 0);
                    line(width/2, 0, point.x, point.y);
                    
                  float[] pointarray = point.array();  
                  int threshline = contours.size();
                  //      String trs = "threshline: " + String.valueOf(threshline);
                  //      text(trs, 20, 25);


                 }
            
          }
        
        fill(200,200,200,10);
        if(sdraw > 0){  endShape();}
          ///  
    } 
            
    translate(0, 0);
}


/////////////////////////////////////////////
void displayEdges(){
  
  if(curredge == 0){
    opencv.findSobelEdges(1,0);
  }else if(curredge == 1){
    opencv.findScharrEdges(OpenCV.HORIZONTAL);
  }else if(curredge == 2){
    opencv.findCannyEdges(cannyprm1,cannyprm2);
  }

    sobel = opencv.getSnapshot();
    
    
    //String edgemode = "ADD";   
    blend(sobel, 0, 0, myMovie.width, myMovie.height, marginX, marginY, opencv.width, opencv.height, currblend);

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
    
}




/////////////////
void mousePressed() {
  mp = !(mp);
    if(mp){
      //myMovie.pause();
    }
    else { //myMovie.loop();
    }
}
/////////////////
void mouseReleased() {
  // myMovie.loop();
}



/////////////////////////////////////////////
void movieEvent(Movie myMovie) {
  myMovie.read();
 // myMovie.loadPixels(); // Make its pixels[] array available
}

/////////////////////
color getAverageColor(PImage img) {
  img.loadPixels();
  int r = 0, g = 0, b = 0;
  for (int i=0; i<img.pixels.length; i++) {
    color c = img.pixels[i];
    r += c>>16&0xFF;
    g += c>>8&0xFF;
    b += c&0xFF;
  }
  r /= img.pixels.length;
  g /= img.pixels.length;
  b /= img.pixels.length;
  return color(r, g, b);
}

/////////////////////
void DrawAvgColor(){
 
  color frameColor = getAverageColor(videobuffer);
  

  int rr = int(red(frameColor));
  int gg = int(green(frameColor));
  int bb = int(blue(frameColor));
  fill(rr,gg,bb); 
  rect(0, 0, 140, 30); 
  
  textFont(f,24);  
  fill(200,200,200,150); 
  text(rr + " " + gg + " " + bb, 20, 22); 

  OscLite(rr,gg,bb);
  
}

///////////////////////////////////
void zoomy(){
  
  int zx = zzx + marginX;
  int zy = zzy + marginY;

  noFill();
  //noStroke();
  //int randgrey = int(random(30)+20);
  //stroke(1,1,1,randgrey);
  //rect(zx,zy + marginY,zw/2,zh/2);
  int randwhite = int(random(30)+20);
  stroke(250,250,250,randwhite);
  rect(zx-2,zy-2 + marginY,zw/2 +2,zh/2 +2);
  
  int zoomarg=int(zw*zoomfactor);

 pushMatrix();
 
  zoomquad=myMovie.get(zx,zy,zw/2,zh/2);
  // cvquad.loadImage(zoomquad);
  cvquad = new OpenCV(this, zoomquad);
  cvquad.useColor(RGB);
 //cvquad.findSobelEdges(1,0);
 // cvquad.findScharrEdges(OpenCV.HORIZONTAL);
 // cvquad.findCannyEdges(cannyprm1,cannyprm2);
 // cvquad.threshold(10);
  cvquad.brightness((int)map(mouseX, 0, width, -255, 255));
  int blurSize = 2;
  cvquad.blur(blurSize);
  zq = new PImage(zw,zh);
  zq = cvquad.getSnapshot();
  image(zq,100,(height-zoomarg)/2 ,int(zoomarg),int(zoomarg));
  popMatrix();
}
