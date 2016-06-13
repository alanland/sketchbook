package alanland.toxiclibscore.geometry;

import alanland.BaseArt;
import processing.core.PApplet;
import toxi.geom.Circle;
import toxi.geom.Line2D;
import toxi.geom.Rect;
import toxi.geom.Vec2D;
import toxi.processing.ToxiclibsSupport;

import java.awt.event.MouseEvent;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class LennyExplorer extends BaseArt {

    private static String CLASS_NAME = LennyExplorer.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    ToxiclibsSupport gfx;
    Path p;

    @Override
    public void setup() {
        size(800, 800, P3D);
        gfx = new ToxiclibsSupport(this);

        frameRate(100);
        smooth();
        p = new Path(new CircleBoundary(new Circle(width / 2, height / 2, 200)), 10, 0.03f, 300);
    }

    @Override
    public void draw() {
        background(255);
        for (int i = 0; i < 50; i++) {
            p.grow();
        }
        p.render();
    }


    @Override
    public void mouseClicked(MouseEvent e) {

    }

    interface BoundaryCheck {
        boolean containsPoint(Vec2D p);

        Vec2D getCentroid();
    }

    class RectBoundary implements BoundaryCheck {
        Rect rect;

        public RectBoundary(Rect r) {
            rect = r;
        }

        @Override
        public boolean containsPoint(Vec2D p) {
            return rect.containsPoint(p);
        }

        @Override
        public Vec2D getCentroid() {
            return rect.getCentroid();
        }
    }

    class CircleBoundary implements BoundaryCheck {

        Circle circle;

        public CircleBoundary(Circle c) {
            circle = c;
        }

        @Override
        public boolean containsPoint(Vec2D p) {
            return circle.containsPoint(p);
        }

        @Override
        public Vec2D getCentroid() {
            return circle;
        }
    }

    class Path {
        Vec2D[] p;
        Vec2D last;
        BoundaryCheck bounds;
        Line2D a, b;
        Line2D.LineIntersection cut;
        float theta = 0;
        float delta;
        float speed;
        int numSearches;

        public Path(BoundaryCheck bounds, float speed, float delta, int history) {
            this.bounds = bounds;
            this.speed = speed;
            this.delta = delta;
            p = new Vec2D[history];
            a = new Line2D(new Vec2D(), new Vec2D());
            b = new Line2D(new Vec2D(), new Vec2D());
            for (int i = 0; i < p.length; i++) {
                p[i] = bounds.getCentroid().copy();
            }
            last = p[0].copy();
        }

        void grow() {
            if (random(1) < 0.1) {
                delta = random(-1, 1) * 0.2f;
            }
            if (!isIntersecting()) {
                move();
            } else {
                search();
            }
        }

        void move() {
            for (int i = p.length - 1; i > 0; i--) {
                p[i].set(p[i - 1]);
            }
            last.set(p[0]);
            theta += delta;
            p[0] = last.add(new Vec2D(speed, theta).toCartesian());
            numSearches = 0;
        }

        void search() {
            theta += delta;
            p[0] = last.add(new Vec2D(speed, theta).toCartesian());
            numSearches++;
        }

        void render() {
            beginShape();
            for (Vec2D pp : p) {
                curveVertex(pp.x, pp.y);
            }
            endShape();
        }

        boolean isIntersecting() {
            if (!bounds.containsPoint(p[0])) {
                return true;
            }
            if (numSearches < 100) {
                a.set(p[0], p[1]);
                for (int i = 3; i < p.length; i++) {
                    b.set(p[i], p[i - 1]);
                    cut = a.intersectLine(b);
                    if (cut.getType() == Line2D.LineIntersection.Type.INTERSECTING) {
                        return true;
                    }
                }
            }
            return false;
        }
    }

}

