		;		ARM Programming Assignment #1: 32 bit multiplier
		;
		;		Write a 32-bit multiplier.
		;		Use the standard shift-and-add operation.
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.
		
		;		Your code here
		
		;numbers	DCD		0xA0BCFF0D, 0xFFF0ADEA
numbers	DCD		0x12, 0x24
result	FILL		8
carry	FILL		4
		
		ADR		r0, numbers		;points r0 to the first operand
		LDR		r3, [r0], #4		;puts the first  operand in r2 | (a)
		LDR		r5, [r0]			;puts the second operand in r4 | (b)
		ADR		r0, result		;points to where the result is to me stored
		;extract	top a and bottom a to r2 and r3 respectively
		MOV		r2, r3, LSR #16	;puts top half of r2 (a) in r1 | (top a)
		BIC		r3, r3, r2, LSL #16 ;puts bottom half of r2 (a) in r2 | (bottom a)
		;extract	top b and bottom b to r4 and r5 respective
		MOV		r4, r5, LSR #16	;puts top half of r4 (b) in r3 | (top b)
		BIC		r5, r5, r4, LSL #16	;puts bottom half of r4 (b) in r4 | (bottom b)
		
		;multiply	(top a) with (top b)
		MOV		r8, r2			;moves (top a) into r8
		MOV		r9, r4			;moves (top b) into r9
		BL		mul				;(top a) * (top b)
		MOV		r1, r10			;moves result (partial sum) to r1
		;multiply	(top a) with (bottom b)
		MOV		r8, r2			;moves (top a) into r8
		MOV		r9, r5			;moves (bottom b) into r9
		BL		mul				;(top a) * (bottom b)
		MOV		r2, r10			;moves result (partial sum) to r2
		;multiply	(bottom a) with (top b)
		MOV		r8, r3			;moves (bottom a) into r8
		MOV		r9, r4			;moves (top b) into r9
		BL		mul				;(bottom a) * (top b)
		MOV		r4, r10			;moves result (partial sum) to r4
		;multiply	(bottom a) with (bottom b)
		MOV		r8, r3			;moves (bottom a) into r8
		MOV		r9, r5			;moves (bottom b) into r9
		BL		mul				;(bottom a) * (bottom b)
		MOV		r3, r10			;moves result (partial sum) to r3
		
		ADDS		r2, r2, r4		;add middle parts
		ADDCS	r1, r1, #&10000	;add in carry from above
		ADDS		r3, r3, r2, LSL #16	;LSB 32 bits
		ADC		r1, r1, r2, LSR #16	;MSB 32 bits
		STR		r3, [r0], #4		;store LSB
		STR		r1, [r0]			;store MSB
		ADR		r0, result
		MOVCC	r2, #0
		MOVCS	r2, #1
		STR		r2, [r0]
		END

		;Multiply uses	r8 for operand 1, r9 for operand 2, r10 for result
mul		MOV		r10, #0		;initialize result register
		
loop		MOVS		r9, r9, lsr #1	;shifts r9 (b) right 1, writes that back to r9, and sets the status flags
		ADDCS	r10, r10, r8	;if the carry bit is set, add r8 to r10
		MOV		r8, r8, lsl #1	;update r8 (a) by shifting it left 1
		CMP		r9, #1
		BGT		loop			;branch back to loop if r9 is not 0
		
		MOVS		r9, r9, lsr #1	;shifts r9 (b) right 1, writes that back to r9 (b), and sets the status flags for the last time
		ADDCS	r10, r10, r8	;if the carry bit is set, add r8 (a) to r10 for the last time
		MOV		pc, lr		;returns
		
