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


int width = 680;
int height = 360;


int ellipseCounter = 0;
int flowerCounter = 0;


//sin wave draw function helper variables
float theta = 0.0;
float amplitude = 75.0;
float period = 500.0;
float dx;
float[] yvalues;
int w;
int xspacing = 16;

Moonlander moonlander;

/*
 * settings() must be used when calling size with variable height and width
 * New in processing 3
 */
void settings() {
  // Set up the drawing area size and renderer (P2D / P3D).
  size(width, height, P2D);
}

void setup() {
  noCursor();
  frameRate(60);
  //set variables for sin wave draw function
  w = width + 16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];

  // Parameters: 
  // - PApplet
  // - soundtrack filename (relative to sketch's folder)
  // - beats per minute in the song
  // - how many rows in Rocket correspond to one beat
  moonlander = Moonlander.initWithSoundtrack(this, "VadodoraChillMix.mp3", 97, 2);

  // Last thing in setup; start Moonlander. This either
  // connects to Rocket (development mode) or loads data 
  // from 'syncdata.rocket' (player mode).
  // Also, in player mode the music playback starts immediately.
  background(255, 255, 255);
  moonlander.start();
}


void draw() {
  moonlander.update(); 
  int scene=moonlander.getIntValue("scene");

  if (scene==0) {  //start/end
  }  
  if (scene==1) {
    drawEllipse();
  }
  if (scene==2) {
    calcWave();
    renderWave();
  }
  if (scene==3) {
    drawFlower();
  }
  if (scene==4) {  //black
  }

  if (scene==98) { // 2019
  }

  if (scene==100) {  //exit
  }
}


void drawEllipse() {
  stroke(0, 40);
  translate(width/2, height/2);

  //float x = (float) moonlander.getValue("cir_x") * C_WIDTH / 2;
  //float y = (float) moonlander.getValue("cir_y") * C_HEIGHT / 2;

  //circle(x, y, 100);
  float t=(float)ellipseCounter;    
  ellipse(sin(t/15)*(t/2.5), cos(t/15)*(t/2.5), sin(t/3), 100);
  scale(height / 1000.0);
  ellipseCounter++;
}

// this could be used on background
void drawNoisyMountains() {
  float time = millis() * 0.0001;

  noiseDetail(10, 0.45);
  for (float x = 0; x < width; x = x + 1) {
    float noiseValue = noise(x/500, time);
    float y = map(noiseValue, 0, 1, 0, height);
    rect(x, y, 1, height);
  }
}

void drawFlower() {
    noFill();
    stroke(0, 40);
    float t=(float) flowerCounter;

    translate(width/2, height/2);                 
    rotate(t/113);
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

    for (int x = 0; x < yvalues.length; x++) {
      ellipse(x*xspacing, height/2+yvalues[x], 16, 16);
    }
  }

  void renderLine() {
    stroke(255);
    strokeWeight(16.0);
    for (int x = 0; x < yvalues.length; x++) {
      line(x*xspacing, height/2+yvalues[x], x*xspacing, height/2+yvalues[x]-x);
    }
  }
