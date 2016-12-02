#!/usr/local/bin/python3
"""AoC 2016 02/01"""

import os

def main():
    pos = (0, 2)

    num_pad = [
        [None, None, "1", None, None],
        [None, "2", "3", "4", None],
        ["5", "6", "7", "8", "9"],
        [None, "A", "B", "C", None],
        [None, None, "D", None, None]
    ]

    code = []

    script_dir = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(script_dir, "input.txt")
    with open(file_path) as input_file:
        for line in input_file:
            for char in line:
                if char == "R":
                    if pos[0]+1 < len(num_pad[pos[1]]) and num_pad[pos[1]][pos[0]+1] is not None:
                        pos = (pos[0]+1, pos[1])
                elif char == "L":
                    if pos[0] > 0 and num_pad[pos[1]][pos[0]-1] is not None:
                        pos = (pos[0]-1, pos[1])
                elif char == "D":
                    if pos[1] < 4 and num_pad[pos[1]+1][pos[0]] is not None:
                        pos = (pos[0], pos[1]+1)
                elif char == "U":
                    if pos[1] > 0 and num_pad[pos[1]-1][pos[0]] is not None:
                        pos = (pos[0], pos[1]-1)

            code.append(num_pad[pos[1]][pos[0]])

    codestr = "".join(str(c) for c in code)
    print("======================")
    print("The Code for the numPad is:")
    print("\t{0}".format(codestr))

if __name__ == "__main__":
    main()
