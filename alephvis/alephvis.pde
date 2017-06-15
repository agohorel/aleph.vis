void setup(){
 size(1280, 720, P3D);
 // i'm locking the frame rate at 60 atm for stability reasons but in theory, higher fps = better
 frameRate(60);
 // disable antialiasing for 'dat perf'
 noSmooth();
 // when you're using this live enable this:
 // noCursor();
 
 // INITIALIZE MINIM & FFTs
 minim = new Minim(this);
 in = minim.getLineIn(Minim.STEREO, bufferSize);
 fft = new FFT(in.bufferSize(), in.sampleRate());
 // i'm not totally sure if i need to be doing these separately...
  fftL = new FFT(in.bufferSize(), in.sampleRate());
  fftR = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.HAMMING);
  fftL.window(FFT.HAMMING);
  fftR.window(FFT.HAMMING);
  
  // SET UP STUFF FROM THE AUDIO FILE
  // first parameter specifies the size of the smallest octave to use (in Hz), second is how many bands to split each octave into.
  fft.logAverages(fft_base_freq, fft_band_per_oct); // results in 9 bands
  numZones = fft.avgSize(); // avgSize() returns the number of averages currently being calculated
  // println("numZones: " + numZones); // returns 9 bands
  
  // SET UP MIDI 
  MidiBus.list(); // use this to list connected MIDI devices
  myBus = new MidiBus(this, 0, 1); // syntax is MidiBus(this, midi in channel, midi out channel). check channels with .list()
}

void draw(){  
  // start FFT forward. audio tab.
  fftForward();
  fftL.forward(in.left);
  fftR.forward(in.right);
  
  // start controls so we can change modes
  midiControls();
}