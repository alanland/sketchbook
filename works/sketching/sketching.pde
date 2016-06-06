/*

 ----------------------------------------------------------------
 Copyright (C) 2005 Ricard Marxer Pi??n
 
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
 sketching
 ----------------------------------------------------------------
 
 */

//import processing.opengl.*;
import geomerative.*;

RFont f;
RGroup grp;
RShape s;

float len;
float angle;
float pos;

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


// The error range for the tangent position and angle
float ANGLEERROR = 0.3;
float POINTERROR = 0;


// The length variation of the tangnet
//   -> 500: sketchy, blueprint
//   -> 150: light blueprint
//   -> 2000: mystic
float LENGTHTANGENT = 30;

// The initial text
String STRNG = "Tangent";

String FONT = "GenAR102.ttf"; // "FreeSerif.ttf";

// The alpha value of the lines
int ALPHAVALUE = 2;

// The velocity of the calligraphy
int VELOCITY = 10;

int MARGIN = 50;

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
  background(255);
  frameRate(25);
  
  LENGTHTANGENT = LENGTHTANGENT * width/800F;
  
  try{
    smooth();
  }catch(Exception e){}
  
  noFill();
  stroke(10, 20, 170, ALPHAVALUE);

  f = new RFont(FONT, 372, RFont.CENTER);

  initialize();
}

void draw(){
  pushMatrix();
  translate(width/2,height/2);
  // Draw very low alpha and long tangents on random points of each letters
  for(int i=0;i<grp.countElements();i++){
    s = (RShape)(grp.elements[i]);

    for(int j=0;j<s.countChildren();j++){
      for(int k=0;k<VELOCITY;k++){
        pos = random(0, 1);

        RPoint tg = s.children[j].getTangent(pos);
        RPoint p = s.children[j].getTangent(pos);

        p.x = p.x + random(-POINTERROR,POINTERROR);
        p.y = p.y + random(-POINTERROR,POINTERROR);

        len = random(-LENGTHTANGENT, LENGTHTANGENT);
        angle = atan2(tg.y, tg.x) + random(-ANGLEERROR, ANGLEERROR);

        //colour = palette[(int)random(0,palette.length-1)];
        //stroke(red(colour),green(colour),blue(colour),2);
        line(p.x, p.y, p.x + len*cos(angle), p.y + len*sin(angle));
      }
    }
  }
  popMatrix();
  if(SAVEVIDEO) saveFrame("filesvideo/sketching-####.tga");
}

void initialize(){
  grp = f.toGroup(STRNG);
  grp.centerIn(g,MARGIN,1,1);
  
  background(255);
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
