import point2line.*;

// 帧率
int FRAME_RATE=24;
// 生成园速度
int CREATE_SPEED=18;


int padding=10;
int mousePressedX=0, mousePressedY=0;
ArrayList<Circles> circlesList;
int mode=60; // 圆的取色角度
boolean stoped=false;  // 是否暂停

void setup() {
  // 初始设置颜色模式等
  colorMode(HSB, 360, 100, 100);
  frameRate(FRAME_RATE);
  size(getW(), getH());
  reset();
}

// 重新记录数据
void reset() {
  circlesList=new ArrayList();
  background(255);
}

void draw() {
  background(255, 0, 100);
  noStroke();
  // 如果没有暂停就生成园
  if (!stoped && frameCount%CREATE_SPEED==0) {
    circlesList.add(new Circles(random(padding, width-padding), 0));
  }
  // 画出已经切开的圆
  for (Circles circles : circlesList) {
    if (circles.sliced)circles.draw();
  }
  // 画出未切开的园
  for (Circles circles : circlesList) {
    if (!circles.sliced)circles.draw();
  }
  // 随机颜色
  stroke(random(255), random(255), random(255));
  strokeWeight(3);
  // 绘制鼠标画的线
  if (mousePressed) {
    line(mousePressedX, mousePressedY, mouseX, mouseY);
  }
}

void keyPressed() {
  // 鼠标按下判断更新取色方案或者暂停下落
  HashMap<Character, Integer> map=new HashMap();
  map.put('1', 60);
  map.put('2', 90);
  if (map.containsKey(key))
    mode = map.get(key);
  if (key==ENTER)
    stoped=true;
}

// 保存图片
void keyReleased () {
  if (key=='c') {
    reset();
  } else if (key=='0') {
    saveFrame("images/####.jpg");
  }
}

void mousePressed() {
  mousePressedX=mouseX;
  mousePressedY=mouseY;
}

void mouseReleased() {
  // 切园的判断
  for (Circles cs : circlesList) {
    if (interected(mouseX, mouseY, mousePressedX, mousePressedY, cs)) {
      cs.slice();
    }
  }
}

// 判断鼠标画线是否切割园
boolean interected(float x1, float y1, float x2, float y2, Circles circles) {
  Vect2 p1 = new Vect2(x1, y1);
  Vect2 p2 = new Vect2(x2, y2);
  Vect2 center = new Vect2(circles.loc.x, circles.loc.y);
  Vect2 p = Space2.closestPointOnLine( center, p1, p2);
  return dist(center.x, center.y, p.x, p.y)<circles.r*circles.count/2 && p.x>min(x1, x2) && p.x<max(x1, x2) && p.y>min(y1, y2) && p.y<max(y1, y2);
}

// 画布高度
int getH() {
  return displayHeight;
}
// 画布长度
int getW() {
  return displayWidth;
}

// 园圈
class Circle {
  PVector loc;// 位置
  int r;// 半径
  int c;// 颜色
  float weight;
  boolean sliced=false;
  PVector slicingLoc;// 切割位置
  float slicingAngle;//切割角度
  float speed;
  Circle(float x, float y, int r1, int c1, float weight) {
    loc = new PVector(x, y);
    r = r1;
    this.weight=weight;
    c=c1;
    sliced=false;
    slicingLoc = new PVector(-1, -1);
  }

  // 切割当前园
  void slice() {
    sliced=true;
    slicingLoc = new PVector(random(loc.x-r, loc.x+r), random(loc.y-r, loc.y+r));
    slicingAngle = random(TWO_PI);
  }

  // 更新位置
  void update() {
    loc.y+=speed;
  }

  // 显示当前园
  void display() {
    fill(c);
    // 如果切割了
    if (sliced) {
      strokeWeight(weight);
      stroke(c);
      pushMatrix();
      translate(slicingLoc.x, slicingLoc.y);
      line(0, 0, sin(slicingAngle)*9999, cos(slicingAngle)*9999);
      line(0, 0, sin(slicingAngle+PI)*9999, cos(slicingAngle+PI)*9999);
      popMatrix();
    } else {// 没有切割
      ellipse(loc.x, loc.y, r, r);
    }
  }

  void draw() {
    update();
    display();
  }
}

// 园环
class Circles {
  PVector loc;// 位置
  int count=int(random(2, 5));// 数量
  int r=40;// 半径
  HashMap points;
  boolean sliced=false;
  ArrayList<Circle> circleList;//园的列表
  float speed=2.5;//速度

  Circles(float x, float y) {
    loc=new PVector(x, y);
    circleList=new ArrayList<Circle>();
    int allWeight=0;    
    int h=int(random(360));
    // 生成多个圆圈，组成园环
    for (int i=count; i>0; i--) {
      float weight=random(10, 30);
      allWeight+=weight*2;
      int c=color(h+random(mode), random(40, 100), random(40, 100));
      Circle cc=new Circle(x, y, allWeight, c, weight);
      cc.speed=speed;
      circleList.add(cc);
    }
  }

  // 切割
  void slice() {
    if (sliced) return;
    sliced=true;
    for (Circle c : circleList) {
      c.slice();
    }
  }

  // 更新
  void update() {
    loc.y+=speed;
  }

  // 显示
  void display() {
    ellipseMode(CENTER);
    noStroke();
    for (int i=circleList.size (); i>0; i--) {
      circleList.get(i-1).draw();
    }
  }

  // 
  void draw() {
    if (loc.y<10000) {
      update();
      display();
    }
  }
}
