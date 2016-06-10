package alanland.geometry.toturial;

import alanland.BaseArt;
import geomerative.RG;
import geomerative.RShape;
import processing.core.PApplet;

import java.awt.event.MouseEvent;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class SplittingShapes extends BaseArt {
    private static String CLASS_NAME = SplittingShapes.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape shp;
    int index;

    @Override
    public void setup() {
        super.setup();

        shp = RG.loadShape("bot1.svg");
        RG.centerIn(shp, g);
    }

    @Override
    public void draw() {
        translate(width / 2, height / 2);
        background(0x2D4D83);

        noFill();
        stroke(255);
        float splitPos = map(mouseX, 0, width, 0, 1);
        RShape[] splitShps = shp.split(splitPos);
        splitShps[index].draw();
    }

    @Override
    public void mousePressed(MouseEvent e) {
        super.mousePressed(e);
        index = (index + 1) % 2;
    }
}

