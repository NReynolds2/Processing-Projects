import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import g4p_controls.*;

float roll  = 0.0F;
float pitch = 0.0F;
float roll2   = 0.0F;
float pitch2  = 0.0F;

PImage img;

// Serial port state.
Serial       port;
String       buffer = "";
final String serialConfigFile = "serialconfig.txt";
boolean      printSerial = false;

void setup() {
  fullScreen();
  frameRate(60);
  img = loadImage("astronaut.jpg");
  //img = loadImage("forest.jpg");
  img.loadPixels();
  
  serialBS();
  
  loadPixels();
}

void draw() {
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*img.width;
      // Get the R,G,B values from image
      float r,g,b;
      r = red (img.pixels[loc]);
      //g = green (img.pixels[loc]);
      //b = blue (img.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = 100;//dist(0,0,width,height);
      //float d = dist(x, y, mouseX, mouseY);
      float d = dist(x, y, 720-10*((pitch+pitch2)/2), 5*((roll+roll2)/2)+450);
      float adjustbrightness = 255*(maxdist-d)/maxdist;
      r += adjustbrightness;
      //g += adjustbrightness;
      //b += adjustbrightness;
      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      //g = constrain(g, 0, 255);
      //b = constrain(b, 0, 255);
      // Make a new color and set pixel in the window
      //color c = color(r, g, b);
      color c = color(r);
      pixels[y*width + x] = c;
    }
  }
  updatePixels();
}