
void serialEvent(Serial p) 
{
  String incoming = p.readString();
  if (printSerial) {
    println(incoming);
  }
  
  if ((incoming.length() > 8))
  {
    String[] list = split(incoming, " ");
    if ( (list.length > 0)) 
    {
      //print(list[0]);
      if(list[0].equals("3"))
      {
       // print("in list");
        pitch  = float(list[1]);
        //roll = float(list[2]);
        //print(roll);
        //print("\n");
        buffer = incoming;
      }
      else
      {
        pitch2  = float(list[1]);
        // roll = float(list[2]); 
         buffer = incoming;
        // print("in else\n");
        // print(roll);
      }
    }
    
  }
}

// Set serial port to desired value.
void setSerialPort(String portName) {
  // Close the port if it's currently open.
  if (port != null) {
    port.stop();
  }
  try {
    // Open port.
    port = new Serial(this, portName, 115200);
    port.bufferUntil('\n');
    // Persist port in configuration.
    saveStrings(serialConfigFile, new String[] { portName });
  }
  catch (RuntimeException ex) {
    // Swallow error if port can't be opened, keep port closed.
    port = null; 
  }
}


void serialBS()
{
  //this is for serial port init
   int selectedPort = 0;
  String[] availablePorts = Serial.list();
  if (availablePorts == null) {
    println("ERROR: No serial ports available!");
    exit();
  }
  String[] serialConfig = loadStrings(serialConfigFile);
  if (serialConfig != null && serialConfig.length > 0) {
    String savedPort = serialConfig[0];
    // Check if saved port is in available ports.
    for (int i = 0; i < availablePorts.length; ++i) {
      if (availablePorts[i].equals(savedPort)) {
        selectedPort = i;
      } 
    }
  }
   //setSerialPort("/dev/cu.usbserial-14CP0151");
   setSerialPort("/dev/cu.usbserial-DA01HD87"); 
  
  
  
  
  
}