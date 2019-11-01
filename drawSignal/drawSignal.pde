int signalBoxSize = 151;

int minValue = 0;
int maxValue = 1024;

int signalBoxWidth = 1000;
int signalBoxHeight = 500;
int signalBoxMargin = 50;
int middle = signalBoxWidth / 2;

int windowWidth = signalBoxWidth + signalBoxMargin*2;
int windowHeight = signalBoxHeight + signalBoxMargin*2;

float lineWidthGap = middle / (float)signalBoxSize;
float lineHeightGap = signalBoxHeight / (float)abs(maxValue - minValue);

signalBox sigBox = new signalBox();
int count = 0; 

void setup(){
    
  size(500, 500);
  surface.setSize(windowWidth, windowHeight);
  
  
  //Testing signalBox!!!
    //signalBox aa = new signalBox();
    
    //for(int i = 0; i<123; i++)
    //  aa.inputSignal(i);
    
    //printArray(aa.dataBox);
    //printArray(aa.getSignal());
    
    //printArray(new int[] {1, 2, 3, 4});
}



void draw(){
  background(200);
  stroke(0);
  drawGrid();
  sigBox.inputSignal((int)random(1024));
  drawSignal(sigBox.getSignal());
  
  delay(10);
  //int[] box = new int[signalBoxSize];
  
  //for(int i=0; i<signalBoxSize; i++){
  //  ellipse(xPos(i), yPos(i*1024/signalBoxSize), 10, 10);
  //  box[i] = i*1024/signalBoxSize;
  //}
  //drawSignal(box);
}

void drawSignal(int[] signalBox){
  for(int i=0; i< signalBoxSize-1; i++){
    line(xPos(i), yPos(signalBox[i]), xPos(i+1), yPos(signalBox[i+1]));
  }
}

int xPos(int widthNum){
  int w = constrain(widthNum, 0, signalBoxSize);
  //return new int[] { signalBoxMargin + middle - lineWidthGap* widthNum, (maxValue - heightNum) * lineHeightGap + signalBoxMargin);
  return (int)(signalBoxMargin + middle - lineWidthGap* w);
}

int yPos(int heightNum){
  int h = constrain(heightNum, minValue, maxValue);
  //return new int[] { signalBoxMargin + middle - lineWidthGap* widthNum, (maxValue - heightNum) * lineHeightGap + signalBoxMargin);
  return (int)((maxValue - h) * lineHeightGap + signalBoxMargin);
}

void drawGrid(){
  line(signalBoxMargin, signalBoxMargin, windowWidth - signalBoxMargin, signalBoxMargin);
  line(signalBoxMargin, windowHeight - signalBoxMargin, windowWidth - signalBoxMargin, windowHeight - signalBoxMargin);

  line(signalBoxMargin + signalBoxWidth/2, signalBoxMargin, signalBoxMargin + signalBoxWidth/2, windowHeight - signalBoxMargin);
  
  line(signalBoxMargin, signalBoxMargin, signalBoxMargin, windowHeight - signalBoxMargin);
  line(windowWidth - signalBoxMargin, signalBoxMargin, windowWidth - signalBoxMargin, windowHeight - signalBoxMargin);
}

void printArray(int[] array){
  println();
  print(" {");
  for(int i=0; i<array.length-1; i++){
    print(array[i]);
    print(", ");
  }
  println(array[array.length-1] + "}");
  
}


class signalBox{
  int[] dataBox;
  int[] returnBox;
  int location = 0;
  
  signalBox(){
    dataBox = new int[signalBoxSize];
    returnBox = new int[signalBoxSize];
    for(int i=0; i<signalBoxSize; i++){
      dataBox[i] = 512;
    }
  }
  void inputSignal(int signal){
    signal = constrain(signal, 0, 1024);
    dataBox[location] = signal;
    location++;
    
    if(location >= signalBoxSize){
      location = 0;
    }
  }
  int[] getSignal(){
    for(int i=0; i< signalBoxSize; i++){
      
        if(0<= location-1-i)
          returnBox[i] = dataBox[location-1-i];
        else
          returnBox[i] = dataBox[signalBoxSize+location-1-i];
      
    }
    return returnBox;
  }
  
  
}
