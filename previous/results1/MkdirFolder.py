import os

txtfile = open('CommitName.txt', 'r')
lines = txtfile.readlines()
for line in lines:
    os.mkdir(line.rstrip("\n")) #inserting the name and taking out \n
