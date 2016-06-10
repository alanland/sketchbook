package alanland.toxiclibscore.geometry;

import alanland.BaseArt;
import processing.core.PApplet;
import toxi.geom.Vec2D;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class ArcPolarCoordinates extends BaseArt {

    private static String CLASS_NAME = ArcPolarCoordinates.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    float theta = 0;
    float innerRadius = 150;
    float outerRadius = 180;
    int numSteps = 10;

    @Override
    public void setup() {
        size(800, 800);
    }

    @Override
    public void draw() {
        background(20);
        translate(width / 2, height / 2);

        // x=radius, y=angle
        Vec2D mousePos = new Vec2D(mouseX, mouseY).sub(width / 2, height / 2).toPolar();
        if (abs(theta - mousePos.y) > PI) {
            if (theta > mousePos.y) {
                theta -= TWO_PI;
            } else {
                mousePos.y -= TWO_PI;
            }
        }

        theta += (mousePos.y - theta) * abs(mousePos.y - theta) * 0.2;
        theta %= TWO_PI;

        noStroke();
        beginShape(TRIANGLE_STRIP);
        Vec2D p = new Vec2D();
        for (float i = 0, t = theta - PI * 0.25f; i < numSteps; i++) {
            p.set(1, t).toCartesian();
            vertex(p.x * innerRadius, p.y * innerRadius);
            vertex(p.x * outerRadius, p.y * outerRadius);
            t += HALF_PI / numSteps;
        }
        endShape();

        mousePos.toCartesian();
        stroke(255, 0, 0);
        line(0, 0, mousePos.x, mousePos.y);
        Vec2D arcPos = new Vec2D(innerRadius, theta).toCartesian();
        stroke(0, 0, 255);
        line(0, 0, arcPos.x, arcPos.y);

    }
}
