
int radiusHour=150, radiusMinute=250;
PImage img;

void setup() {

  colorMode(HSB, 360, 360, 360);

  size(600, 600);
  frameRate(1);
  smooth();
  img=loadImage("background.jpeg");
  img.loadPixels();
  background(255);
}

void draw() {
  tint(30);
  image(img,0,0);
  translate(width/2, height/2);
  //  rotate(-PI*0.5);

  // caculate angle of hour and minute
  float angleHour=map(hour()%12, 0, 12, -PI*0.5, PI*1.5);
  float angleMinute=map(minute(), 0, 59, -PI*0.5, PI*1.5);
  loadPixels();
  for (int x=-width/2; x<width/2; x++) {
    for (int y=-height/2; y<height/2; y++) {
      // location of pixel before translate
      int loc=(y+height/2)*width + x+width/2;
      // distance of current pixel
      float dist=dist(0, 0, x, y);
      if (dist<radiusMinute) { 
        float h, s, b;
        float angle=atan2(y, x);
        if (angle<-PI/2) {
          angle+=TWO_PI;
        }
        if (dist<radiusHour) {
          if (angle<angleHour) {
            h=hue(img.pixels[loc]);
            s=saturation(img.pixels[loc]);
            b=brightness(img.pixels[loc]);
            pixels[loc]=color(h, s, b);
          }
        } else {
          if (angle<angleMinute) {
            h=hue(img.pixels[loc]);
            s=saturation(img.pixels[loc]);
            b=brightness(img.pixels[loc]);
            pixels[loc]=color(h, s-140, b-100);
          }
        }
      } else {
      }
    }
  }
  updatePixels();
  
  // draw line
  //  line(0, 0, cos(angleHour)*radiusHour, sin(angleHour)*radiusHour);
  //  line(0, 0, cos(angleMinute)*radiusMinute, sin(angleMinute)*radiusMinute);
}
//void updateTranslatedPixels(int x,int y,)
