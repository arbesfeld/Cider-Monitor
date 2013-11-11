

// Graphing sketch


// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects values in the
// range 0 to 1023, followed by a newline, or newline and carriage return

// Created 20 Apr 2005
// Updated 18 Jan 2008
// by Tom Igoe
// This example code is in the public domain.

import processing.serial.*;
import java.io.BufferedWriter;
import java.io.FileWriter;

String outFilename = "out.txt";
Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
int bubbleCount = 0;
float firstBubble = millis();
float previousBubble = millis();
float lastBubble = firstBubble + 1;
PFont f;

void setup () {
  // set the window size:
  size(800, 600);        

  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[2], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  
  appendTextToFile(outFilename, "START");
  f = createFont("Arial", 16, true); 

  frameRate(1);
  // set inital background:
  background(0);
}
void draw () {

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } 
  else {
    // increment the horizontal position:
    xPos++;
  }

  lastBubble = millis();
  float elapsedTime = (lastBubble - firstBubble) / 1000.0;
  float bubbleRate = (float)bubbleCount / elapsedTime;
  float bubbleRateClamped = map(bubbleRate, 0, 1.0, 0, height);

  textFont(f);

  fill(0);
  stroke(0);
  rect(0, 0, width, 60);

  fill(255);
  String outputString = "Rate (bubbles/min): " + Float.toString(bubbleRate*60);
  text(outputString, 5, 20);

  float elapsedTimeSinceLastBubble = (lastBubble - previousBubble) / 1000.0;
  outputString = "Seconds since last bubble: " + Float.toString(elapsedTimeSinceLastBubble);
  text(outputString, width/2.0, 20);

  stroke(127, 34, 255);
  line(xPos, height, xPos, height - bubbleRateClamped);
}

void serialEvent (Serial myPort) {
  if (myPort.available() > 0) {
    String inString = myPort.readString();

    if (inString != null) {
      inString = trim(inString);
      appendTextToFile(outFilename, inString); 
      previousBubble = millis();
      bubbleCount++;
    }
  }
}

/**
 * Appends text to the end of a text file located in the data directory, 
 * creates the file if it does not exist.
 * Can be used for big files with lots of rows, 
 * existing lines will not be rewritten
 */
void appendTextToFile(String filename, String text) {
  File f = new File(dataPath(filename));
  if (!f.exists()) {
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

/**
 * Creates a new file including all subfolders
 */
void createFile(File f) {
  File parentDir = f.getParentFile();
  try {
    parentDir.mkdirs(); 
    f.createNewFile();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}    

