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
 
 Created 14 November 2006
 
 ----------------------------------------------------------------
 lettree
 ----------------------------------------------------------------
 
 */

import processing.core.*;
import geomerative.*;

public class LetterSet {
  public Letter[] letters;
  private int[] degree;
  
  private RFont f;
  private int fontSize;
  private PApplet prnt;
  
  private int growMode = FURTHESTFROMFIRST;

  private float minFactor=344F;
  private float maxFactor=43F;
  private float angleTol=0.4F;
  
  public final static int DEPTH = 0;
  public final static int BREADTH = 1;
  public final static int FURTHESTFROMFIRST = 2;
  public final static int CLOSESTTOMOUSE = 3;
  

  public LetterSet(PApplet parent, String fontPath, int fontSz, float mnFactor, float mxFactor, float anglTol){
    prnt = parent;
    f = new RFont(fontPath, fontSz, RFont.CENTER);
    fontSize = fontSz;
    minFactor = mnFactor;
    maxFactor = mxFactor;
    angleTol = anglTol;
  }
  
  public LetterSet(PApplet parent, String fontPath, int fontSz){
    this(parent, fontPath, fontSz, 0F, 0.05F, 0.4F);
  }
  
  public int countLetters(){
    if(letters==null) return 0;
    return letters.length;
  }
  
  private Letter getLetter(char c){
    return new Letter(f.toShape(c),fontSize,c,minFactor,maxFactor,angleTol);
  }
  
  public void addChar(char c){
    Letter l = getLetter(c);
    if(l.countSerifs()>0){
      switch(growMode){
      case DEPTH:
	addDepthFirst(l);
	break;
      case BREADTH:
	addBreadthFirst(l);
	break;
      case FURTHESTFROMFIRST:
	addFurthestFromFirst(l);
	break;
      case CLOSESTTOMOUSE:
	addClosestToMouse(l);
	break;
      }
    }
  }
  
  public void removeChar(){
    int numLetters = countLetters();
    if(countLetters()>0){
    	Letter removingl = letters[letters.length-1];
    	removeLastLetter();
    	
    	for (int i=0; i<removingl.countSerifs(); i++){
    		if(!removingl.serifs[i].isEmpty()){
    		  Serif stayingsrf = removingl.serifs[i].connected;
    		  Letter stayingl = stayingsrf.parent;
    		  stayingsrf.state = Serif.EMPTY;
    		  stayingsrf.connected = null;
    		  
    		  removingl = null;
    		  break;
    		}
    	}
    }
  }
  
  private void addBreadthFirst(Letter l) {
    int numLetters = countLetters();
    int parentDegree=0;
    
    if(numLetters!=0){
      int minDegree = Integer.MAX_VALUE;
      int numFreeLetter = 0;
      for (int i=0; i<numLetters; i++) {
	int nSerifs = letters[i].countEmptySerifs();
	if (nSerifs > 0 && minDegree>=degree[i]) {
	  if(minDegree == degree[i]){
	    numFreeLetter++;
	  }else{
	    numFreeLetter = 1;
	    minDegree = degree[i];
	  }
	}
      }
      
      int randmFreeLetter = (int)round(random(1,numFreeLetter));
      int countFreeLetter = 0;
      for(int i=0;i<numLetters;i++){
	if(letters[i].countEmptySerifs()>0){
		countFreeLetter++;
		if(countFreeLetter==randmFreeLetter){
		  letters[i].attatchLetter(l);
		  parentDegree = degree[i];
		  break;
		}
	}
      }
    }
    
    addLetter(l);
    addDegree(parentDegree+1);
  }
  
  private void addDepthFirst(Letter l) {
    int numLetters = countLetters();
    int parentDegree=0;
    
    if(numLetters!=0){
      int maxDegree = Integer.MIN_VALUE;
      int numFreeLetter = 0;
      for (int i=0; i<numLetters; i++) {
	int nSerifs = letters[i].countEmptySerifs();
	if (nSerifs > 0 && maxDegree>=degree[i]) {
	  if(maxDegree == degree[i]){
	    numFreeLetter++;
	  }else{
	    numFreeLetter = 1;
	    maxDegree = degree[i];
	  }
	}
      }
      
      int randmFreeLetter = (int)round(random(1,numFreeLetter));
      int countFreeLetter = 0;
      for(int i=0;i<numLetters;i++){
	if(letters[i].countEmptySerifs()>0){
	    countFreeLetter++;
	    if(countFreeLetter==randmFreeLetter){
		letters[i].attatchLetter(l);
		parentDegree = degree[i];
		break;
	    }
	}
      }
    }
    
    addLetter(l);
    addDegree(parentDegree+1);
  }
  
  private void addFurthestFromFirst(Letter l) {
    int numLetters = countLetters();
    int parentDegree=0;
    
    if(numLetters!=0){
      Letter parentLetter = letters[0];
      int indSerif = 0;
      RPoint centerp = new RPoint(letters[0].shape.getCenter());
      float maxDist = Float.MIN_VALUE;
      for (int i=0; i<numLetters; i++) {
	Letter let = letters[i];
	if (let.countEmptySerifs() > 0) {
	  for(int j=0;j<let.countSerifs();j++) {
	    Serif srf = let.serifs[j];
	    if(srf.isEmpty()){
	      float px = (srf.startp.x + srf.endp.x)/2;
	      float py = (srf.startp.y + srf.endp.y)/2;
	      float dst = dist(px,py,centerp.x,centerp.y);
	      if(dst>maxDist){
		maxDist = dst;
		parentLetter = letters[i];
		parentDegree = degree[i];
		indSerif = j;
	      }
	    }
	  }
	}
      }
      
      parentLetter.attatchLetter(l,indSerif);
    }
    
    addLetter(l);
    addDegree(parentDegree+1);
  }
  
  public void addClosestToMouse(Letter l) {
    int numLetters = countLetters();
    int parentDegree=0;
    
    int indi=0, indj=0;
    float inddst=0;
    
    if(numLetters!=0){
      Letter parentLetter = letters[0];
      int parentSerif = 0;
      RPoint centerp = new RPoint((float)prnt.mouseX-(float)prnt.width/2F,(float)prnt.mouseY-(float)prnt.height/2F);
      float minDist = Float.MAX_VALUE;
      for (int i=0; i<numLetters; i++) {
	Letter let = letters[i];
	int numSerifs = let.countSerifs();
	if (let.countEmptySerifs() > 0) {
	  for(int j=0;j<let.countSerifs();j++) {
	    Serif srf = let.serifs[j];
	    if(srf.isEmpty()){
	      float px = (srf.startp.x + srf.endp.x)/2F;
	      float py = (srf.startp.y + srf.endp.y)/2F;
	      float dst = dist(px,py,centerp.x,centerp.y);
	      if(dst<minDist){
		minDist = dst;
		parentLetter = letters[i];
		parentDegree = degree[i];
		parentSerif = i;
		inddst = dst;
		indi = i;
		indj = j;
	      }
	    }
	  }
	}
      }
      
      parentLetter.attatchLetter(letters[indi]);
    }
    
    addLetter(l);
    addDegree(parentDegree+1);
  }

  public void drawEmptySerifs(PGraphics g){
    int numLetters = countLetters();
    if(numLetters!=0){
      for (int i=0; i<numLetters; i++) {
	Letter let = letters[i];
	if (let.countEmptySerifs() > 0) {
	  for(int j=0;j<let.countSerifs();j++) {
	    Serif srf = let.serifs[j];
	    if(srf.isEmpty()){
	      float px = (srf.startp.x + srf.endp.x)/2;
	      float py = (srf.startp.y + srf.endp.y)/2;
	      float angle = atan2(srf.endp.x-srf.startp.x,srf.endp.y-srf.startp.y)+(float)Math.PI;
	      g.stroke(0,0,255);
	      g.line(srf.startp.x,srf.startp.y,srf.startp.x-10F*(float)Math.cos(angle),srf.startp.y+10F*(float)Math.sin(angle));
	      g.line(srf.endp.x,srf.endp.y,srf.endp.x-10F*(float)Math.cos(angle),srf.endp.y+10F*(float)Math.sin(angle));
	      g.stroke(255,0,0);
	      g.line(px,py,px-10F*(float)Math.cos(angle),py+10F*(float)Math.sin(angle));
	    }
	  }
	}
      }
    }
  }

  public RGroup toGroup(){
    RGroup result = new RGroup();
    for(int i=0;i<countLetters();i++){
      result.addElement(new RShape(letters[i].shape));
    }
    return result;
  }
  
  private void addLetter(Letter nextletter){
    Letter[] newletters;
    if(letters==null){
      newletters = new Letter[1];
      newletters[0] = nextletter;
    }else{
      newletters = new Letter[letters.length+1];
      System.arraycopy(letters,0,newletters,0,letters.length);
      newletters[letters.length]=nextletter;
    }
    letters = newletters; 
  }
  
  private void removeLastLetter(){
    Letter[] newletters=null;
    if(letters!=null){
    	if(letters.length>1){
      		newletters = new Letter[letters.length-1];
      		System.arraycopy(letters,0,newletters,0,letters.length-1);
      	}
    }
    letters = newletters; 
  }
  
  private void addDegree(int nextdegree){
    int[] newdegrees;
    if(degree==null){
      newdegrees = new int[1];
      newdegrees[0] = nextdegree;
    }else{
      newdegrees = new int[degree.length+1];
      System.arraycopy(degree,0,newdegrees,0,degree.length);
      newdegrees[degree.length]=nextdegree;
    }
    degree = newdegrees; 
  }

  private static float dist(float x1, float y1, float x2, float y2){
	float difx = x2-x1;
	float dify = y2-y1;
	return (float)Math.sqrt(difx*difx + dify*dify);
  }

  private static float atan2(float x, float y){
	return (float)Math.atan2(x,y);
  }

  private static float random(float min, float max){
	return (float)((max-min)*Math.random()+min);
  }

  private static float round(float a){
	return (float)Math.round(a);
  }
}
