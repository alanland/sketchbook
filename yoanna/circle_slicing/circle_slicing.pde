import point2line.*;

int WIDTH=800;
int HEIGHT=600;
int FRAME_RATE=24;
int CREATE_SPEED=18;


int padding=10;
int mousePressedX=0, mousePressedY=0;
ArrayList<Circles> circlesList;
int mode=60;
boolean stoped=false;

void setup() {
  colorMode(HSB, 360, 100, 100);
  frameRate(FRAME_RATE);
  size(WIDTH, HEIGHT);
  reset();
}

void reset() {
  circlesList=new ArrayList();
  background(255);
}

void draw() {
  background(255, 0, 100);
  noStroke();
  if (!stoped && frameCount%CREATE_SPEED==0) {
    circlesList.add(new Circles(random(padding, width-padding), 0));
  }
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
  HashMap<Character, Integer> map=new HashMap();
  map.put('1', 60);
  map.put('2', 90);
  if (map.containsKey(key))
    mode = map.get(key);
  if (key==ENTER)
    stoped=true;
}

void keyReleased () {
  if (key=='c') {
    reset();
  } else if (key=='0') {
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
