import gab.opencv.*;
import java.awt.*;
import processing.video.*;

int w=640/2, h=480/2;
Capture video;
OpenCV opencv;
void setup() {
  size(w*3, h*3);
  video=new Capture(this, w, h);
  video.start();

  opencv=new OpenCV(this, w, h);
}

void draw() {
  clear();
  noTint();
  image(video, w, 0);
  opencv.loadImage(video);

  tint(255, 0, 0);
  image(opencv.getSnapshot(opencv.getR()), w*0, h);

  tint(0, 255, 0);
  image(opencv.getSnapshot(opencv.getG()), w*1, h);

  tint(0, 0, 255);
  image(opencv.getSnapshot(opencv.getB()), w*2, h);

  noTint();
  image(opencv.getSnapshot(opencv.getR()), w*0, h*2);
  image(opencv.getSnapshot(opencv.getG()), w*1, h*2);
  image(opencv.getSnapshot(opencv.getB()), w*2, h*2);
}

void captureEvent(Capture c) {
  c.read();
}
