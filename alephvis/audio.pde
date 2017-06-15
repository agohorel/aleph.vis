// derived from Joelle Snaith's "Minim - Log Averages & Isolating Frequencies in the Spectrum":
// https://www.openprocessing.org/sketch/101123#
// using the Minim sound library for Processing:
// http://code.compartmental.net/tools/minim/

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
FFT fftL;
FFT fftR;

//basic audio variables
float volume, leftVol, rightVol;
float band1, band2, band3, band4, band5, band6, band7, band8, band9;
int sampleRate = 44100;
int bufferSize = 512; //smaller buffer = faster response

/* if the number for fft_band_per_oct is higher than 1, it will still result in 9 octaves / bands
 because the number of bands you get is equal to log2 of bufferSize ie. log2(512) = 9 */

// 512 returns 86hz bandwidth which allows 9 octaves / bands
// 1024 returns 43hz bandwidth which allows 10 octaves / bands
// 2048 returns 21hz bandwidth which allows 11 octaves / bands

int fft_base_freq = 86; // size of the smallest octave to use (in Hz) so we calculate averages based on a miminum octave width of 86 Hz
int  fft_band_per_oct = 1; // how many bands to split each octave into? in this case split each octave into 1 band
int numZones = 0;

int ccScale = 15;

//forward the FFT and assign value to volume variable. considers input 0 if below a threshold.
void fftForward() {
  fft.forward(in.mix);

  int highZone = numZones - 1;

  for (int i = 0; i < numZones; i++) { // 9 bands / zones / averages

    float average = fft.getAvg(i); // return the value of the requested average band, ie. returns averages[i]
    // println("Averages " + i + " : " + average);

    float avg = 0;
    int lowFreq;

    if ( i == 0 ) {
      lowFreq = 0;
    } else {
      lowFreq = (int)((sampleRate/2) / (float)Math.pow(2, numZones - i)); // 0, 86, 172, 344, 689, 1378, 2756, 5512, 11025
    }
    int hiFreq = (int)((sampleRate/2) / (float)Math.pow(2, highZone - i)); // 86, 172, 344, 689, 1378, 2756, 5512, 11025, 22050

    // ***** ASK FOR THE INDEX OF lowFreq & hiFreq USING freqToIndex ***** //

    // freqToIndex returns the index of the frequency band that contains the requested frequency

    int lowBound = fft.freqToIndex(lowFreq);
    int hiBound = fft.freqToIndex(hiFreq);

    // println("lowFreq: " + lowFreq + " Hz");
    // println("hiFreq: " + hiFreq + " Hz");
    // println("lowBound: " + lowBound);
    // println("hiBound: " + hiBound);

    // ***** NB: THE BELOW PRINTS THE RANGES 0 - 8, THEIR RESPECTIVE FREQENCIES & INDEXES ***** //

    // println("range " + i + " = " + "Freq: " + lowFreq + " Hz - " + hiFreq + " Hz " + "indexes: " + lowBound + "-" + hiBound);

    for (int j = lowBound; j <= hiBound; j++) { // j is 0 - 256

      float spectrum = fft.getBand(j); // return the amplitude of the requested frequency band, ie. returns spectrum[offset]
      // println("Spectrum " + j + " : " +  spectrum); // j is 0 - 256

      avg += spectrum; // avg += spectrum[j];
      // println("avg: " + avg);
    }

    avg /= (hiBound - lowBound + 1);
    average = avg; // averages[i] = avg;

    // ***** THIS IS WHERE WE CAN ISOLATE SPECIFIC FREQUENCIES. THERE ARE 9 FREQUENCY BANDS (0 - 8) ***** //

    // ***** 0 Hz - 86 Hz ***** //

    if (i == 0) {  // if the frequency band is equal to 0 ie. between 0 Hz and 86 Hz

      // println(average); // printing the average to the console is super helpful as you can see the loudness of each frequency band & further isolate parts of a track, for example just the peak

       band1 = abs(map(average, 0, 128, 0, 100) + (ccNeg[1] * ccScale));
     
    }
    // ***** 86 Hz - 172 Hz ***** //

    if (i == 1) {
      
      band2 = abs(map(average, 0, 65, 0, 100) + (ccNeg[1] * ccScale));
      
    }

    // ***** 172 Hz - 344 Hz ***** //

    if (i == 2) {

      band3 = abs(map(average, 0, 50, 0, 100) + (ccNeg[1] * ccScale));
    
    }

    // ***** 344 Hz - 689 Hz ***** //

    if (i == 3) {
      
       band4 = abs(map(average, 0, 15, 0, 100) + (ccNeg[2] * ccScale));      
      
    }

    noStroke();

    // ***** 689 Hz - 1378 Hz ***** //

    if (i == 4) {

       band5 = abs(map(average, 0, 5, 0, 100) + (ccNeg[2] * ccScale)); 
          
    }

    // ***** 1378 Hz - 2756 Hz ***** //

    if (i == 5) {
    
       band6 = abs(map(average, 0, 4, 0, 100) + (ccNeg[2] * ccScale)); 
     
    }

    // ***** 2756 Hz - 5512 Hz ***** //

    if (i == 6) {

       band7 = abs(map(average, 0, 4, 0, 100) + (ccNeg[3] * ccScale)); 
      
    }

    // ***** 5512 Hz - 11025 Hz ***** //

    if (i == 7) {

       band8 = abs(map(average, 0, 2, 0, 100) + (ccNeg[3] * ccScale)); 
      
    }

    // ***** 11025 Hz - 22050 Hz ***** //

    if (i == 8) {

       band9 = abs(map(average, 0, .5, 0, 100) + (ccNeg[3] * ccScale));  
      
    }

    // ********** //
  }

  if (in.mix.level() > 0.001) {
    volume = map(in.mix.level(), 0, ccAttenuate[4] + .1, 0, 100);
  } else {
    volume = 0;
  }
  
    if (in.left.level() > 0.001) {
    leftVol = map(in.mix.level(), 0, ccAttenuate[4] + .1, 0, 100);
  } else {
    leftVol = 0;
  }
  
    if (in.right.level() > 0.001) {
    rightVol = map(in.mix.level(), 0, ccAttenuate[4] + .1, 0, 100);
  } else {
    rightVol = 0;
  }
}

void stop() {
  in.close();
  minim.stop();
  super.stop();
}