from ctrl import *


class Block:
    ColorA = color(102, 204, 0)  # hold chees
    ColorB = color(204, 102, 0)
    ColorSelected = color(0, 0, 255)

    def __init__(self, row, col, c, size, player=None):
        self.row = row
        self.col = col
        self.x = col * size
        self.y = row * size
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
        """
        0 move fail
        1 move success
        2 eat success
        :param target:
        :return:
        """
        print 'try move: ', self.row, self.col, target.row, target.col
        if self.player:
            row = 1
            if not self.player.first:  # player 1 or 2
                row = -1

            if self.player.king:
                if abs(target.row - self.row) == 1 and abs(target.col - self.col) == 1: # move
                    target.player = self.player
                    self.player = None
                    self.diselect()
                    target.checkKing()
                    return 1
                if abs(target.row - self.row) == 2 and abs(target.col - self.col) == 2: # eat
                    mid = getBlockBetween(self, target)
                    debugBoard()
                    print 'size 2'
                    print 'self: ', self
                    print 'mid : ', mid
                    print 'tgt : ', target
                    print mid.player.first
                    if mid.player and mid.player.first != self.player.first:  # can eat
                        print 'can eat'
                        mid.player = None
                        target.player = self.player
                        self.player = None
                        self.diselect()
                        target.checkKing()
                        # todo continus eat
                        return 2
                pass
            else:
                print 'not king'
                if target.row == self.row + row and abs(target.col - self.col) == 1:  # move
                    print 'size 1'
                    target.player = self.player
                    self.player = None
                    self.diselect()
                    target.checkKing()
                    return 1
                if target.row == self.row + row * 2 and abs(target.col - self.col) == 2:  # eat
                    mid = getBlockBetween(self, target)
                    debugBoard()
                    print 'size 2'
                    print 'self: ', self
                    print 'mid : ', mid
                    print 'tgt : ', target
                    print mid.player.first
                    if mid.player and mid.player.first != self.player.first:  # can eat
                        print 'can eat'
                        mid.player = None
                        target.player = self.player
                        self.player = None
                        self.diselect()
                        target.checkKing()
                        # todo continus eat
                        return 2
        return 0

    def __repr__(self):
        if self.player:
            p = self.player.name
        else:
            p = '-'
        return 'row %s, col %s, player %s' % (self.row, self.col, p)

    def checkKing(self):
        if self.player.first:
            if self.row == 7:
                self.player.king = 1
        else:
            if self.row == 0:
                self.player.king = 1