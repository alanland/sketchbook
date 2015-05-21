
import punktiert.math.Vec;
import punktiert.physics.*;
import processing.video.*;

// 0: 空白状态
// 1: 开始动画
// 2: 摄像头拍摄并呈现出来
int status = 0;
Capture video;
float threshold = 50;
int captureWidth = 640, captureHeight=480;
boolean saving=false;

public void setup() {
  // 初始设置
  frameRate(20);
  size(displayWidth, displayHeight);
  colorMode(HSB, 360, 255, 255, 100);
  noStroke();
  initOpening();

  // 摄像头
  video = new Capture(this, captureWidth, captureHeight, 15);
  video.start();
}
int a=255;


public void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
  // 开始动画
  if (status==0) {
    drawBlank();
  }
  // 转景
  if (status==1) {
    opening();
  }
  //摄像头捕捉
  if (status==2) {
    dance();
  }
  if (saving)
    saveFrame("frames/#####.tif");
}

// 如果人物进入场景开始动画
void drawBlank() {
  background(0, 0, 255, 10);
  color c = video.get(captureWidth/2, captureHeight/2);
  if (frameCount>10&&brightness(c)<threshold) {
    println(brightness(c), threshold);
    status=1;
  }
}

void dance() {
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);
  for (int i=0; i<1000; i++) {
    int x=int(random(0, captureWidth));
    int y=int(random(0, captureHeight));
    color c = video.get(x, y);
    // 判断当前摄像头拍到的东西，并呈现出来
    if (brightness(c)<threshold) {
      fill(frameCount/3%360+random(60), 255-random(50), 255-random(50));
      float radius = random(5, 24);
      ellipse(map(x, 0, captureWidth, 0, width), map(y, 0, captureHeight, 0, height), radius, radius);
    }
  }
}

void keyPressed() {
  saving=!saving;
}
