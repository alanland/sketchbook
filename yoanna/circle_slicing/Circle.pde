class Circle {
  PVector loc;
  int r;
  int c;// color
  int weight=18;
  boolean sliced=false;
  PVector slicingLoc;
  float slicingAngle;
  Circle(float x, float y, int r1, int c1) {
    loc = new PVector(x, y);
    r = r1;
    c=c1;
    sliced=false;
    slicingLoc = new PVector(-1, -1);
  }

  void slice() {
    sliced=true;
    slicingLoc = new PVector(random(loc.x-r, loc.x+r), random(loc.y-r, loc.y+r));
    slicingAngle = random(TWO_PI);
  }

  void draw() {
    fill(c);
    if (sliced) {
      strokeWeight(weight);
      stroke(c);
      pushMatrix();
      translate(slicingLoc.x, slicingLoc.y);
      line(0, 0, sin(slicingAngle)*9999, cos(slicingAngle)*9999);
      line(0, 0, sin(slicingAngle+PI)*9999, cos(slicingAngle+PI)*9999);
      popMatrix();
    } else {
      ellipse(loc.x, loc.y, r, r);
    }
  }
}
