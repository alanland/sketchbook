class Circles {
  PVector loc;
  int count=int(random(2, 5));
  int r=40;
  HashMap points;
  boolean sliced=false;
  ArrayList<Circle> circleList;

  Circles(float x, float y) {
    loc=new PVector(x, y);
    circleList=new ArrayList<Circle>();
    int allWeight=0;
    for (int i=count; i>0; i--) {
      float weight=random(10, 30);
      allWeight+=weight*2;
      circleList.add(new Circle(x, y, allWeight, color(random(255), random(255), random(255)), weight));
    }
  }

  void slice() {
    if (sliced) return;
    sliced=true;
    for (Circle c : circleList) {
      c.slice();
    }
  }

  void update() {
    loc.y++;
  }

  void display() {
    ellipseMode(CENTER);
    noStroke();
    for (int i=circleList.size (); i>0; i--) {
      circleList.get(i-1).draw();
    }
  }

  void draw() {
    if (loc.y<10000) {
      update();
      display();
    }
  }
}
