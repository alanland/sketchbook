
class HanZi {
  String str = "";
  PVector loc = new PVector(0, 0);
  PVector start = new PVector(0, 0);
  PVector dest = new PVector(0, 0);
  PVector velocity =  new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  boolean started=false;
  boolean ended=false;
  boolean disappearing=false;
  int index=0;

  HanZi(String str) {
    this.str = str;
  }
  HanZi(String str, float x, float y) {
    this.str = str;
    this.loc = new PVector(x, y);
    this.start = new PVector(x, y);
    this.dest = new PVector(x, y);
  }
  HanZi(String str, float startx, float starty, float destx, float desty, int index) {
    this.str = str;
    this.start = new PVector(startx, starty);
    this.loc = new PVector(startx, starty);
    this.dest = new PVector(destx, desty);
    this.index=index;
    defaultAcceleration();
  }
  void start() {
    started=true;
    disappearing=false;
  }
  void reset() {
    this.loc = new PVector(start.x, start.y);
    //defaultAcceleration();
    started=false;
    ended=false;
    disappearing=false;

    velocity.x=0;
    velocity.y=0;
    acceleration.x=0;
    acceleration.y=0;
  }
  void disappear() {
    disappearing=true;
    //started=false;
  }
  void defaultAcceleration() {
    this.acceleration = PVector.sub(dest, loc);
    acceleration.div(400);
  }
  void force(PVector f) {
    acceleration=new PVector(f.x, f.y);
  }
  void update() {
    if (!started) return;
    if (!ended) {
      defaultAcceleration();
    } 
    if (disappearing) {
      acceleration = PVector.random2D();
      acceleration.div(10);
    }
    velocity.add(acceleration);
    loc.add(velocity);
  }
  void checkEdge() {
    if (started&&!ended&&dist(loc.x, loc.y, dest.x, dest.y)<5) {
      loc.x=dest.x;
      loc.y=dest.y;
      ended=true;
      velocity.x=0;
      velocity.y=0;
      acceleration.x=0;
      acceleration.y=0;
    }
  }
  void display() {
    text(str, loc.x, loc.y);
  }
  void draw() {
    if (started) {
      update();
      checkEdge();
      display();
    }
  }
}

