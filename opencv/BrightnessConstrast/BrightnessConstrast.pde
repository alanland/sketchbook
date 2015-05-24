import gab.opencv.*;
import java.awt.*;
import processing.video.*;

int w=640, h=480;
Capture video;
OpenCV opencv;
void setup() {
  size(w, h);
  video=new Capture(this, w/2, h/2);
  video.start();

  opencv=new OpenCV(this, w/2, h/2);
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  opencv.brightness((int)map(mouseX, 0, width, -255, 255));
  image(opencv.getOutput(), 0, 0);
}

void captureEvent(Capture c) {
  c.read();
}
