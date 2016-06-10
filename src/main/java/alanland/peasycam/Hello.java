package alanland.peasycam;

import peasy.PeasyCam;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class Hello extends PeasyCamBaseArt {
    private static String CLASS_NAME = Hello.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    PeasyCam cam;

    @Override
    public void setup() {
        size(400, 400, P3D);
        cam = new PeasyCam(this, 100);
        cam.setMinimumDistance(50);
        cam.setMaximumDistance(500);
    }

    @Override
    public void draw() {
        rotateX(0.5f);
        rotateY(.5f);
        clear();
        fill(255, 0, 0);
        box(30);

        pushMatrix();
        translate(0, 0, 20);
        fill(0, 255, 0);
        box(5);
        popMatrix();

    }
}

