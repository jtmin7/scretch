
PFont fontA;
int fontSize = 22;

int nbrRowPins = 8;
int nbrColPins = 8;

int rectMargin = 30/2;
int rectSize = 60/2;

int windowWidth = rectMargin*2 + (nbrColPins-1)*rectMargin + nbrColPins*rectSize;
int windowHeight = rectMargin*2 + (nbrRowPins-1)*rectMargin + nbrRowPins*rectSize;

int lastTime = 0;
boolean colorStatus = true;

void setup(){
    size(500, 500); 
   
    surface.setSize(windowWidth, windowHeight);
    
    fontA = createFont("Arial.normal", fontSize);
    textFont(fontA);
    textSize(fontSize);
    
    lastTime = millis();
}

void draw(){
    background(240);
    if(colorStatus == true)
      fill(010, 0, 210);
    else
      fill(0, 220, 50);
      
      
    for(int row=0; row<8; row++){
      for(int col = 0; col<8; col++){
        drawRect(row, col);
      }
    }
    
    
    if(millis() - lastTime > 1000){
      lastTime = millis();
      colorStatus = !colorStatus;
      println(lastTime);
    }
    
    
    delay(50); 
    
}
//processign is draw is one count

void drawRect(int row, int col){
  rect(rectMargin + row*rectMargin + row*rectSize, 
        rectMargin + col*rectMargin + col*rectSize, 
        rectSize, rectSize);
}
