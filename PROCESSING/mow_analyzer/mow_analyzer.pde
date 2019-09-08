import gab.opencv.*;
import processing.video.*;

boolean LIVECAMERA =false;

OpenCV opencv;
Histogram grayHist, rHist, gHist, bHist;
PImage img, videobuffer;
Capture cam; 
Movie myMovie;
boolean mp = true;
boolean vidposFlag = false;
PFont f;
int jumpunit = 20;
int histoW = 250;
int histoH = 50;
int histoMargin = 100;
int histoAlpha = 50;
boolean histoFlag = false;
String sketchPath = "";
boolean helpFlag = false;
int helpMargin = 100;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;
boolean contourFlag = false;
int threshy = 120;
boolean trsdir = true;

int marginX, marginY;

PVector point;
boolean CONTLINE = true;

void setup() {
 
  // SIZE INIT 
 // ---- HD SCALED SIZES ------ 
 // size(1920, 1080);
  //size(1280, 720);
 // size(1138, 640);
 // size(1067, 600);
 // size(853, 480);
 // size(711, 400);
 // size(640, 360);
 fullScreen();
 
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
  f = createFont(sketchPath + "fonts/" + "THEOREM.ttf",16,true); // Arial, 16 point, anti-aliasing on
 
 
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
  oscP5 = new OscP5(this, 7777);  /* start oscP5, listening for incoming messages at port 7777 */
  myRemoteLocation = new NetAddress("127.0.0.1", 7777);/* address of destination server and port */
  maxAddress = new NetAddress("127.0.0.1", 8888);/* address of destination server and port */

  // MOVE INIT
  if (!LIVECAMERA){
      myMovie = new Movie(this, sketchPath+"as-video-test-720.mp4");
      myMovie.loop();
  }
  
  // image(myMovie, 0, 0); // display movie
  
 opencv = new OpenCV(this, myMovie.width, myMovie.height);
 opencv.startBackgroundSubtraction(5, 3, 0.5);
  
 marginX=(width - myMovie.width) / 2;
 marginY=(height - myMovie.height) / 2;
 
 
  //image( opencv.image(), 0, 0 );                     // display OpenCV buffer
  //image( loadImage("niolon.jpg"), 0, 0);             // show image source



}


//////////////////////////////////////////////
void draw() {
  background(0);
   
   if(LIVECAMERA){ cam.read();}  // capture camera video
   
   // DISPLAY MOVIE
   translate(0,0);
   int x = (width - myMovie.width) / 2;
   int y = (height - myMovie.height) / 2;   
   image(myMovie, x, y); // display movie
  // println("VIDEO myMovie: " + myMovie);
    
    videobuffer = myMovie.get(0,0,myMovie.width,myMovie.height);
     
  // opencv.loadImage(videobuffer); 
      
  opencv = new OpenCV(this, myMovie);
   
   
       if(contourFlag){displayContour();} // display CONTOUR
       
       translate(0,0);
        
       if(histoFlag){drawHisto();} // display histogram
       
       if(vidposFlag){displayVideoPos();} // display video position

       if(helpFlag){displayHelp();} // display HELP

}

/////////////////////////////////////
void displayHelp(){
  
  translate(0,0);
  
   // --- HELP window ---
  noStroke();
  fill(0,0,0,histoAlpha); 
  rect(helpMargin, helpMargin, width-helpMargin*2,height-helpMargin*2);
  
  String helptext = "";
  
  textFont(f,24);  
  fill(200,200,200,150); 
  helptext = "HELP";
  text(helptext, helpMargin + 50, helpMargin + 50); 
  
  textFont(f,16);
  fill(0,200,0,200); 
  
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

 // ------- OpenCV  help
 
  helptext = "i  :::  Hystograms  // OpenCV";
  text(helptext, helpMargin + 450, helpMargin + 100); 

  helptext = " c :::  Contour  // OpenCV";
  text(helptext, helpMargin + 450, helpMargin + 130); 

}

//////////////////////////////////////////////
void drawHisto(){
  translate(0,0);
  
  grayHist = opencv.findHistogram(opencv.getGray(), 256);
  rHist = opencv.findHistogram(opencv.getR(), 256);
  gHist = opencv.findHistogram(opencv.getG(), 256);
  bHist = opencv.findHistogram(opencv.getB(), 256);
 
 
  if (!contourFlag){
      // --- GREY HISTOGRAM ---
      noStroke();
      fill(0,0,0,histoAlpha); 
      rect(width-(histoW+histoMargin), histoMargin, histoW, histoH + histoMargin/2);
      fill(200,200,200,histoAlpha*4); 
      noStroke();
      grayHist.draw(width-(histoW+histoMargin), histoMargin, histoW, histoH + histoMargin/2);
  }

  // --- RED HISTOGRAM ---
  noStroke();
  fill(200,0,0,histoAlpha); 
  rect(width-(histoW+histoMargin), histoMargin + histoH*2, histoW, histoH + histoMargin/2);
  fill(200,200,200,histoAlpha*4); 
  noStroke();
  rHist.draw(width-(histoW+histoMargin), histoMargin + histoH*2, histoW, histoH + histoMargin/2);

  // --- GREEN HISTOGRAM ---
  fill(0,200,0,histoAlpha); 
  rect(width-(histoW+histoMargin), histoMargin + histoH*4, histoW, histoH + histoMargin/2);
  fill(200,200,200,histoAlpha*4); 
  noStroke();
  gHist.draw(width-(histoW+histoMargin), histoMargin + histoH*4, histoW, histoH + histoMargin/2);


  // --- BLUE HISTOGRAM ---
  fill(0,0,200,histoAlpha); 
  rect(width-(histoW+histoMargin), histoMargin + histoH*6, histoW, histoH + histoMargin/2);
  fill(200,200,200,histoAlpha*4); 
  noStroke();
  bHist.draw(width-(histoW+histoMargin), histoMargin + histoH*6, histoW, histoH + histoMargin/2);


 
}


////////////////////////
void displayVideoPos(){
  translate(0,0);
  
  textFont(f,16);
  fill(200,200,200, 250);
  String vidpos = "pos: " + String.valueOf(myMovie.time());
  text(vidpos, width-(histoW+histoMargin - 12), histoMargin + 12); 
}

////////////////////////
void displayContour(){
    
    opencv.gray();
    opencv.threshold(threshy); 
    contours = opencv.findContours();

   int x = (width - myMovie.width) / 2;
   int y = (height - myMovie.height) / 2; 
   translate(x, y);

      //for (Contour contour : opencv.findContours()) {
      //    contour.draw();
      //}

    for (Contour contour : contours) {
      //stroke(0, 0, 50);
      fill(0,250,0,30);
      //contour.draw();
          ///
          stroke(0, 0, 200);
          beginShape();
          
           for (PVector point : contour.getPolygonApproximation().getPoints()) {
            vertex(point.x, point.y);
            
            if(CONTLINE){
                    
                  
                  float[] pointarray = point.array();  
                  int threshline = pointarray.length;
                 
                  if(threshline > 210){
                    trsdir = false;  
                  }else if (threshline <= 0){
                    trsdir = true;
                  }
                  
                  if(trsdir == false){
                    threshy -= 0.5;
                  }else{
                    threshy += 0.5;
                  }
                    
                  
                  
                  
                  stroke(100, 100, 100, random(99)+20);
                  translate(0, 0);
                  line(width/2, 0, point.x, point.y);
                 // line(width/2, height-marginY*2, point.x, point.y); 
                  
                
                          
            }
            
          }
          endShape();
          ///
    
    } 
    
    
    

    
    
    translate(0, 0);

}


/////////////////////////////////////////////
void movieEvent(Movie m) {
  m.read(); // Called every time a new frame is available to read

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

/////////////////
void keyPressed(){
println("pressed " + int(key) + " " + keyCode);


  if (keyCode == 80){ // key "p"
         mp = !(mp);
         if(mp){
          myMovie.pause();
        }
        else {myMovie.loop(); }
    }
  
  
    else if (keyCode == 39){ // key arrow RIGHT
          float newpos=myMovie.time() + myMovie.duration() / jumpunit;
          if(newpos < myMovie.duration()){
                 myMovie.jump(newpos);
          }else{
            myMovie.jump(0);
          }
          
    }     
   
    
    else if (keyCode == 37){ // key arrow LEFT
             float newpos=myMovie.time() - myMovie.duration() / jumpunit;
          if(newpos > 0){
                 myMovie.jump(newpos);
          }else{
            myMovie.jump(myMovie.duration() - jumpunit );
        }
        
    }
  
    else if (keyCode == 82){ // key "r"
          myMovie.jump(random(myMovie.duration()));
    }
    
    else if (keyCode == 73){ // key "i"
         histoFlag=!(histoFlag);
    }
    
    else if (keyCode == 86){ // key "v"
         vidposFlag=!(vidposFlag);
    }
    
    else if (keyCode == 72){ // key "h"
         helpFlag=!(helpFlag);
    }
    
    else if (keyCode == 67){ // key "c"
         contourFlag=!(contourFlag);
    }
 
}
