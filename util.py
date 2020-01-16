import re

def main():
    textIn = open("util.txt", "r")
    textOut = open("out.txt", "w+")

    linesIn = textIn.readlines()
    for line in linesIn:
        textOut.write("[")
        noSemiColon = re.sub("[;\n]+","",line)
        newDelim = re.sub("\s+",",\t",noSemiColon)
        textOut.write(newDelim)
        textOut.write("],")
        textOut.write("\n")


    textIn.close()
    textOut.close()

if __name__ == "__main__":
    main()