import java.util.List;
import processing.video.*;


Capture cam;
PImage flip;

List<Character> chars = new ArrayList();

void setup() {
  testCameras();
  size(800, 600);
  cam = new Capture(this, 640, 480, 30);
  cam.start();
  for (int i=0; i<40; i++) {
    chars.add(new Character());
  }
}

void draw() {
  background(0);
  
  image(cam, 0, 0);
  for (Character c : chars) {
    c.draw();
  }
}

void captureEvent(Capture c) {
  c.read();
}
