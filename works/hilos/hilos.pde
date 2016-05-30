/*

 ----------------------------------------------------------------
 Copyright (C) 2005 Ricard Marxer Pi��n
 
 email (at) ricardmarxer.com
 http://www.ricardmarxer.com/
 ----------------------------------------------------------------
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 ----------------------------------------------------------------
 Built with Processing (Beta) v098
 uses Geomerative (Alpha) v004
 ----------------------------------------------------------------
 
 Created 17 January 2006
 
 ---------------------------------------------------------------- 
 hilos
 ---------------------------------------------------------------- 
 
 */


//import processing.opengl.*;
import geomerative.*;

RFont f;
RGroup grupo;
Particle[] psys;
int numPoints, numParticles;
float toldist = 20;
float maxvel;
float maxalph;
float backalpha;
boolean restart = true;
float t=0;


//------------------------ Runtime properties ----------------------------------
// Save each frame
boolean SAVEVIDEO = false;
boolean SAVEFRAME = false;
boolean APPLICATION = false;

String DEFAULTAPPLETRENDERER = P3D;
int DEFAULTAPPLETWIDTH = 680;
int DEFAULTAPPLETHEIGHT = 480;

String DEFAULTAPPLICRENDERER = OPENGL;
int DEFAULTAPPLICWIDTH = 800;
int DEFAULTAPPLICHEIGHT = 600;
//------------------------------------------------------------------------------

// The text to be written
String STRNG = "Srings";

// The font to be used
//String FONT = "LidoSTF.ttf";
String FONT = "darkcrystaloutline.ttf";

// The inertie of the particles
float INERTIE[] = {
  0.5, 1.3
};

// The coefficient with which to reach the target
float TARGET[] = {
  0.028, 0.029
};

// The trail coefficient: 0 no trail - 1 infinite trail
float TRAILCOEFF = 0.96;

// The brightness coefficient: 0 no brightness - 1 full brightness
float BRIGHTCOEFF = 0.7;

// The brightness error coefficient: inf no error in brightness (the brightness is completely independent on the velocity)
float BRIGHTERRCOEFF = 2.2;//1.2;

// The velocity of the drawing
int VELOCITY = 2;

String newString = "";

void setup() {

  int w = DEFAULTAPPLICWIDTH, h = DEFAULTAPPLICHEIGHT;
  String r = DEFAULTAPPLICRENDERER;

  if (!APPLICATION) {
    // Specify the widtha and height at runtime
    //    w = int(param("width"));
    //    h = int(param("height"));
    w = width;
    h = height;
    r = (String)param("renderer");


    // (String) will return null if param("renderer") doesn't exist
    if (r != OPENGL && r != P3D && r != JAVA2D && r != P2D) {
      r = DEFAULTAPPLETRENDERER;
    }
    // int() will return 0 if param("width") doesn't exist
    if (w <= 0) {
      w = DEFAULTAPPLETWIDTH;
    }
    // int() will return 0 if param("height") doesn't exist
    if (h <= 0) {
      h = DEFAULTAPPLETHEIGHT;
    }
  }
  w = 800;
  h = 600;
  
  RG.init(this);

  size(w, h, r);
  frameRate(25);
  try {
    smooth();
  }
  catch(Exception e) {
  }
  background(0);

  f = new RFont(FONT, 372, RFont.CENTER);

  initialize();
}

void draw() {
  translate(width/2, height/2);
  noStroke();
  fill(0, backalpha);
  rect(-width/2, -height/2, width, height); 

  for (int j=0; j<VELOCITY; j++) {
    for (int i=0; i<numParticles; i++) {
      psys[i].update(grupo);
      psys[i].draw(g);
    }
  }
  INERTIE[0] = 0.75*float(constrain(mouseX, 1, width))/float(width);
  INERTIE[1] = INERTIE[0]+ 0.4*float(constrain(mouseX, 1, width))/float(width);

  TARGET[0] = 0.4*float(constrain(mouseY, 1, height))/float(height);
  TARGET[1] = TARGET[0]+ 0.5*float(constrain(mouseY, 1, height))/float(height);
  t++;

  if (SAVEVIDEO) saveFrame("hilos-####.tga");
  toldist += 0.009;
}

void initialize() {
  maxvel = width/90 * constrain(BRIGHTERRCOEFF, 0.01, BRIGHTERRCOEFF) * (6F/(STRNG.length()+1));
  maxalph = constrain(BRIGHTCOEFF, 0, 1)*255;
  backalpha = 255-constrain(TRAILCOEFF, 0, 1)*255;
  toldist = 20;

  grupo = f.toGroup(STRNG);

  RCommand.setSegmentStep(2);
  RCommand.setSegmentator(RCommand.UNIFORMSTEP);

  grupo = grupo.toPolygonGroup();
  grupo.centerIn(g, 10, 1, 1);

  RPoint[] ps = grupo.getPoints();
  numPoints = ps.length;
  numParticles = floor(numPoints);

  int lasthuev = int(random(0, 255));
  psys = new Particle[numParticles];
  for (int i=0; i<numParticles; i++) {
    int huev = lasthuev + int(random(-12, 12));
    huev = (huev + 255) % 255;
    lasthuev = huev;
    psys[i] = new Particle(g, i, huev);
    psys[i].pos = new RPoint(ps[i]);
  }
}

void keyReleased() {
  if (keyCode==ENTER) {
    STRNG = newString; 
    newString = "";
    initialize();
  } else if (keyCode==BACKSPACE) {
    if (newString.length() !=0 ) {
      newString = newString.substring(0, newString.length()-1);
    }
  } else if (keyCode!=SHIFT) {
    newString += key;
  }
}

void mousePressed() {
  saveFrame(STRNG+".tga");
}

public class Particle {
  // Velocity
  RPoint vel;

  // Position
  RPoint pos;
  RPoint lastpos;

  // Caracteristics
  int col;
  int hueval;
  float sz;

  // ID
  int id;

  // Constructor
  public Particle(PGraphics gfx, int ident, int huevalue) {
    pos = new RPoint(random(-gfx.width/2, gfx.width/2), random(-gfx.height/2, gfx.height/2));
    lastpos = new RPoint(pos);
    vel = new RPoint(0, 0);

    colorMode(HSB);
    sz = random(2, 3);

    id = ident;
    hueval = huevalue;
  }

  // Updater of position, velocity and colour depending on a RGroup
  public void update(RGroup grp) {
    lastpos = new RPoint(pos);
    pos.add(vel);
    RPoint[] ps = grp.getPoints();
    if (ps != null) {
      float distancia = dist(pos.x, pos.y, ps[id].x, ps[id].y);
      if (distancia <= toldist) {
        id = (id + 1) % ps.length;
      }

      RPoint distPoint = new RPoint(ps[id]);
      distPoint.sub(pos);

      distPoint.scale(random(TARGET[0], TARGET[1]));
      vel.scale(random(INERTIE[0], INERTIE[1]));
      vel.add(distPoint);
      float sat = constrain((width-distancia)*0.25, 0.001, 255);
      float velnorm = constrain(vel.norm(), 0, maxvel);

      sat = abs(maxvel-velnorm)/maxvel*maxalph;
      sat = constrain(sat, 0, maxalph);
      col = color(hueval, 150, 255, sat);
    }
  }

  public void setPos(RPoint newpos) {
    lastpos = new RPoint(pos);
    pos = newpos;
  }

  // Drawing the particle
  public void draw(PGraphics gfx) {
    stroke(col);
    line(lastpos.x, lastpos.y, pos.x, pos.y);
  }
}

