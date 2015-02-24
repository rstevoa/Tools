"""Don't use this. This isn't a safe scraper for reddit. It's unstable and sometimes
it'll start throwing out too many requests.
"""


import requests
import pygame
import re
import time

pygame.mixer.init()
pygame.mixer.music.load('beep-04.mp3')

reddit = ''
headers = {
    'User-Agent': 'ScraperBot-Python2-Requests-4-per-minute'
}

consecutiveFails = 0
codes = []
links = []
while True:
    try:
        time.sleep(15)
        response = requests.get(reddit)
        consecutiveFails = 0
    except:
        consecutiveFails += 1
        print "Failure"
        continue
    s = response.text
    new = re.findall('A0[67].{13,16}', s)
    newl = re.findall('http://(?:i.)?imgur.com/.*?\.png', s)
    if len(new) is 0 and len(newl) is 0:
        pygame.mixer.music.play()
        print s
        continue

    print "="*16

    if codes != new:
        pygame.mixer.music.play()
        i = 0
        for code in set(new)-set(codes):
            i+=1
            print str(i)+": "+code
        codes = new

    if links != newl:
        pygame.mixer.music.play()
        i = 0
        for code in set(newl)-set(links):
            i+=1
            print str(i)+": "+code
        links = newl
