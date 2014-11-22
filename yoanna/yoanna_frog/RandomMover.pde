class RandomMover extends Mover {
  boolean alive=true;

  RandomMover(String img) {
    super(img);
    loc.x=random(width);
    loc.y=random(height/3);
  }

  void update() {
    acceleration.x=random(-1, 1)/2;
    acceleration.y=random(-1, 1)/2;
    velocity.add(acceleration);
    velocity.limit(5);
    loc.add(velocity);
  }

  void checkEdge() {

    if (loc.x<=30||loc.x>=width-30) {

      velocity.x*=-1;
    }
    if (loc.y<=30||loc.y>=height/3-30) {
      velocity.y*=-1;
    }

    loc.x=constrain(loc.x, 30, width-30);
    loc.y=constrain(loc.y, 30, height/3-30);
  }

  void display() {
    image(img, loc.x, loc.y, 30, 30);
  }

  void draw() {
    if (alive) {
      update();
      checkEdge();
      display();
    }
  }

  void die() {
    alive=false;
  }
  void reset() {
    alive=true;
    loc.x=random(width);
    loc.y=random(height/3);
  }
}
