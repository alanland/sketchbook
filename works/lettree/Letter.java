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

import processing.core.*;
import geomerative.*;

public class Letter{
  public Serif[] serifs;
  public RShape shape;
  public char chr;

  private float minFactor;
  private float maxFactor;
  private float angleTol = 0.4F;
  
  public Letter(RShape s, int fontSize, char c, float mnFactor, float mxFactor, float anglTol){
    this.shape = s;
    this.minFactor = mnFactor;
    this.maxFactor = mxFactor;
    this.angleTol = anglTol;
    this.findSerifs(fontSize);
    this.chr = c;
  }
  
  public Letter(RShape s, int fontSize, float mnFactor, float mxFactor, float anglTol){
    shape = s;
    minFactor = mnFactor;
    maxFactor = mxFactor;
    angleTol = anglTol;
    findSerifs(fontSize);
  }
  
  public Letter(){
    shape = null;
    serifs = null;
  }
  
  public Letter(Letter l){
    shape = new RShape(l.shape);
    for(int i=0; i<l.countSerifs(); i++){
      addSerif(new Serif(this,l.serifs[i]));
    }
    minFactor = l.minFactor;
    maxFactor = l.maxFactor;
  }
 
  public void findSerifs(int fontSize){
    if(shape!=null){
      if(shape.subshapes!=null){
	for(int j=0;j<shape.countSubshapes();j++){
	  int numCommands = shape.subshapes[j].countCommands();
	  for(int i=0;i<numCommands;i++){
	    RCommand c = shape.subshapes[j].commands[i];
	    if(c.getCommandType() == RCommand.LINETO){

	      // Take the previous and next point to the line and check that it really is a serif
	      // by checking the parallelism of the tangents to starting and ending points
	      int previ = (i - 1 + numCommands)%numCommands;
	      int nexti = (i + 1)%numCommands;
	      RCommand cbef = shape.subshapes[j].commands[previ];
	      RCommand caft = shape.subshapes[j].commands[nexti];

	      RPoint beforep = cbef.getCurveTangent(1F);
	      RPoint afterp = caft.getCurveTangent(0F);
	      
	      /*
	      RPoint beforep = cbef.startPoint;
	      RPoint afterp = caft.endPoint;
	      if(cbef.controlPoints != null){
	        beforep = cbef.controlPoints[cbef.controlPoints.length-1];
	      }
	      if(caft.controlPoints != null){
	        afterp = caft.controlPoints[0];
	      }
	      */
	      
	      // Take the start and end points of the line of the serif
	      RPoint startp = c.startPoint;
	      RPoint endp = c.endPoint;
	      
	      RPoint line = new RPoint(endp);
	      line.sub(startp);
	      
	      // For it to be a serif we need:	      
	      // The length to be under a certain maximum
	      float len = dist(startp.x,startp.y,endp.x,endp.y);

	      // The tangents to be close to parallel
	      float anglebeforepline = beforep.angle(line);
	      float anglelineafterp = line.angle(afterp);
	      
	      float PI_HALF = (float)Math.PI / 2F;

	      // Pass the tests to see if its a serif
	      if(len>(float)fontSize*minFactor && len<(float)fontSize*maxFactor){
                if(((float)Math.abs(anglebeforepline - PI_HALF) < angleTol && (float)Math.abs(anglelineafterp - PI_HALF) < angleTol) || (float)Math.abs((anglebeforepline + anglelineafterp) - (float)Math.PI) < angleTol)
		{
		  Serif srf = new Serif(this,startp,endp);
		  addSerif(srf);
		}
	     }
	   }
	 }
        }
      }
    }
  }
  
  public int countSerifs(){
    if(serifs==null) return 0;
    return serifs.length;
  }
  
  public int countEmptySerifs(){
    int numEmptySerifs = 0;
    for(int i=0;i<countSerifs();i++){
      if(serifs[i].isEmpty()) numEmptySerifs++;
    }
    return numEmptySerifs;
  }
  
  public int getEmptySerif(){
    int numEmptySerifs = countEmptySerifs();
    int indice = 0;
    if(numEmptySerifs > 0){
      // Find a random empty serif
      float rand = random(1,numEmptySerifs);
      int randmFreeSerif = (int)round(rand);
      int countFreeSerif = 0;
      for(int i=0;i<countSerifs();i++){
	if(serifs[i].isEmpty()) {
	       countFreeSerif++;
	       if(countFreeSerif==randmFreeSerif) {
		       indice = i;
		       break;
	       }
        }
      }
    }else{
      throw new RuntimeException("No more empty serifs.");
    }
    return indice;
  }
  
  public void attatchLetter(Letter l, int indSerif) throws RuntimeException{
    if(indSerif<0 || indSerif>countSerifs()-1){
        throw new RuntimeException("Index of serif out of bounds");
    }
    if(!serifs[indSerif].isEmpty()){
        throw new RuntimeException("Serif chosen is not empty");
    }
    Serif srfparent = serifs[indSerif];
    int indSrfChild = l.getEmptySerif();
    Serif srfchild = l.serifs[indSrfChild];
    
    
    srfparent.attatchSerif(srfchild);
  }
  
  public void attatchLetter(Letter l){
    Serif srfparent = serifs[getEmptySerif()];
    Serif srfchild = l.serifs[l.getEmptySerif()];
    
    srfparent.attatchSerif(srfchild);
  }
  
  public void transform(RMatrix mtx){
    shape.transform(mtx);
  }
  
  private void addSerif(Serif nextSerif){
    Serif[] newserifs;
    if(serifs==null){
      newserifs = new Serif[1];
      newserifs[0] = nextSerif;
    }else{
      newserifs = new Serif[serifs.length+1];
      System.arraycopy(serifs,0,newserifs,0,serifs.length);
      newserifs[serifs.length]=nextSerif;
    }
    this.serifs = newserifs; 
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
