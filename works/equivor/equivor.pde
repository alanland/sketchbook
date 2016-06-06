import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.List;



List<WB_Point> points ;
List<WB_Point> boundary ;
List<WB_VoronoiCell2D> vors;
WB_Render render;
int n;

PImage bkg;
int[] colors;
void setup() {
  size(1280,720,P3D);
  n=1000;
  boundary =new ArrayList<WB_Point>(4);
  boundary.add(new WB_Point(-50, -50));
  boundary.add(new WB_Point(width+50, -50));
  boundary.add(new WB_Point(width+50, height+50));
  boundary.add(new WB_Point(-50, height+50));
  points =new ArrayList<WB_Point>(n);
  colors=new int[n];
  bkg=loadImage("005.jpg");
  WB_RandomCircle roc=new WB_RandomCircle().setRadius(200);
  for (int i=0; i<n/2; i++) {
      WB_Point p=roc.nextPoint().addSelf(width/2+random(-2,2),height/2+random(-2,2),0);//new WB_Point(random(639,641), random(0, height));
      int c=bkg.pixels[constrain((int)p.yd(), 0, bkg.height-1)*bkg.width+constrain((int)p.xd(), 0, bkg.width-1)];
      colors[i]=color(red(c), green(c), blue(c), 10);
      points.add(p);

  }
  
  roc=new WB_RandomCircle().setRadius(340);
   for (int i=n/2; i<n; i++) {
      WB_Point p=roc.nextPoint().addSelf(width/2+random(-2,2),height/2+random(-2,2),0);//new WB_Point(random(639,641), random(0, height));
      int c=bkg.pixels[constrain((int)p.yd(), 0, bkg.height-1)*bkg.width+constrain((int)p.xd(), 0, bkg.width-1)];
      colors[i]=color(red(c), green(c), blue(c), 10);
      points.add(p);

  }
  frameCount=0;
  vors=WB_Voronoi.getClippedVoronoi2D(points, boundary, 0, 0);

  smooth();
  noFill();

  background(255);
  render=new WB_Render(this);
  
}

void draw() {
  //background(255);
  /*
scale(3);
   strokeWeight(0.3);
   */
  //bkg.loadPixels();

  for (WB_VoronoiCell2D vor : vors) {
    int n=vor.getPolygon().getNumberOfPoints();
    if (vor.getCentroid()!=null) {
      WB_Point p=vor.getCentroid();
      int cell=vor.getIndex();
      WB_Vector v=p.subToVector2D(points.get(cell));
      v.mulSelf(.1);
      points.get(cell).addSelf(v);
      stroke(0, 8);
      fill(colors[vor.getIndex()]);
      beginShape();
      int j=0;
      for (j=0; j<n; j++) {
        p=vor.getPolygon().getPoint(j);
        vertex(p.xf(), p.yf());
      }
      endShape();
    }
  }
  vors=WB_Voronoi.getClippedVoronoi2D(points, boundary, frameCount*0.04, 0);
}

void mousePressed() {

  background(255);
  points =new ArrayList<WB_Point>(n);
  colors=new int[n];
  bkg=loadImage("005.jpg");
  WB_RandomCircle roc=new WB_RandomCircle().setRadius(200);
  for (int i=0; i<n/2; i++) {
      WB_Point p=roc.nextPoint().addSelf(width/2+random(-2,2),height/2+random(-2,2),0);//new WB_Point(random(639,641), random(0, height));
      int c=bkg.pixels[constrain((int)p.yd(), 0, bkg.height-1)*bkg.width+constrain((int)p.xd(), 0, bkg.width-1)];
      colors[i]=color(red(c), green(c), blue(c), 10);
      points.add(p);

  }
  
  roc=new WB_RandomCircle().setRadius(340);
   for (int i=n/2; i<n; i++) {
      WB_Point p=roc.nextPoint().addSelf(width/2+random(-2,2),height/2+random(-2,2),0);//new WB_Point(random(639,641), random(0, height));
      int c=bkg.pixels[constrain((int)p.yd(), 0, bkg.height-1)*bkg.width+constrain((int)p.xd(), 0, bkg.width-1)];
      colors[i]=color(red(c), green(c), blue(c), 10);
      points.add(p);

  }
  frameCount=0;
}
