game = None


def getGame():
    global game
    return game


def setGame(g):
    global game
    game = g
    print 'set game', game
