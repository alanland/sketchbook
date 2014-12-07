
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
BConstantForce force;

int amount=500;

void setup() {
  size(displayWidth, displayHeight);
  ellipseMode(CENTER);
  fill(0, 255);
  noStroke();

  physics=new VPhysics(new Vec(100, 100), new Vec(width-100, height-100));
  physics.setfriction(0.1);

  force = new BConstantForce(new Vec());
  physics.addBehavior(force);

  for (int i=0; i<amount; i++) {
    float  rad = random(3, 8);
    float weight=rad;//*0.5;
    VParticle p = new VParticle(random(width), random(height), 0, weight, rad);
    p.addBehavior(new BCollision().setLimit(0.1));
    physics.addParticle(p);
  }
}

void draw() {
  background(255);
  stroke(0, 100, 0);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  noStroke();
  physics.update();
  force.setForce(new Vec(mouseX-width*0.5, mouseY-height*0.5).normalizeTo(0.03));

  for (VParticle p : physics.particles) {
    ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
  }
}
