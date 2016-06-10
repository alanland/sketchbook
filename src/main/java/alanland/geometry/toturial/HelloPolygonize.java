package alanland.geometry.toturial;

import alanland.geometry.GeometryBaseArt;
import geomerative.RG;
import geomerative.RShape;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class HelloPolygonize extends GeometryBaseArt {
    private static String CLASS_NAME = HelloPolygonize.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    RShape shp;
    RShape polyshp;

    @Override
    public void setup() {
        super.setup();
        shp = RG.loadShape("lion.svg");
        shp.centerIn(g, 100);
    }

    @Override
    public void draw() {
        background(255);

        float pointSeparation = map(constrain(mouseX, 100, width - 100), 100, width - 100, 5, 100);

        RG.setPolygonizer(RG.UNIFORMLENGTH);
        RG.setPolygonizerLength(pointSeparation);

        polyshp = RG.polygonize(shp);
        translate(mouseX, mouseY);
        polyshp.draw();
//        RG.shape(shp, 200, 200);
    }
}

