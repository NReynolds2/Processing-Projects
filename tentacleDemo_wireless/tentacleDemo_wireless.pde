import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import g4p_controls.*;

float roll  = 0.0F;
float pitch = 0.0F;
float roll2   = 0.0F;
float pitch2  = 0.0F;


int numSegments = 40;
float[] x = new float[numSegments];
float[] y = new float[numSegments];
float[] angle = new float[numSegments];

float[] x2 = new float[numSegments];
float[] y2 = new float[numSegments];
float[] angle2 = new float[numSegments];


float segLength = 26;
float targetX, targetY;
float targetX2, targetY2;
boolean tent = true;

// Serial port state.
Serial       port;
String       buffer = "";
final String serialConfigFile = "serialconfig.txt";

void setup() {
  
  serialBS();
  fullScreen();
  
  strokeWeight(20.0);
  stroke(255, 100);
  x2[x2.length-1] = width/2;     // Set base x-coordinate
  y2[x2.length-1] = 0;  // Set base y-coordinate

  strokeWeight(20.0);
  stroke(255, 100);
  x[x.length-1] = width/2;     // Set base x-coordinate
  y[x.length-1] = height;  // Set base y-coordinate
  
  pitch = 0;
  roll = 0;
  pitch2 = 0;
  roll2 = 0;
  
}

void draw() {
  
  background(0); 
   
    //background(0); 
    reachSegment(x,y,angle,0, (10*pitch+720), (5*roll+450), tent);
    //reachSegment(0, (720), (450));
    
    for(int i=1; i<numSegments; i++) {
      reachSegment(x,y,angle,i, targetX, targetY, tent);
    }
    for(int i=x.length-1; i>=1; i--) {
      positionSegment(x,y,angle,i, i-1);  
    } 
    for(int i=0; i<x.length; i++) {
      segment(x[i], y[i], angle[i], (i+1)*2); 
    }
    tent = false;
    
    reachSegment(x2,y2,angle2,0, (10*pitch2+720), (5*roll2+450), tent);
    //reachSegment(0, (720), (450));
    
    for(int i=1; i<numSegments; i++) {
      reachSegment(x2,y2,angle2,i, targetX2, targetY2, tent);
    }
    for(int i=x2.length-1; i>=1; i--) {
      positionSegment(x2,y2,angle2,i, i-1);  
    } 
    for(int i=0; i<x2.length; i++) {
      segment(x2[i], y2[i], angle2[i], (i+1)*2); 
    }
    tent = true;
}

void positionSegment(float xArray[], float yArray[], float angleArray[],int a, int b) {
  xArray[b] = xArray[a] + cos(angleArray[a]) * segLength;
  yArray[b] = yArray[a] + sin(angleArray[a]) * segLength; 
}

void reachSegment(float xArray[],float yArray[],float angleArray[],int i, float xin, float yin, boolean tentState) {
  float dx = xin - xArray[i];
  float dy = yin - yArray[i];
  angleArray[i] = atan2(dy, dx);  
  
  if(tentState)
  {
    targetX = xin - cos(angleArray[i]) * segLength;
    targetY = yin - sin(angleArray[i]) * segLength;
  }
  else
  {
    targetX2 = xin - cos(angleArray[i]) * segLength;
    targetY2 = yin - sin(angleArray[i]) * segLength;
  }
}

void segment(float x, float y, float a, float sw) {
  strokeWeight(sw);
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  popMatrix();
}