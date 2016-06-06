from block import Block

from ctrl import *


class CheckersBoard:
    def __init__(self, size, p1, p2):
        self.size = size
        self.p1 = p1
        self.p2 = p2
        self.paddingLeft = 200
        self.paddingRight = 40
        self.paddingTop = 100
        self.x1 = self.paddingLeft
        self.y1 = self.paddingTop
        self.blockSize = int(
            (width - self.paddingLeft - self.paddingRight) / self.size)

        self.x2 = self.x1 + self.blockSize * self.size
        self.y2 = self.y1 + +self.blockSize * self.size

        self.player = p1
        self.selected = None

        self.matrix = [
            [0 for col in range(self.size)] for row in range(self.size)]
        self.status = 0

        def changeStatus():
            self.status = not self.status

        for row in range(self.size):
            for col in range(self.size):
                player = None
                if row in [0, 1, 2]:
                    player = p1.clone()
                    print 1,
                elif row in [5, 6, 7]:
                    player = p2.clone()
                    print 1,
                else:
                    player = None
                    print 0,

                self.matrix[row][col] = Block(row, col, self.status, self.blockSize, player)
                changeStatus()
            print ''
            changeStatus()

    def changePlayer(self):
        if self.player == self.p1:
            self.player = self.p2
        else:
            self.player = self.p1

    def mouseInBoard(self):
        return mouseX > self.x1 and mouseX < self.x2 and mouseY > self.y1 and mouseY < self.y2

    def getMouseBlock(self):
        if self.mouseInBoard():
            return self.matrix[(mouseY - self.y1) / self.blockSize][(mouseX - self.x1) / self.blockSize]
        else:
            return None

    def mousePressed(self):
        debugBoard()
        if not self.mouseInBoard():
            print 'out'
            return
        target = self.getMouseBlock()
        if not target or not target.c:
            print 'not block'
            return
        if target.player and not self.player == target.player:
            print 'wrong player'
            return

        if self.selected:  # change select, move , each
            # blank move
            if target.player:  # change select
                self.selected.diselect()
                self.selected = target
                target.select()
            else:  # move
                res = self.selected.movePlayerTo(target)
                if res == 1:  # move success
                    self.selected = None
                    self.changePlayer()

                    # others

                    # return
                elif res == 2:
                    self.selected = None
                    self.changePlayer()

        elif target.player:  # select
            print 'choose'
            self.selected = target
            target.select()  #

    def display(self):
        with pushMatrix():
            translate(self.x1, self.y1)
            text(self.player.name,-100, 20)
            for i in range(self.size):
                for j in range(self.size):
                    self.matrix[i][j].display()


