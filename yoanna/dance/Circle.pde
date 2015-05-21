class Circle extends VParticle {
  color c = color(random(255), random(255), random(255));

  Circle(Vec v, float mess, float radius) {
    super(v, mess, radius);
  }
  void draw() {
    fill(c);
    ellipse(x, y, getRadius() * 2, getRadius() * 2);
  }
}
