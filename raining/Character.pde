class Character {
  color c;
  String content;
  PVector v;
  PVector loc;
  int threshold;
  
  Character(){
    c = color(random(255),random(255),random(255));
    v = new PVector(0,2);
    loc = new PVector(random(width),10);
  }
  
  void update(){
    loc.add(v);
  }
  
  void display(){
    noStroke();
    fill(c);
    ellipse(loc.x,loc.y,10,10);
  }
  
  void draw(){
    update();
    display();
  }
}
