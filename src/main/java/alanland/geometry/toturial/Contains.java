package alanland.geometry.toturial;

import alanland.geometry.GeometryBaseArt;
import geomerative.RG;
import geomerative.RPoint;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class Contains extends GeometryBaseArt {
    private static String CLASS_NAME = Contains.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape grp;

    @Override
    public void setup() {
        super.setup();
        smooth();
        grp = RG.loadShape("Toucan.svg");
        grp.centerIn(g);
    }

    @Override
    public void draw() {
        background(0X2D4D83);
        noFill();
        stroke(255);
        translate(width / 2, height / 2);
        RG.ignoreStyles();
        grp.draw();
        RPoint p = new RPoint(mouseX - width / 2, mouseY - height / 2);
        for (RShape shp : grp.children) {
            if (shp.contains(p)) {
                stroke(0);
                fill(0);
                strokeWeight(3);
                shp.draw();
            }
        }
    }
}

