# sketch_20150616

from mine import random_mine
rows = 1
cols = 1
count = 1
mines = random_mine(rows, cols, count)
gameover = 0  # o: gaming, -1,win, 1: over
msg = {1: 'Game Over...', -1: 'Win ...'}
choices = {
    (0, 0): [4, 4, 2, '难度1'],
    (0, 1): [5, 5, 6, '难度2'],
    (0, 2): [6, 6, 10, '难度3'],
    (1, 0): [8, 8, 20, '难度4'],
    (1, 1): [10, 10, 40, '难度5'],
    (1, 2): [10, 10, 60, '难度6'],
    (2, 0): [15, 15, 60, '巨难1'],
    (2, 1): [15, 15, 100, '巨难2'],
    (2, 2): [20, 20, 300, '巨难3']
}
status = 0
marked = []

def setup():
    size(600, 700)
    textSize(12)
    noStroke()
    textMode(CENTER)

def draw():
    global status
    background(255)
    if status == 0:
        draw0()
    else:
        draw1()

def draw0():
    ellipseMode(CENTER)
    padding = 100
    textSize(40)
    text('Degree Select', 160, 70)
    for _x in range(3):
        for _y in range(3):
            s = (width - padding * 2) / 3
            x = _x * s + padding + s / 2
            y = _y * s + padding + s / 2
            fill(_x * 80, _y * 80, 0, 50)
            if dist(mouseX, mouseY, x, y) < 50:
                ellipse(x, y, 120, 120)
            ellipse(x, y, 100, 100)

def draw1():
    global rows, cols, count
    for _x in range(cols):
        for _y in range(rows):
            x = _x * (width - 5) / cols
            y = _y * (height - 105) / rows
            fill(map(_y, 0, cols, 180, 40))
            if(mines[_y][_x] >= 10):
                fill(220)
            elif marked.__contains__((_x, _y)):
                fill(0, 255, 0)
            rect(x + 2, y + 2, (width - 5) / cols - 4,
                 (height - 105) / rows - 4)
            if(mines[_y][_x] >= 10):
                fill(0)
                text(mines[_y][_x] %
                     10, x + width / cols / 2 - 3, y + (height - 105) / rows / 2)
            if mines[_y][_x] == -2:
                fill(255, 0, 0)
                rect(
                    x + 2, y + 2, (width - 5) / cols - 4, (height - 105) / rows - 4)
    if gameover != 0:
        textSize(36)
        fill(0)
        text(msg[gameover], 200, 200)
    textSize(30)
    fill(0, 55, 99, 200)
    text('%s rows, %s columns, %s mines' % (rows, cols, count), 50, 640)
    textSize(12)

def mouseClicked(e):
    if status == 0:
        mouseClicked0(e)
    else:
        mouseClicked1(e)

def mouseClicked0(e):
    global choices, mines, status, rows, cols, count
    padding = 100
    for _x in range(3):
        for _y in range(3):
            s = (width - padding * 2) / 3
            x = _x * s + padding + s / 2
            y = _y * s + padding + s / 2
            if dist(mouseX, mouseY, x, y) < 100:
                define = choices.get((_x, _y))
                rows = define[0]
                cols = define[1]
                count = define[2]
                mines = random_mine(rows, cols, count)
                status = 1
                draw1()
                return

def mouseClicked1(e):
    global gameover, marked
    if gameover:
        return
    _x = mouseX / ((width - 5) / cols)
    _y = mouseY / ((height - 105) / rows)
    if e.getButton() == 37:
        if mines[_y][_x] == -1:
            mines[_y][_x] = -2
            gameover = 1  # over
        else:
            mines[_y][_x] += 10
    elif e.getButton() == 39:
        marked.append((_x, _y))
    # check win
    notWine = False
    for _x in range(cols):
        for _y in range(rows):
            if mines[_y][_x] >= 0 and mines[_y][_x] < 9:
                return
            elif mines[_y][_x] == -2:
                return
            elif mines[_y][_x] == -1 and not marked.__contains__((_x, _y)):
                return
    gameover = -1

