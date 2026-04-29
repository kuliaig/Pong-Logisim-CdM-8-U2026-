asect 0x00

start:
#0xf3 - x
#0xf4 - y
#0xf5 - vxy
# the main formula: y + (224 - x) * vy / vx
ldi r0, 0xf5
ld r0, r0
# vx in r1
ldi r1, 0x07
and r0, r1
move r0, r0 #clear flags to get no effect on shr
shr r0
move r0, r0 #clear flags to get no effect on shr
shr r0
move r0, r0 #clear flags to get no effect on shr
shr r0
# vy in r0 
ldi r2, 0x07
and r2, r0
# x in r2
ldi r2, 0xf3
ld r2, r2

# sign of vy in r3, |vy| in r0
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
# if vx = vy, no operations, go to finish
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
push r3
# push y to stack to use it later, r3 is free
ldi r3, 0xf4
ld r3, r3
push r3
ldi r3, 4
# if vy = -4, it returns to 3 so we need to count new coordinates
# x = x + vx * (y / 4)
# y = 0
# vy = 3
if
	cmp r3, r0
is eq
	# get y from stack
	pop r3
	inc r3 # add 3 to y to round up
	inc r3
	inc r3
	move r3, r3 #clear flags to get no effect on shr
	shr r3
	move r3, r3
	shr r3
	move r3, r0
	# push vx to stack to remember it
	push r1
	dec r1
	# calculate vx * (y / 4)
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
	# r1 check where the hit will be
	# if it's further than the bat, returns the original coordinates
	if
		tst r1
	is lt
		ldi r3, 0xf4
		ld r3, r3
		ldi r2, 0xf3
		ld r2, r2
		ldi r0, 4
		pop r1 # get vx from stack
	else
	# if the hit is closer than racket
	# put new coordinates
		ldi r3, 0
		pop r1 # get vx from stack
		pop r0 # get vy sign from stack
		ldi r0, 0
		push r0 # push new vy sign to stack
		ldi r0, 3
	fi
	push r3 # push new y to stack
fi
# push vx to stack
push r1

# distance in r2
ldi r3, 0xe0
sub r3, r2
# remember distance to r1 to calculate distance * 3
move r2, r1
ldi r3, 0x01
and r0, r3
# even -> r3 == 0, not even -> r3 == 1
if
	tst r3
is eq
	# if vy == 2 or vy == 4
	add r2, r2
	addc r3, r3
	ldi r1, 0x04
	if # vy == 4
		cmp r0, r1
	is eq
		clr r1
		add r2, r2
		addc r1, r1
		add r3, r3
		add r1, r3
	fi
else
	if # vy == 3
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

# division 2-3, because -4 is to left bat
# elder bytes in r3, low bytes in r2
# get vx from r0
pop r0
ldi r1, 0x02
if
	# if vx == 2
	cmp r1, r0
is eq
	move r3, r3
	shra r3
	shr r2
else
	ldi r1, 0x03
	if # vx == 3
# x / 3 is close to (x * 85 + 85) / 256, faster then cycle 
		cmp r1, r0
	is eq
	# * 85
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
move r3, r1 # elder bytes in r1
# get y from stack to r0
pop r0
# get sign of vy to r3
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

#if r1 is neg than the res is neg
# we need to neg it because coordinate can be less than 0
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
# is elder bytes odd?
# elder bytes is count of hits
# if it's odd we need to do 255 - res
if
	tst r1
is ne
	not r2
fi

# push result to address
ldi r0, 0xf3
st r0, r2
br start
halt

# FOR TESTS
asect 0xf3
x> dc 100
asect 0xf4
y> dc 128
asect 0xf5
vxy> dc 0b00101001
end