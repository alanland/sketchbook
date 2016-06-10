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
public class GetPointPaths extends GeometryBaseArt {
    private static String CLASS_NAME = GetPointPaths.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape grp;


    @Override
    public void setup() {
        super.setup();
        smooth();
        grp = RG.loadShape("bot1.svg");
        grp.centerIn(g, 100, 1, 1);
    }

    @Override
    public void draw() {
        translate(width / 2, height / 2);

        float xmag = mouseX / (float) (width) * TWO_PI;
        float ymag = mouseY / (float) (height) * TWO_PI;
        rotateX(xmag);
        rotateY(ymag);

        background(0);
        stroke(255);
        noFill();

        float z = 11 * sin(frameCount / 20f * PI);
        float zz = abs(z) * 2 - z;
        drawShape(zz);
    }

    void drawShape(float zz) {
        for (RShape shp : grp.children) {
            translate(0, 0, zz);
            stroke(105);
            beginShape();
            for (RPoint p : shp.getPoints()) {
                vertex(p.x, p.y);
            }
            endShape();
        }
    }
}

