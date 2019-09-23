/////////////////
void keyPressed(){

  println(" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-");
  println("pressed " + int(key) + " " + keyCode);
  println(" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-");


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
          }else{ myMovie.jump(0);}
          
        }     
   
    
    else if (keyCode == 37){ // key arrow LEFT
             float newpos=myMovie.time() - myMovie.duration() / jumpunit;
          if(newpos > 0){
                 myMovie.jump(newpos);
          }else{
                  myMovie.jump(myMovie.duration() - jumpunit );
          }
        
      }
  
    else if (keyCode == 67){ // key "c"
         contourFlag=!(contourFlag);
    }
    
    else if (keyCode == 69){ // key "e"
         edgesFlag=!(edgesFlag);
    }
    else if (keyCode == 82){ // key "r"
          myMovie.jump(random(myMovie.duration()));
    }

    else if (keyCode == 71){ // key "g"
         histoFlag=!(histoFlag);
    }
    
    else if (keyCode == 73){ // key "i"
         imgFlag=!(imgFlag);
    }
    
    else if (keyCode == 86){ // key "v"
         vidposFlag=!(vidposFlag);
    }
    
    else if (keyCode == 72){ // key "h"
         helpFlag=!(helpFlag);
         if(helpFlag){showControls();}else{hideControls();}
    }
    
    else if (keyCode == 38){ // key "arrow UP"        
         if(currblend<blendmodes.length) {currblend++;}
         else{currblend = 0;}        
    }
    
    else if (keyCode == 40){ // key "arrow UP"        
         if(currblend>0) {currblend--;}
         else{currblend =  blendmodes.length;}        
    }

    
   else if (key == 48) {  // Key 0 // zero
      recording=!(recording);    
      if(recording == false){videoExport.endMovie();}
    }   
    
   else if (key == 'k' ) { // toggle console
      console = !(console);
   }
   
   else if (key == 'b' ) { // toggle blobs
      blobFlag = !(blobFlag);
   }
      
   else if (key == 'a' ) { // toggle Average
      avgFlag = !(avgFlag);
   }

   else if (key == 'z' ) { // toggle Average
      zoomFlag = !(zoomFlag);
   }


 
}
