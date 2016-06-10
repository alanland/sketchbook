package alanland.geometry.toturial;

import alanland.geometry.GeometryBaseArt;
import geomerative.RClosest;
import geomerative.RCommand;
import geomerative.RPoint;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class ClosestCommand extends GeometryBaseArt {
    private static String CLASS_NAME = ClosestCommand.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RCommand line1;
    RCommand line2;

    @Override
    public void setup() {
        super.setup();
        smooth();
        line1 = new RCommand(0, 0, 200, 300);
    }

    @Override
    public void draw() {
        background(0X2D4D83);
        noFill();
        stroke(255);
        line2 = new RCommand(width, 0, mouseX, mouseY);
        smooth();
        line1.draw();
        line2.draw();
        RClosest c = line1.closestPoints(line2);
        RPoint[] ps = c.distance > 0 ? c.closest : c.intersects;
        if (ps != null) {
            for (RPoint p : ps) {
                ellipse(p.x, p.y, 10, 10);
            }
        }
    }
}

