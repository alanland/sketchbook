package alanland.geometry;

import alanland.BaseArt;
import geomerative.RG;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class GeometryBaseArt extends BaseArt {

    private static String CLASS_NAME = GeometryBaseArt.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    public static String FONT = "胡敬礼毛笔行书简.ttf";

    @Override
    public void setup() {
        super.setup();
        RG.init(this);
    }
}
