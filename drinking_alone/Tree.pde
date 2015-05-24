class Tree {
  // Pressing Control-R will render this sketch.

  // This is modified from the demo sketches on processing.org and processing.js
  int i = 5; 

  float theta;
  float a=10;
  int seed;

  Tree() {  
    //    frameRate(1);
    // smooth edges
    smooth();

    // set the width of the line. 
    // strokeWeight(10);

    theta = radians(a);
    seed=(int)(random(999));
  } 

  void reset() {
    i=5;
  }

  void draw() {  // this is run repeatedly.  
    randomSeed(seed);
    // Start the tree from the bottom of the screen
    translate(1117, 547);

    // set the color
    //    stroke(random(50), random(255), random(255), 255);

    stroke(275, 97, 94);

    // draw the line
    strokeWeight(20);
    //    line(0, 0, 0, -100);

    // move to the end of that line
    translate(0, -100);

    // Start the recursive branching
    branch(i, 0);
    i = min(150, i+1);
  }

  void branch(float h, int deepth) {
    // Each branch will be 2/3rds the size of the previous one
    h *= random(0.5, 0.8);

    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (h > random(1, 8)) { // h>2
      for (int i=-1; i<2; i+=2) {
        pushMatrix();    // Save the current state of transformation (i.e. where are we now)
        rotate(i*(theta + random(0.5)));   // Rotate by theta, i=1 for rigth branch, -1 for left branch
        strokeWeight(h/4);
        line(0, 0, 0, -h);  // Draw the branch
        translate(0, -h); // Move to the end of the branch
        branch(h+random(1), deepth+1);       // Ok, now call myself to draw two new branches!!
        popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
      }
    }
  }
}

