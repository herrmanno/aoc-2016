#!/usr/local/bin/python3
"""AoC 2016 02/01"""

def main():
    pos = (1, 1)

    num_pad = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]

    code = []

    with open("./input.txt") as input_file:
        for line in input_file:
            for char in line:
                if char == "R":
                    pos = (min(pos[0]+1, 2), pos[1])
                elif char == "L":
                    pos = (max(pos[0]-1, 0), pos[1])
                elif char == "D":
                    pos = (pos[0], min(pos[1]+1, 2))
                elif char == "U":
                    pos = (pos[0], max(pos[1]-1, 0))

            code.append(num_pad[pos[1]][pos[0]])

    codestr = "".join(str(c) for c in code)
    print("======================")
    print("The Code for the numPad is:")
    print("\t{0}".format(codestr))

if __name__ == "__main__":
    main()
