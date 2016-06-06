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

  Created 12 November 2006

 ----------------------------------------------------------------
  pyrographie
 ----------------------------------------------------------------

*/

import processing.opengl.*;
import geomerative.*;

RFont f;
RGroup grupo;
Particle[] psys;
int numPoints;
int ballsize;
float segLength;

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

// Text to be written
String STRNG = "partycular";

// Font to be used
String FONT = "GenAR102.ttf"; // "Lacuna.ttf";

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
  }catch(Exception e){}
  background(0);
  
  f = new RFont(FONT,372,RFont.CENTER);

  initialize();
}

void draw(){
  translate(width/2, height/2);
  noStroke();
  int val = 25;
  if(keyCode==CONTROL) val=5;
  fill(0, val);
  rect(-width/2, -height/2, width, height); 

  for(int i=0;i<numPoints;i++){
    psys[i].update(grupo);
    psys[i].draw(g);
  }
  
  if(SAVEVIDEO) saveFrame("pyrographie-####.tga");
}


void initialize(){
  grupo = f.toGroup(STRNG);
  
  ballsize = ceil(width/400F);
  segLength = width/200F*((constrain(STRNG.length(),1,STRNG.length())));
  
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  RCommand.setSegmentLength(segLength);
  
  
  grupo = grupo.toPolygonGroup();
  grupo.centerIn(g, 50, 1, 1);
  
  RPoint[] ps = grupo.getPoints();
  if(ps != null){
    numPoints = ps.length;
  
    psys = new Particle[numPoints];
    for(int i=0;i<numPoints;i++){
      psys[i] = new Particle(g,i);
      psys[i].vel.add(new RPoint(random(-50,50),random(-50,50)));
    }
  }
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

void mouseDragged(){
  for(int i=0;i<numPoints;i++){
    float distToMouse = dist(psys[i].pos.x,psys[i].pos.y,mouseX-width/2,mouseY-height/2)*0.1;
    distToMouse = constrain(distToMouse,0.001,distToMouse);
    psys[i].pos.add(new RPoint((mouseX-pmouseX)*random(0,0.5)/distToMouse/2,(mouseY-pmouseY)*random(0,0.5)/distToMouse/2));
    psys[i].vel.add(new RPoint((mouseX-pmouseX)*random(0,0.5)/distToMouse/2,(mouseY-pmouseY)*random(0,0.5)/distToMouse/2));
  }
}


public class Particle{
  // Velocity
  RPoint vel;
  
  // Position
  RPoint pos;
  
  // Caracteristics
  int col;
  float sz;
  
  // ID
  int id;
  
  // Constructor
  public Particle(PGraphics gfx, int ident){
    pos = new RPoint(random(-gfx.width/2,gfx.width/2), random(-gfx.height/2,gfx.height/2));
    vel = new RPoint(0, 0);
    
    colorMode(HSB);
    col = color(random(0,255),random(100,255),255);
    sz = random(ballsize,ballsize+1);
    
    id = ident;
  }
  
  // Updater of position, velocity and colour depending on a RGroup
  public void update(RGroup grp){
    pos.add(vel);
    RPoint[] ps = grp.getPoints();
    if(ps != null){
      RPoint distPoint = new RPoint(ps[id]);
      distPoint.sub(pos);
      
      distPoint.scale(random(0.002,0.005));
      vel.scale(random(0.8,1.1));
      vel.add(distPoint);
    }
  }
  
  // Drawing the particle
  public void draw(PGraphics gfx){
    fill(col);
    noStroke();
    ellipse(pos.x, pos.y, sz, sz);
  }
  
  RPoint[] getClosests(RPoint[] ps, int num){
    return new RPoint[num];
    
  }
}

