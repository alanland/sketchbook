class CheckersBoard:

    def __init__(self, size, p1, p2):
        self.size = size
        self.p1 = p1
        self.p2 = p2
        self.paddingLeft = 100
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

        for i in range(self.size):
            for j in range(self.size):
                player = None
                if j in [0, 1, 2]:
                    player = p1
                elif j in [5, 6, 7]:
                    player = p2
                else:
                    player = None

                self.matrix[i][j] = Block(
                    i, j, self.status, self.blockSize, player)
                changeStatus()
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
            return self.matrix[(mouseX - self.x1) / self.blockSize][(mouseY - self.y1) / self.blockSize]
        else:
            return None

    def mousePressed(self):
        if not self.mouseInBoard():
            return
        target = self.getMouseBlock()
        if not target or not target.c:
            print 'not block'
            return
        if target.player and not self.player == target.player:
            print 'wrong player'
            return

        if self.selected:
            print 'move'
            # blank move
            if target.player:
                self.selected.diselect()
                self.selected = target
                target.select()
            else:
                res = self.selected.movePlayerTo(target)
                if res:
                    self.selected = None
                    self.changePlayer()
                #                 block.player = self.selected.player
                #                 self.selected.player = None
                #                 self.selected.diselect()
                #                 self.selected = None

                # others

                # return

        elif target.player:
            print 'choose'
            self.selected = target
            target.select()  #

    def display(self):
        with pushMatrix():
            translate(self.x1, self.y1)
            for i in range(self.size):
                for j in range(self.size):
                    self.matrix[i][j].display()


class Block:
    ColorA = color(102, 204, 0)  # hold chees
    ColorB = color(204, 102, 0)
    ColorSelected = color(0, 0, 255)

    def __init__(self, x, y, c, size, player=None):
        self.col = x
        self.row = y
        self.x = x * size
        self.y = y * size
        self.c = c
        self.size = size
        if not c:
            player = None
        self.player = player
        self.selected = 0

    def display(self):
        rectMode(CORNER)
        stroke(2)
        if self.c:
            fill(Block.ColorA)
        else:
            fill(Block.ColorB)
        if self.selected:
            fill(Block.ColorSelected)
        rect(self.x, self.y, self.size, self.size)
        if self.player:
            self.player.display(self.x, self.y, self.size)

    def select(self):
        self.selected = 1

    def diselect(self):
        self.selected = 0

    def movePlayerTo(self, target):
        if self.player:
            row = 1
            if not self.player.first:
                row = -1
            if self.player.king:
                # todo
                pass
            else:
                if target.row == self.row + row and abs(target.col - self.col) == 1:
                    target.player = self.player
                    self.player = None
                    self.diselect()
                    return 1
                
        return 0


class Player:

    def __init__(self, first, img1, img2):
        self.first = first
        self.img1 = img1
        self.img2 = img2
        self.king = 0

    def display(self, x, y, size):
        if self.king:
            image(self.img2, x, y, size, size)
        else:
            image(self.img1, x, y, size, size)

