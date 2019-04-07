		;		ARM Programming Assignment #1: Capitalizer
		;
		;		Write a program that goes through the characters in chars,
		;		and Capitalizes every lower-case letter that it finds..
		;		Write the number of capitalizations the program performed
		;		In the caps "fill" memory provided.

		;		Your code here

chars	DCD		'a', 'B', '5', 'q', '0', 'O', '1', 's', 'b', 'i', 'G'
count	DCD		11
caps	FILL	4

		ADR		r2, chars		;Make r1 point to the chars
		ADR		r1, count
		LDR		r1, [r1]		;loads elememt count
		MOV		r0, #0			;initialized elements changed count

LOOP
		LDR		r3, [r2], #4	;Load the first element into r3
		CMP		r3, #97			;Checks if the element is grater than 97
		BLGE	GREATER			;branches to GREATER if r4 is greater than or equal to 97
		SUBS	r1, r1, #1		;Update loop counter
		BNE		LOOP

		ADR		r2, caps
		STR		r0, [r2]
		END

GREATER
		CMP		r3, #122
		SUBLE	r3, r3, #32		;converts to a capital
		STRLE	r3, [r2]		;Updates the element in memory
		ADDLE	r0, r0, #1		;updates changed element count
		MOV		PC, LR
