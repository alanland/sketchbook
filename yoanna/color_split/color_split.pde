
import java.util.*;
import controlP5.*;

int WIDTH=1366;
int HEIGHT=768;

ControlP5 cp5;

int 
s1=0, b1=100, 
s2=0, b2=100, 
s3=0, b3=100, 
s4=0, b4=100, 
s5=0, b5=100, 
s6=0, b6=100, 
s7=0, b7=100;


int beginx;
int beginy=20;
int w=150;
int h=10;
int paddingh=3;
int paddingh2=20;

long lastPressed=0;
char lastKey=0;
boolean drawing=false;
HashSet<Character> keys;

HashMap<Integer, Integer> smap;
HashMap<Integer, Integer> bmap;

Seed s;
ArrayList<Seed> seedList;
void setup() {
  colorMode(HSB, 700, 100, 100);
  //  frameRate(1);
  size(WIDTH, HEIGHT);
  //  background(0,0,100);

  seedList=new ArrayList();

  keys=new HashSet();

  s=new Seed(100, 100);
  s.velocity=new PVector(1, 1);

  gui();
}


void gui() {
  beginx=width-300;

  cp5 = new ControlP5(this);
  ///1
  cp5.addSlider("s1")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*0)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s1)
            ;
  cp5.addSlider("b1")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*0+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b1)
            ;
  ///2
  cp5.addSlider("s2")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*1)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s2)
            ;
  cp5.addSlider("b2")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*1+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b2)
            ;
  ///3
  cp5.addSlider("s3")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*2)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s3)
            ;
  cp5.addSlider("b3")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*2+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b3)
            ;
  ///4
  cp5.addSlider("s4")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*3)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s4)
            ;
  cp5.addSlider("b4")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*3+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b4)
            ;
  ///5
  cp5.addSlider("s5")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*4)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s5)
            ;
  cp5.addSlider("b5")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*4+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b5)
            ;
  ///6
  cp5.addSlider("s6")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*5)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s6)
            ;
  cp5.addSlider("b6")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*5+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b6)
            ;
  ///7
  cp5.addSlider("s7")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*6)
      .setSize(w, h)
        .setRange(-50, 50)
          .setValue(s7)
            ;
  cp5.addSlider("b7")
    .setPosition(beginx, beginy+(h*2+paddingh+paddingh2)*6+h+paddingh)
      .setSize(w, h)
        .setRange(0, 100)
          .setValue(b7)
            ;
}

color getColor(int i) {
  if (i==1) {
    if (s1<0)
      return color(s1+700, 100, b1);
    else
      return color(s1, 100, b1);
  } else if (i==2) {
    return color(s2+100, 100, b1);
  } else if (i==3) {
    return color(s3+200, 100, b1);
  } else if (i==4) {
    return color(s4+300, 100, b1);
  } else if (i==5) {
    return color(s5+400, 100, b1);
  } else if (i==6) {
    return color(s6+500, 100, b1);
  } else if (i==7) {
    return color(s7+600, 100, b1);
  } else {
    return 0;
  }
}

void drawGui() {
  if (s1<0)
    fill(s1+700, 100, b1);
  else
    fill(s1, 100, b1);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*0, h*2+paddingh, h*2+paddingh);
  fill(s2+100, 100, b2);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*1, h*2+paddingh, h*2+paddingh);
  fill(s3+200, 100, b3);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*2, h*2+paddingh, h*2+paddingh);
  fill(s4+300, 100, b4);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*3, h*2+paddingh, h*2+paddingh);
  fill(s5+400, 100, b5);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*4, h*2+paddingh, h*2+paddingh);
  fill(s6+500, 100, b6);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*5, h*2+paddingh, h*2+paddingh);
  fill(s7+600, 100, b7);
  rect(beginx+w+20, beginy+(h*2+paddingh+paddingh2)*6, h*2+paddingh, h*2+paddingh);
}

void draw() {
  drawGui();

  if (keyPressed && lastKey==key)s.draw();
  if (keyPressed)println(key);
}

void keyPressed() {
  if (lastKey==key) {
    drawing=true;
  } else {
    drawing=false;
  }
  long cur=millis();
  if (cur-lastPressed>300) {
    lastPressed=cur;
    splitColor();
  }
  if (key==lastKey) {
    // 按着不放
  }
  println(key, keyPressed);
  lastKey=key;
}

void keyReleased() {
  keys.remove(key);
}

void splitColor() {
  s.changeDir();
  //  println("sssssssssss");
  for (char c : keys) {
  }
}

protected void keyDown(KeyEvent e) {
  println(e);
}
protected void processKeyEvent(KeyEvent e) {
  println(e);
}
