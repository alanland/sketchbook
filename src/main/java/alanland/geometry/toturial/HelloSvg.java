package alanland.geometry.toturial;

import alanland.BaseArt;
import geomerative.RG;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class HelloSvg extends BaseArt {
    private static String CLASS_NAME = HelloSvg.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape shp;

    @Override
    public void setup() {
        super.setup();
        shp = RG.loadShape("tiger.svg");
        shp.centerIn(g);
    }

    @Override
    public void draw() {
        background(255);
        translate(mouseX, mouseY);
        shp.draw();
    }
}

