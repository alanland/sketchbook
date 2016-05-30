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
    row2 = int(b1.row+1 + b1.row+1)/2
    col2 = int(b1.col + b2.col)/2
    print 'mid row:', row2
    print 'mid col:', col2
    return getBlock(row2, col2)

def debugBoard():
    global game
    m = game.board.matrix
    for row in range(8):
        for col in range(8):
            if m[row][col].player:
                print 1,
            else:
                print 0,
        print
    print
    print


