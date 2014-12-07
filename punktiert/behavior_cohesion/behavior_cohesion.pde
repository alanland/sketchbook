
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
BAttraction attr;

int amount=300;
boolean cb=true;

BCollision cl=new BCollision();
// (radius,maxSpeed,maxForce)
BCohesion ch=new BCohesion(100, 1.5, 0.5);

void setup() {
  size(displayWidth, displayHeight);
  noStroke();
  ellipseMode(CENTER);
  fill(0, 255, 0);

  physics=new VPhysics();

  for (int i=0; i<amount; i++) {
    float rad=random(2, 20);
    // (x,y,z,mass,radius)
    VParticle p = new VParticle(random(width), random(height), 0, 5, rad);
    p.addBehavior(cl); //碰撞
    // p.addBehavior(ch); //内聚
    physics.addParticle(p);
  }
}

void keyReleased() {
  if (key==CENTER)cb=!cb;
  update();
}

void draw() {
  background(255);
  physics.update();
  for (VParticle p : physics.particles) {
    ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
  }
}
void update() {
  for (VParticle p : physics.particles) {
    p.clearForce();
    p.clearVelocity();
    if (cb) {
      p.addBehavior(ch); //内聚
      p.removeBehavior(cl);
    } else {
      p.addBehavior(cl); //内聚
      p.removeBehavior(ch);
    }
  }
}
