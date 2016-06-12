package alanland.toxiclibscore.geometry;

import alanland.BaseArt;
import processing.core.PApplet;
import toxi.geom.Circle;
import toxi.geom.Line2D;
import toxi.geom.Ray2D;
import toxi.geom.Vec2D;
import toxi.processing.ToxiclibsSupport;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class CircleTangentPoint extends BaseArt {

    private static String CLASS_NAME = CircleTangentPoint.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    ToxiclibsSupport gfx;
    Circle c;


    @Override
    public void setup() {
        size(800, 800);
        smooth();
        stroke(255);
        noFill();
        gfx = new ToxiclibsSupport(this);
        c = new Circle(width / 2, height / 2, 200);
    }

    @Override
    public void draw() {
        background(0);
        gfx.ellipse(c);

        Vec2D p = new Vec2D(mouseX, mouseY);
        if (mousePressed) {
            c.setRadius(p.distanceTo(c));
        }

        Line2D l = new Line2D(p, c);
        gfx.line(p, c);

        Vec2D[] isec = c.getTangentPoints(p);
        if (isec != null) {
            for (Vec2D pc : isec) {
                gfx.ellipse(new Circle(pc, 5));
                gfx.line(c, pc);
                gfx.line(p, pc);
                gfx.ray(new Ray2D(p, pc.sub(p)), 1000);
            }
        }

        gfx.ellipse(new Circle(l.getMidPoint(), l.getLength() / 2));

        gfx.ray(new Ray2D(p, new Vec2D(100, 100).sub(p)), 1000);
        gfx.circle(new Vec2D(100, 100), 10);
    }
}
