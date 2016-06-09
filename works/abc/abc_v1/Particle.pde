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


      float distancia = dist(pos.x, pos.y, ps[id].x, ps[id].y);
      println(distancia);
      if (distancia <= 1) {
        id = (id + 1) % ps.length;
//        id = (id + 1);// % ps.length;
      }

      if (id >= ps.length) {
        noLoop();
        return;
      }

      RPoint distPoint = new RPoint(ps[id]);
      distPoint.sub(pos);

      distPoint.scale(random(0, 003));



      vel.scale(random(0.01, 0.15));
      vel.add(distPoint);
    }
  }

  void draw() {
    float distance = dist(lastpos.x, lastpos.y, pos.x, pos.y);
    //    println(distance);

    colour = color(0, 0, 1, 200);
    if (distance > 20) colour = color(0, 0, 1, 0);
    stroke(colour);
    strokeWeight(2);
    line(lastpos.x, lastpos.y, pos.x, pos.y);
  }
}
