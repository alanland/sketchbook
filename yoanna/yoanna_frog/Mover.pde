class Mover {
  PImage img;
  PVector loc;
  PVector lastLoc;
  PVector velocity;
  PVector acceleration;
  Mover(String img) {
    this.img=loadImage(img);
    loc = new PVector(0, height);
    lastLoc=new PVector(0, height);
    velocity=new PVector(0, 0);
    acceleration=new PVector(0, 0);
  }
  void setPos(float x, float y) {
    PVector target=new PVector(x, y);
    loc=PVector.add(lastLoc, PVector.div(PVector.sub(target, lastLoc), 10));
    lastLoc.x=loc.x;
    lastLoc.y=loc.y;
  }
  void update() {
    velocity.add(acceleration);
    loc.add(velocity);
  }
  void checkEdge() {
    loc.x=constrain(loc.x, 0, width);
    loc.y=constrain(loc.y, 0, height);
  }
  void display() {
    image(img, loc.x, loc.y, 100, 100);
  }
  void draw() {
    update();
    checkEdge();
    display();
  }
}
