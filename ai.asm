asect 0x00

start:
#0xf3 - x
#0xf4 - y
#0xf5 - vxy
clr r0
ldi r0, 0xf5
ld r0, r0
# vx in r1
ldi r1, 0x07
and r0, r1
move r0, r0
shr r0
move r0, r0
shr r0
move r0, r0
shr r0
# vy in r0 
ldi r2, 0x07
and r2, r0
# x in r2
ldi r2, 0xf3
ld r2, r2

# sign of vy in r3, |vy|
ldi r3, 0x04
and r0, r3

if
	tst r3
is ne
	neg r0
	ldi r3, 0x07
	and r3, r0
	ldi r3, 0x01
fi
# if vx = vy, no operations
if 
	cmp r1, r0
is eq
	push r3
	ldi r3, 224
	sub r3, r2
	ldi r3, 0xf4
	ld r3, r3
	push r3
	ldi r3, 0x00
	br finish
fi
# vy sign in stack, r3 is free
# vx in stack, r1 is free, 
# r0 - vy, r2 - distance
push r3
ldi r3, 0xf4
ld r3, r3
push r3
ldi r3, 4
# if vy = -4, it returns to 3 so we need to count new coordinates
if
	cmp r3, r0
is eq
	pop r3
	inc r3
	inc r3
	inc r3
	move r3, r3
	shr r3
	move r3, r3
	shr r3
	move r3, r0
	push r1
	dec r1
	while
		tst r1
	stays gt
		add r0, r3
		if
		is cs
			ldi r1, -1
		fi
		dec r1
	wend
	add r3, r2
	if
	is cs
		ldi r1, -1
	fi
	ldi r3, 31
	add r2, r3
	if
	is cs
		ldi r1, -1
	fi
	if
		tst r1
	is lt
		ldi r3, 0xf4
		ld r3, r3
		ldi r2, 0xf3
		ld r2, r2
		ldi r0, 4
		pop r1
	else
		ldi r3, 0
		pop r1
		pop r0
		ldi r0, 0
		push r0
		ldi r0, 3
	fi
	push r3
fi
push r1

# distance in r2
ldi r3, 0xe0
sub r3, r2
# r1 - distance 
move r2, r1
ldi r3, 0x01
and r0, r3
# even -> r3 == 0, not even -> r3 == 1
if
	tst r3
is eq
	add r2, r2
	addc r3, r3
	ldi r1, 0x04
	if
		cmp r0, r1
	is eq
		clr r1
		add r2, r2
		addc r1, r1
		add r3, r3
		add r1, r3
	fi
else
	if
		cmp r0, r3
	is eq
		clr r3
	else
		clr r3
		add r2, r2
		addc r3, r3
		clr r0
		add r1, r2
		addc r0, r3
	fi
fi

# division (2/3)
# elder bytes in r3, low bytes in r2
# vx in r0
pop r0
ldi r1, 0x02
if
	cmp r1, r0
is eq
	move r3, r3
	shra r3
	shr r2
else
	ldi r1, 0x03
	if
		cmp r1, r0
	is eq
	# * 85 + 85 
		move r3, r1
		move r2, r0
		shla r0
		shl r1
		shla r0
		shl r1
		add r0, r2
		addc r1, r3
		shla r0
		shl r1
		shla r0
		shl r1
		add r0, r2
		addc r1, r3
		shla r0
		shl r1
		shla r0
		shl r1
		add r0, r2
		addc r1, r3
		# + 85
		ldi r0, 0x55
		add r0, r2
		ldi r0, 0x00
		addc r0, r3
		# / 256
		move r3, r2
		clr r3
	fi 
fi

# elder bytes in r3, low bytes in r2
# almost all operations are done
finish:
move r3, r1
pop r0
pop r3
# correct if vy was negative
if
	tst r3
is ne
	not r2
	not r1
	inc r2
	if
	is cs
		inc r1
	fi
fi

add r0, r2
if
is cs
	inc r1
fi

if 
	tst r1
is lt
	not r2
	not r1
	inc r2
	if
	is cs
		inc r1
	fi
fi 
ldi r0, 1
and r0, r1
if
	tst r1
is ne
	not r2
fi

ldi r0, 0xf3
st r0, r2
br start
halt

asect 0xf3
x> dc 146
asect 0xf4
y> dc 254
asect 0xf5
vxy> dc 0b00110010
end