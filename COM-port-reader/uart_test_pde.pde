//Nick Reynolds 5/3/2015
//Programs reads serial data, converts it, and outputs it to CSV

import processing.serial.*;
import controlP5.*;
//import java.io.File;

ControlP5 cp5; // Create object for GUI
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int i=0, j=0, k=0, incr=0, filenum=1;

byte[] transferBuffer = new byte[1000];
int bytesRead,saveIncr;

//array determined by 60 second recording ability: 1920*8*60*10 = 9216000
byte[] saveArray = new byte[10000000];
String logcodefilename;
String[] portName;
int portn;
String[] temport;
int portOK=0;
boolean start, testSync1,testSync2, sync, channel, printToScreen = false;

//an arraylist is used to hold  printwriters so that the program can write to multiple files if
//its stopped and started more than once
//(this is a limitation of processing)
ArrayList<PrintWriter> writers = new ArrayList<PrintWriter>();

//PrintWriter output; //for writing to file
int startTime,currTime, secondsCount;
byte currChannel;

int startIndex=0;

byte[] recoveryArray = new byte[10000000];

void setup() 
{
  size(700, 200);
  background(0);
  textSize(14);
  text("==== Eaton Breaker Logcode Reader (V0.5) ====",40,20);

   setupGui();
   setupUart();
   start = false;
   saveIncr = 0;
 }

void draw()
{
  if(start && portOK == 1)
  {
    if ( myPort.available() > 0)
    {  
      bytesRead = myPort.readBytes(transferBuffer);
      currTime = millis();
      
      if(currTime-startTime >= 1000)
      {
        secondsCount++;
        startTime=currTime;
        background(0);
        text("seconds recorded: "+secondsCount+" (max: 60)",40,130);
        RedrawScreen();
      }
      
      
      if(bytesRead+saveIncr >= 10000000)
      {
        text("MAX SECONDS REACHED!",60,130);
        println("stopping...");
        start = false;
        Stop(1);
      }
      
      for(i=0;i<bytesRead;i++)
      {
        saveArray[saveIncr + i] = transferBuffer[i]; 
      }
      
      saveIncr = saveIncr + bytesRead;
    }
  }
}//end draw