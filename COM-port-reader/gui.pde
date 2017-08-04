//Functions to control button behavior
//Note Processing "includes/imports" this file implicitely and is combined before compilation

//sets up the buttons and gui object
void setupGui()
{
  cp5 = new ControlP5(this); // for GUI
  //Start button
  cp5.addButton("Start")
     .setBroadcast(false) //note: setBroadcast is disabled for each button  
     .setValue(0)         //then enabled to prevent an unintended event trigger during setup
     .setPosition(40,30)
     .setSize(100,19)
     .setBroadcast(true)
     ;
     
  //Stop button
  cp5.addButton("Stop")
     .setBroadcast(false)
     .setValue(0)
     .setPosition(165,30)
     .setSize(100,19)
     ;
}//end setupgui


//start event function
public void Start(int theValue)
{
  cp5.getController("Start").setBroadcast(false);
  cp5.getController("Stop").setBroadcast(true);
  createFilename();
  writers.add(createWriter(logcodefilename +".txt"));
  text("Logfile Name: " + logcodefilename ,40,100);
  
  startTime = currTime;
  secondsCount = 0;
  start = true;
  myPort.clear();
  println("started");
}//end start

//stop event function
public void Stop(int theValue)
{
  cp5.getController("Stop").setBroadcast(false);
  cp5.getController("Start").setBroadcast(true);
  start = false;
  Parse();
  saveIncr = 0;
  writers.remove(0);
  println("stopped");
}//end stop