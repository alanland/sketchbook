package alanland.geometry.toturial;

import alanland.BaseArt;
import geomerative.RClosest;
import geomerative.RG;
import geomerative.RPoint;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class Closest extends BaseArt {
    private static String CLASS_NAME = Closest.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape shp;

    @Override
    public void setup() {
        super.setup();
        RG.setPolygonizer(RG.ADAPTATIVE);
        shp = RG.loadShape("Toucan.svg");
        shp.centerIn(g);
        RG.ignoreStyles();
    }

    @Override
    public void draw() {
        background(0X2D4D83);
        translate(width / 2, height / 2);

        noFill();
        stroke(255);

        shp.draw();
        RShape line = RG.getLine(-width / 2, -height / 2, mouseX - width / 2, mouseY - height / 2);
        line.draw();

        fill(0, 200);
        noStroke();

        RClosest c = shp.getClosest(line);
        RPoint[] ps = c.distance > 0 ? c.closest : c.intersects;
        if (ps != null) {
            for (RPoint p : ps) {
                ellipse(p.x, p.y, 10, 10);
            }
        }

    }
}

