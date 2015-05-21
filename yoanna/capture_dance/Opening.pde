VPhysics physics;
// 引力
BAttraction attr;
// 粒子数量
int amount = 600;

// 开始动画
void initOpening() {
  //set up physics
  physics = new VPhysics();
  physics.setfriction(.4f);

  // 吸引力
  // new AttractionForce: (Vec pos, radius, strength)
  attr = new BAttraction(new Vec(width * .5f, height * .5f), 4000, 0.45f);
  physics.addBehavior(attr);

  // 生成粒子
  for (int i = 0; i < amount; i++) {
    // val for arbitrary radius
    float rad = random(2, 10);
    // vector for position
    Vec pos = new Vec(random(rad, width - rad), random(rad, height - rad));
    // create particle (Vec pos, mass, radius)
    VParticle particle = new Circle(pos, 15, rad);
    // add Collision Behavior
    //    particle.addBehavior(new BCollision());
    // add particle to world
    physics.addParticle(particle);
  }
}

void opening() {

  // 填充色，背景
  fill(0, 0, 255, 40);
  rect(0, 0, width, height);

  // 更新
  physics.update();

  noFill();

  // 到达中心的粒子数目
  int count=0;
  noStroke();
  fill(0, 255);
  for (VParticle vp : physics.particles) {
    Circle p = (Circle)vp;
    if (abs(p.x-width/2)<50 && abs(p.y-height/2)<30) {
      // 累加到达中心的数目
      count++;
    } else {
      // 画出粒子
      p.draw();
    }
  }

  // 如果都到达
  if (count>=amount-1) {
    if (a>=3)
      a-=5;
    fill(a);
    rect(0, 0, width, height);
    // 开场动画结束
    if (a<=3) {
      status=2;
    }
  }
}
