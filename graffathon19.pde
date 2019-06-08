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
int C_WIDTH = 500;
int C_HEIGHT = 500;
int ellipseCounter = 0;

Moonlander moonlander;

/*
 * settings() must be used when calling size with variable height and width
 * New in processing 3
 */
void settings() {
  // Set up the drawing area size and renderer (P2D / P3D).
  size(C_WIDTH, C_HEIGHT, P2D);
}

void setup() {
  noCursor();
  frameRate(60);

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
    ellipseCounter++;
  }
  if (scene==2) {

  }
  if (scene==3) {

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
  translate(C_WIDTH/2, C_HEIGHT/2);

  //float x = (float) moonlander.getValue("cir_x") * C_WIDTH / 2;
  //float y = (float) moonlander.getValue("cir_y") * C_HEIGHT / 2;

  //circle(x, y, 100);
  float t=(float)ellipseCounter;    
  ellipse(sin(t/15)*(t/2.5), cos(t/15)*(t/2.5), sin(t/3), 100);
  scale(C_HEIGHT / 1000.0);
}
