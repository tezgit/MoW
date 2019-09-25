// Console vars
String[] dT = {">",">",">",">",">",">",">",">",">",">",">",">",">",">",">",">",">"};
boolean datatext = false;
int dTindex = 0;
////////////////////////////////////////////
void showdatatext(){
  fill(40, 40, 0, 200);
  noStroke();
  int dtop=0; // height - height/4;
  int dleft = 30;
  int dgap = 20;
  rect(dleft,dtop, 250, height);
  
  stroke(0,255,0);
  fill(255,255,255, 100);
  textSize(9);
  
  int cs=dT.length - 1;
  


PFont fonty;
// The font must be located in the sketch's 
// "data" directory to load successfully
fonty = createFont("fonts/COURIER.TTF", 12);
textFont(fonty);

  text(dT[0] , dleft + 10, dtop +  dgap * 1); 
  text(dT[2] , dleft + 10, dtop +  dgap * 3); 
  text(dT[3] , dleft + 10, dtop +  dgap * 4);
  text(dT[4] , dleft + 10, dtop +  dgap * 5);
  text(dT[5] , dleft + 10, dtop +  dgap * 6);
  text(dT[6] , dleft + 10, dtop +  dgap * 7);
  text(dT[7] , dleft + 10, dtop +  dgap * 8);
  text(dT[8] , dleft + 10, dtop +  dgap * 9); 
  text(dT[9] , dleft + 10, dtop +  dgap * 10); 
  text(dT[10] , dleft + 10, dtop +  dgap * 11); 
  text(dT[11] , dleft + 10, dtop +  dgap * 12);
  text(dT[12] , dleft + 10, dtop +  dgap * 13);
  text(dT[13] , dleft + 10, dtop +  dgap * 14);
  text(dT[14] , dleft + 10, dtop +  dgap * 15);
  text(dT[15] , dleft + 10, dtop +  dgap * 16);
  
   
}
//////////////////////////////////////////
void datatext(int dline, String mystring){
 // consindex++;
 // consindex=consindex % 8;
  dTindex = dline -1;
  dT[dTindex]= "> " + mystring;
  // println(cons[consindex]);
  
  // clear
  if(dline==0 || mystring=="clear"){
    for(int i=0; i<8;i++){
      dT[i] = ">> ";
    }
  }
  
}
