
class ShootingStar {
  int STAR_SIZE = int(random(5, 10));
  int starSize;
  int starColor = color(0, 0, 255);
  PVector start;
  PVector end;
  int tail = int(random(10, 30));
  int life = int(random(10, 30));
  int waked;
  PVector[] points;
  PVector velocity;

  ShootingStar() {
    start = new PVector(random(width), random(200));
    end = new PVector(random(width), random(200));
    if (start.y>end.y) {
      float tmp = start.y;
      start.y=end.y;
      end.y=tmp;
    }
    points = new PVector[tail];
    velocity = PVector.sub(end, start);
    velocity.div(tail);
    waked = 0;
    starSize = STAR_SIZE;
    starColor=color(0, random(10), 200);
    for (int i = 0; i < tail; i++) {
      points[i] = new PVector(start.x, start.y);
    }
  }

  void display() {
    for (int i = 0; i < tail - 1; i++) {
      float shooterSize = max(0, (float) (starSize * i / tail));
      if (shooterSize > 0) {
        strokeWeight(shooterSize);
        stroke(starColor);
        line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y);
      } else {
        noStroke();
      }
    }
  }

  void update() {
    // shrink the shooting star as it fades
    starSize *= 0.9;
    //            if (starSize<1){
    //                waked=tail-1;
    //                life=0;
    //            }

    // move the shooting star along it's path
    if (waked < tail) {
      for (int i = 0; i < tail - 1; i++) {
        points[i].x = points[i + 1].x;
        points[i].y = points[i + 1].y;
      }
      waked++;
    } else {
      life--;
    }

    // add the new points in to the shooting star as lang as it hasn't burnt out
    if (life >= 0) {
      if (waked>=tail) {
        for (int i=0; i<tail; i++) {
          points[i].add(velocity);
        }
      } else {
        points[points.length - 1].add(velocity);
      }
      //                  shootX[shootX.length - 1] = startX + deltaX * timer;
      //                shootY[shootY.length - 1] = startY + deltaY * timer;
      //                timer++;
      //                if (timer >= tail) {
      //                    timer = -1; // end the shooting star
      //                }
    }
  }

  boolean isDead() {
    return life < 0;
  }

  void draw() {
    randomSeed(System.currentTimeMillis());
    if (!isDead()) {
      update();
      display();
    }
  }
}

