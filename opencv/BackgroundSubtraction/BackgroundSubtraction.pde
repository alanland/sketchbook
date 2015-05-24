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
  opencv.startBackgroundSubtraction(5, 3, 0.5);
}

void draw() {
  scale(2);
  image(video, 0, 0);
  opencv.loadImage( video);
  opencv.updateBackground();
  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3 );
  for (Contour contour : opencv.findContours ()) {
    contour.draw();
  }
}

void captureEvent(Capture c) {
  c.read();
}
