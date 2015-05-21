// 扩展粒子类
class Circle extends VParticle {
  // 记录当前粒子颜色
  color c = color(random(255), random(255), random(255));

  Circle(Vec v, float mess, float radius) {
    super(v, mess, radius);
  }
  // 画出当前粒子
  void draw() {
    fill(c);
    ellipse(x, y, getRadius() * 2, getRadius() * 2);
  }
}
