import random

def random_mine(rows, cols, n):
    res = [([0] * cols) for i in range(rows)]
    count = 0
    rate = float(n) / (rows * cols)
    while count < n:
        for _row in res:
            for i in range(cols):
                if random.random() < rate and count < n:
                    _row[i] = -1
                    count += 1
    for y in range(rows):
        for x in range(cols):
            if res[y][x] >= 0 and x > 0 and y > 0 and res[y - 1][x - 1] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and x > 0 and res[y][x - 1] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and y > 0 and res[y - 1][x] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and x < cols - 1 and y < rows - 1 and res[y + 1][x + 1] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and x < cols - 1 and res[y][x + 1] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and y < rows - 1 and res[y + 1][x] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and x > 0 and y < rows - 1 and res[y + 1][x - 1] == -1:
                res[y][x] += 1
            if res[y][x] >= 0 and x < cols - 1 and y > 0 and res[y - 1][x + 1] == -1:
                res[y][x] += 1
    return res
