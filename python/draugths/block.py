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
        """
        0 move fail
        1 move success
        2 eat success
        :param target:
        :return:
        """
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

