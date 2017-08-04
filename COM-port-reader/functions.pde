//Note Processing "includes/imports" this file implicitely and is combined before compilation
//general setup, check, and functions 


//sets up the uart for use
void setupUart()
{
 boolean portBusy = false;
 portName = loadStrings("config.txt");
  temport = Serial.list();
  
   if(portName != null) 
   {
     for(portn = 0; portn < temport.length; portn ++)
     {
       //text(temport[portn],40+portn,50);
       if(portName[0].equals(temport[portn]))
       {
         try
         {
         myPort = new Serial(this, portName[0], 384000);
         text("SERIAL PORT OK!",40,70);
         text(portName[0],40,85);
         portOK = 1;
         }
         catch(Exception e)
         {
          text("SERIAL PORT BUSY (do you have multiple instances open?)",40,70);
          portBusy = true;
         }
         
       }
     } 
     
     if(portOK == 0 & !portBusy) 
     {
         text("SERIAL PORT DOES NOT EXIST!  PLEASE CHECK THE CONFIG FILE AND DEVICE CONNECTION!",40,110);
     }
   }
   else
   {
     text("SERIAL PORT DOES NOT EXIST! PLEASE CHECK THE CONFIG FILE!",40,110);
     portOK = 0;
   }    
}//end setupUart  
  
//converts array to channel numbers and values
void Parse()
{
  int incommingData=0;
  int channelNum, channelData;
  byte channelPlace;
  
  if(errorCheck())
  {
    try{
      writers.get(0).println("1,2,3,4");
      channelPlace = 3;
      for(j=startIndex;j<saveIncr;j++)
      {
        //switches between handling channel data packet and measurement data packet
        if(channel)
        {
          channelNum = saveArray[j] & 0xF0;
          channelNum = channelNum >> 4;
          channelData = saveArray[j] & 0x0F;
          channelData = channelData << 8;
          
          incommingData = channelData | incommingData;
          incommingData = incommingData >> 2;
          
          /*
          switch(channelNum)
          {
            case 3: writers.get(0).print(incommingData +",");
                    break;
            case 7: writers.get(0).print(incommingData +",");
                    break;
            case 0xB: writers.get(0).print(incommingData +",");
                    break;
            case 0xF: writers.get(0).print(incommingData);
                    writers.get(0).println("");
                    break;  
          }
          */

          switch(channelPlace)
          {
            case 3: writers.get(0).print(incommingData +",");
                    channelPlace = 7;
                    break;
            case 7: writers.get(0).print(incommingData +",");
                    channelPlace = 0xB;
                    break;
            case 0xB: writers.get(0).print(incommingData +",");
                    channelPlace = 0xF;
                    break;
            case 0xF: writers.get(0).print(incommingData);
                    channelPlace = 3;
                    writers.get(0).println("");
                    break;  
          }
          channel = false;
        }
        else
        {
          incommingData = saveArray[j];
          //needed so when Java sign extends to convert to int, it won't mess up later bit manipulation
          incommingData = incommingData & 0x000000FF;
          channel = true;
        }
      }
       writers.get(0).close();
       text("saved!",40,150);
       println("saved");
    }
    catch(Exception e)
    {
      text("ERROR SAVING",40,150);
    }
  }
}//end Parse


//
boolean syncInput()
{
  int syncChannelNum =0,syncChannelNum2 =0,syncChannelNum3 =0;
  
  for(j=0;j<saveIncr;j++)
  {
    syncChannelNum = saveArray[j] & 0xF0;
    syncChannelNum = syncChannelNum >> 4;
    
    syncChannelNum2 = saveArray[j+2] & 0xF0;
    syncChannelNum2 = syncChannelNum2 >> 4;
    
    syncChannelNum3 = saveArray[j+4] & 0xF0;
    syncChannelNum3 = syncChannelNum3 >> 4;
    
    if(syncChannelNum == 0xB && syncChannelNum2 == 0xF && syncChannelNum3 == 0x3)
    {
      startIndex = j+3; //want to start reading from first channel data point
      return true;
    }  
  }
  return false;
}//end syncInput



void createFilename()
{
  int hourConvert;
  String minConvert;
  
  if(hour()>12)
    hourConvert = hour()-12; 
  else
    hourConvert = hour(); 
    
  if(minute()<10)
    minConvert = "0"+ str(minute());
  else
    minConvert = str(minute());
    
  //logcodefilename = "/Data Output/DATA"+"-"+year()+"-"+month()+"-"+day()+"-"+hourConvert+"."+minConvert+"."+second()+".csv"; 
  logcodefilename = "/Data Output/DATA"+"-"+year()+"-"+month()+"-"+day()+"-"+hourConvert+"."+minConvert+"."+second(); 
}//end createFilename

  
//repaint the screen
void RedrawScreen()
{
  text("==== Eaton Breaker Logcode Reader (V0.5) ====",40,20);
  text("SERIAL PORT OK!",40,70);
  text(portName[0],40,85);
  text("Logfile Name: " + logcodefilename ,40,100); 
}//ends redraw screen


boolean errorCheck()
{
 int channelCalc;
 int prevChan;
   
 if(syncInput())
 {
   println("in error check");
   
   prevChan = 0xF;
   
   for(int m=startIndex+1;m<saveIncr;m=m+2)
   {
     channelCalc = saveArray[m] & 0xF0;
     
     switch(channelCalc)
     {
       case 3: if(prevChan != 0xF){fixData(prevChan,m);}
               println("error caught!");
               break;
       case 7: if(prevChan != 0x3){fixData(prevChan,m);}
               println("error caught!");
               break;
       case 0xB: if(prevChan != 0x7){fixData(prevChan,m);}
               println("error caught!");
               break;
       case 0xF: if(prevChan != 0xB){fixData(prevChan,m);}
               println("error caught!");
               break;
     }
   }
   return true;
 } 
 return false;
}//end errorCheck
  
  
//shifts data in array until the correct channel pattern matches
void fixData(int prevChannel, int index)
{ 
 int nextChannelCalc, indexOffset=0;
  
 //save already good data to new array
 for(int n=0;n<index;n++)
 {
  recoveryArray[n] = saveArray[n];  
 }
 
 
 switch (prevChannel)
 {
  case 0xF:
     for(int m=index;m<saveIncr;m=m+2)
     {
       nextChannelCalc = saveArray[m] & 0xF0;
       
       if(nextChannelCalc == 3)
       {
         indexOffset = m-index;
         m=saveIncr; //just to end for loop
       }
     }
     break;
  case 3:
     for(int m=index;m<saveIncr;m=m+2)
     {
       nextChannelCalc = saveArray[m] & 0xF0;
       
       if(nextChannelCalc == 7)
       {
         indexOffset = m-index;
         m=saveIncr; //just to end for loop
       }
     }
     break;
   case 7:
     for(int m=index;m<saveIncr;m=m+2)
     {
       nextChannelCalc = saveArray[m] & 0xF0;
       
       if(nextChannelCalc == 0xB)
       {
         indexOffset = m-index;
         m=saveIncr; //just to end for loop
       }
     }
     break;
   case 0xB:
     for(int m=index;m<saveIncr;m=m+2)
     {
       nextChannelCalc = saveArray[m] & 0xF0;
       
       if(nextChannelCalc == 0xF)
       {
         indexOffset = m-index;
         m=saveIncr; //just to end for loop
       }
     }
     break; 
 }
 
 //set new length of array
 saveIncr = saveIncr-indexOffset;
 
 for(int n=index;n<saveIncr;n++)
 {
   recoveryArray[n]= saveArray[n+indexOffset];
 }
  
 for(int n=0;n<saveIncr;n++)
 {
   saveArray[n]= recoveryArray[n];
 }
  
}
  
  
  
  
  
  
  
  
  
  
  