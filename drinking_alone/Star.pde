
// 星星类
class Star {
  // radius of star
  float r; // 星星的半径
  float x, y; // 星星的坐标
  float h, s, v; // 星星的颜色 HSV

  Star() {
    r = random(2); // 星星大小随机为2一下的数字
    x=random(width); // x位置随机在宽度内
    y=random(150); // y位置随机在150内

    h=270; // 挑选的颜色
    s=random(10); // 饱和度在10以内
    v=random(100, 200); // 亮度在100,200
  }

  void update() {
  }

  void display() {
  }

  // 画星星的函数
  void draw() {
    //colorMode(HSB,100,100,100);
    v =(v+random(30))%200; // 亮度每frame增加30,超过200 从0开始
    fill(h, s, v); // 填充色
    ellipse(x, y, r, r); // 画一个小原作为星星
  }
}

