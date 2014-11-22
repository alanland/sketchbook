import processing.video.*;

Movie mov;
int w=480, h=204;
int barWidth = 50, barSpace=20;
float colors[];
int colorCount=w*h;
float reds[];
float greens[];
float blues[];
float[] brights;
float[] saturations;
long redsum;
long greensum;
long bluesum;
long brigthsum;
long saturationsum;

void setup() {
  size(w, h*3);
  background(0);
  ellipseMode(CORNER);
  mov=new Movie(this, "sintel.mp4");
  mov.loop();
  colors = new float[colorCount];
  reds = new float[colorCount];
  greens = new float[colorCount];
  blues = new float[colorCount];
  brights=new float[colorCount];
  saturations=new float[colorCount];
}

void draw() {
  noStroke();
  fill(30, 30);
  rect(0, 0, width, height);

  if (mov.available() == true) {
    mov.read();
    mov.loadPixels();
    int count = 0;
    redsum=0;
    greensum=0;
    bluesum=0;
    brigthsum=0;
    saturationsum=0;
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        int c = mov.get(i, j);
        colors[count] = c;
        float temp=red(c);
        reds[count] = temp;
        redsum+=temp;
        temp=green(c);
        greens[count] = temp;
        greensum+=temp;
        temp=blue(c);
        blues[count] = temp;
        bluesum+=temp;

        temp=brightness(c);
        brights[count]=temp;
        brigthsum+=temp;
        temp=saturation(c);
        saturations[count]=temp;
        saturationsum+=temp;

        count++;
      }
    }
  }


  image(mov, 0, 0);
  translate(0, h);
  fill(255, 0, 0, 50);
  drawBar(0, 0, int(redsum/colorCount));

  fill(0, 255, 0, 50);
  drawBar(barWidth+barSpace, 0, int(greensum/colorCount));

  fill(0, 0, 255, 50);
  drawBar((barWidth+barSpace)*2, 0, int(bluesum/colorCount));

  drawBar((barWidth+barSpace)*3, 0, int(brigthsum/colorCount));
  drawBar((barWidth+barSpace)*4, 0, int(saturationsum/colorCount));
}

void drawBar(int beginX, int beginY, int barHeight) {
  int r=20;
  int count = barHeight/r;
  for (int n=0; n<3; n++) {
    for (int i=0; i<count+random(3); i++) {
      ellipse(beginX+n*r, beginY+r*i, r, r);
    }
  }
}
