import geomerative.*;

String string = "节";
RFont f;
RGroup group;

Particle p;
void setup() {
  stroke(0);
  RG.init(this );
  size(800, 600);
  f = new RFont("/home/alan/Documents/fonts/bb5582/胡敬礼毛笔行书简.TTF", 256, RFont.CENTER);
  background(255);

  p = new Particle(g, 0);
  group = f.toGroup(string);
  group = group.toPolygonGroup();
  
  frameRate(200);
}

void draw() {
  pushMatrix();
  translate(width/2, height/2);

  p.update(group);
  p.draw();

  popMatrix();
}
