import processing.video.*;

Movie mov, mov1, mov2;
int w=int(1024*0.8), h=768;
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
float movWidth = 1024*0.8;
float movHeight = 768*0.8;

void setup() {
  size(w, h);
  background(0);
  ellipseMode(CORNER);
  mov1=new Movie(this, "blue1.ifox");
  mov2=new Movie(this, "blue2.ifox");
  mov=mov1;
  mov.play();

  colors = new float[colorCount];
  reds = new float[colorCount];
  greens = new float[colorCount];
  blues = new float[colorCount];
  brights=new float[colorCount];
  saturations=new float[colorCount];
}

void draw() {
  noStroke();
  fill(0, 50);
  rect(0, 0, width, height);

  if (mov.time()>=mov.duration()-0.3) {
    mov=mov2;
    mov.play();
  }
  if (mov.available()) {
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


  image(mov, 0, 0, movWidth, movHeight);
  drawBars(int(redsum/colorCount), int(greensum/colorCount), int(bluesum/colorCount), int(brigthsum/colorCount), int(saturationsum/colorCount));
}

void drawBars(int red, int green, int blue, int b, int s) {
  if (red>255||green>255||blue>255||b>255||s>255)
    println(red, green, blue, b, s);
  colorMode(HSB, width, 255, 255);
  strokeWeight(3);
  for (int i=0; i<width; i+=5) {
    float angle = map(i, 0, width, 0, PI*5);
    stroke(i, 255, 255);
    if (angle<PI) {
      line(i, height, i, height-sin(angle)*map(red, 0, 255, 0, (height-movHeight)));
    } else if (angle <PI*2) {
      line(i, height, i, height+sin(angle)*map(blue, 0, 255, 0, (height-movHeight)));
    } else if (angle <PI*3) {
      line(i, height, i, height-sin(angle)*map(green, 0, 255, 0, (height-movHeight)));
    } else if (angle <PI*4) {
      line(i, height, i, height+sin(angle)*map(b, 0, 255, 0, (height-movHeight)));
    } else if (angle <PI*5) {
      line(i, height, i, height-sin(angle)*map(s, 0, 255, 0, (height-movHeight)));
    }
  }
  colorMode(RGB, 255, 255, 255);
}
