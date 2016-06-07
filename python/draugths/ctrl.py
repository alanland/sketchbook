game = None
board = None


def getGame():
    global game
    return game


def setGame(g):
    global game
    game = g


def getBoard():
    global game
    return game.board


def getBlock(row, col):
    global game
    return game.board.matrix[row][col]


def getBlockBetween(b1, b2):
    row2 = min(b1.row, b2.row) + 1
    col2 = min(b1.col, b2.col) + 1
    return getBlock(row2, col2)


def debugBoard():
    pass

