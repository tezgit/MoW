int histoW = 150;
int histoH = 50;
int histoMargin = 100;
int histoAlpha = 90;
int hx = 250;
  
//////////////////////////////////////////////
void drawHisto(){
  translate(0,0);
   
  grayHist = opencv.findHistogram(opencv.getGray(), 256);
  rHist = opencv.findHistogram(opencv.getR(), 256);
  gHist = opencv.findHistogram(opencv.getG(), 256);
  bHist = opencv.findHistogram(opencv.getB(), 256);
 

  if (!contourFlag && !edgesFlag){
      // --- GREY HISTOGRAM ---
      noStroke();
      fill(0,0,0,histoAlpha); 
      rect(marginX + hx + (histoW*1), height -helpMargin - histoH*9, histoW*3, histoH*8);

      fill(200,200,200,histoAlpha*4); 
      noStroke();
      grayHist.draw(marginX + hx +(histoW*1), height -helpMargin - histoH*9, histoW, histoH*8);
    }

  // --- RED HISTOGRAM ---
  noStroke();
  fill(200,0,0,histoAlpha); 
  rect(marginX + hx + (histoW*1), height -helpMargin - histoH, histoW, histoH);
  fill(200,200,200,histoAlpha*4); 
  noStroke();
  rHist.draw(marginX + hx + (histoW*1), height -helpMargin - histoH, histoW, histoH);

  // --- GREEN HISTOGRAM ---
  fill(0,200,0,histoAlpha); 
  rect(marginX + hx + (histoW*2), height -helpMargin - histoH, histoW, histoH);
  fill(200,200,200,histoAlpha*4); 
  noStroke();
  gHist.draw(marginX + hx + (histoW*2), height -helpMargin - histoH, histoW, histoH);

  // --- BLUE HISTOGRAM ---
  fill(0,0,200,histoAlpha); 
  rect(marginX + hx + (histoW*3), height -helpMargin - histoH, histoW, histoH);
  fill(200,200,200,histoAlpha*4); 
  noStroke();
  bHist.draw(marginX + hx + (histoW*3), height -helpMargin - histoH, histoW, histoH);

}
