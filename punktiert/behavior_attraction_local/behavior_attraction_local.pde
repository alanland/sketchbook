

//
// keys
//    enter: remove/add attraction 
//     

import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
int amount=500;
boolean withAttr=true;
int times=99;


int radi=20;
// (radius, strenght)
BAttractionLocal b=new BAttractionLocal(radi*5, 2);

void setup() {
  size(displayWidth, displayHeight);
  fill(0, 255, 0);
  noStroke();

  physics=new VPhysics();
  physics.setfriction(0.2);

  for (int i=0; i<amount; i++) {
    float rad=random(2, 20);
    Vec pos = new Vec(random(rad, width-rad), random(rad, height-rad));
    VParticle p = new VParticle(pos, 2, rad);
    p.addBehavior(new BCollision());
    p.addBehavior(b);
    physics.addParticle(p);
  }
}

void draw() {
  background(255);
  physics.update();
  for (VParticle p : physics.particles) {
    ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
  }
}

void updateBehavior() {
  for (VParticle p : physics.particles) {
    if (withAttr)
      for (int i=0; i<times; i++) {
        p.addBehavior(b);
      } else
      for (int i=0; i<times; i++) {
      p.removeBehavior(b);
    }
  }
}

void keyReleased() {
  if (key==ENTER) {
    withAttr=!withAttr;
    updateBehavior();
  }
}
