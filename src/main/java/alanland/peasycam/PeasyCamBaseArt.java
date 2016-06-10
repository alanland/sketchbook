package alanland.peasycam;

import alanland.BaseArt;
import processing.core.PApplet;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class PeasyCamBaseArt extends BaseArt {

    private static String CLASS_NAME = PeasyCamBaseArt.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    public static String FONT = "胡敬礼毛笔行书简.ttf";

    @Override
    public void setup() {
        super.setup();
    }
}
