/*

 ----------------------------------------------------------------
 Copyright (C) 2005 Ricard Marxer Piñón
 
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
 
 Created 14 November 2006
 
 ----------------------------------------------------------------
 lettree
 ----------------------------------------------------------------
 
 */
 
//import processing.opengl.*;
import geomerative.*;

RGroup grp;
LetterSet ls;
RMatrix transf;
RPoint centerlast;
RContour clast;
RFont f;
boolean start = true;


//------------------------ Runtime properties ----------------------------------
// Save each frame
boolean SAVE = false;
boolean APPLICATION = false;

String DEFAULTAPPLETRENDERER = P3D;
int DEFAULTAPPLETWIDTH = 680;
int DEFAULTAPPLETHEIGHT = 480;

String DEFAULTAPPLICRENDERER = OPENGL;
int DEFAULTAPPLICWIDTH = 800;
int DEFAULTAPPLICHEIGHT = 600;
//------------------------------------------------------------------------------

// The minFraction and maxFraction are found empirically in order to discriminize the serifs

//---------------- FreeSerif -----------------------
float MINFRACTION = 0.000290697674F;
float MAXFRACTION = 0.044265814F;
float ANGLETOL = 0.5F;
//--------------------------------------------------

//---------------- LidoSTF -------------------------
/*
float MINFRACTION = 0.01390697674F;
float MAXFRACTION = 0.044265814F;
float ANGLETOL = 0.5F;
*/
//--------------------------------------------------

String FONT = "FreeSerif.ttf";
int FONTSIZE = 372;

// The smoothness of the movement following the letters
float MOVEMENTSMOOTHNESS = 6;
float t=0;
boolean rotation = false;

void setup(){
  
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
  background(0);
  framerate(25);
  fill(255);
  stroke(255);
  try{
    smooth();
  }catch(Exception e){}

  RCommand.setSegmentator(RCommand.ADAPTATIVE);
  ls = new LetterSet(this,FONT,FONTSIZE,MINFRACTION,MAXFRACTION,ANGLETOL);
  f = new RFont(this,FONT,372,RFont.CENTER);
  grp = new RGroup();
}

void draw(){
  background(0);
  translate(width/2,height/2);
  background(0);
  
  try{
    if(rotation){
      rotateY(PI/175*t);
      rotateX(PI/138*t);
      t++;
    }
  }catch(Exception e){}

  if(start){
    RGroup texto = f.toGroup("click and type...");
    texto.centerIn(g,min(width/3,height/2),1,1);
    texto.draw(g);
  }

  if(grp.countElements()>0){
    start = false;
    if(mousePressed){

      RPoint trns = new RPoint(mouseX-width/2,mouseY-height/2);

      transf = new RMatrix();
      transf.translate(-trns.x/MOVEMENTSMOOTHNESS,-trns.y/MOVEMENTSMOOTHNESS);
      transf.scale(1.04);

      grp.transform(transf);

    }
    else{
      RContour c = grp.getBounds();
      float scl = min((width-width/5)/abs(c.points[0].x-c.points[2].x),(height-height/5)/abs(c.points[0].y-c.points[2].y));
      RPoint trns = grp.getCenter();

      transf = new RMatrix();
      transf.scale(1+(scl-1)/MOVEMENTSMOOTHNESS);
      transf.translate(-trns.x/MOVEMENTSMOOTHNESS,-trns.y/MOVEMENTSMOOTHNESS);

      grp.transform(transf);
    }
  }

  grp.draw(g);
  
  if(SAVE) saveFrame("filesvideo/lettree-####.tga");
}

void keyPressed(){
  if(keyCode == ENTER){
    rotation = !rotation;
  }
  else if(keyCode == CONTROL){
    saveFrame("lettree-##.tga");
  }
  else if(key == ' '){
    ls = new LetterSet(this,FONT,FONTSIZE,MINFRACTION,MAXFRACTION,ANGLETOL); 
    ls.addChar(key);
    grp = ls.toGroup();
    grp.transform(transf);
  }
  else if(keyCode == 8){
    ls.removeChar();

    if(grp.countElements()>0){

      RContour cold = grp.getBounds();
      RPoint centerold = grp.getCenter();

      grp = ls.toGroup();

      RContour cnew = grp.getBounds();
      RPoint centernew = grp.getCenter();

      float scl = max(abs(cold.points[0].x-cold.points[2].x)/abs(clast.points[0].x-clast.points[2].x),abs(cold.points[0].y-cold.points[2].y)/abs(clast.points[0].y-clast.points[2].y));

      RMatrix mtx = new RMatrix();
      mtx.translate(-centerold.x,-centerold.y);
      mtx.scale(scl);
      mtx.translate(-centernew.x,-centernew.y);

      grp.transform(mtx);

      clast = new RContour(cnew);
      centerlast = new RPoint(centernew);
    }
    else{
      grp = ls.toGroup();
      clast = grp.getBounds();
      centerlast = grp.getCenter();
    }
  }
  else{
    try{

      ls.addChar(key);

      if(grp.countElements()>0){

        RContour cold = grp.getBounds();
        RPoint centerold = grp.getCenter();

        grp = ls.toGroup();

        RContour cnew = grp.getBounds();
        RPoint centernew = grp.getCenter();

        float scl = max(abs(cold.points[0].x-cold.points[2].x)/abs(clast.points[0].x-clast.points[2].x),abs(cold.points[0].y-cold.points[2].y)/abs(clast.points[0].y-clast.points[2].y));

        RMatrix mtx = new RMatrix();
        mtx.translate(-centerold.x,-centerold.y);
        mtx.scale(scl);
        mtx.translate(-centernew.x,-centernew.y);

        grp.transform(mtx);

        clast = new RContour(cnew);
        centerlast = new RPoint(centernew);
      }
      else{
        grp = ls.toGroup();
        clast = grp.getBounds();
        centerlast = grp.getCenter();
      }

    }
    catch(Exception e){
      ls = new LetterSet(this,FONT,FONTSIZE,MINFRACTION,MAXFRACTION,ANGLETOL); 
      ls.addChar(key);
      grp = ls.toGroup();
      grp.transform(transf);
    }
  }
}
