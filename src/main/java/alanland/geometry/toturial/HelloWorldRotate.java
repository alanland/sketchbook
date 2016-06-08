package alanland.geometry.toturial;

import alanland.BaseArt;
import geomerative.RFont;
import geomerative.RG;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class HelloWorldRotate extends BaseArt {

    private static String CLASS_NAME = HelloWorldRotate.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RFont f;
    RShape grp;

    @Override
    public void setup() {
        super.setup();

        grp = RG.getText("Hello", FONT, 200, CENTER);
    }

    @Override
    public void draw() {
        background(255);
        translate(width / 2, height / 2);
        grp.children[0].rotate(PI / 20, grp.children[0].getCenter());
        grp.draw();
    }
}
