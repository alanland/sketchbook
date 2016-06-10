package alanland.geometry.toturial;

import alanland.geometry.GeometryBaseArt;
import geomerative.RG;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class HelloIgnoreStyle extends GeometryBaseArt {
    private static String CLASS_NAME = HelloIgnoreStyle.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape shp;
    RShape polyshp;

    @Override
    public void setup() {
        super.setup();
        shp = RG.loadShape("Toucan.svg");
        shp.centerIn(g);
    }

    @Override
    public void draw() {
        background(255);

        translate(width / 2, height / 2);

        float pointSeparation = map(constrain(mouseX, 100, width - 100), 100, width - 100, 5, 200);

        RG.setPolygonizer(RG.UNIFORMLENGTH);
        RG.setPolygonizerLength(pointSeparation);

        polyshp = RG.polygonize(shp);

        RG.ignoreStyles(false);
        polyshp.draw();

        RG.ignoreStyles();
        noFill();
        stroke(0, 80);
        shp.draw();
    }
}

