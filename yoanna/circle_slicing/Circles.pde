class Circles {
  PVector loc;
  int count=int(random(2,5));
  int r=40;
  HashMap points;
  boolean sliced=false;
  ArrayList<Circle> circleList;

  Circles(float x, float y) {
    loc=new PVector(x, y);
    circleList=new ArrayList<Circle>();
    for (int i=count; i>0; i--) {
      circleList.add(new Circle(x, y, r*i, color(random(255), random(255), random(255))));
    }
  }
  
  void slice(){
    if(sliced) return;
    sliced=true;
    for(Circle c:circleList){
      c.slice();
    }
  }

  void draw() {
    ellipseMode(CENTER);
    noStroke();
    for (Circle circle : circleList) {
      circle.draw();
    }
  }
}
