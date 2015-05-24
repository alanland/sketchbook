import peasy.PeasyCam;
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysicsSimple physics;
VPhysicsSimple physicsConstraints;
PeasyCam cam;

void setup() {
  size(800, 600, P3D);

  cam=new PeasyCam(this, 800);
  physics=new VPhysicsSimple();
  BConstantForce force=new BConstantForce(0, 0, 0.1);
  physics.addBehavior(force);

  physicsConstraints=new VPhysicsSimple();
  physicsConstraints.addBehavior(new BAttraction(new Vec(), 100, 1));

  VParticle a = new VParticle(-width*0.5, -height*0.5).lock();
  VParticle b = new VParticle(width*0.5, -height*0.5).lock();
  VParticle c = new VParticle(width*0.5, height*0.5).lock();
  VParticle d = new VParticle(-width*0.5, height*0.5).lock();

  physics.addConstraint(a);
  physics.addConstraint(b);
  physics.addConstraint(c);
  physics.addConstraint(d);

  physicsConstraints.addConstraint(a);
  physicsConstraints.addConstraint(b);
  physicsConstraints.addConstraint(c);
  physicsConstraints.addConstraint(d);

  float amountX=100;
  float amountY=50;

  float strength=1;
  ArrayList<VParticle> particles=new ArrayList<VParticle>();
  for (int i=0; i<amountY; i++) {
    Vec a0 = a.interpolateTo(d, i/amountY);
  }



  physics=new VPhysics(new Vec(100, 100), new Vec(width-100, height-100));
  int amount=2000;
  for (int i=0; i<amount; i++) {
    Vec pos = new Vec(random(10, width), random(10, width));
    float rad=random(3, 7);
    VBoid p = new VBoid(pos);
    p.swarm.setSeperationScale(rad*0.7);
    p.setRadius(rad);
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


void keyPressed() {
  if (key=='s' || key=='S') {
    saveFrame("snapshot.png");
    //saveFrame(year()+month()+day()+hour()+minute()+second()+"_##.png");
  }
}
