;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA		mysub,  READONLY,  CODE
			THUMB
			EXTERN		__main
			EXPORT		CONVRT
		
;R0 holds divisor, R1 holds a multiplicant, R2 holds EOT in ASCII,
;R3 holds #10, R4 holds the number, R5 holds a memory adress,
;R6 holds the digit of decimal number we're converting to instantly.

CONVRT	PROC
		PUSH {LR}
		PUSH {R4}
		PUSH {R5}
		LDR  R0,=0x3B9ACA00 ;#10^9 in hex (divisor)
		LDR  R3,=0xA		;#10 in hex
		LDR  R2,=0x04		;EOT ascii
		CMP  R4,#10			;Check if the number is single digit decimal
		BLT  iflw10    		;If the number is lower than 10 go to iflw10
		B    clc0			;If not go to clc0
		
;loop executes if initially number is lower than 10
iflw10  ADD  R4,R4,#0x30 ;Convert the number to ASCII
		STRB R4,[R5],#1  ;Put it into [R5] and do R5=R5+1
		STRB R2,[R5]     ;Also put EOT into [R5]
		POP  {R5}		 ;POP R5 to have initial adress	
		POP  {R4}		 ;POP R4 which is the number
		POP  {LR}		 ;POP LR
		BX   LR			 ;Return to main program
			
;loop0 clears all the 0s at the beginning
clc0	UDIV R6,R4,R0 ;Divide the number by divisor then hold the digit
		MUL  R1,R6,R0 ;R1 = R6*R0 (hold the multiplicant)
		SUBS R4,R1    ;R4-R1->R4  (substract the multiplicant)
		UDIV R0,R3    ;Divisor/10
		CMP  R6,#0	  ;Check the digit 0 or not
		BEQ  clc0	  ;If 0 branch to clc0
		B    loop     ;After all 0s are cleared -> leave

;loop finds the digits and store them
loop	ADD  R6,R6,#0x30  ;The last digit from clc0, convert it to ASCII
		STRB R6,[R5],#1   ;Store the digit -> [R5] then R5+1
		UDIV R6,R4,R0     ;Divide the number by divisor -> R6
		MUL  R1,R6,R0	  ;R1 = R6*R0 (hold the multiplicant)
		SUB  R4,R1        ;R4-R1->R4  (substract the multiplicant)
		CMP  R0,#1        ;Check the divisor if 1 go end_p
		BEQ  end_p        
		UDIV R0,R3        ;If not 1, Divisor/10
		B    loop

;end of subroutine	
end_p  	MOV  R6,R1        ;The last digit from loop ->R6
		ADD  R6,R6,#0x30  ;Convert it to ASCII
		STRB R6,[R5],#1   ;Store the digit -> [R5] then R5+1
		STRB R2,[R5]      ;Also put EOT into [R5]
		POP  {R5}		  ;POP the initial address
		POP  {R4}		  ;POP the inital number
		POP  {LR}		  ;POP the link register
		BX   LR
		ENDP