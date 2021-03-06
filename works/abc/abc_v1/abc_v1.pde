import geomerative.RCommand
import geomerative.RFont
import geomerative.RG
import geomerative.RGroup;

String string = "端午节快乐";
RFont f;
RGroup group;

Particle p;
void setup() {
  stroke(0);
  RG.init(this );
  size(1666, 600);
  f = new RFont("/home/alan/Documents/fonts/bb5582/胡敬礼毛笔行书简.TTF", 256, RFont.CENTER);
  background(255);

  p = new Particle(g, 0);
  group = f.toGroup(string);

  RCommand.setSegmentStep(1 - constrain(0.3, 0, 0.99));
  RCommand.setSegmentator(RCommand.UNIFORMSTEP);

  group = group.toPolygonGroup();

  frameRate(25);
}

void draw() {
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < 50; i++) {
    p.update(group);
    p.draw();
  }
  popMatrix();
}
