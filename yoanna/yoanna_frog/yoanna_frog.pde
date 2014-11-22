import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;
Mover frog;
Mover bug1;
Mover bug2;

void setup() {
  size(600, 600);
  imageMode(CENTER);

  minim=new Minim(this);
  in=minim.getLineIn();
  fft=new FFT(in.bufferSize(), in.sampleRate());
  frog=new Mover("frog.png");
  bug1=new Mover("bug1.png");
  bug2=new Mover("bug2.png");
}

void draw() {
  clear();
  stroke(255);
  fft.forward(in.mix);
  long bandSum=0;
  long freqSum=0;
  for (int i = 0; i < fft.specSize (); i++) {
    bandSum+=fft.getBand(i)*8;
    freqSum+=fft.getFreq(i)*8;
    // draw the line for frequency band i, scaling it up a bit so we can see it
    line( i, height, i, height - fft.getBand(i)*8 );
  }
  float freq=map(freqSum/fft.specSize(), 100, 1000, 0, width);
  float band=height-map(bandSum/fft.specSize(), 0, 200, 0, height);

  frog.setPos(freq, band);
  frog.draw();

  rect(0, 0, band, 10);
  rect(0, 0, 10, freq);
  println(freqSum/fft.specSize());
  ellipse(band, freq, 100, 100);
}

