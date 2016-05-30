/*

 ----------------------------------------------------------------
 Copyright (C) 2005 Ricard Marxer Pi��n
 
 email (at) ricardmarxer.com
 http://www.ricardmarxer.com/
 http://www.caligraft.com/exhibition/lalana
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
 lalana
 ----------------------------------------------------------------
 
 */

import processing.opengl.*;
import geomerative.*;

float toldist;
RFont f;
RGroup grupo;
boolean restart = false;
Particle[] psys;
int numPoints, numParticles;
float maxvel;


//------------------------ Runtime properties ----------------------------------
// Save each frame
boolean SAVEVIDEO = false;
boolean SAVEFRAME = false;
boolean APPLICATION = true;

String DEFAULTAPPLETRENDERER = P3D;
int DEFAULTAPPLETWIDTH = 680;
int DEFAULTAPPLETHEIGHT = 480;

String DEFAULTAPPLICRENDERER = OPENGL;
int DEFAULTAPPLICWIDTH = 800;
int DEFAULTAPPLICHEIGHT = 600;
//------------------------------------------------------------------------------


// Text to be written
String STRNG = "Wiven";

// Font to be used
//String FONT = "Gentium.ttf";
String FONT = "GenAR102.TTF";

// Velocity of change
int VELOCITY = 3;

// Velacity of deformation
float TOLCHANGE = 0.025;

// Coefficient that handles the variation of amount of ink for the drawing 
float INKERRCOEFF = 0.8;

// Coefficient that handles the amount of ink for the drawing
float INKCOEFF = 0.3;

// Coefficient of precision: 0 for lowest precision
float PRECCOEFF = 0.75;

String newString = "";

void setup(){
  RG.init(this);
  int w = DEFAULTAPPLICWIDTH, h = DEFAULTAPPLICHEIGHT;
  String r = DEFAULTAPPLICRENDERER;

  if(!APPLICATION){
    // Specify the widtha and height at runtime
    w = int(param("width"));
    h = int(param("height"));
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

  size(w,h,r);
  frameRate(25);
  try{
    smooth();
  }
  catch(Exception e){
  }

  background(0);

  f = new RFont(FONT,372,RFont.CENTER);

  initialize();
}

void draw(){
  pushMatrix();
  translate(width/2, height/2);
  noStroke();

  for(int i=0;i<numParticles;i++){
    for(int j=0;j<VELOCITY;j++){
      psys[i].update(grupo);
      psys[i].draw(g);
    }
  }
  popMatrix();

  if(SAVEVIDEO) saveFrame("filesvideo/"+STRNG+"-####.tga");
  toldist += TOLCHANGE;
}

void initialize(){
  toldist = ceil(width/200F) * (6F/(STRNG.length()+1));
  maxvel = width/80F * INKERRCOEFF * (6F/(STRNG.length()+1));

  grupo = f.toGroup(STRNG);

  RCommand.setSegmentStep(1-constrain(PRECCOEFF,0,0.99));
  RCommand.setSegmentator(RCommand.UNIFORMSTEP);

  grupo = grupo.toPolygonGroup();
  grupo.centerIn(g, 5, 1, 1);

  background(0);
  RPoint[] ps = grupo.getPoints();
  numPoints = ps.length;
  numParticles = numPoints;
  psys = new Particle[numParticles];
  for(int i=0;i<numParticles;i++){
    psys[i] = new Particle(g,i,int(float(i)/float(numParticles)*125));
    psys[i].pos = new RPoint(ps[i]);
    psys[i].vel.add(new RPoint(random(-10,10),random(-10,10)));
  } 

  toldist = 8;
}

void keyReleased(){
  if(keyCode==ENTER){
    STRNG = newString; 
    newString = "";
    initialize();
  }
  else if(keyCode==BACKSPACE){
    if(newString.length() !=0 ){
      newString = newString.substring(0,newString.length()-1);
    }
  }
  else if(keyCode!=SHIFT){
    newString += key;
  }
}

public class Particle{
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
  public Particle(PGraphics gfx, int ident, int huevalue){
    pos = new RPoint(random(-gfx.width/2,gfx.width/2), random(-gfx.height/2,gfx.height/2));
    lastpos = new RPoint(pos);
    vel = new RPoint(0, 0);

    colorMode(HSB);
    sz = random(2,3);

    id = ident;
    hueval = huevalue;
  }

  // Updater of position, velocity and colour depending on a RGroup
  public void update(RGroup grp){
    lastpos = new RPoint(pos);
    pos.add(vel);
    RPoint[] ps = grp.getPoints();
    if(ps != null){
      float distancia = dist(pos.x,pos.y,ps[id].x,ps[id].y);
      if(distancia <= toldist){
        id = (id + 1) % ps.length;

      }

      RPoint distPoint = new RPoint(ps[id]);
      distPoint.sub(pos);

      distPoint.scale(random(0.028,0.029));
      vel.scale(random(0.5,1.3));
      vel.add(distPoint);
      float sat = constrain((width-distancia)*0.25,0.001,255);
      float velnorm = constrain(vel.norm(),0,maxvel);

      sat = abs(maxvel-velnorm)/maxvel*INKCOEFF*255;
      sat = constrain(sat,0,255);
      col = color(hueval,150,255,sat*(toldist/80));
    }
  }

  public void setPos(RPoint newpos){
    lastpos = new RPoint(pos);
    pos = newpos;
  }

  // Drawing the particle
  public void draw(PGraphics gfx){
    stroke(col);
    line(lastpos.x,lastpos.y,pos.x, pos.y);
  }
}

