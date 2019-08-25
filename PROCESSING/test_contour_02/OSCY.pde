import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress maxAddress;

int magnitude;
float[] oscparams = new float[3];
float[] belevs = new float[5];



/////////////////////////
void MaxOscOut(float p0, float p1, float p2) {
  /* create a new osc message object */
  OscMessage myMessage = new OscMessage("/orbgen");
  
  myMessage.add(p0); // add a float to the osc message 
  myMessage.add(p1); // add a float to the osc message 
  myMessage.add(p2); // add a float to the osc message     
  
  /* send the message */
  oscP5.send(myMessage, maxAddress); 
}


/////////////////////////
void oscOUT(float p0, float p1, float p2) {
  /* create a new osc message object */
  OscMessage myMessage = new OscMessage("/orbgen");
  
  myMessage.add(p0); // add a float to the osc message 
  myMessage.add(p1); // add a float to the osc message 
  myMessage.add(p2); // add a float to the osc message     
  
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void oscRESTART(float p0) {
  /* create a new osc message object */
  OscMessage myMessage = new OscMessage("/restart");
  
  myMessage.add(p0); // add a float to the osc message  
  
  /* send the message */
  oscP5.send(myMessage, maxAddress); 
}



/////////////////////////////////////
void oscEvent(OscMessage theOscMessage) {
  // generic check on every received message
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  
  // parsing message
  
 if(theOscMessage.checkAddrPattern("/pippo")==true) {
      println("thresh received");
   
      if(theOscMessage.checkTypetag("f")) {     
      oscparams[0] = theOscMessage.get(0).floatValue(); 
      threshy = int(oscparams[0]); 
       threshy = int(oscparams[1]); 
        threshy = int(oscparams[2]); 
      println("thresh received with params " + oscparams[0] );
      
      }     
   }
  
   else if(theOscMessage.checkAddrPattern("/orbgen")==true) {
         
      if(theOscMessage.checkTypetag("fff")) {     
      oscparams[0] = theOscMessage.get(0).floatValue(); 
      oscparams[1] = theOscMessage.get(1).floatValue(); 
      oscparams[2] = theOscMessage.get(2).floatValue(); 
      magnitude = int(oscparams[0]);       
     // TezOrbGen(oscparams[0], oscparams[1], oscparams[2]);
      println("orbgen received with params " + oscparams[0] + " // " + oscparams[1] + " // " + oscparams[2] );
      
      }     
   }
   
    else if(theOscMessage.checkAddrPattern("/tresh")==true) {
         
      if(theOscMessage.checkTypetag("fff")) {     
      oscparams[0] = theOscMessage.get(0).floatValue(); 
      oscparams[1] = theOscMessage.get(1).floatValue(); 
      oscparams[2] = theOscMessage.get(2).floatValue(); 
      threshy = int(oscparams[0]);       
     // TezOrbGen(oscparams[0], oscparams[1], oscparams[2]);
      println("thresh received with params " + oscparams[0] );
      
      }     
   }
   
   
  /// other
  
  else if(theOscMessage.checkAddrPattern("/test")==true) {
     println("osc test message received!");
    /* check if the typetag is the right one. ifs = int + float + string */
    if(theOscMessage.checkTypetag("ifs")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int firstValue = theOscMessage.get(0).intValue();  
      float secondValue = theOscMessage.get(1).floatValue();
      String thirdValue = theOscMessage.get(2).stringValue();
      print("### received an osc message /test with typetag ifs.");
      println(" values: "+firstValue+", "+secondValue+", "+thirdValue);
      return;
    }  
  } 
  
 //  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
