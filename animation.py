# библиотека для отрисовки
import pygame
# системные функции
import sys
# работа с файловой системой
import os
import random

h = 750
w = 750
pygame.init()
screen = pygame.display.set_mode((h, w))
pygame.display.set_caption("Pink Pong") # название дисплея

project = "tennis.circ"
light_pink = (255, 189, 246)
dark_pink = (255, 32, 189)
black = (0, 0, 0)
white = (255, 255, 255)

x = 0
y = 0
vx = 4
vy = 3

left_bat = h // 2 - 50
right_bat = h // 2 - 50

go = True
while go:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            go = False
        if event.type == pygame.KEYDOWN and event.key == pygame.K_RETURN:
            go = False

    screen.fill(light_pink)
    for _ in range(30):
        starx = random.randint(0, 750)
        stary = random.randint(0, 750)
        pygame.draw.circle(screen, white, (starx, stary), 3)


    font_name = pygame.font.Font(None, 140)
    text_name = font_name.render("PINK PONG", True, black)
    screen.blit(text_name, (115, 300))

    pygame.draw.circle(screen, dark_pink, (x, y), 10)
    if (x + vx > h) or (x + vx < 0):
        vx = -vx
    x += vx
    if (y + vy > w) or (y + vy < 0):
        vy = -vy
    y += vy

    left_bat += (y - 50 - left_bat) * 0.1
    right_bat += (y - 50 - right_bat) * 0.1

    font_cont = pygame.font.Font(None, 30)
    text_cont = font_cont.render("Press ENTER to continue", False, black)
    screen.blit(text_cont, (250, 700))

    pygame.draw.rect(screen, dark_pink, (20, left_bat, 20, 100))
    pygame.draw.rect(screen, dark_pink, (w - 35, right_bat, 20, 100))

    pygame.display.flip() # обновление экрана
    pygame.time.Clock().tick(60) # кадры в секунду

pygame.quit()

if os.path.exists(project):
    os.startfile(project)
else:
    print("Файл с игрой не найден. Проверьте, что он называется 'tennis.circ' и находится в одной папке с заставкой.")
    input("Для выхода нажмите на любую кнопку.")
