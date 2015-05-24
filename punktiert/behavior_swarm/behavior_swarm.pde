import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;

void setup() {
  size(800, 600);
  noStroke();
  fill(0, 255);

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
