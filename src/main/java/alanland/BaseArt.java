package alanland;

import processing.core.PApplet;

import java.awt.event.KeyEvent;

/**
 * @author 王成义
 * @version 6/9/16
 */
public class BaseArt extends PApplet {

    private static String CLASS_NAME = BaseArt.class.getName();

    public static void main(String[] args) {
        PApplet.main(new String[]{CLASS_NAME});
    }

    @Override
    public void setup() {
        size(1000, 800, OPENGL);
        frameRate(20);
        background(255);
        fill(255, 102, 0);
        stroke(0);
        smooth();
    }

    @Override
    public void keyReleased(KeyEvent e) {
        if (key == 's') {
            saveFrame(getClass().getSimpleName() + ".png");
        }
    }
}
