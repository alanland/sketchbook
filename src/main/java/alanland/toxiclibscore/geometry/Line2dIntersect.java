package alanland.toxiclibscore.geometry;

import alanland.BaseArt;
import processing.core.PApplet;
import toxi.geom.Circle;
import toxi.geom.Vec2D;
import toxi.math.waves.AbstractWave;
import toxi.math.waves.SineWave;
import toxi.processing.ToxiclibsSupport;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class Line2dIntersect extends BaseArt {

    private static String CLASS_NAME = Line2dIntersect.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    ToxiclibsSupport gfx;
    AbstractWave wave1 = new SineWave(0, 0.02f, 100, 200);
    AbstractWave wave2 = new SineWave(0, 0.023f, 100, 200);


    @Override
    public void setup() {
        size(800, 800);
        smooth();
        stroke(255);
        noFill();
        gfx = new ToxiclibsSupport(this);
    }

    @Override
    public void draw() {
        background(0);
        Vec2D p1 = new Vec2D(200, wave1.update());
        Vec2D p2 = new Vec2D(400, wave2.update());
        Vec2D p3 = new Vec2D(mouseX, mouseY);
        Circle circle = Circle.from3Points(p1, p2, p3);
        if (circle != null) {
            gfx.ellipse(circle);
            gfx.circle(p1, 10);
            gfx.circle(p2, 10);
            gfx.circle(p3, 10);
        }
        Circle c2 = Circle.from2Points(p1, p2);
        stroke(200);
        gfx.ellipse(c2);
    }
}
