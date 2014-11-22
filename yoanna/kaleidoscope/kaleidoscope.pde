//<>// //<>// //<>// //<>// //<>// //<>// //<>//

int WIDTH=600, HEIGHT=600;
final int r=20;
int level=0;
final float scala=0.8;
final char TYPE_SHAPE0='a', 
TYPE_SHAPE3='b', 
TYPE_SHAPE4='c', 
TYPE_SHAPE5='d', 
TYPE_SHAPE6='e';

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
}

void draw() {
}

void keyReleased() {
  if (key=='a'||key=='b'||key=='c'||key=='d'||key=='e') {
    if (level==0) {
      drawCircle(key, 0, 0);
    } else {
      typeKey=key;
      typeIndex=1;
      numberIndex=stepIndex=0;
    }
  } else if (key=='1'||key=='2'||key=='3'||key=='4'||key=='5'
    ||key=='6'||key=='7'||key=='8'||key=='9'||key=='0') {
    if (typeIndex==1) {
      numberKey=key;
      numberIndex=1;
      typeIndex++;
    } else if (numberIndex==1) {
      stepKey=key;
      stepIndex=1;
      typeIndex++;
      numberIndex++;
    } else {
      typeIndex=numberIndex=stepIndex=0;
    }
    if (numberIndex==1) {
      drawCircle(typeKey, int(String.valueOf(numberKey)), int(String.valueOf(stepKey)));
    }
  } else {
  }
}

void drawCircle(char type, int n, int noDraw) {
  println("-----"+level);
  println(type, n, noDraw);
  int R=level*r;
  noStroke();
  fill(random(255), random(255), random(255));
  pushMatrix();
  translate(width/2, height/2);

  if (level==0) {
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
    for (int i=0; i<6*level; i++) {
      if (n>0) {
        rr=int(r*pow(scala, n-abs(i%(2*n)-n)));
      }
      rotate(TWO_PI/6/level);
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
  level++;
}
