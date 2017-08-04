
import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;
//import g4p_controls.*;

float roll  = 0.0F;
float pitch = 0.0F;
float pitch2 = 0.0F;

int totalPts = 500;
float steps = 10*totalPts + 1;

float s = 0.0;
float radPitch;

// Serial port state.
Serial       port;
String       buffer = "";
final String serialConfigFile = "serialconfig.txt";
boolean      printSerial = false;
 
void setup() {
  fullScreen();
  stroke(255);
  serialBS();
  frameRate(60);
} 

void draw() {
  //print(roll);
  //print(pitch);
  radPitch = radians((pitch+pitch2)/2);
  s = abs(sin(radPitch));
  
  background(0);
  float rand = 0;
  for  (int i = 1; i < steps; i++) {
    point( (width/steps) * i, (height/2) + random(-rand, rand) );
    strokeWeight(1.5);
    rand += s*random(-5, 5);
  }
}