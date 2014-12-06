import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;
// 青蛙
Mover frog;
// 两只虫子
RandomMover bug1;
RandomMover bug2;

// 0 表示欢迎
// 1 表示游戏中
// 2 通关界面
int status=0;
// 1,2,3,4 表示四个关卡
int stage=1;

int beginFrame=0;

void setup() {
  size(600, 600);
  imageMode(CENTER);

  // 创建音频相关对象
  minim=new Minim(this);
  in=minim.getLineIn();
  fft=new FFT(in.bufferSize(), in.sampleRate());
  // 初始化青蛙和虫子
  frog=new Mover("frog.png");
  frog.setPos(0, height);
  bug1=new RandomMover("bug1.png");
  bug2=new RandomMover("bug2.png");
}
void draw() {
  // 根据不同的状态画图
  clear();
  if (status==0) {
    draw0();
  } else if (status==1) {
    draw1();
  } else if (status==2) {
    draw2();
  }
}

void keyReleased() {
  // 按任意键盘开始游戏
  if (status==0||status==2) {
    status=1;
    stage=1;
    bug1.reset();
    bug1.die();
    bug2.reset();
    bug2.speedRate=0.5;
    beginFrame=frameCount;
  }
//  if (key=='s') {
//   all bugs die
//  }
}

void draw0() {
  // 显示欢迎屏幕
  textSize(100 );
  text("Walcome!", 70, 250);
  textSize(40);
  text("press any key to play", 150, 400);
}

void draw1() {
  // 分析音频程序，获取振幅和频率
  fft.forward(in.mix);
  long bandSum=0;
  long freqSum=0;
  for (int i = 0; i < fft.specSize (); i++) {
    bandSum+=fft.getBand(i)*8;
    freqSum+=fft.getFreq(i)*8;
    // draw the line for frequency band i, scaling it up a bit so we can see it
    // line( i, height, i, height - fft.getBand(i)*8 );
  }
  float freq=map(freqSum/fft.specSize(), 100, 1000, 0, width);
  float band=height-map(bandSum/fft.specSize(), 0, 200, 0, height);

  frog.setPos(freq, band);

  // 画出青蛙和虫子位置
  frog.draw();
  bug1.draw();
  bug2.draw();

  //rect(0, 0, band, 10);
  //rect(0, 0, 10, freq);
  //println(freqSum/fft.specSize());
  //ellipse(band, freq, 100, 100);

  // 检查有没有被吃掉
  checkEat();
}

void draw2() {
  // 恭喜通关
  textSize(60);
  text("Congratulations!", 70, 250);
  textSize(30);
  text("press any key to play again", 150, 400);
}

void checkEat() {
  // 检查虫子是否被青蛙吃掉
  if (frog.loc.dist(bug1.loc)<60) {
    bug1.die();
  }
  if (frog.loc.dist(bug2.loc)<60) {
    bug2.die();
  }
  // 如果虫子全部被吃掉，那么自动进行下一个关卡
  if (!bug1.alive&&!bug2.alive) {
    if (stage==1) {
      bug1.reset();
      bug1.die();
      bug2.reset();
      bug2.speedRate=1.5;
      stage++;
    } else if (stage==2) {
      bug1.reset();
      bug1.speedRate=0.5;
      bug2.reset();
      bug2.speedRate=0.5;
      stage++;
    } else if (stage==3) {
      bug1.reset();
      bug1.speedRate=1.5;
      bug2.reset();
      bug2.speedRate=1.5;
      stage++;
    } else if (stage==4) {
      stage=1;
      status=2;
    }
  }
}
