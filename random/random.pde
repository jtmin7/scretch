

void setup(){
  randomSeed(5000);
  background(200);
  size(300, 300);
}

void draw(){
  
  delay(500);
  int a = (int)random(1000);
  boolean b = true;
  if(a > 500){
    b = true;
    fill(0, 100, 50);
  }
  else{
    b = false;
    fill(200, 50, 10);
  }
  
  rect(100, 100, 100, 100);
  
  println(b);
}
