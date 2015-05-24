
// 夜空类
class NightSky {
  // 该方法用于指定一个长方形来画夜空
  // x1 y1 夜空左上顶点坐标
  // x2 y2 夜空右下顶点坐标
  void drawNightSky(float x1, float y1, float x2, float y2) {
    noStroke();// 不要边填充
    float W=x2-x1, H=y2-y1; // 计算夜空的宽度和高度
    // 夜色模式设置成 HSB，色相为360,S和B都是高度，因为夜空只在一个方向上进行简便
    colorMode(HSB, 360, H, H);
    // 选择 270 的色相（深蓝色，恰似夜空的颜色）
    float h=270;//random(260,280);
    pushMatrix(); // 
    translate(x1, y1); // 把坐标移动到 夜空的左上角
    // 横向的总量为夜空宽度，也就是只画一次
    // 纵向增量为2,两个像素画一次
    float xstep=W, ystep=2;

    // 遍历高度，每 ystep 执行一次
    for (int y=0; y<H; y+=ystep) {
      for (int x=0; x<W; x+=xstep) { // 遍历宽度，因为xstep=W，所以只会执行一次
        // 填充色，根据高度进行渐变，因为想让蓝色多一点，所以，所以根据cos函数进行渐变（可参考色相图）
        fill(h, H*cos(float(y)/H*HALF_PI), y);
        // 画一个长方向（一个一个的长方向组成了渐变的夜空效果）
        rect(x, y, x+xstep, ystep);
      }
    }
    popMatrix();
  }
}

