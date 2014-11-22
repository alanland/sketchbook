void drawShape(int num, int centerX, int centerY, float innerR, float outerR) {
  PVector[] points = new PVector[ num * 2 ];
  float angle = TWO_PI / points.length;

  for ( int i = 0; i < points.length; i++ ) {
    float x, y;
    if ( i % 2 == 0 ) {
      x = cos( angle * i ) * outerR;
      y = sin( angle * i ) * outerR;
    } else {
      x = cos( angle * i ) * innerR;
      y = sin( angle * i ) * innerR;
    }
    points[i] = new PVector( x, y );
  }

  beginShape();
  for (int i = 0; i < points.length; i++) {
    vertex( points[i].x+centerX, points[i].y+centerY );
  }
  endShape(CLOSE);
}
