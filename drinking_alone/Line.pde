
class Line {
    // 起点坐标1
    PVector pb1;
    // 起点坐标2
    PVector pb2;
    // 当前坐标1
    PVector p1;
    // 当前坐标2
    PVector p2;
    // 终点坐标1
    PVector pe1;
    // 终点坐标2
    PVector pe2;

    // 1点已移动到位置
    boolean endX1;
    boolean endY1;
    // 1点已移动到位置
    boolean endX2;
    boolean endY2;
    // 开始移动
    boolean begined;
    // 结束移动
    boolean finished;

    // 直线下落速度，数值越大下落越快
    float easing = 0.1;

    Line(PVector p1, PVector p2, PVector pe1, PVector pe2) {
        endX1 = false;
        endY1 = false;
        endX2 = false;
        endY2 = false;
        begined = false;
        finished = false;
        this.pb1 = new PVector(p1.x, p1.y);
        this.pb2 = new PVector(p2.x, p2.y);
        this.p1 = p1;
        this.p2 = p2;
        this.pe1 = pe1;
        this.pe2 = pe2;
    }

    // 重新设置属性，让直线重新从起点运行到终点，
    void reset() {
        endX1 = false;
        endY1 = false;
        endX2 = false;
        endY2 = false;
        begined = false;
        finished = false;
        this.p1 = new PVector(pb1.x, pb1.y);
        this.p2 = new PVector(pb2.x, pb2.y);
    }

    // 开始移动
    void begin() {
        this.begined = true;
    }

    // 更新直线位置
    void update() {
        if (!endX1) p1.x += (pe1.x - p1.x) * easing;
        if (!endY1) p1.y += (pe1.y - p1.y) * easing;
        if (!endX2) p2.x += (pe2.x - p2.x) * easing;
        if (!endY2) p2.y += (pe2.y - p2.y) * easing;
    }

    // 检查是否已经移动结束
    void checkEnd() {
        if (PApplet.dist(p1.x, p1.y, pe1.x, pe1.y) < 1) {
            endX1 = true;
            endY1 = true;
            p1 = pe1;
        }
        if (PApplet.dist(p2.x, p2.y, pe2.x, pe2.y) < 1) {
            endX2 = true;
            endY2 = true;
            p2 = pe2;
        }
        // 如果已经结束，那么完成
        if (endX1 && endY1 && endX2 && endY2) {
            finished = true;
        }
    }

    // 显示
    void display() {
        line(p1.x, p1.y, p2.x, p2.y);
    }

    // 如果开始移动，那么更新坐标位置，检查，然后画线
    void draw() {
        if (begined) {
            update();
            checkEnd();
            display();
        }
    }

}

