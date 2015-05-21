import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;
ArrayList<Box> boxes;

void setup() {
  size(800, 600);
  smooth();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -50);

  boxes = new ArrayList();
  boundaries = new ArrayList();

  boundaries.add(new Boundary(110, 300, 200, 50));
  boundaries.add(new Boundary(500, 300, 200, 20));
  boundaries.add(new Boundary(300, 300, 100, 10));
}

void draw() {
  background(255);
  box2d.step();

  if (random(1)<0.2) {
    boxes.add(new Box(width/2, 30));
  }

  for (Boundary wall : boundaries) {
    wall.display();
  }

  for (Box b : boxes) {
    b.display();
  }

  for (int i = boxes.size ()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
}
