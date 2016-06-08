package alanland.geometry.toturial;

import alanland.BaseArt;
import geomerative.RFont;
import geomerative.RG;
import geomerative.RPoint;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class HelloWorldPoints extends BaseArt {
    private static String CLASS_NAME = HelloWorldPoints.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RFont f;
    RShape grp;
    RPoint[] points;

    @Override
    public void setup() {
        super.setup();
        grp = RG.getText("Hello", FONT, 200, CENTER);
    }

    @Override
    public void draw() {
        background(255);
        translate(width / 2, height / 2);

        noFill();
        stroke(0, 0, 200, 150);
        RG.setPolygonizer(RG.ADAPTATIVE);
        grp.draw();

        RG.setPolygonizer(RG.UNIFORMLENGTH);
        RG.setPolygonizerLength(map(mouseY, 0, height, 10, 200));
        points = grp.getPoints();

        if (points != null) {
            noFill();
            stroke(0, 200, 0);
            beginShape();
            for (RPoint point : points) {
                vertex(point.x, point.y);
            }
            endShape();

            fill(0);
            stroke(0);
            for (RPoint point : points) {
                ellipse(point.x, point.y, 5, 5);
            }
        }


    }
}
