
//　窗口大小
int screenSize=600;

//　时针长度
int radiusHour=150, 
//　分针长度
radiusMinute=200, 
//　秒针长度
radiusSecond=280;

//　剪纸图片
PImage img;
//　夜空背景
PImage backImg;

//　记录三个指针颜色变换的程度　
int fsecond=0;
int fminute=0;
int fhour=0;

void setup() {
  //　让夜空的背景透明度低一些
  tint(40);
  //　颜色模式用　ＨＳＢ
  colorMode(HSB, 360, 360, 360);
  //　设置窗口大小
  size(screenSize, screenSize);
  //　设置帧率
  frameRate(15);
  //　设置平滑
  smooth();
  //　加载窗口大小对应的ｊｐｇ剪纸图片
  img=loadImage("background-"+screenSize+".jpg");
  img.loadPixels();
  //　加载夜空图片
  backImg=loadImage("b-"+screenSize+".jpg");
}

void draw() {
  //　设置三个指针对应的颜色变化程度
  fsecond+=8; //　最快
  fminute+=4; //　其次　
  fhour+=2;// 最慢
  image(backImg, 0, 0);//画出夜空
  translate(width/2, height/2);//坐标变换到画布中心
  //  rotate(-PI*0.5);

  // 计算出当前的时针对应的角度
  float angleHour=map(hour()%12, 0, 12, -PI*0.5, PI*1.5);
  // 计算出当前的分针对应的角度
  float angleMinute=map(minute(), 0, 60, -PI*0.5, PI*1.5);
  // 计算出当前的秒针对应的角度
  float angleSecond=map(second(), 0, 60, -PI*0.5, PI*1.5);

  // 加载画布像素
  loadPixels();
  // 遍历画布上的点　－　横向
  for (int x=-width/2; x<width/2; x++) {
    // 遍历画布上的点　－　纵向
    for (int y=-height/2; y<height/2; y++) {
      // 计算出坐标变换前的位置
      int loc=(y+height/2)*width + x+width/2;
      // 当前像素距离中心点的距离
      float dist=dist(0, 0, x, y);
      // 如果像素在分针范围内
      if (dist<radiusSecond) {
        // 定义色相，饱和度，亮度属性
        float h, s, b;
        // 计算出当前像素对应的角度
        float angle=atan2(y, x);
        // 换算小于　－２７０　度的坐标（０点之前的）
        if (angle<-PI/2) {
          angle+=TWO_PI;
        }
        // 如果角度小于秒针角度
        if (angle<angleSecond) {
          // 获取色相
          h=hue(img.pixels[loc]);
          // 获取饱和度
          s=saturation(img.pixels[loc]);
          // 获取亮度
          b=brightness(img.pixels[loc]);
          // 计算根据当前角度对应的色相的３６０度色轮上的颜色
          h=(degrees(angleBetween(angle, angleMinute)/2))%360;
          // 加上秒针的色相偏移
          h=(h+fsecond)%360;
          // 更新当前像素颜色
          pixels[loc]=color(h, s, b-150);
        }
        // 如果在分针圆圈范围内
        if (dist<radiusMinute) {  
          // 角度小于分针
          if (angle<angleMinute) {

            // 0-11点，白天的情况
            if (hour()<12) {
              h=hue(img.pixels[loc]);
              s=saturation(img.pixels[loc]);
              b=brightness(img.pixels[loc]);
              h=(degrees(angleBetween(angle, angleMinute)/2))%360;
              h=(h+fminute)%360;
              pixels[loc]=color(h, s, b-100);
            } else {// 夜晚的情况
              h=(hue(img.pixels[loc]))%360;
              h=(h+fminute)%360;
              s=saturation(img.pixels[loc]);
              b=brightness(img.pixels[loc]);
              pixels[loc]=color(h, s, b-70);
            }
          }
          // 如果在时针范围内
          if (dist<radiusHour) {
            // 如果角度小于时针
            if (angle<angleHour) {
              // 白天
              if (hour()<12) {
                h=hue(img.pixels[loc]);
                s=saturation(img.pixels[loc]);
                b=brightness(img.pixels[loc]);
                h=(h+fhour)%360;
                pixels[loc]=img.pixels[loc];
              } else {// 夜晚
                h=hue(img.pixels[loc]);
                s=saturation(img.pixels[loc]);
                b=brightness(img.pixels[loc]);
                h=(degrees(angleBetween(angle, angleHour))/2)%360;
                h=(h+fhour)%360;
                pixels[loc]=color(h, s, b);
              }
            }
          }// end hour
        }// end minute
      }// end second
    }
  }
  // 更新像素
  updatePixels();
}

// 计算两个角度之间的差别
float angleBetween(float angle, float angleMinute) {
  // 把角度换算成　０－３６０
  angle+=PI/2;
  angleMinute+=PI/2;
  // 用ＰＶｅｃｔｏｒ表示角度
  PVector pa = new PVector(cos(angle), sin(angle));
  PVector pm = new PVector(cos(angleMinute), sin(angleMinute));
  // 返回角度
  return PVector.angleBetween(pa, pm);
}
