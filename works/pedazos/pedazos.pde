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
 pedazos
 ----------------------------------------------------------------
 
 */

//import processing.opengl.*;
import geomerative.*;

RFont f;
String STRNG[] = {"SATOR","AREPO","TENET","OPERA","ROTAS"};
//String STRNG[] = {"sator","arepo","tenet","opera","rotas"};
//String STRNG[] = {"999","996","966","969","696","996","966","666"};
//String STRNG[] = {"A","I"};
float SMOOTHNESS = 0.2;

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

String FONT = "GenAR102.ttf"; //  "FreeSans.ttf";

int MARGIN = 100;

float angle = 0;
int lngth;
int strind = 0;

boolean saved = false;

RPolygon polys[];
RPolygon polysnext[];
RPolygon pinter[];
RPolygon pdiff[];
RPolygon pdiffinv[];

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
  try{
    smooth();
  }catch(Exception e){}

  frameRate(24);
  background(255);
  if(r==P3D)
    ortho(-width/2,width/2,-height/2,height/2,-100,100);

  f = new RFont(FONT,372, RFont.CENTER);

  lngth = STRNG[strind].length();

  polys = new RPolygon[lngth];
  polysnext = new RPolygon[lngth];
  pinter = new RPolygon[lngth];
  pdiff = new RPolygon[lngth];
  pdiffinv = new RPolygon[lngth];

  int strindnext = (strind + 1) % STRNG.length;
  for(int i=0;i<lngth;i++){
    polys[i] = f.toShape(STRNG[strind].charAt(i)).toPolygon();
    polysnext[i] = f.toShape(STRNG[strindnext].charAt(i)).toPolygon();

    polys[i].centerIn(g,MARGIN,1,1);
    polysnext[i].centerIn(g,MARGIN,1,1);
  }

  strind = strindnext;

  for(int ip=0;ip<lngth;ip++){
    pinter[ip] = polys[ip].intersection(polysnext[ip]);
    pdiff[ip] = polys[ip].diff(polysnext[ip]);
    pdiffinv[ip] = polysnext[ip].diff(polys[ip]);
  }
}

void draw(){
  noStroke();
  fill(255);
  rect(0,0, width, height);
  translate(0, height/2);
  background(255);

  fill(0);
  stroke(0);

  for(int i=0;i<lngth;i++)
  {
    pushMatrix();

    float scl = 1/float(lngth);
    float trans = i*(width/lngth) + width/(lngth*2);

    translate(trans, 0);
    scale(scl);
    if(angle<=PI+HALF_PI){
      pushMatrix();
      rotateY(angle);
      pdiff[i].draw(g);
      popMatrix();

      pushMatrix();
      rotateX(angle);
      pinter[i].draw(g);
      popMatrix();
    }
    else{
      pushMatrix();
      rotateY(angle);
      pdiffinv[i].draw(g);
      popMatrix();

      pushMatrix();
      rotateX(angle);
      pinter[i].draw(g);
      popMatrix();
    }
    popMatrix();
  }

  if(angle<=HALF_PI){
    angle += angle*SMOOTHNESS+0.001;
  }
  else if(angle<=PI){
    angle += (PI-angle)*SMOOTHNESS+0.001;
  }
  else if(angle<=PI+HALF_PI){
    if(!saved){
     if(SAVEFRAME) saveFrame(STRNG[0]+"-"+STRNG[1]+".tga");
     saved = true;
    }
    angle += (angle-PI)*SMOOTHNESS+0.001;
  }
  else if(angle<=TWO_PI){
    if(saved){
      saved = false;
    }
    angle += (TWO_PI-angle)*SMOOTHNESS+0.001;
  }
  else if(angle>=TWO_PI){
    angle = 0;
    int strindnext = (strind + 1) % STRNG.length;
    for(int i=0;i<lngth;i++){
      polys[i] = f.toShape(STRNG[strind].charAt(i)).toPolygon();
      polysnext[i] = f.toShape(STRNG[strindnext].charAt(i)).toPolygon();

      polys[i].centerIn(g,MARGIN,1,1);
      polysnext[i].centerIn(g,MARGIN,1,1);
    }

    strind = strindnext;

    for(int ip=0;ip<lngth;ip++){
      pinter[ip] = polys[ip].intersection(polysnext[ip]);
      pdiff[ip] = polys[ip].diff(polysnext[ip]);
      pdiffinv[ip] = polysnext[ip].diff(polys[ip]);
    }
  }

  if(SAVEVIDEO) saveFrame("filesvideo/pedazos-####.tga");
}

void keyPressed(){
   saveFrame("pedazos-####.tga");
}
