
void setup() {
  size(displayWidth, displayHeight);
//  noStroke();
}
void draw() {
  background(255);
  translate(0, 300);

  fill(0, 89, 99);
  float x=0, y=0;
  for (int i=100; i<200; i++) {
    x=i;
    y=sin(i/10.0+frameCount/100.0)*50;
    ellipse(x, y, 10, 10);
  }
  fill(100, 0, 22);
  float rotate=0.3;
  translate(x, y);
  rotate(1);
  ellipse(0, 0, 20, 20);
//  translate(0,sin(0/10.0+frameCount/100.0)*50);
  
  line(0, 0, 100, 0);
  line(0, 0, 0, 100);
  for (int i=0; i<100; i++) {
    x=i;
    y=sin(i/10.0+frameCount/100.0)*50-sin(0/10.0+frameCount/100.0)*50;
    ellipse(x, y, 10, 10);
  }

  for (int i=200; i<300; i++) {
    x=i;
    y=sin(i/100.0+frameCount/100.0)*50;
    PVector v = new PVector(x, y);
    pushMatrix();
    v.rotate(rotate);
    ellipse(v.x, v.y, 10, 10);
    popMatrix();
  }
}
