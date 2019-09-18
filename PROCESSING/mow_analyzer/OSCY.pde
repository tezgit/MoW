import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress maxAddress;
String OSCmsg;

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
  
 if(theOscMessage.checkAddrPattern("/tresh")==true) {
         
      if(theOscMessage.checkTypetag("fff")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          oscparams[1] = theOscMessage.get(1).floatValue(); 
          oscparams[2] = theOscMessage.get(2).floatValue(); 
          threshy = int(oscparams[0]);       
         // TezOrbGen(oscparams[0], oscparams[1], oscparams[2]);
          println("thresh received with params " + oscparams[0] );
      
      }else if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          threshy = int(oscparams[0]);       
         // TezOrbGen(oscparams[0], oscparams[1], oscparams[2]);
          println("thresh received with params " + oscparams[0] );
      
      }     
   }
   
   
       else if(theOscMessage.checkAddrPattern("/contourFlag")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          contourFlag = parseBoolean(int(oscparams[0]));     
          println("contourFlag received with params " + oscparams[0] );
      }
      
    }
 
    else if(theOscMessage.checkAddrPattern("/edgesFlag")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          edgesFlag = parseBoolean(int(oscparams[0]));     
          println("edgesFlag received with params " + oscparams[0] );
      }
      
    }
 
    else if(theOscMessage.checkAddrPattern("/histoFlag")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          histoFlag = parseBoolean(int(oscparams[0]));     
          println("histoFlag received with params " + oscparams[0] );
      }
      
    }
 
    else if(theOscMessage.checkAddrPattern("/cdraw")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          cdraw = int(oscparams[0]);     
          println("cdraw received with params " + oscparams[0] );
      }
      
    }
 
     else if(theOscMessage.checkAddrPattern("/sdraw")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          sdraw = int(oscparams[0]);     
          println("sdraw received with params " + oscparams[0] );
      }
      
    }
    
    else if(theOscMessage.checkAddrPattern("/ldraw")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          ldraw = int(oscparams[0]);     
          println("ldraw received with params " + oscparams[0] );
      }
      
    }
    
    else if(theOscMessage.checkAddrPattern("/cannyprm1")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          cannyprm1 = int(oscparams[0]);     
          println("cannyprm1 received with params " + oscparams[0] );
      }
      
    }

    
     else if(theOscMessage.checkAddrPattern("/cannyprm2")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          cannyprm2 = int(oscparams[0]);     
          println("cannyprm2 received with params " + oscparams[0] );
      }
      
    }

     else if(theOscMessage.checkAddrPattern("/curredge")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          curredge = int(oscparams[0]);     
          println("curredge received with params " + oscparams[0] );
      }
      
    }

     else if(theOscMessage.checkAddrPattern("/currblend")==true) {
         
      if(theOscMessage.checkTypetag("f")) {     
          oscparams[0] = theOscMessage.get(0).floatValue(); 
          currblend = int(oscparams[0]);     
          println("currblend received with params " + oscparams[0] );
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

//////////////////////////////////////////////////
void updateOSC() {
   OscMessage myMessage = new OscMessage("/" + pEvent);
   myMessage.add(pValue); /* add an int to the osc message */ 
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  cons(3, "OSC out >> " + myMessage); // print to Console
 }

/*
//////////////////////////////////////////////////
// incoming osc message are forwarded to the oscEvent method. 
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage 
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  // relays incoming message to OSC out
  oscP5.send(theOscMessage, myRemoteLocation); 
}

*/
