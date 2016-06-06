from board import CheckersBoard
from ctrl import *
from game import Game
from player import Player

p1 = Player(True, loadImage('a1.png'), loadImage('a2.png'))
p2 = Player(False, loadImage('b1.png'), loadImage('b2.png'))


def setup():
    size(600, 600)
    textSize(12)
    # noStroke()
    textMode(CENTER)
    global board
    board = CheckersBoard(8, p1, p2)
    game = Game(board)
    setGame(game)


def draw():
    clear()
    board.display()


def mouseClicked(e):
    board.mousePressed()
