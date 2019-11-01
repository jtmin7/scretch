import java.awt.AWTException;
import processing.serial.*;

Serial myPort;
PFont fontA;
int fontSize = 22;
int maxNumberOfLabels = 12;
int rectMargin = 200;
int windowWidth = 1200;
int windowHeight = rectMargin + (maxNumberOfLabels + 1)*(fontSize*2);
int rectWidth = windowWidth- rectMargin*2;
int rectHeight = windowHeight -rectMargin;
int rectCenter = rectMargin + rectWidth/2;
public static final short LF = 10;

public static final short recMessageLength = 3;
int[] myData = new int[] {0, 0, 0 };


int origin = rectMargin;
int minValue = -1024;
int maxValue = 1024;
int standardValue = 0 ;

float scale = float(rectWidth)/(maxValue - minValue);

String[] sensorLabels = { "PM 1.0 (ug/m3)", "PM 2.5 (ug/m3)", "PM 10.0 (ug/m3)", "HCHO", "TVOC", };

int labelCount = maxNumberOfLabels;





void setup(){
  scale = abs(scale);
  origin = getOrigin(standardValue, minValue, rectMargin, scale);
  
  size(1200, 700);
  
  fontA = createFont("Arial.normal", fontSize);
  textFont(fontA);
  labelCount = sensorLabels.length;
  textSize(fontSize);
  
  String portName = Serial.list()[1];
  print(portName);
  myPort = new Serial(this, portName, 9600);

}

void draw(){
  background(255);
  drawGrid();
  
  
  drawBar(1, myData[2]);
  drawBar(2, myData[1]);
  drawBar(3, myData[0]);
  
  
  delay(1000);
}

void serialEvent(Serial p){
  String message = myPort.readStringUntil(LF);
  
  
  if(message != null){
    //println(message);
    
    String[] data = message.split(",");
    if(data[0].equals("H")){
      if(data[1].equals("D")){
        if(data.length > 2 + recMessageLength){
           try{
             for (int i=0; i<recMessageLength; i++){
               myData[i] = Integer.parseInt(data[i+2]);
             }
             printArray(myData);
           }
           catch(Throwable t){
             println(".syntex error");
             //print(message);
             
           }
        }
      }
    }
    
  }
}

void printArray(String[] array){
  for(int i=0; i< array.length; i++){ 
    print(array[i] + ", ");  
  
  }
  println();
}
void printArray(int[] array){
  for(int i=0; i< array.length; i++){ 
    print(array[i] + ", ");  
  
  }
  println();
}


int getOrigin(int standardValue, int minValue, int rectMargin, float scale){
  int value = standardValue - minValue;
  return rectMargin + int(value * scale);
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
