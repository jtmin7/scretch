import processing.serial.*;
Serial myPort;
String message = null;
PFont fontA;
int fontSize = 22;
int maxNumberOfLabels = 12;
int rectMargin = 200;
int windowWidth = 1200;
int windowHeight = rectMargin + (maxNumberOfLabels + 1)*(fontSize*2);
int rectWidth = windowWidth- rectMargin*2;
int rectHeight = windowHeight -rectMargin;
int rectCenter = rectMargin + rectWidth/2;

int origin = rectMargin;
int minValue = 0;
int maxValue = 1024;
int standardValue = maxValue /2 ;

float scale = float(rectWidth)/(maxValue - minValue);

String[] sensorLabels = { "PM 1.0 (ug/m3)", "PM 2.5 (ug/m3)", "PM 10.0 (ug/m3)", "HCHO", "TVOC", };

int labelCount = maxNumberOfLabels;


int[] position = {100, 300, 700, 200, 400, 600};
int[] position2 = {50, 500, 900, 800, 600, 300, 200};
int[] position3 = {700, 400, 100, 30, 500, 1024};
int[] position4 = {300, 600, 200, 50, 500, 200, 6000};

virtualPositioning v1 = new virtualPositioning(30, position, minValue, maxValue);
virtualPositioning v2 = new virtualPositioning(20, position2, minValue, maxValue);
virtualPositioning v3 = new virtualPositioning(30, position3, minValue, maxValue);
virtualPositioning v4 = new virtualPositioning(50, position4, minValue, maxValue);
virtualPositioning v5 = new virtualPositioning(40, position2, minValue, maxValue);

gradationColor c1 = new gradationColor(240, 240, 96, 240, 0, 144, minValue, maxValue);
gradationColor c2 = new gradationColor(144, 240, 192, 96, 240, 96, minValue, maxValue);
gradationColor c3 = new gradationColor(0, 90, 192, 96, 240, 96, minValue, maxValue);
gradationColor c4 = new gradationColor(144,96, 0, 192,  240, 6, minValue, maxValue);
gradationColor c5 = new gradationColor(70, 150, 240, 0, 100, 28, minValue, maxValue);





void setup(){
  scale = abs(scale);
  origin = getOrigin(standardValue, minValue, rectMargin, scale);
  
  size(600, 600);
  //size(windowWidth, windowHeight);
  surface.setSize(windowWidth+400, windowHeight);
  short portIndex = 2;
  //String portName = Serial.list()[portIndex];
  //println(Serial.list());
  //println("Connecting to -> " + portName);
  //myPort = new Serial(this, portName, 57600);
  fontA = createFont("Arial.normal", fontSize);
  textFont(fontA);
  labelCount = sensorLabels.length;
  textSize(fontSize);

}

void drawGrid(){
  fill(0);
  text(minValue, xPos(minValue), rectMargin - fontSize);
  line(xPos(minValue), rectMargin, xPos(minValue), rectHeight + fontSize);
  
  text(standardValue , origin, rectMargin-fontSize);
  line(origin, rectMargin, origin, rectHeight + fontSize);
  
  text(maxValue, xPos(maxValue), rectMargin - fontSize);
  line(xPos(maxValue), rectMargin, xPos(maxValue), rectHeight+fontSize);
  
  for(int i=0; i< labelCount; i++){
    text(sensorLabels[i], fontSize, yPos(i));
    text(sensorLabels[i], xPos(maxValue) + fontSize, yPos(i));
  }
}

int yPos(int index){
  return rectMargin + fontSize + (index*fontSize*2);
}
int xPos(int index){
  return origin + int(scale * (index - standardValue));
}

void drawBar(int yIndex, int value){
  rect(origin, yPos(yIndex) - fontSize, (value - standardValue) * scale, fontSize);
}
void draw(){
  background(255);
  drawGrid();
  
  drawBar_v3(0, v1.getVirtualPosition(), c1);
  drawBar_v3(1, v2.getVirtualPosition(), c1);
  drawBar_v3(2, v3.getVirtualPosition(), c1);
  drawBar_v3(3, v4.getVirtualPosition(), c1);
  drawBar_v3(4, v5.getVirtualPosition(), c1);
  
  delay(10);
}


void showArray(int[] array, String name){
  print("---[ "); print( name); println(" ]---");
  for(int i=0; i< array.length; i++){
    println(array[i]);
  }
}
void testSetArray(int[] array){
  for(int i=0; i<array.length; i++){
    array[i] = constrain(array[i], 0, 40);
  }
}

int getOrigin(int standardValue, int minValue, int rectMargin, float scale){
  int value = standardValue - minValue;
  return rectMargin + int(value * scale);
}


void drawBar_v3(int index, int var, gradationColor gColor){
  gColor.fillColor(var);
  drawBar(index, var);
}

class virtualPositioning{
  int arrayNumCount = 0;
  int timeCount = 0;
  int gapTime = 10;
  int[] positionArray = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int arrayMaxLength = 10;
  
  float currentPosition = 0.0f;
  float unitDistance = 0.0f;
  
  virtualPositioning(int gapTime, int[] positionArray, int minValue, int maxValue){
    this.gapTime = gapTime;
    arrayMaxLength = min(positionArray.length, this.positionArray.length);
    
    arrayCopy(positionArray, 0, this.positionArray, 0, arrayMaxLength);
    setArrayConstrain(minValue, maxValue);
  }
  
  float getUnitDistance(int startPosition, int finishPosition, int gapTime){
    return (float)(finishPosition - startPosition) / (float)gapTime;
  }
  
  void setArrayConstrain(int minValue, int maxValue){
    for(int i=0; i<arrayMaxLength; i++){
      positionArray[i] = constrain(positionArray[i], minValue, maxValue);
    }
  }
  
  
  int getVirtualPosition(){
    if(arrayNumCount > arrayMaxLength-2){
      //currentPosition = getPosition(positionArray[arrayNumCount], positionArray[0], timeCount, gapTime);
      //timeCount++;
      //if(timeCount >= gapTime){
      //  timeCount=0;
      //  arrayNumCount = 0;
      //}
      
      if(timeCount == 0){
        currentPosition = positionArray[arrayNumCount];
        unitDistance = getUnitDistance(positionArray[arrayNumCount], positionArray[0], gapTime);
        timeCount++;
      }
      else if(timeCount <= gapTime){
        currentPosition = currentPosition + unitDistance;
        timeCount++;
      }
      else{
        currentPosition = currentPosition + unitDistance;
        timeCount=0;
        arrayNumCount=0;
      }
      
    }
    else{
            
      if(timeCount == 0){
        currentPosition = positionArray[arrayNumCount];
        unitDistance = getUnitDistance(positionArray[arrayNumCount], positionArray[arrayNumCount+1], gapTime);
        timeCount++;
      }
      else if(timeCount <= gapTime){
        currentPosition = currentPosition + unitDistance;
        timeCount++;
      }
      else{
        currentPosition = currentPosition + unitDistance;
        timeCount=0;
        arrayNumCount++;
      }
    }
    
    return (int)currentPosition;
  }
  
  
  int getPosition(int startPosition, int finishPosition, int timeCount, int gapTime){
    return startPosition + (timeCount*((finishPosition-startPosition)/gapTime));
  }
}

class gradationColor{
  int startR = 144, finishR = 240;
  int startG = 240, finishG = 0;
  int startB = 240, finishB = 0;
  int minValueBar, maxValueBar;
  gradationColor(){
  }
  gradationColor(int startR, int startG, int startB, int finishR, int finishG, int finishB, int minValueBar, int maxValueBar){
    this.startR = startR;
    this.finishR = finishR;
    this.startG = startG;
    this.finishG = finishG;
    this.startB = startB;
    this.finishB = finishB;
    this.minValueBar = minValueBar;
    this.maxValueBar = maxValueBar;
  }
  
  int getColor(int minValueBar, int maxValueBar, int currentValueBar, int startConcent, int finishConcent){
    return startConcent + (currentValueBar-minValueBar)*(finishConcent-startConcent)/(maxValueBar-minValueBar); 
  }
  int getColorR(int currentValueBar){
    return getColor(minValueBar, maxValueBar, currentValueBar, startR, finishR);
  }
  int getColorG(int currentValueBar){
    return getColor(minValueBar, maxValueBar, currentValueBar, startG, finishG);
  }
  int getColorB(int currentValueBar){
    return getColor(minValueBar, maxValueBar, currentValueBar, startB, finishB);
  }

  void fillColor(int currentValueBar){
    fill(getColorR(currentValueBar), getColorG(currentValueBar), getColorB(currentValueBar));
  }
}
