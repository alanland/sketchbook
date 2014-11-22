import processing.pdf.*; //<>//
import java.util.*;

int WIDTH=600, HEIGHT=600;
final int r=20;
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

  types=new ArrayList<Character>();
  nums=new ArrayList<Character>();
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
  if (key=='a'||key=='b'||key=='c'||key=='d'||key=='e') {
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
    if (type==TYPE_SHAPE0) {
      ellipse(R, 0, rr, rr);
    } else if (type==TYPE_SHAPE3) {
      drawShape(3, R, 0, rr*0.35, rr*0.5);
    } else if (type==TYPE_SHAPE4) {
      drawShape(4, R, 0, rr*0.35, rr*0.5);
    } else if (type==TYPE_SHAPE5) {
      drawShape(5, R, 0, rr*0.35, rr*0.5);
    } else if (type==TYPE_SHAPE6) {
      drawShape(6, R, 0, rr*0.35, rr*0.5);
    }
  } else {
    int rr=r;
    for (int i=0; i<6*theLevel; i++) {
      if (n>0) {
        rr=int(r*pow(scala, n-abs(i%(2*n)-n)));
      }
      rotate(TWO_PI/6/theLevel);
      println("rr:"+rr);
      println("R:"+R);
      println(degrees(TWO_PI/(TWO_PI*R/r)));
      println("type key:"+type);
      if (type==TYPE_SHAPE0) {
        ellipse(R, 0, rr, rr);
      } else if (type==TYPE_SHAPE3) {
        drawShape(3, R, 0, rr*0.35, rr*0.5);
      } else if (type==TYPE_SHAPE4) {
        drawShape(4, R, 0, rr*0.35, rr*0.5);
      } else if (type==TYPE_SHAPE5) {
        drawShape(5, R, 0, rr*0.35, rr*0.5);
      } else if (type==TYPE_SHAPE6) {
        drawShape(6, R, 0, rr*0.35, rr*0.5);
      }
    }
  }
  popMatrix();
}
