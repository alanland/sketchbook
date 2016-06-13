package alanland.toxiclibscore.geometry;

import alanland.BaseArt;
import processing.core.PApplet;
import toxi.geom.AABB;
import toxi.geom.Line3D;
import toxi.geom.Vec3D;
import toxi.geom.mesh.WETriangleMesh;
import toxi.geom.mesh.WingedEdge;
import toxi.processing.ToxiclibsSupport;

import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.List;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class DashedDottedBox extends BaseArt {

    private static String CLASS_NAME = DashedDottedBox.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    ToxiclibsSupport gfx;

    List<Line3D> edges = new ArrayList<>();
    float step = 5;
    float phase;
    boolean isDashed = false;

    @Override
    public void setup() {
        size(800, 800, P3D);
        gfx = new ToxiclibsSupport(this);

        smooth();
        WETriangleMesh box = new WETriangleMesh();
        box.addMesh(new AABB(new Vec3D(), 100).toMesh());

//        edges.addAll(box.edges.values().stream()
//                .filter(e -> e.getDirection().isMajorAxis(0.01f))
//                .collect(Collectors.toList()));

        for (WingedEdge e : box.edges.values()) {
            if (e.getDirection().isMajorAxis(0.01f)) {
                edges.add(e);
            }
        }
    }

    @Override
    public void draw() {
        background(0);
        translate(width / 2, height / 2, 0);
        rotateX(mouseY * 0.01f);
        rotateY(mouseX * 0.01f);
        stroke(255);
        phase = (phase + 0.05f) % 1;
        for (Line3D l : edges) {
            if (isDashed) {
                drawDashed(l, phase);
            } else {
                drawDotted(l, phase);
            }
        }
    }

    void drawDashed(Line3D l, float phase) {
        l = new Line3D(l.a.add(l.getDirection().normalizeTo(phase * step)), l.b);
        List<Vec3D> points = l.splitIntoSegments(null, step, true);
        for (int i = 0, num = points.size() - 1; i < num; i += 2) {
            Vec3D p = points.get(i);
            Vec3D q = points.get(i + 1);
            gfx.line(p, q);
        }
    }

    void drawDotted(Line3D l, float phase) {
        l = new Line3D(l.a.add(l.getDirection().normalizeTo(phase * step)), l.b);
        for (Vec3D p : l.splitIntoSegments(null, step, true)) {
            gfx.point(p);
        }
    }

    @Override
    public void mouseClicked(MouseEvent e) {
        isDashed = !isDashed;
    }
}
