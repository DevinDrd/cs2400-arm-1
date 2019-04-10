		;		ARM Programming Assignment #1: 16 bit multiplier
		;
		;		Write a 16-bit multiplier, meaning numbers that have their high 16 bits set to 0.
		;		Use the standard shift-and-add operation.
		;		Note that we cannot address half-words here. We can only address words and bytes (B).
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.

		;		Your code here

numbers	DCD		0b1100101010010001, 0b1111010101000011
result	FILL		4

carry	FILL		4

		ADR		r0, numbers
		LDR		r1, [r0], #4	;loads first operand into r1
		LDR		r2, [r0], #4	;loads second operand into r2
		MOV		r3, #0		;initialize result register

loop		MOVS		r2, r2, lsr #1	;shifts r2 right 1, writes that back to r2, and sets the status flags
		ADDCS	r3, r3, r1	;if the carry bit is set, add r1 to r3
		MOV		r1, r1, lsl #1	;update r1 by shifting it left 1
		CMP		r2, #1
		BGT		loop			;branch back to loop if r2 is not 0
		MOVS		r2, r2, lsr #1	;shifts r2 right 1, writes that back to r2, and sets the status flags for the last time
		ADDCS	r3, r3, r1	;if the carry bit is set, add r1 to r3 for the last time

		STR		r3, [r0], #4
		MOVCC	r4, #0
		MOVCS	r4, #1
		STR		r4, [r0]
		END
