
from CheckersBoard import CheckersBoard,Block,Player


p1 = Player(True,loadImage('a1.png'),loadImage('a2.png'))
p2 = Player(False,loadImage('b1.png'),loadImage('b2.png'))

def setup():
    size(600, 700)
    textSize(12)
    # noStroke()
    textMode(CENTER)
    global board
    board = CheckersBoard(8, p1, p2)
    
def draw():
    clear()   
    text(str(mouseX)+'    '+str(mouseY),10,10)
    board.display()


def mouseClicked(e):
    board.mousePressed()
    
