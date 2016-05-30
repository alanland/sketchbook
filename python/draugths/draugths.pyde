
from board import CheckersBoard
from block import Block
from player import Player
from game import Game
from ctrl import *

p1 = Player(True,loadImage('a1.png'),loadImage('a2.png'))
p2 = Player(False,loadImage('b1.png'),loadImage('b2.png'))



def setup():
    size(600, 700)
    textSize(12)
    # noStroke()
    textMode(CENTER)
    global board
    board = CheckersBoard(8, p1, p2)
    game = Game(board)
    setBoard(board)
    setGame(game)

    
    
def draw():
    clear()   
    board.display()


def mouseClicked(e):
    board.mousePressed()
    
