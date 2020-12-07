;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA		main,  READONLY,  CODE
			THUMB
				
			EXPORT		__main
			EXTERN		CONVRT
			EXTERN		OutStr

__main
			LDR	R4,=0x000000F0 	;The number
			LDR R5,=0x20000080  ;R5 holds the address		
			BL  CONVRT			;Call subroutine
			BL  OutStr		    ;Call subroutine
inf			B   inf			    ;infinite loop
			END