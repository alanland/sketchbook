
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;

int amount=100;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(60);
  ellipseMode(CENTER);

  int padding=100;
  physics=new VPhysics(new Vec(padding, padding), new Vec(width-padding, height-padding));
  physics.setfriction(0.1);

  for (int i=0; i<amount; i++) {
    float rad=random(2, 10);
    Sepp p=new Sepp(random(width), random(height), 0f, 5f, rad);
    physics.addParticle(p);
  }
}

void draw() {
  background(255);
  physics.update();
  for (Object o : physics.particles) {
    Sepp p = (Sepp)o;
    float sep = frameCount*0.07;
    p.setSeparation(sep);
    stroke(230, 150, 1);
    noFill();
    ellipse(p.x, p.y, sep, sep);

    noStroke();
    fill(0);
    ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
  }
}
