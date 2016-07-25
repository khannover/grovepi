#!/usr/bin/python2

import sys,getopt
from grove_rgb_lcd import *

def main(argv):
        text = ''
        red = 0
        green = 0
        blue = 0
        try:
                opts,args = getopt.getopt(argv,"ht:r:g:b:",["text=","red=","green=", "blue="])
        except getopt.GetoptError:
                print 'lcd.py -t <text> -r <color> -g <color> -b <color>'
                sys.exit(2)
        for opt,arg in opts:
                if opt == "-h":
                        print 'lcd.py -t <text> -r <color> -g <color> -b <color>'
                        sys.exit()
                if opt == "-t":
                        text = arg
                if opt == "-r":
                        red = arg
                if opt == "-g":
                        green = arg
                if opt == "-b":
                        blue = arg
        setText(text)
        setRGB(int(red), int(green), int(blue))
if __name__ == "__main__":
        main(sys.argv[1:])
