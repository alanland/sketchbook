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
 dibuixant
 ---------------------------------------------------------------- 
 
 */

import processing.opengl.*;
import geomerative.*;

RGroup grupo;
Particle particula;
float toldist;
float maxvel;
float maxalph;

RFont f;

//------------------------ Runtime properties ----------------------------------
// Save each frame
boolean SAVEVIDEO = false;
boolean SAVEFRAME = false;
boolean APPLICATION = true;

String DEFAULTAPPLETRENDERER = JAVA2D;
int DEFAULTAPPLETWIDTH = 680;
int DEFAULTAPPLETHEIGHT = 480;

String DEFAULTAPPLICRENDERER = OPENGL;
int DEFAULTAPPLICWIDTH = 800;
int DEFAULTAPPLICHEIGHT = 600;
//------------------------------------------------------------------------------

//------------------------ Drawing properties ----------------------------------
// Text to be drawn
String STRNG = "Caligraft";

// Font to be used
String FONT = "GenAR102.ttf"; // "LidoSTF.ttf";

// Margin from the borders
float MARGIN = 50;
//------------------------------------------------------------------------------


//------------------------- Drawer properties ----------------------------------
// The coefficient of the velocity of getting to a desired point
float MINNERVE = 0.002;
float MAXNERVE = 0.005;

// The average of mininertia and maxinertia must be under one to have good results
float MININERTIA = 0.7;
float MAXINERTIA = 1.2;

// Coefficient that handles the error of the drawing: 0 for lowest error
float DRWERRCOEFF = 1.0009;

// Coefficient that handles the variation of amount of ink for the drawing 
float INKERRCOEFF = 0.5;

// Coefficient that handles the amount of ink for the drawing
float INKCOEFF = 0.3;

// Coefficient of precision: 0 for lowest precision
float PRECCOEFF = 0.8;

// Velocity of the drawing
int VELOCIDAD = 128;
//-----------------------------------------------------------------------------


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

  background(255);

  f = new RFont(FONT,372,RFont.CENTER);
  
  initialize();
}

void draw(){
  pushMatrix();
    translate(width/2, height/2);

  for(int i=0;i<VELOCIDAD;i++){
    particula.update(grupo);
    particula.draw(g);
  }
  popMatrix();

  if(SAVEVIDEO) saveFrame(STRNG+"video-####.tga");
}

void initialize(){
  background(255);
  
  toldist = (width/80F) * DRWERRCOEFF * (10F/(STRNG.length()+1));
  maxvel = (width/190F) * constrain(INKERRCOEFF,0.01,INKERRCOEFF) * (10F/(STRNG.length()+1));
  maxalph = 255 * constrain(INKCOEFF,0,1);
  
  grupo = f.toGroup(STRNG);

  RCommand.setSegmentStep(1-constrain(PRECCOEFF,0,0.99));
  RCommand.setSegmentator(RCommand.UNIFORMSTEP);

  grupo = grupo.toPolygonGroup();
  grupo.centerIn(g, MARGIN, 1, 1);
  
  particula = new Particle(g,0);
}

void mouseDragged(){
  float distToMouse = dist(particula.pos.x,particula.pos.y,mouseX-width/2,mouseY-height/2)*0.3;
  distToMouse = constrain(distToMouse,0.001,distToMouse);
  RPoint p = new RPoint(particula.pos);
  p.add(new RPoint((mouseX-pmouseX)*random(0,0.5)/distToMouse,(mouseY-pmouseY)*random(0,0.5)/distToMouse));
  particula.setPos(p);
  particula.vel.add(new RPoint((mouseX-pmouseX)*random(0,0.5)/distToMouse,(mouseY-pmouseY)*random(0,0.5)/distToMouse));
}

void keyReleased(){
  //exit();
  //saveFrame(STRNG+"-###.tga");
  if(keyCode==ENTER){
    STRNG = newString; 
    newString = "";
    initialize();
  }else if(keyCode==BACKSPACE){
    if(newString.length() !=0 ){
      newString = newString.substring(0,newString.length()-1);
    }
  }else if(keyCode!=SHIFT){
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
  float sz;

  // ID
  int id;

  // Constructor
  public Particle(PGraphics gfx, int ident){
    pos = new RPoint(random(-gfx.width/2,gfx.width/2), random(-gfx.height/2,gfx.height/2));
    lastpos = new RPoint(pos);
    vel = new RPoint(0, 0);

    colorMode(HSB);
    sz = random(2,3);

    id = ident;
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
        if(SAVEFRAME && id==0) saveFrame(STRNG+"frame-####.tga");
      }

      RPoint distPoint = new RPoint(ps[id]);
      distPoint.sub(pos);

      distPoint.scale(random(MINNERVE,MAXNERVE));
      vel.scale(random(MININERTIA,MAXINERTIA));
      vel.add(distPoint);

      // Alpha and saturation in function of the velocity of the drawing
      float velnorm = constrain(vel.norm(),0,maxvel);
      float sat = abs(maxvel - velnorm)/maxvel*maxalph;
      col = color(0,0,1,sat);
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

