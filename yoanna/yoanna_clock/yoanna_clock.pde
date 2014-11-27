
int screenSize=600;

int radiusHour=150, radiusMinute=200, radiusSecond=280;
PImage img;
PImage backImg;
int fsecond=0;
int fminute=0;
int fhour=0;

void setup() {
  tint(40);
  colorMode(HSB, 360, 360, 360);
  size(screenSize, screenSize);
  frameRate(20);
  smooth();
  img=loadImage("background-"+screenSize+".jpg");
  //  img=loadImage("background.png");
  img.loadPixels();
  backImg=loadImage("b-"+screenSize+".jpg");
  background(255);
}

void draw() {
  fsecond+=4;
  fminute+=2;
  fhour+=1;
  image(backImg, 0, 0);
  translate(width/2, height/2);
  //  rotate(-PI*0.5);

  // caculate angle of hour and minute
  float angleHour=map(hour()%12, 0, 12, -PI*0.5, PI*1.5);
  float angleMinute=map(minute(), 0, 60, -PI*0.5, PI*1.5);
  float angleSecond=map(second(), 0, 60, -PI*0.5, PI*1.5);

  //  println(degrees(angleMinute));
  loadPixels();
  for (int x=-width/2; x<width/2; x++) {
    for (int y=-height/2; y<height/2; y++) {
      // location of pixel before translate
      int loc=(y+height/2)*width + x+width/2;
      // distance of current pixel
      float dist=dist(0, 0, x, y);
      if (dist<radiusSecond) {
        float h, s, b;
        float angle=atan2(y, x);
        if (angle<-PI/2) {
          angle+=TWO_PI;
        }
        if (angle<angleSecond) {
          h=hue(img.pixels[loc]);
          s=saturation(img.pixels[loc]);
          b=brightness(img.pixels[loc]);
          h=(degrees(angleBetween(angle, angleMinute)/2))%360;
          h=(h+fsecond)%360;
          pixels[loc]=color(h, s, b-150);
        }
        if (dist<radiusMinute) {  // minute
          if (angle<angleMinute) {
            //if (needDrawMinute(angle, angleMinute)) {
            // 0-11
            if (hour()<12) {
              h=hue(img.pixels[loc]);
              s=saturation(img.pixels[loc]);
              b=brightness(img.pixels[loc]);
              h=(degrees(angleBetween(angle, angleMinute)/2))%360;
              h=(h+fminute)%360;
              pixels[loc]=color(h, s, b-100);
            } else {
              h=(hue(img.pixels[loc]))%360;
              h=(h+fminute)%360;
              s=saturation(img.pixels[loc]);
              b=brightness(img.pixels[loc]);
              pixels[loc]=color(h, s, b-70);
            }
          }
          if (dist<radiusHour) {
            if (angle<angleHour) {
              if (hour()<12) {
                h=hue(img.pixels[loc]);
                s=saturation(img.pixels[loc]);
                b=brightness(img.pixels[loc]);
                h=(h+fhour)%360;
                pixels[loc]=img.pixels[loc];
              } else {
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
      else {
        //        pixels[loc]=img.get(x+width/2, y+height/2);
      }
    }
  }
  updatePixels();

  // draw line
  //  line(0, 0, cos(angleHour)*radiusHour, sin(angleHour)*radiusHour);
  //  line(0, 0, cos(angleMinute)*radiusMinute, sin(angleMinute)*radiusMinute);
}
boolean needDrawMinute2(float angle, float angleMinute) {
  if (angleMinute>0) {

    return angle<angleMinute && angle>angleMinute-PI/2;
  } else {
    return angle<0&&angle<angleMinute || angle>PI/2*3-angleMinute+PI/2;
  }
}

float angleBetween(float angle, float angleMinute) {
  angle+=PI/2;
  angleMinute+=PI/2;
  PVector pa = new PVector(cos(angle), sin(angle));
  PVector pm = new PVector(cos(angleMinute), sin(angleMinute));
  return PVector.angleBetween(pa, pm);
}
