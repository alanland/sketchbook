from block import Block

from ctrl import *


class CheckersBoard:
    def __init__(self, size, p1, p2):
        self.size = size
        self.p1 = p1
        self.p2 = p2
        self.paddingLeft = 0
        self.paddingRight = 0
        self.paddingTop = 0
        self.needChange = 0
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
                elif row in [5, 6, 7]:
                    player = p2.clone()
                else:
                    player = None

                self.matrix[row][col] = Block(row, col, self.status, self.blockSize, player)
                changeStatus()
            changeStatus()

    def changePlayer(self):
        if self.player == self.p1:
            self.player = self.p2
        else:
            self.player = self.p1
        self.needChange = 0
        self.checkCanEat()
        if self.needChange:
            self.needChange = 0
            self.changePlayer()

    def mouseInBoard(self):
        return mouseX > self.x1 and mouseX < self.x2 and mouseY > self.y1 and mouseY < self.y2

    def getMouseBlock(self):
        if self.mouseInBoard():
            return self.matrix[(mouseY - self.y1) / self.blockSize][(mouseX - self.x1) / self.blockSize]
        else:
            return None

    def mousePressed(self):
        self.doCheckWin()
        debugBoard()
        if not self.mouseInBoard():
            return
        target = self.getMouseBlock()
        if not target or not target.c:
            return
        if target.player and not self.player == target.player:
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
                    self.checkCanEat()
                    self.changePlayer()

        elif target.player:  # select
            self.selected = target
            target.select()  #

    def display(self):
        with pushMatrix():
            translate(self.x1, self.y1)
            for i in range(self.size):
                for j in range(self.size):
                    self.matrix[i][j].display()

    def checkCanEat(self):
        canEat = self.canEatByPlayer(self.player)
        if canEat:
            self.needChange = 1
            res = canEat[0].movePlayerTo(canEat[2])
            if res == 2:
                return self.checkCanEat()
        return 0

    def canEatByPlayer(self, player):
        for i in range(self.size):
            for j in range(self.size):
                b = self.matrix[i][j]
                if b.player and b.player.first == player.first:
                    canEat = self.canEatByBlock(b)
                    if canEat:
                        return canEat
        return 0

    def canEatByBlock(self, block):
        forward = [(1, 1), (1, -1)]
        if block.player and not block.player.first:
            forward = [(-1, 1), (-1, -1)]
        if block.player.king:
            forward = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
        r = block.row
        c = block.col
        for s in forward:
            if (r + s[0] * 2) in range(0, self.size) and (c + s[1] * 2) in range(0, self.size):
                target = self.matrix[r + s[0] * 2][c + s[1] * 2]
                mid = self.matrix[r + s[0]][c + s[1]]
                if (target and not target.player) and mid and mid.player and mid.player.first != block.player.first:
                    return (block, mid, target)
        return 0

    def checkWin(self):
        res = self.doCheckWin()
        if res[0]:
            with pushMatrix():
                translate(self.x1, self.y1)
                imageMode(CENTER)
                image(res[1].img1, self.blockSize * self.size / 2, self.blockSize * self.size / 2, 300, 300)
                noLoop()

    def doCheckWin(self):
        count1 = 0
        count2 = 0
        for i in range(self.size):
            for j in range(self.size):
                b = self.matrix[i][j]
                if b.player:
                    if b.player.first:
                        count1 += 1
                    else:
                        count2 += 1
        if count1 == 0:
            return 1, self.p2
        if count2 == 0:
            return 1, self.p1
        return 0,
