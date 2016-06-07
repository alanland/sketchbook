public class Particle {
  RPoint vel;
  RPoint pos;
  RPoint lastpos;
  int id;
  int colour;

  public Particle(PGraphics gfx, int ident) {
    pos = new RPoint(random(-gfx.width/2, gfx.width/2), random(-gfx.height/2, gfx.height/2));
    lastpos = new RPoint(pos);
    vel = new RPoint(0, 0);
    colorMode(HSB);
    id = ident;
  }

  void update(RGroup grp) {
    lastpos = new RPoint(pos);
    pos.add(vel);
    RPoint[] ps = grp.getPoints();
    if (ps!=null) {

      id = (id+1)%ps.length;
      RPoint distPoint = new RPoint(ps[id]);
      distPoint.sub(pos);

      distPoint.scale(random(0.01, 2));



      vel.scale(0.01*random(1, 5));
      vel.add(distPoint);
    }
  }

  void setPos(RPoint newpos) {
    lastpos = new RPoint(pos);
    pos = newpos;
  }

  void draw() {



    float distance = dist(lastpos.x, lastpos.y, pos.x, pos.y);
    println(distance);

    colour = color(0, 0, 1, 200);
    if (distance>40)colour = color(0, 0, 1, 0);
    stroke(colour);
    line(lastpos.x, lastpos.y, pos.x, pos.y);
  }
}
