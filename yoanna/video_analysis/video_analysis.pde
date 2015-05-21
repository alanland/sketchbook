import processing.video.*;

// 视频文件
Movie mov;
int w=int(1024*0.6), h=768;
int barWidth = 50, barSpace=20;
float colors[];
int colorCount=w*h;
// 分析指标数组
float reds[];
float greens[];
float blues[];
float[] brights;
float[] saturations;
// 指标总和
long redsum;
long greensum;
long bluesum;
long brigthsum;
long saturationsum;
float movWidth = 1024*0.6;
float movHeight = 768*0.6;

int videoCount = 3;
int current=1;

void setup() {
  size(w, h);
  background(0);
  ellipseMode(CORNER);
  mov=new Movie(this, "blue1.ifox");
  mov.play();

  // 初始化数组
  colors = new float[colorCount];
  reds = new float[colorCount];
  greens = new float[colorCount];
  blues = new float[colorCount];
  brights=new float[colorCount];
  saturations=new float[colorCount];
}

void draw() {
  noStroke();
  fill(30, 50);
  rect(0, 0, width, height);
  textSize(18);
  fill(160);
  float texty = 768*0.7;
  // 指标英文标识
  text("RED", 20, texty);
  text("GREEN", 20+width/5, texty);
  text("BLUE", 20+width/5*2, texty);
  text("BRIGHT", 20+width/5*3, texty);
  text("SATURATION", 10+width/5*4, texty);
  textSize(100);
  if (paused) {
    // 暂停
    text("PAUSED", 100, height-200);
  }

  // 循环播放视频
  if (mov.time()>=mov.duration()-0.3) {
    if (current<videoCount) {
      current++;
      mov = new Movie(this, "blue"+current+".ifox");
      mov.play();
    }
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
    
    // 记录当前画面的颜色参数
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        int c = mov.get(i, j);
        colors[count] = c;
        // 红
        float temp=red(c);
        reds[count] = temp;
        redsum+=temp;
        // 绿
        temp=green(c);
        greens[count] = temp;
        greensum+=temp;
        // 蓝
        temp=blue(c);
        blues[count] = temp;
        bluesum+=temp;
        // 亮度
        temp=brightness(c);
        brights[count]=temp;
        brigthsum+=temp;
        // 饱和度
        temp=saturation(c);
        saturations[count]=temp;
        saturationsum+=temp;

        count++;
      }
    }
  }

  // 影片
  image(mov, 0, 0, movWidth, movHeight);
  drawBars(int(redsum/colorCount), int(greensum/colorCount), int(bluesum/colorCount), int(brigthsum/colorCount), int(saturationsum/colorCount));
}

// 画出颜色条
void drawBars(int red, int green, int blue, int b, int s) {
  if (red>255||green>255||blue>255||b>255||s>255)
    println(red, green, blue, b, s);
  colorMode(HSB, width, 255, 255);
  strokeWeight(2);
  for (int i=0; i<width; i+=5) {
    float angle = map(i, 0, width, 0, PI*5);
    stroke((i+frameCount*2)%width, 255, 255);
    // 用三角函数计算柱子的高度
    if (angle<PI) {
      line(i, height, i, height-sin(angle)*map(red, 0, 255, 0, (height-movHeight+100)));
    } else if (angle <PI*2) {
      line(i, height, i, height+sin(angle)*map(green, 0, 255, 0, (height-movHeight+100)));
    } else if (angle <PI*3) {
      line(i, height, i, height-sin(angle)*map(blue, 0, 255, 0, (height-movHeight+100)));
    } else if (angle <PI*4) {
      line(i, height, i, height+sin(angle)*map(b, 0, 255, 0, (height-movHeight+100)));
    } else if (angle <PI*5) {
      line(i, height, i, height-sin(angle)*map(s, 0, 255, 0, (height-movHeight+100)));
    }
  }
  colorMode(RGB, 255, 255, 255);
}

boolean paused=false;
void keyPressed() {
  if (key==ENTER) {
    if (paused) {
      mov.play();
      paused=false;
    } else {
      mov.pause();
      paused=true;
    }
  }
}
