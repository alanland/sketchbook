

import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
Vec mouse;

int amount = 100;

void setup() {
  size(displayWidth, displayHeight);
  smooth();
  fill(0, 255);

  physics=new VPhysics(new Vec(100, 100), new Vec(width-100, height-100));
  mouse=new Vec(width/2, height/2);

  for (int i=0; i<amount; i++) {
    float rad=random(2, 20);
    VParticle p = new VParticle(random(width), random(height), 0, 1, rad);
    p.addBehavior(new BCollision());
    p.addBehavior(new BSeek(mouse));
    physics.addParticle(p);
  }
}

void draw() {
  background(255);
  physics.update();
  mouse.set(mouseX, mouseY);
  for (VParticle p : physics.particles) {
    drawParticle(p);
  }
}

void drawParticle(VParticle p) {
  float deform = p.getVelocity().mag();
  float rad=p.getRadius();
  deform = map(deform, 0, 1.5f, rad, 0);
  float rotation=p.getVelocity().heading();
  pushMatrix();
  translate(p.x, p.y);
  rotate(HALF_PI*0.5+rotation);
  beginShape();
  vertex(-rad, +rad);
  vertex(deform, deform);
  vertex(rad, -rad);
  vertex(-deform, -deform);
  endShape(CLOSE);
  popMatrix();
}
