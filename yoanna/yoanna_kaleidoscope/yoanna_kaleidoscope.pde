import processing.pdf.*; //<>//
import java.util.*;

int WIDTH=800, HEIGHT=800;
final int r=50;
// 当前圈数
int level=0;
// 相邻图像缩放比例
final float scala=0.8;
boolean savePDF = false;
ArrayList<Character> types;
ArrayList<Character> nums;
HashMap<Character, PImage> keyPngs;

// 当前按键
char typeKey='a';
// 大小变换图像的个数
char numberKey='1';
int typeIndex=0;
int numberIndex=0;
int stepIndex=0;

void setup() {
  size(WIDTH, HEIGHT);
  background(255);
  ellipseMode(CENTER);
  smooth();

  imageMode(CENTER);

  types=new ArrayList<Character>();
  nums=new ArrayList<Character>();
  // 按键对应的图像放到 map 中
  keyPngs=new HashMap();
  keyPngs.put('a', loadImage("1.png"));
  keyPngs.put('b', loadImage("2.png"));
  keyPngs.put('c', loadImage("3.png"));
  keyPngs.put('d', loadImage("4.png"));
  keyPngs.put('e', loadImage("5.png"));
  keyPngs.put('f', loadImage("6.png"));
  keyPngs.put('g', loadImage("7.png"));
  keyPngs.put('h', loadImage("8.png"));
  keyPngs.put('i', loadImage("9.png"));
}

void draw() {
  // 是否保存pdf
  if (savePDF) beginRecord(PDF, "pdf/####.pdf"); 
  background(255);
  // 画出图形
  for (int i=0; i<types.size (); i++) {
    drawCircle(i, types.get(i), int(String.valueOf(nums.get(i))), 0);
  }
  // 保存pdf
  if (savePDF) {
    endRecord();
    savePDF=false;
  }
}

void keyReleased() {
  // 如果是 a-i 那么更换图形样式
  if (keyPngs.keySet().contains(key)) {
    if (level==0) {
      types.add(key);
      nums.add('0');
      level++;
    }
    typeKey=key;
  } else if (key=='1'||key=='2'||key=='3'||key=='4'||key=='5'
    ||key=='6'||key=='7'||key=='8'||key=='9'||key=='0') {
    // 1-0 修改图形大小切换的个数
    types.add(typeKey);
    nums.add(key);
  } else if (key=='p') { // p 键保存
    savePDF=true;
  }
}

// 
void drawCircle(int theLevel, char type, int n, int noDraw) {
  int R=theLevel*r;
  noStroke();
  fill(random(255), random(255), random(255));
  pushMatrix();
  translate(width/2, height/2);

  if (theLevel==0) {
    // 中心的圆
    int rr=r;
    image(keyPngs.get(type), R, 0, rr, rr);
  } else {
    // 中心之外的图片
    int rr=r;
    for (int i=0; i<6*theLevel; i++) {
      if (n>0) { // 缩放图片
        rr=int(r*pow(scala, n-abs(i%(2*n)-n)));
      }
      // 旋转并画一个图片
      rotate(TWO_PI/6/theLevel);
      image(keyPngs.get(type), R, 0, rr, rr);
    }
  }
  popMatrix();
}
