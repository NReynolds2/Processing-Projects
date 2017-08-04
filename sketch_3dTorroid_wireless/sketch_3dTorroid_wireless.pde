import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

//for sensor... 
float roll  = 0.0F;
float pitch = 0.0F;
float pitch2 = 0.0F;
float radPitch, radRoll;

// Serial port state.
Serial       port;
String       buffer = "";
final String serialConfigFile = "serialconfig.txt";
boolean      printSerial = false;


int pts = 40; 
float angle = 0;
float radius = 60.0;
float s = 0.0;
float r = 0;

// lathe segments
int segments = 60;
float latheAngle = 0;
float latheRadius = 100.0;

//vertices
PVector vertices[], vertices2[];

// for shaded or wireframe rendering 
boolean isWireFrame = true;

// for optional helix
boolean isHelix = false;

void setup(){
   serialBS();
  // Only need to load the pixels[] array once, because we're only
  // manipulating pixels[] inside draw(), not drawing shapes.
 // size(640, 360);
  fullScreen(P3D);
}

void draw(){
  background(0, 0, 0);
  // basic lighting setup
  lights();

  
  // wireframe 
    stroke(255, 255, 250);
    noFill();
 
  //center and spin toroid
  translate(width/2+20, height/2+10, 600);

  rotateX(frameCount*PI/1550);
  rotateY(frameCount*PI/1570);
  rotateZ(frameCount*PI/1590);

  // initialize point arrays
  vertices = new PVector[pts+1];
  vertices2 = new PVector[pts+1];
  
  radPitch = radians((pitch+pitch2)/2);
  //radPitch = radians(pitch);
  s = abs(sin(radPitch));
  radius = 60 + radius*s; 
  
  radRoll = radians(roll);
  r = 10*sin(radPitch);
  //print(r);
  //segments = 60 - r;
  //print(segments);
  
  // fill arrays
  for(int i=0; i<=pts; i++){
    vertices[i] = new PVector();
    vertices2[i] = new PVector();
    vertices[i].x = latheRadius + sin(radians(angle))*radius;
    vertices[i].z = cos(radians(angle))*radius;
    angle+=360.0/pts;
  }
  
  // draw toroid
  latheAngle = 0;
  for(int i=0; i<=segments; i++){
    beginShape(QUAD_STRIP);
    for(int j=0; j<=pts; j++){
      if (i>0){
        vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
      }
      vertices2[j].x = cos(radians(latheAngle))*vertices[j].x;
      vertices2[j].y = sin(radians(latheAngle))*vertices[j].x;
      vertices2[j].z = vertices[j].z;
      vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
    }
    // create extra rotation for helix
    if (isHelix){
      latheAngle+=720.0/segments;
    } 
    else {
      latheAngle+=360.0/segments;
    }
    endShape();
  }
}

/*void keyPressed(){
 
    // extrusion length
    if (keyCode == LEFT) { 
      if (segments>3){
        segments--; 
      }
    } 
    else if (keyCode == RIGHT) { 
      if (segments<80){
        segments++; 
      }
    } 
  
}*/