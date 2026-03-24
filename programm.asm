asect 0x00

#0xf3 - адрес координаты X
#0xf4 - адрес координаты Y
#0xf5 - адрес VXY
start:
#ПРОВЕРКА НАПРАВЛЕНИЯ (только если Vx > 0)
ldi r0, 0xf5
ld r0, r1
move r1, r2 #запоминаем чтобы позже читать Vy
ldi r0, 0x04 #маска для старшего бита Vx
and r0, r1

#РАСЧЕТ ВРЕМЕНИ ДО ПОДЛЕТА
ldi r0, 0xf3
ld r0, r0
ldi r1, 0xe0 #самый первый бит ракетки
sub r1, r0

#РАСПАКОВКА И ОБРАБОТКА VY
shr r2
shr r2
shr r2
ldi r1, 0x07
and r1, r2
ldi r1, 0x04
and r2, r1

if
	tst r1
is ne
	neg r2
	ldi r3, 0x07
	and r3, r2
fi

ldi r3, 0x01
and r2, r3
push r1
clr r1
if
	tst r3
is gt
	ldi r3, 0x03
	shr r0
	if 
		cmp r3, r2
	is eq
		move r0, r3
		add r0, r0
		if
		is cs
			ldi r1, 0x01
		fi
		add r3, r0
		if
		is cs
			ldi r1, 0x01
		fi
	fi
else
	ldi r3, 0x04
	if 
		cmp r3, r2
	is eq
		add r0, r0
		if
		is cs
			ldi r1, 0x01
		fi
	fi
fi
move r1, r3

pop r1

ldi r2, 0xf4
ld r2, r2

if
	tst r3
is ne
	if
		tst r1
	is ne
		sub r2, r0
		if
		is cs
			neg r0
		fi
	else
		add r2, r0
		if
		is cs
		else
			neg r0
		fi
	fi
else
	if
		tst r1
	is ne
		sub r2, r0
		if
		is cs
		else
			neg r0
		fi
	else
		add r2, r0
		if
		is cs
			neg r0
		fi
	fi
fi

ldi r3, 0xf3
st r3, r0

halt

end