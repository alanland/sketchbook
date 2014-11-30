class Seed {
  PVector loc;
  PVector velocity=new PVector(0, 0);
  float velocityShift=0.01;
  float speed=0.9;
  PVector adir;
  int r=10;
  int c;

  Seed(float x, float y) {
    loc = new PVector(x, y);
  }

  void changeDir() {
    float ratio=1;
    velocity.add(new PVector(random(-velocity.x, velocity.x)*ratio, random(-velocity.x, velocity.x)*ratio));
  }

  Seed copy(int colour) {
    Seed s=new Seed(loc.x, loc.y);
    s.velocity=velocity;
    s.velocityShift=velocityShift;
    s.speed=speed;
    s.adir=adir;
    s.r=r;
    s.c=colour;
    return s;
  }

  void update() {
    velocity.normalize();
    velocity.add(new PVector(random(-velocityShift, velocityShift), random(-velocityShift, velocityShift)));
    velocity.mult(speed);
    loc.add(velocity);
  }

  void display() {
    noStroke();
    fill(c);
    ellipse(loc.x, loc.y, r, r);
  }

  void draw() {
    update();
    display();
  }
}
