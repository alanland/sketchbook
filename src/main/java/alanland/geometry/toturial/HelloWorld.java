package alanland.geometry.toturial;

import alanland.BaseArt;
import geomerative.RG;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/8/16
 */
public class HelloWorld extends BaseArt {

    private static String CLASS_NAME = HelloWorld.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape grp;

    @Override
    public void setup() {
        super.setup();
        grp = RG.getText("Hello", FONT, 256, CENTER);
    }

    @Override
    public void draw() {
        background(255);
        translate(width / 2, height / 2);
        grp.draw();
    }
}