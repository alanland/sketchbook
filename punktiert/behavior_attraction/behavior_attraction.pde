
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
BAttraction attr;

int amount=100;

void setup() {
  size(800, 600);
  noStroke();
  ellipseMode(CENTER);

  physics=new VPhysics();
  physics.setfriction(0.4);

  // (pos, radius, strenght)
  // 强度很大的时候，会把球吸在一起，摆脱particle的直径限制
  attr=new BAttraction(new Vec(width*0.5, height*0.5), 200, 0.1);
  physics.addBehavior(attr);

  for (int i=0; i<amount; i++) {
    float rad=random(2, 20);
    Vec pos = new Vec(random(rad, width-rad), random(rad, height-rad));
    VParticle particle = new VParticle(pos, 4, rad);
    particle.addBehavior(new BCollision());
    physics.addParticle(particle);
  }
}

void draw() {
  background(255);
  physics.update();

  noFill();
  stroke(200, 0, 0);
  attr.setAttractor(new Vec(mouseX, mouseY) );
  ellipse(attr.getAttractor().x, attr.getAttractor().y, attr.getRadius()*2, attr.getRadius()*2);

  noStroke();
  fill(0, 255, 0);
  // 显示出粒子，可以自定要显示的形状
  for (VParticle p : physics.particles) {
    ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
  }
}
