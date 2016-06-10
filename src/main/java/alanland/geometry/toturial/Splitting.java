package alanland.geometry.toturial;

import alanland.geometry.GeometryBaseArt;
import geomerative.RCommand;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class Splitting extends GeometryBaseArt {
    private static String CLASS_NAME = Splitting.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RCommand curva = new RCommand(0, 0, -200, -200, 200, -200, 0, -100);
    RCommand[] piezas = new RCommand[2];

    @Override
    public void setup() {
        super.setup();
    }

    @Override
    public void draw() {
        translate(width / 2, height / 2);
        clear();
        piezas = curva.split(map(mouseX, 0, width, 0, 1));

        noFill();
        stroke(0, 100);
        curva.draw();

        stroke(255, 0, 0);
        piezas[0].draw();
        ellipse(piezas[0].endPoint.x, piezas[0].endPoint.y, 10, 10);

        stroke(0, 255, 0);
        piezas[1].draw();
        ellipse(piezas[1].endPoint.x, piezas[1].endPoint.y, 10, 10);
    }
}

