import processing.pdf.*; //<>//
import java.util.*;

int WIDTH=800, HEIGHT=800;
final int r=50;
int level=0;
final float scala=0.8;
final char TYPE_SHAPE0='a', 
TYPE_SHAPE3='b', 
TYPE_SHAPE4='c', 
TYPE_SHAPE5='d', 
TYPE_SHAPE6='e';
boolean savePDF = false;
ArrayList<Character> types;
ArrayList<Character> nums;
HashMap<Character,PImage> keyPngs;

char typeKey='a';
char numberKey='1';
char stepKey='0';
int typeIndex=0;
int numberIndex=0;
int stepIndex=0;

void setup() {
  size(WIDTH, HEIGHT);
  background(255);
  ellipseMode(CENTER);
  smooth();
  frameRate(3);

  imageMode(CENTER);

  types=new ArrayList<Character>();
  nums=new ArrayList<Character>();
  keyPngs=new HashMap();
  keyPngs.put('a',loadImage("1.png"));
  keyPngs.put('b',loadImage("2.png"));
  keyPngs.put('c',loadImage("3.png"));
  keyPngs.put('d',loadImage("4.png"));
  keyPngs.put('e',loadImage("5.png"));
  keyPngs.put('f',loadImage("6.png"));
  keyPngs.put('g',loadImage("7.png"));
  keyPngs.put('h',loadImage("8.png"));
  keyPngs.put('i',loadImage("9.png"));
}

void draw() {
  if (savePDF) beginRecord(PDF, "pdf/####.pdf"); 
  background(255);
  for (int i=0; i<types.size (); i++) {
    drawCircle(i, types.get(i), int(String.valueOf(nums.get(i))), 0);
  }
  if (savePDF) {
    endRecord();
    savePDF=false;
  }
}

void keyReleased() {
  if (keyPngs.keySet().contains(key)){
    if (level==0) {
      types.add(key);
      nums.add('0');
      level++;
    }
    typeKey=key;
  } else if (key=='1'||key=='2'||key=='3'||key=='4'||key=='5'
    ||key=='6'||key=='7'||key=='8'||key=='9'||key=='0') {
    types.add(typeKey);
    nums.add(key);
  } else if (key=='p') {
    savePDF=true;
  }
}

void drawCircle(int theLevel, char type, int n, int noDraw) {
  int R=theLevel*r;
  noStroke();
  fill(random(255), random(255), random(255));
  pushMatrix();
  translate(width/2, height/2);

  if (theLevel==0) {
    int rr=r;
    image(keyPngs.get(type),R, 0, rr, rr);
      } else {
    int rr=r;
    for (int i=0; i<6*theLevel; i++) {
      if (n>0) {
        rr=int(r*pow(scala, n-abs(i%(2*n)-n)));
      }
      rotate(TWO_PI/6/theLevel);
      image(keyPngs.get(type),R, 0, rr, rr);
    }
  }
  popMatrix();
}
