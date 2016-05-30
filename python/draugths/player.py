class Player:
    def __init__(self, first, img1, img2):
        self.first = first
        self.img1 = img1
        self.img2 = img2
        self.king = 0
        if self.first:
            self.name='A'
        else:
            self.name='B'

    def display(self, x, y, size):
        if self.king:
            image(self.img2, x, y, size, size)
        else:
            image(self.img1, x, y, size, size)

    def __repr__(self):
        return 'player '+self.name