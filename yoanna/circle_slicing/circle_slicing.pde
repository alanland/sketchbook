import point2line.*;


int WIDTH=800;
int HEIGHT=600;

int padding=10;
int mousePressedX=0, mousePressedY=0;
ArrayList<Circles> circlesList;

void setup() {
  frameRate(20);
  size(WIDTH, HEIGHT);
  reset();
}

void reset() {
  circlesList=new ArrayList();
  background(255);
}

void draw() {
  background(255);
  noStroke();
  for (Circles circles : circlesList) {
    if (circles.sliced)circles.draw();
  }
  for (Circles circles : circlesList) {
    if (!circles.sliced)circles.draw();
  }
  stroke(random(255), random(255), random(255));
  strokeWeight(3);
  if (mousePressed) {
    line(mousePressedX, mousePressedY, mouseX, mouseY);
  }
}

void keyPressed() {
  if (key=='1') {
    circlesList.add(new Circles(random(padding, width-padding), 0));
  }
}

void keyReleased () {
  if (key=='c') {
    reset();
  } else if (key=='j') {
    saveFrame("images/####.jpg");
  }
}

void mousePressed() {
  mousePressedX=mouseX;
  mousePressedY=mouseY;
}

void mouseReleased() {
  for (Circles cs : circlesList) {
    if (interected(mouseX, mouseY, mousePressedX, mousePressedY, cs)) {
      cs.slice();
    }
  }
}

boolean interected(float x1, float y1, float x2, float y2, Circles circles) {
  Vect2 p1 = new Vect2(x1, y1);
  Vect2 p2 = new Vect2(x2, y2);
  Vect2 center = new Vect2(circles.loc.x, circles.loc.y);
  Vect2 p = Space2.closestPointOnLine( center, p1, p2);
  return dist(center.x, center.y, p.x, p.y)<circles.r*circles.count/2 && p.x>min(x1, x2) && p.x<max(x1, x2) && p.y>min(y1, y2) && p.y<max(y1, y2);
}
