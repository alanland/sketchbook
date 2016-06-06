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
    # print 'get mid: %s%s,%s%s = %s%s:' % (b1.row, b1.col, b2.row, b2.col, row2, col2)
    return getBlock(row2, col2)


def debugBoard():
    pass


def pirntBoard():
    global game
    print random(1)
    m = game.board.matrix
    for row in range(8):
        for col in range(8):
            if m[row][col].player:
                if m[row][col].player.first:
                    print 'A',
                else:
                    print 'B',
            else:
                print ' ',
        print
    print
    print
