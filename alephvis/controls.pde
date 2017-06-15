// using The Midibus library for Processing:
// http://www.smallbutdigital.com/projects/themidibus/

import themidibus.*;

MidiBus myBus;

float cc[] = new float[512];
float ccNeg[] = new float[512];
float ccAttenuate[] = new float[512];
float ccInvert[] = new float[512];
float ccInverted[] = new float[512];

// cc (faders, pots, etc.)
void controllerChange(int channel, int number, int value) {
  println(number);
  // map CC value from 0-127 to 0-1 for easier scaling (or 0-255 for colors) 
  cc[number] = map(value, 0, 127, 0, 1);
  ccAttenuate[number] = map(value, 127, 0, 0, 1); // i honestly can't remember what the fuck this is for
  ccNeg[number] = map(value, 0, 127, -1, 1); // use for things where you might want to add *or* subtract 
  // these next two are for color related things and inverting colors
  ccInvert[number] = map(value, 0, 127, 0, 255);
  ccInverted[number] = map(ccInvert[number], 0, 255, 255, 0);
}

// notes (pads, keys, etc)
void noteOn(int channel, int pitch, int velocity) {
  println(channel, pitch, velocity);
  // STARTING AT C0 & GOING UP (in ableton with my setup anyway, change the pitch values to equal your cc values)
    if (pitch == 24){
      switcher = 1; 
    }
    
    if (pitch == 25){
      switcher = 2; 
    }
    
    if (pitch == 26){
      switcher = 3; 
    }
    
    if (pitch == 27){
      switcher = 4; 
    }
    
    if (pitch == 28){
      switcher = 5; 
    }
    
    if (pitch == 29){
      switcher = 6; 
    }
    
    if (pitch == 30){
      switcher = 7; 
    }
    
    if (pitch == 31){
      switcher = 8; 
    }
}

int switcher = 1; 
//keyboard control
void keyPressed() {
  if (key == '1') {

  }
  if (key == '2') {

  }
  if (key == '3') {
    
  }
  if (key == '4') {
    
  }
  if (key == '5') {
    
  }
  if (key == '6') {
    
  }
  if (key == '7') {
    
  }
  if (key == '8') {
    
  }
  if (key == '9') {
    
  }
  if (key == '0') {
    
  }
}

void midiControls() {
  switch(switcher) {
  // put functions from modes in these cases to switch between them
  case 1:
  vectorscope();
    break;
  case 2:
    break;
  case 3:
  
    break;
  case 4:
  
    break;
  case 5:
    
    break;
  case 6:
    
    break;
  case 7:
    
    break;
  case 8:
    
    break;
  case 9:
    
    break;
  case 10:
    
    break;
  case 11: 
    
    break;
  case 12:
    
    break;
  case 13:
    
    break;
  case 14:
    
    break;
  case 15:
    
    break;
  case 16:
  
    break;
  }
}
