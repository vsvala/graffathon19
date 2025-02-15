import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import moonlander.library.*;

// These control how big the opened window is.
// Before you release your demo, set these to 
// full HD resolution (1920x1080).


int ellipseCounter = 0;
int flowerCounter = 0;
int mandalaCounter = 0;
int treeCounter = 0;
float a = 0.0;
float s = 0.0;

//sin wave draw function helper variables
float theta = 0.0;
float amplitude = height*6;
float period = 500.0;
float dx;
float[] yvalues;
int w;
int xspacing = 16;

//apndx wave helper variables
int apndx_xspacing = 16;   // How far apart should each horizontal location be spaced
int apndx_w;              // Width of entire wave
float apndx_theta = 0.0;  // Start angle at 0
float apndx_period = 500.0;  // How many pixels before the wave repeats, 500.0 original
float apndx_dx;  // Value for incrementing X, a function of period and xspacing
float[] apndx_yvalues;  // Using an array to store height values for the wave
float ampli = 100.0;  // Height of wave

Moonlander moonlander;
PFont font; 


/*
 * settings() must be used when calling size with variable height and width
 * New in processing 3
 */
void settings() {
  // Set up the drawing area size and renderer (P2D / P3D).
  // size(1980/2, 1080/2, P2D);
  fullScreen(P2D);
}

void setup() {
  noCursor();
  frameRate(60);
  //set variables for sin wave draw function
  translate(width/2, height/2);
  scale(height / 1000.0);
  w = width + 16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w];
  font = createFont("KaushanScript-Regular.ttf", 64);
 
 //for new flowerWithPulse
  float a = 0.0;
  float s = 0.0;
  
  moonlander = Moonlander.initWithSoundtrack(this, "VadodoraChillMix.mp3", 97, 2);

  background(255, 255, 255);
  moonlander.start();
}


void draw() {
  moonlander.update(); 

  translate(width/2, height/2);
  scale(height / 1000.0);

  int scene = moonlander.getIntValue("scene"); 
  int updatebackground = moonlander.getIntValue("updatebackground");
  int start = moonlander.getIntValue("start");
  int end = moonlander.getIntValue("end");
  
  if (updatebackground != 0) {
    ellipseCounter = 0;
    flowerCounter = 0;
    mandalaCounter = 0;
    treeCounter = 0;
    if (updatebackground == 1) {
      background(0);
    } else if (updatebackground == -1) {
      background(255);
    }
  }

  if (scene==0) {  //start/end
    drawNoisyMountains();
    drawTitle(0, 64);
  }
  if (scene==1) {
    drawEllipse();
  }
  if (scene==2) {
    calcWave();
    renderWave();
  }
  if (scene==3) {
   drawFlowerWithPulse(false);
  }
  if (scene==33) {
    drawFlower(true);
  }
  if (scene==4) {
    drawNoisyMountains();
    drawFlower(false);
  }
   if (scene==6) {
    drawBezier(start, end);
  }
  if (scene==7) {
    drawMand();
  }
  if (scene==8) {
    drawTreeBackground();
    tree();
  }
  if (scene==9) {
    drawFlowerWithFlower(false);
  }

  if (scene==98) { // 2019
      drawMusicCredits(0, 48);
  }
  
   if (scene==99) { // 2019
      drawBezier (start,end);
      drawMathematicalCredits(0, 48);
  }
  if (scene==100) {  //exit
    drawEndText(0 , 48);
  }
  if (scene==666) {
    exit();
  }
}

void drawEllipse() {
  stroke(0, 90);
  strokeWeight(3);

  float t = (float) ellipseCounter;    
  ellipse(sin(t/15) * (t/1.5), cos(t/15)*(t/1.5), sin(t/1.5), 100);
  
  ellipseCounter++;
}

// this could be used on background
void drawNoisyMountains() {
  float time = millis() * 0.0001;

  noiseDetail(10, 0.45);
  for (float x = -width; x < width; x = x + 1) {
    float noiseValue = noise(x/(height/3), time);
    float y = map(noiseValue, 0, 1, 0, -height/2);
    rect(x, y, 1, -height/2);
    rect(-x, -y, 1, height/2);
  }
}

void drawFlower(boolean changeColor) {
  noFill();
  if (changeColor == true) {
    stroke(map(flowerCounter, 0, 500, 0, 75), 0, 0, 40);
  } else {
    stroke(0, 0, 0, 40);
  }
  
  float t=(float) flowerCounter;      
  rotate(t/70);
  ellipse(sin(t/100)*width/2, cos(t/100)*width/2, sin(t/100)*width/2, cos(t/100)*width/2);
  ellipse(sin(t/100)*width/3, cos(t/100)*width/3, sin(t/100)*width/3, cos(t/100)*width/3);
  ellipse(sin(t/100)*width/5, cos(t/100)*width/5, sin(t/100)*width/5, cos(t/100)*width/5);

  flowerCounter++;
}

void calcWave() {
  theta += 0.02;
  float x = theta;  
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x += dx;
  }
}


void renderWave() {
  noStroke();
  fill(255);
  int xbegin = -width;

  for (int x = 0; x < yvalues.length; x++) {
    ellipse(xbegin + x * xspacing, yvalues[x], 16, 16);
  }
}



void renderLine() {
  stroke(255);
  strokeWeight(16.0);
  for (int x = 0; x < yvalues.length; x++) {
    line(x*xspacing, yvalues[x], x*xspacing, yvalues[x]-x);
  }
}

void calcApndxWave1() {
  // Increment theta (try different values for 'angular velocity' here
  apndx_w = width+16;
  apndx_dx = (TWO_PI / apndx_period) * apndx_xspacing;
  apndx_yvalues = new float[apndx_w/apndx_xspacing];
  apndx_theta += 0.01; // 0.02 original
  // For every x value, calculate a y value with sine function
  float x = apndx_theta;
  for (int i = 0; i < apndx_yvalues.length; i++) {
    apndx_yvalues[i] = sin(x)*ampli;
    x+=apndx_dx;
  }
}

void calcApndxWave2() {
  // Increment theta (try different values for 'angular velocity' here
  apndx_w = width+16;
  apndx_dx = (TWO_PI / apndx_period) * apndx_xspacing;
  apndx_yvalues = new float[apndx_w/apndx_xspacing];
  apndx_theta += 0.1; // 0.02 original

  // For every x value, calculate a y value with sine function
  float x = apndx_theta;
  for (int i = 0; i < apndx_yvalues.length; i++) {
    apndx_yvalues[i] = sin(2*x)*ampli;
    x+=apndx_dx;
  }
}

void drawApndxWave1() {
  calcApndxWave1();
  noStroke();
  fill(0, 44);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < apndx_yvalues.length; x++) {
    rect(x*apndx_xspacing, height/2+apndx_yvalues[x], 15, 5);
  }
}

void drawApndxWave2() {
  calcApndxWave2();
  noStroke();
  fill(0);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < apndx_yvalues.length; x++) {
    rect(x*apndx_xspacing, height/2+apndx_yvalues[x], 5, 15);
  }
}

  void drawMand(){
    drawCircle();
    drawLittleCircle();
    drawParamCirc();
    drawMandala1();
   }

   void drawCircle(){ 
   stroke(0,0);
   fill(100, 0,0,1);
  ellipse(width/3*0.90, -height/3 * 0.5, width/12, width/12);

   }
     
     
  void drawLittleCircle(){ 
  stroke(0,0);
  fill(100, 0,0,1);
  ellipse(-width/3*0.9, -height/3 * 0.3, width/33, width/33);

   }
   
  void drawParamCirc(){ 
   stroke(0,0);
   fill(100, 0,0,1);
    ellipse((float) (width/3*moonlander.getValue("C_x")), 
      (float) (-height/3 * moonlander.getValue("C_y")),
      width/12 * (float) moonlander.getValue("C_size"),
      width/12 * (float) moonlander.getValue("C_size"));

   }
  
  void drawMandala1(){
  noFill();
  stroke(0,40);
  frameRate(1000);
  float t=(float)mandalaCounter;
  
  // translate(-width/2, -height/2); 
   rotate(t/-width/2);    
  line(sin(t/140)*width/5, cos(t/140)*width/5, cos(t/10)*width/3, sin(t/10)*width/3);
  fill(175);
  mandalaCounter++;
   }
   


void drawBezier(int start, int end) {
  drawCircle();
  drawLittleCircle();
  background(255);
  stroke(0);
   noFill();
  for (int i = 0; i < 200; i += 20) {
      bezier(start-(i/2.0), 40+i, 410, 20, 440, 300, end, 300+(i/8.0));
  }
}

void tree(){
    stroke(0);
    line(0, height, 0, height * 0.175);
    translate(0, height * 0.175);
    branch(height/3);
    theta = radians(map(millis(), 0, 10000, 0, 90));
    treeCounter++;
}

void branch(float h){
  h *= 0.66;
  if(h > 2){
    pushMatrix();   
    rotate(theta);
    line(0,0,0,-h);
    translate(0,-h);
    branch(h);
    popMatrix();
    
    pushMatrix();
    rotate(-theta);
    line(0,0,0,-h);
    translate(0,-h);
    branch(h);
    popMatrix();
  }
}

void drawTitle(float x, int fontSize){
  textFont(font);
  textAlign(CENTER); 
  textSize(fontSize);
  fill(100);
  text("MANDOLOID", x, 0); 
}

void drawMusicCredits(float x, int fontSize) {
  
  textFont(font);
  textSize(fontSize);
  textAlign(CENTER);
  fill(100);
  text("MUSIC CREDITS:", x, -height/10);
  fill(175);
  text("Vadora Chill Mix, Kevin MacLeod", x, 0);
  fill(200);
  text("(incompetech.com), Licensed under Creative Commons: By Attribution 3.0 License", x, height/10);
  fill(200);
  text("http://creativecommons.org/licenses/by/3.0/", x, height/6);
  drawParamCirc();
}
 
void drawEndText(float x, int fontSize){
  textFont(font);
  textAlign(CENTER); 
  textSize(fontSize);
  fill(100);
  text("GRAFFATHON 2019", x, -height/10); 
  fill(175);
  text("Team vaDOD: Ava Heinonen, Heli Huhtilainen, Harri Mehtälä & Virva Svala ", x, 0);
  drawParamCirc();
 } 
  
 ///LAST FLOWER SCENE
 
void drawFlowerWithPulse(boolean changeColor) {
  noFill();
  if (changeColor == true) {
    stroke(map(flowerCounter, 0, 500, 0, 75), 0, 0, 40);
  } else {
    stroke(0, 0, 0, 40);
  }
  
  float t=(float) flowerCounter;      
  rotate(t/70);
  ellipse(sin(t/100)*width/100, cos(t/100)*width/100, sin(t/100)*width/2, cos(t/100)*width/2);
  ellipse(sin(t/100)*width/3, cos(t/100)*width/3, sin(t/100)*width/3, cos(t/100)*width/3);
  ellipse(sin(t/100)*width/5, cos(t/100)*width/5, sin(t/100)*width/5, cos(t/100)*width/5);

  a = a + 0.04;
  s = cos(a)*5;
  
  scale(s);
  fill(100, 0,0,20);
  ellipse(0, 0, 25, 25); 
  fill(100, 0,0,50);
  line(300, 110, 25, 25); 
 
 
  flowerCounter++;
}

void drawMathematicalCredits(float x, int fontSize) {
  textFont(font);
  textSize(fontSize);
  textAlign(CENTER);
  fill(100);
  text("CREDITS FOR MATHEMATICAL FUNCTIONS", x, -height/10);
}


// secondscene FLOWER with FLOWER

void drawFlowerWithFlower(boolean changeColor) {
  noFill();
  if (changeColor == true) {
    stroke(map(flowerCounter, 0, 500, 0, 75), 0, 0, 40);
  } else {
    stroke(0, 0, 0, 40);
  }
  
  
  float t=(float) flowerCounter;      
  rotate(t/27);
  ellipse(sin(t/100)*width/100, cos(t/100)*width/100, sin(t/100)*width/2, cos(t/100)*width/2);
  ellipse(sin(t/100)*width/3, cos(t/100)*width/3, sin(t/100)*width/3, cos(t/100)*width/3);
  ellipse(sin(t/100)*width/5, cos(t/100)*width/5, sin(t/100)*width/5, cos(t/100)*width/5);
  a = a + 0.04;
  s = cos(a)*10;

  scale(s); 
  fill(100, 0,0,1);
  ellipse(0, 0, 50, 50); 
  
  flowerCounter++;
}

void drawTreeBackground(){
pushMatrix();
   float circleCounter = (float) moonlander.getValue("circleCounter");
   stroke(0,0);
   fill(100, 0, 0, 30);
   float size = map(circleCounter, 0, 1000, 25, 500);
   float yPosition = map(circleCounter, 0, 3000, height/2, -height/2);
   ellipse(0, yPosition, size, size);
   popMatrix();
}
