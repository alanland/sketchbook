import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;

OpenCV opencv;
Rectangle[] faces;

int w=640, h=480;

Capture video;

void setup() {
  size(w, h);
  video = new Capture(this, w/2, h/2);
  video.start();

  opencv = new OpenCV(this, w/2, h/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}

void draw() {
  scale(2 );
//  if (video.available()) {
//    video.read();
//  }
  opencv.loadImage(video );
  image(video, 0, 0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces=opencv.detect();

  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}


void captureEvent(Capture c) {
  c.read();
}
