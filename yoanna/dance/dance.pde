// Punktiert is a particle engine based and thought as an extension of Karsten Schmidt's toxiclibs.physics code. 
// This library is developed through and for an architectural context. Based on my teaching experiences over the past couple years. (c) 2012 Daniel Köhler, daniel@lab-eds.org

//here: global attractor force connected to mouse position

import punktiert.math.Vec;
import punktiert.physics.*;

// world object
VPhysics physics;

// attractor
BAttraction attr;

// number of particles in the scene
int amount = 300;

public void setup() {
  size(displayWidth, displayHeight);
  noStroke();

  //set up physics
  physics = new VPhysics();
  physics.setfriction(.4f);

  // new AttractionForce: (Vec pos, radius, strength)
  attr = new BAttraction(new Vec(width * .5f, height * .5f), 4000, 0.15f);
  physics.addBehavior(attr);

  for (int i = 0; i < amount; i++) {
    // val for arbitrary radius
    float rad = random(2, 10);
    // vector for position
    Vec pos = new Vec(random(rad, width - rad), random(rad, height - rad));
    // create particle (Vec pos, mass, radius)
    VParticle particle = new Circle(pos, 9, rad);
    // add Collision Behavior
    //    particle.addBehavior(new BCollision());
    // add particle to world
    physics.addParticle(particle);
  }
}
int a=255;


public void draw() {

  fill(255, 30);
  rect(0, 0, width, height);

  physics.update();

  noFill();

  ellipse(attr.getAttractor().x, attr.getAttractor().y, attr.getRadius(), attr.getRadius());

  int count=0;
  noStroke();
  fill(0, 255);
  for (VParticle vp : physics.particles) {
    Circle p = (Circle)vp;
    if (abs(p.x-width/2)<100 && abs(p.y-height/2)<100) {
      count++;
    } else {
      p.draw();
    }
  }

  if (count>=amount-1) {
    if (a>=3)
      a-=3;
    fill(a);
    rect(0, 0, width, height);
  }
}
