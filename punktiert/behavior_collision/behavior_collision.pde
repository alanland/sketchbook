

import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
int amount=300;

void setup() {
  size(displayWidth, displayHeight);
  noStroke();
  ellipseMode(CENTER);
  fill(0, 255);
  randomSeed(100);

  physics=new VPhysics(new Vec(100, 100), new Vec(width-100, height-100));
  physics.setfriction(0.1);
  for (int i=0; i<amount; i++) {
    float rad=random(5, 20);
    VParticle p = new VParticle(random(width), random(height), 0, 1, rad);
    p.addBehavior(new BCollision());
    physics.addParticle(p);
  }
}

void draw() {
  background(255);
  physics.update();
  for (VParticle p : physics.particles) {
    ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
  }
  if (mousePressed) {
    physics.addParticle(new VParticle(mouseX, mouseY, 0, 1, random(5, 20)).addBehavior(new BCollision()));
  }
}
