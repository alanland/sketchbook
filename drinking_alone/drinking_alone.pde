
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.util.*;
import java.awt.event.KeyEvent;

// the screen size
int ScreenSizeX = 1500 ;
int ScreenSizeY = 820 ;

// variables of flower drawing
int petalX = 0 ;
int petalY = 0 ;  
int petalCount = 5 ;
int petalWidth = 35 ;
int petalHeight = 35 ;
// rotation and delta
float flowerRotate = 0;
float rotateDelta = 0.1; // not the really rotate delta

// images 
PImage imgLibai;
PImage imgTree;
PImage imgPaper;
PImage imgMoon;
// moon position
int MOONX=750, MOONY=80, MOONR=140, moonr=MOONR;
int MOON_AUTO=0;
// 0: 初始状态 1: 变大 2: 变小
int MOON_STATE=0;
// scalar of images
float libaiScala = 1;
float treeScala = 1;
// image clickable color value
int colorTree= -14187992;
int colorLibai = -331806;
int colorBranch = -10535561;

// music
Minim minim;
AudioPlayer player;
boolean paused=false;

// flowers
List<PVector> locations=new ArrayList<PVector>();

// stars
int starCount=500;
ArrayList<Star> stars;

// shootingstars
int shootingStarsCount=10;
ArrayList<ShootingStar> shootingStars;

// night sky
NightSky nightSky;

// growing tree
//Tree tree;

// HanZi
PFont font;
ArrayList<ArrayList<HanZi>> hanzis;
int lastPoemMoveFrame=-1;
// 0: hidden
// 1: moveing; 
// 2: stoped: 
// 3: disappearing
int POEM_X=730;
int POEM_Y=295;
int poemStatus = 0;


//
void setup() {
  // set size
  size(ScreenSizeX, ScreenSizeY);
  smooth();
  // initialize media player
  minim= new Minim(this);
  player=minim.loadFile("Adele.mp3");
  player.loop();
  player.play();

  // load images
  imgLibai =loadImage("libai.png");
  imgTree=loadImage("tree.png");
  imgPaper=loadImage("paper.png");
  imgMoon=loadImage("moon.png");

  // 30 frames per second
  frameRate(30);

  // tree 
  //  tree = new Tree();

  // night sky
  nightSky = new NightSky();

  initStar(); // init stars
  initShootingStar(); // init shooting stars

  initPoem(); // init poem content
}

void initPoem() {

  // load font
  font = createFont("草泥马体", 32); 
  textFont(font);

  String[] strs = {
    "花间一壶酒 独酌无相亲", 
    "举杯邀明月 对影成三人", 
    "月既不解饮 影徒随我身", 
    "暂伴月将影 行乐须及春", 
    "我歌月徘徊 我舞影零乱", 
    "醒时相交欢 醉后各分散", 
    "永结无情游 相期邈云汉"
  };
  hanzis = new ArrayList<ArrayList<HanZi>>();
  int cur=0;
  for (int n=0; n<strs.length; n++) {
    ArrayList<HanZi> hanzi = new ArrayList<HanZi>();
    hanzis.add(hanzi);
    String str=strs[n];
    for (int i=0; i<str.length (); i++) {
      float x1=random(300, 600), y1=random(300, 600), x2=POEM_X-(font.getSize()+25)*n, y2= POEM_Y+(font.getSize())*i;
      hanzi.add(new HanZi(String.valueOf(str.charAt(i)), x1, y1, x2, y2, cur++));
    }
  }
}

void initShootingStar() {
  shootingStars=new ArrayList<ShootingStar>();
  for (int i=0; i<shootingStarsCount; i++) {
    shootingStars.add(new ShootingStar());
  }
}
void initStar() {
  stars = new ArrayList<Star>();
  for (int i=0; i<starCount; i++) {
    stars.add(new Star());
  }
}

void draw() {
  // set background with a white and transparent rect
  fill(0, 0, 200, 40); // alpha will cause drop shadows, smaller value for langer shawdos
  noStroke();
  rect(0, 0, width, height);

  // draw night sky at top position
  nightSky.drawNightSky(0, 0, width, 200);

  drawStars(); // draw stars 
  drawShootingStars(); // draw shooting stars

    // draw images with scala
  pushMatrix();
  //  translate(50, 300);
  translate(150, 600);
  rotate(sin(map(frameCount%50, 0, 50, 0, TWO_PI))*0.015);
  image(imgLibai, -100, -300, imgLibai.width*libaiScala, imgLibai.height*libaiScala);
  //  rect(0, 0, 100, 100);
  popMatrix();
  image(imgTree, 846, 60, imgTree.width*treeScala, imgTree.height*treeScala);

  if (poemStatus>0) {
    //      tint(255, 127);
    //alpha(10);
    //      image(imgPaper, 250, 250, 600, 400);
  }

  //  tree.draw();

  // draw flowers
  drawFlower(); // draw flowers

  // draw poem
  drawPoem();

  // draw moon
  if (MOON_AUTO==0) drawMoon();
  else drawMoon2();

  // draw mouse effect
  mouseEffect();
}

//
void drawMoon() {
  noStroke();
  fill(0, 0, 200);
  pushMatrix();
  translate(MOONX, MOONY);
  ellipse(0, 0, MOONR, MOONR);
  if (MOON_STATE==0) {
    //    moonr=MOONR;
  } else if (MOON_STATE==1) {
    moonr++;
    moonr=min(moonr, MOONR+40);
  } else {
    moonr--;
    if (moonr==MOONR) MOON_STATE=0;
  }
  image(imgMoon, -moonr/2, -moonr/2, moonr, moonr);
  popMatrix();
}

//
void drawMoon2() {
  noStroke();
  fill(0, 0, 200);
  pushMatrix();
  translate(MOONX, MOONY);
  ellipse(0, 0, MOONR, MOONR);
  if (dist(mouseX, mouseY, MOONX, MOONY)<MOONR/2) {
    if (MOON_STATE==0) {
      MOON_STATE=1;
      moonr=MOONR;
    } else if (MOON_STATE==1) {
      moonr+=2;
      if (moonr>MOONR+40) MOON_STATE=2;
    } else {
      moonr--;
      if (moonr==MOONR) MOON_STATE=0;
    }
  } else {
    if (MOON_STATE==0) {
      moonr=MOONR;
    } else if (MOON_STATE==1) {
      moonr++;
      if (moonr>MOONR+40) {
        MOON_STATE=2;
      }
    } else {
      moonr--;
      if (moonr==MOONR) {
        MOON_STATE=0;
      }
    }
  }
  image(imgMoon, -moonr/2, -moonr/2, moonr, moonr);
  popMatrix();
}

//
void drawPoem() {
  if (poemStatus==1) {
    int r=10;
    int hueStep = 2; 
    // if write over, set hue to 4
    if (frameCount>lastPoemMoveFrame+77*10) hueStep=4;
    fill(frameCount%(360/hueStep)*hueStep, 140, 130); // change hue by hueStep per frame
    for ( ArrayList<HanZi> hanzi : hanzis) {
      for (HanZi zi : hanzi) {
        if (frameCount>lastPoemMoveFrame+zi.index*10) { // start a character per 15 frame
          zi.start(); // start if zi isnot disappearing
        }
        zi.draw();
      }
    }
  } 
  if (poemStatus==3) {
    fill(155, 220, random(180, 220));
    for ( ArrayList<HanZi> hanzi : hanzis) {
      for (HanZi zi : hanzi) {
        zi.disappear();
        zi.draw();
        if (!insidePoemArea(zi.loc.x, zi.loc.y)) {
          zi.reset();
        }
      }
    }
  }
} 

// 
void mouseEffect() {
  // get color value of mouse position
  int c = get(mouseX, mouseY);
  //
  if (c==colorLibai || c==colorTree  ||
    (poemStatus==1&&insidePoemArea(mouseX, mouseY))||
    (MOON_AUTO==0 && dist(mouseX, mouseY, MOONX, MOONY)<moonr/2)
    ) {
    noFill();
    strokeWeight(1);
    if (dist(mouseX, mouseY, MOONX, MOONY)<moonr/2) {
      stroke(353, 200, 200);
    } else {
      stroke(c+5000); // set a color different from mouse position color
    }
    int r = 25-frameCount%25; // calacute times
    for (int i=5; i<r; i++) { // draw circles, radius >= 5 ensure mouse position color not changed
      ellipse(mouseX, mouseY, i, i);
    }
  }
}

//
void drawShootingStars() {
  for (int i=0; i<shootingStars.size (); i++) {
    ShootingStar star = shootingStars.get(i);
    star.draw();
    // if a shooting star is dead, create a new one with a random chance
    if (star.isDead() && random(10) > 4) { 
      shootingStars.set(i, new ShootingStar());
    }
  }
}

// 
void drawStars() {
  for (Star star : stars) {
    star.draw();
  }
}

//
void drawFlower() {
  for (PVector loc : locations) {
    addFlower(loc.x, loc.y);
  }

  flowerRotate += rotateDelta;
}

void addFlower(float petalX, float petalY) {
  noStroke();
  strokeWeight(random(5, 5));
  if (random(100)<2) {
    stroke(0, 0, 200);
  }
  pushMatrix();
  translate(petalX, petalY);
  if (dist(mouseX, mouseY, petalX, petalY)<petalWidth) {
    rotate(flowerRotate*1.5);
    strokeWeight(2);
    stroke(0, 0, frameCount%250);
  } else {
    rotate(flowerRotate/3);
  }

  for (int i=0; i< petalCount*2; i++) {  
    // draw the shape of a petal   
    fill(#F59CC8) ;
    beginShape();
    vertex(0, 0);
    bezierVertex(0, 0, 0-petalWidth/1.2, 0-petalHeight/2, 0, 0-petalHeight);
    bezierVertex(0, 0-petalHeight, petalWidth/1.2, 0-petalHeight/2, 0, 0 );     
    endShape();
    float angle =TWO_PI/petalCount; 
    rotate(angle); 
    i++;
  }
  popMatrix();
}

// key events
void keyReleased() {
  // key c will remove all flowers
  if (key=='c' || key=='C') locations = new ArrayList<PVector>();

  // key space will pause or play music
  if (key==KeyEvent.VK_SPACE) {
    paused=!paused;
    if (paused) {
      player.pause();
    } else {
      player.play();
    }
  }
  // 
  if (key=='1') MOON_AUTO=0;
  if (key=='2') MOON_AUTO=1;
}

// mouse click events
void mouseClicked() {
  //  println(get(mouseX, mouseY));
  // println(mouseX, mouseY);


  // add a flower and record the position
  int c=get(mouseX, mouseY);
  if (c==colorTree) {
    locations.add(new PVector(mouseX, mouseY));
  }

  // the poet(sleeve) clicked
  if (c==colorLibai) {
    if (libaiScala<1) { 
      // restore 
      libaiScala=1;
      poemStatus=0;
      for ( ArrayList<HanZi> hanzi : hanzis) {
        for (HanZi zi : hanzi) {
          zi.reset();
        }
      }
    } else {
      // zoom smaller
      libaiScala = 0.5; 

      // play poem with chinese character
      poemStatus=1;

      // 
      lastPoemMoveFrame=frameCount;
    }
  }

  // branch
  //  if (c==colorBranch) {
  //    tree.reset();
  //  }

  // poem status 
  if (poemStatus==1 && insidePoemArea(mouseX, mouseY)) {
    if (poemStatus==1) {
      poemStatus=3;
    }
  }

  // moon
  if (dist(mouseX, mouseY, MOONX, MOONY)<MOONR/2) {
    if (MOON_AUTO==0) {
      if (MOON_STATE==0) MOON_STATE=1;
      else if (MOON_STATE==1) MOON_STATE=2;
      else MOON_STATE=0;
    } else {
      MOON_STATE=1;
    }
  }
}

boolean insidePoemArea(float x, float y) {
  //rect(350, 250, 830-250, 640-250);
  //println(x, y, x<250&&x>830&&y<250&&y>640);
  return x>350&&x<830&&y>250&&y<640;
}
