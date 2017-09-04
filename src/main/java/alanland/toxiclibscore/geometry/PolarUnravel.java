package alanland.toxiclibscore.geometry;

import alanland.BaseArt;
import processing.core.PApplet;
import toxi.geom.Line2D;
import toxi.geom.Vec2D;
import toxi.processing.ToxiclibsSupport;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class PolarUnravel extends BaseArt {

    private static String CLASS_NAME = PolarUnravel.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    ToxiclibsSupport gfx;

    @Override
    public void setup() {
        size(800, 800);
        smooth();
        stroke(255);
        textSize(22);
        noFill();
        gfx = new ToxiclibsSupport(this);
    }

    @Override
    public void draw() {
        background(255);
        Line2D l = new Line2D(new Vec2D(200, 50), new Vec2D(500, 500));
        Line2D m = new Line2D(new Vec2D(500, 100), new Vec2D(mouseX, mouseY));
        Line2D.LineIntersection isec = l.intersectLine(m);
        if (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING) {
            stroke(200, 0, 0);
            fill(0,200,0);
            Vec2D pos = isec.getPos();
            ellipse(pos.x, pos.y, 10, 10);
            textAlign(pos.x > width / 2 ? RIGHT : LEFT);
            text(pos.toString(), pos.x, pos.y-10);
        } else {
            stroke(0);
        }
        gfx.line(l);
        gfx.line(m);
    }
}
