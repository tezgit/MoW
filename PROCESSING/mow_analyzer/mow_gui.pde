import controlP5.*;
// Control vars
ControlP5 cp5;
int buttonColor;
int buttonBgColor;
long lastOscMillis;
Textlabel myTitle, mainLabel, convLabel, cameraLabel;
Textlabel controllers;
Textlabel rt1, rtime1;

String pEvent;
float pValue;

boolean showcontrol = false;

// params vars
float[] vp = new float[9];


// Console vars
String[] cons = {">",">",">",">",">",">",">",">"};
boolean console = false;
int consindex = 0;
////////////////////////

void initPgui(){
  
    for (int n=0; n<9; ++n){
    vp[n]=0;
  }
  
// Init Controls
//cp5 = new ControlP5(this);


 int pX=20 + width-helpMargin*3;
 int pY=10 + helpMargin;
 

PFont pfont = createFont("Arial",20,true); // use true/false for smooth/no-smooth
 

   ControlFont font14 = new ControlFont(pfont,14);  
   ControlFont font12 = new ControlFont(pfont,12); 
   
   CColor c = new CColor();
   c.setBackground(color(77,77,77,90));
   c.setAlpha(100);
   
   mainLabel = cp5.addTextlabel("contourlabel")
    .setText("CONTOUR")
    .setPosition(pX, pY)
    .setColorValue(color(200,200,200))
    .setFont(font12)
    //.setColorValue(0x000000ff)
    ;
          
    // Slider for threshy
    cp5.addSlider("threshy")
      .setLabel("threshy")
      .setPosition(pX, pY+30)
      .setRange(1, 255)
      .setColorValue(color(255))
      .setColorActive(color(0,100,0))
      .setColorForeground(color(0,100,0))
      .setColorBackground(color(77,77,77, 90))
      .setValue(90)
     ;
     
  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("cdraw")
     .setPosition(pX,pY + 60)
     .setSize(30,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     .setColorBackground(color(77,77,77, 90))
     .setColorActive(color(0,200,0))
     ;
  
  cp5.addToggle("sdraw")
     .setPosition(pX + 60,pY + 60)
     .setSize(30,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     .setColorBackground(color(77,77,77, 90))
     .setColorActive(color(0,200,0))
     ;

  cp5.addToggle("ldraw")
     .setPosition(pX + 120,pY + 60)
     .setSize(30,10)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     .setColorBackground(color(77,77,77, 90))
     .setColorActive(color(200,0,0))
     ;
     
     
    mainLabel = cp5.addTextlabel("edgeslabel")
    .setText("EDGES")
    .setPosition(pX, pY+130)
    .setColorValue(color(200,200,200))
    .setFont(font12)
    //.setColorValue(0x000000ff)
    ;
    
        // Slider for cannyprm1
    cp5.addSlider("cannyprm1")
      .setLabel("Canny_1")
      .setPosition(pX, pY+180)
      .setRange(0, 50)
      .setColorValue(color(255))
      .setColorActive(color(0,100,0))
      .setColorForeground(color(0,100,0))
      .setColorBackground(color(77,77,77, 90))
      .setValue(10)
     ;
     
  
    // Slider for cannyprm2
    cp5.addSlider("cannyprm2")
      .setLabel("Canny_2")
      .setPosition(pX, pY+200)
      .setRange(0, 50)
      .setColorValue(color(255))
      .setColorActive(color(0,100,0))
      .setColorForeground(color(0,100,0))
      .setColorBackground(color(77,77,77, 90))
      .setValue(10)
     ;


      cp5.addScrollableList("curredge")
     .setPosition(pX, pY+150)
     .setSize(70, 150)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(edgemodes)
     .setCaptionLabel("edge type") 
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
     
   cp5.get(ScrollableList.class, "curredge").setType(ControlP5.DROPDOWN);
   cp5.get(ScrollableList.class, "curredge").close();
   cp5.get(ScrollableList.class, "curredge").setColorBackground(#008080); 
   cp5.get(ScrollableList.class, "curredge").setColor(c); 


     
     
     cp5.addScrollableList("currblend")
     .setPosition(pX+ 80, pY+150)
     .setSize(70, 300)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(blendstrings)
     .setCaptionLabel("blend modes") 
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
     
   cp5.get(ScrollableList.class, "currblend").setType(ControlP5.DROPDOWN);
   cp5.get(ScrollableList.class, "currblend").close();
   cp5.get(ScrollableList.class, "currblend").setColorBackground(#008080); 
   cp5.get(ScrollableList.class, "currblend").setColor(c); 
  
    
  
       
  /*
  cp5.addButton("gradbut")
     .setPosition(350, 320)
     .setImages(loadImage("gradbut.png"), loadImage("gradbut-on.png"), loadImage("gradbut.png"))
     .updateSize()
     .activateBy(ControlP5.PRESSED)
     ;
*/


}


//////////////////////////////////////
void controlEvent(ControlEvent theEvent) {
  /* events triggered by controllers are automatically forwarded to 
     the controlEvent method. by checking the name of a controller one can 
     distinguish which of the controllers has been changed.
  */ 
 
  /* check if the event is from a controller otherwise you'll get an error
     when clicking other interface elements like Radiobutton that don't support
     the controller() methods
  */
  
  if(theEvent.isController()) { 
    
    String cc="control event from : "+theEvent.controller().getName();
    pEvent=theEvent.controller().getName();
    float vv = theEvent.controller().getValue();
    pValue=theEvent.controller().getValue();
    cons(2, pEvent + " value: " + pValue); // print event and value to console
 
    updateOSC();
    
     if(theEvent.controller().getName()=="cdraw") {
       
           if (vv==0){ 
             cp5.getController("cdraw").setColorActive(color(200,0,0));
           } else{
           cp5.getController("cdraw").setColorActive(color(0,200,0));     
           }
      }
    
     if(theEvent.controller().getName()=="sdraw") {
       
           if (vv==0){ 
             cp5.getController("sdraw").setColorActive(color(200,0,0));
           } else{
           cp5.getController("sdraw").setColorActive(color(0,200,0));     
           }
      } 
     if(theEvent.controller().getName()=="ldraw") {
       
           if (vv==0){ 
             cp5.getController("ldraw").setColorActive(color(200,0,0));
           } else{
           cp5.getController("ldraw").setColorActive(color(0,200,0));     
           }
      }

    
    
    // check if gradient button is pushed
     if(theEvent.controller().getName()=="gradbut") {
      //nextGrad();
      println("gradbut : "+ vv);
    }

    
  }  
}

////////////////////////////////////////////
void showConsole(){
  fill(40, 40, 0, 200);
  noStroke();
  int ctop=height - height/4;
  rect(0,ctop, width, height);
  
  stroke(0,255,0);
  fill(0,255,0);
  textSize(9);
  
  int cs=cons.length - 1;
  


PFont fonty;
// The font must be located in the sketch's 
// "data" directory to load successfully
fonty = createFont("fonts/COURIER.TTF", 12);
textFont(fonty);

  text(cons[0] , 10, ctop + 20); 
  text(cons[1] , 10, ctop + 40); 
  text(cons[2] , 10, ctop + 60); 
  text(cons[3] , 10, ctop + 80); 
   
}
//////////////////////////////////////////
void cons(int cline, String mystring){
 // consindex++;
 // consindex=consindex % 8;
  consindex = cline -1;
  cons[consindex]= "> " + mystring;
  // println(cons[consindex]);
  
  // clear
  if(cline==0 || mystring=="clear"){
    for(int i=0; i<8;i++){
      cons[i] = ">> ";
    }
  }
  
}

////////////////////////////////
//////////////////////////
void setLock(Controller theController, boolean theValue) {

  theController.setLock(theValue);

  if (theValue) {
    theController.setColorBackground(color(150, 150));
    theController.setColorForeground(color(100, 100));
  } else {
    theController.setColorBackground(color(buttonBgColor));
    theController.setColorForeground(color(buttonColor));
  }
}

//////////////////////////
void hideControls(){
 cp5.getController("contourlabel").hide(); 
 cp5.getController("threshy").hide(); 
 cp5.getController("cdraw").hide(); 
 cp5.getController("sdraw").hide(); 
 cp5.getController("ldraw").hide(); 
 cp5.getController("edgeslabel").hide(); 
 cp5.getController("curredge").hide(); 
 cp5.getController("currblend").hide(); 
 cp5.getController("cannyprm1").hide();  
 cp5.getController("cannyprm2").hide();   
}

//////////////////////////
void showControls(){
 cp5.getController("contourlabel").show(); 
 cp5.getController("threshy").show(); 
 cp5.getController("cdraw").show(); 
 cp5.getController("sdraw").show();  
 cp5.getController("ldraw").show();  
 cp5.getController("edgeslabel").show(); 
 cp5.getController("curredge").show(); 
 cp5.getController("currblend").show(); 
 cp5.getController("cannyprm1").show();  
 cp5.getController("cannyprm2").show();  
}
