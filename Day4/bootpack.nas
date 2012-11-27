[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_sprintf
	EXTERN	_io_hlt
	EXTERN	_io_load_eflags
	EXTERN	_io_cli
	EXTERN	_io_out8
	EXTERN	_io_store_eflags
	EXTERN	_hankaku
[FILE "bootpack.c"]
[SECTION .data]
LC1:
	DB	"scrnx = ",0x22,"%d",0x22,0x00
LC2:
	DB	"scrny = ",0x22,"%d",0x22,0x00
[SECTION .text]
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	SUB	ESP,256
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_desktop
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	LC1
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	8
	PUSH	8
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putFonts8_asc
	ADD	ESP,48
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	PUSH	LC2
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	LEA	EBX,DWORD [-260+EBP]
	PUSH	26
	PUSH	8
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putFonts8_asc
	ADD	ESP,36
	PUSH	14
	PUSH	EBX
	CALL	_init_mouse_cursor8
	PUSH	16
	PUSH	EBX
	PUSH	180
	PUSH	180
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,40
L2:
	CALL	_io_hlt
	JMP	L2
[SECTION .data]
_table_rgb.0:
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	0
	DB	-1
	DB	-1
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	-1
	DB	0
	DB	-1
	DB	0
	DB	-1
	DB	-1
	DB	-1
	DB	-1
	DB	-1
	DB	-58
	DB	-58
	DB	-58
	DB	-124
	DB	0
	DB	0
	DB	0
	DB	-124
	DB	0
	DB	-124
	DB	-124
	DB	0
	DB	0
	DB	0
	DB	-124
	DB	-124
	DB	0
	DB	-124
	DB	0
	DB	-124
	DB	-124
	DB	-124
	DB	-124
	DB	-124
[SECTION .text]
	GLOBAL	_init_palette
_init_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	_table_rgb.0
	PUSH	15
	PUSH	0
	CALL	_set_palette
	LEAVE
	RET
	GLOBAL	_set_palette
_set_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX
	MOV	EBX,DWORD [8+EBP]
	MOV	EDI,DWORD [12+EBP]
	MOV	ESI,DWORD [16+EBP]
	CALL	_io_load_eflags
	MOV	DWORD [-16+EBP],EAX
	CALL	_io_cli
	PUSH	EBX
	PUSH	968
	CALL	_io_out8
	CMP	EBX,EDI
	POP	EAX
	POP	EDX
	JLE	L11
L13:
	MOV	EAX,DWORD [-16+EBP]
	MOV	DWORD [8+EBP],EAX
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	JMP	_io_store_eflags
L11:
	MOV	AL,BYTE [ESI]
	INC	EBX
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	MOV	AL,BYTE [1+ESI]
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	MOV	AL,BYTE [2+ESI]
	SHR	AL,2
	ADD	ESI,3
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	ADD	ESP,24
	CMP	EBX,EDI
	JLE	L11
	JMP	L13
	GLOBAL	_fill_rectangle8
_fill_rectangle8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	MOV	ECX,DWORD [24+EBP]
	MOV	ESI,DWORD [32+EBP]
	PUSH	EBX
	MOV	EDI,DWORD [28+EBP]
	MOV	BL,BYTE [16+EBP]
	CMP	ECX,ESI
	JG	L26
	MOV	EAX,DWORD [12+EBP]
	IMUL	EAX,ECX
	ADD	EAX,DWORD [8+EBP]
L24:
	MOV	EDX,DWORD [20+EBP]
	CMP	EDX,EDI
	JG	L28
L23:
	MOV	BYTE [EDX+EAX*1],BL
	INC	EDX
	CMP	EDX,EDI
	JLE	L23
L28:
	INC	ECX
	ADD	EAX,DWORD [12+EBP]
	CMP	ECX,ESI
	JLE	L24
L26:
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_init_desktop
_init_desktop:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	SUB	ESP,24
	MOVSX	EBX,WORD [12+EBP]
	MOVSX	EAX,WORD [16+EBP]
	MOV	DWORD [-16+EBP],EAX
	LEA	EDI,DWORD [-1+EBX]
	DEC	EAX
	LEA	ESI,DWORD [-4+EBX]
	PUSH	EAX
	MOV	DWORD [-20+EBP],EAX
	PUSH	EDI
	PUSH	0
	PUSH	0
	PUSH	14
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	MOV	EAX,DWORD [-16+EBP]
	SUB	EAX,25
	PUSH	EAX
	PUSH	EDI
	PUSH	EAX
	PUSH	0
	PUSH	7
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	MOV	EAX,DWORD [-16+EBP]
	ADD	ESP,56
	SUB	EAX,24
	PUSH	DWORD [-20+EBP]
	PUSH	EDI
	LEA	EDI,DWORD [-47+EBX]
	PUSH	EAX
	PUSH	0
	PUSH	8
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	MOV	EAX,DWORD [-16+EBP]
	SUB	EAX,21
	PUSH	EAX
	MOV	DWORD [-24+EBP],EAX
	PUSH	59
	PUSH	EAX
	PUSH	3
	PUSH	7
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	MOV	EAX,DWORD [-16+EBP]
	ADD	ESP,56
	SUB	EAX,4
	MOV	DWORD [-28+EBP],EAX
	PUSH	EAX
	PUSH	2
	PUSH	DWORD [-24+EBP]
	PUSH	2
	PUSH	7
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	PUSH	DWORD [-28+EBP]
	PUSH	59
	PUSH	DWORD [-28+EBP]
	PUSH	3
	PUSH	15
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	MOV	EAX,DWORD [-16+EBP]
	ADD	ESP,56
	SUB	EAX,5
	PUSH	EAX
	MOV	EAX,DWORD [-16+EBP]
	PUSH	59
	SUB	EAX,20
	PUSH	EAX
	MOV	DWORD [-32+EBP],EAX
	PUSH	59
	PUSH	15
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	MOV	EAX,DWORD [-16+EBP]
	SUB	EAX,3
	PUSH	EAX
	MOV	DWORD [-36+EBP],EAX
	PUSH	59
	PUSH	EAX
	PUSH	2
	PUSH	0
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	ADD	ESP,56
	PUSH	DWORD [-36+EBP]
	PUSH	60
	PUSH	DWORD [-24+EBP]
	PUSH	60
	PUSH	0
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	PUSH	DWORD [-24+EBP]
	PUSH	ESI
	PUSH	DWORD [-24+EBP]
	PUSH	EDI
	PUSH	15
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	ADD	ESP,56
	PUSH	DWORD [-28+EBP]
	PUSH	EDI
	PUSH	DWORD [-32+EBP]
	PUSH	EDI
	PUSH	15
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	PUSH	DWORD [-36+EBP]
	PUSH	ESI
	PUSH	DWORD [-36+EBP]
	PUSH	EDI
	PUSH	7
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	LEA	EAX,DWORD [-3+EBX]
	ADD	ESP,56
	PUSH	DWORD [-36+EBP]
	PUSH	EAX
	PUSH	DWORD [-24+EBP]
	PUSH	EAX
	PUSH	7
	PUSH	EBX
	PUSH	DWORD [8+EBP]
	CALL	_fill_rectangle8
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_putFont8
_putFont8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	XOR	ESI,ESI
	PUSH	EBX
	MOV	EDI,DWORD [28+EBP]
	MOV	BL,BYTE [24+EBP]
L43:
	MOV	EAX,DWORD [20+EBP]
	MOV	EDX,DWORD [16+EBP]
	ADD	EAX,ESI
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,DWORD [8+EBP]
	LEA	ECX,DWORD [EDX+EAX*1]
	MOV	DL,BYTE [ESI+EDI*1]
	TEST	DL,DL
	JNS	L35
	MOV	BYTE [ECX],BL
L35:
	MOV	AL,DL
	AND	EAX,64
	TEST	AL,AL
	JE	L36
	MOV	BYTE [1+ECX],BL
L36:
	MOV	AL,DL
	AND	EAX,32
	TEST	AL,AL
	JE	L37
	MOV	BYTE [2+ECX],BL
L37:
	MOV	AL,DL
	AND	EAX,16
	TEST	AL,AL
	JE	L38
	MOV	BYTE [3+ECX],BL
L38:
	MOV	AL,DL
	AND	EAX,8
	TEST	AL,AL
	JE	L39
	MOV	BYTE [4+ECX],BL
L39:
	MOV	AL,DL
	AND	EAX,4
	TEST	AL,AL
	JE	L40
	MOV	BYTE [5+ECX],BL
L40:
	MOV	AL,DL
	AND	EAX,2
	TEST	AL,AL
	JE	L41
	MOV	BYTE [6+ECX],BL
L41:
	AND	EDX,1
	TEST	DL,DL
	JE	L33
	MOV	BYTE [7+ECX],BL
L33:
	INC	ESI
	CMP	ESI,15
	JLE	L43
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_putFonts8_asc
_putFonts8_asc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	EBX
	MOV	EBX,DWORD [28+EBP]
	MOV	AL,BYTE [24+EBP]
	MOV	BYTE [-13+EBP],AL
	MOV	ESI,DWORD [16+EBP]
	MOV	EDI,DWORD [20+EBP]
	CMP	BYTE [EBX],0
	JNE	L51
L53:
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L51:
	MOVZX	EAX,BYTE [EBX]
	SAL	EAX,4
	INC	EBX
	ADD	EAX,_hankaku
	PUSH	EAX
	MOVSX	EAX,BYTE [-13+EBP]
	PUSH	EAX
	PUSH	EDI
	PUSH	ESI
	ADD	ESI,8
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_putFont8
	ADD	ESP,24
	CMP	BYTE [EBX],0
	JNE	L51
	JMP	L53
[SECTION .data]
_cursor.1:
	DB	"**************.."
	DB	"*00000000000*..."
	DB	"*0000000000*...."
	DB	"*000000000*....."
	DB	"*00000000*......"
	DB	"*0000000*......."
	DB	"*0000000*......."
	DB	"*00000000*......"
	DB	"*0000**000*....."
	DB	"*000*..*000*...."
	DB	"*00*....*000*..."
	DB	"*0*......*000*.."
	DB	"**........*000*."
	DB	"*..........*000*"
	DB	"............*00*"
	DB	".............***"
[SECTION .text]
	GLOBAL	_init_mouse_cursor8
_init_mouse_cursor8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	XOR	EDI,EDI
	PUSH	EBX
	SUB	ESP,12
	MOV	AL,BYTE [12+EBP]
	MOV	ESI,DWORD [8+EBP]
	MOV	BYTE [-13+EBP],AL
	MOV	DWORD [-20+EBP],0
	MOV	DWORD [-24+EBP],0
L71:
	MOV	ECX,DWORD [-24+EBP]
	XOR	EBX,EBX
	ADD	ECX,ESI
L70:
	LEA	EDX,DWORD [EBX+EDI*1]
	MOVSX	EAX,BYTE [_cursor.1+EDX]
	CMP	EAX,46
	JE	L66
	CMP	EAX,46
	JG	L69
	CMP	EAX,42
	JE	L64
L67:
	MOV	AL,BYTE [-13+EBP]
	MOV	BYTE [ECX],AL
L61:
	INC	EBX
	INC	ECX
	CMP	EBX,15
	JLE	L70
	INC	DWORD [-20+EBP]
	ADD	EDI,16
	ADD	DWORD [-24+EBP],16
	CMP	DWORD [-20+EBP],15
	JLE	L71
	ADD	ESP,12
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L64:
	MOV	BYTE [EDX+ESI*1],0
	JMP	L61
L69:
	CMP	EAX,48
	JNE	L67
	MOV	BYTE [EDX+ESI*1],7
	JMP	L61
L66:
	MOV	AL,BYTE [-13+EBP]
	MOV	BYTE [EDX+ESI*1],AL
	JMP	L61
	GLOBAL	_putblock8_8
_putblock8_8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	XOR	ESI,ESI
	PUSH	EBX
	SUB	ESP,12
	CMP	ESI,DWORD [20+EBP]
	JGE	L88
	XOR	EDI,EDI
L86:
	XOR	EBX,EBX
	CMP	EBX,DWORD [16+EBP]
	JGE	L90
	MOV	EAX,DWORD [32+EBP]
	ADD	EAX,EDI
	MOV	DWORD [-20+EBP],EAX
L85:
	MOV	EAX,DWORD [28+EBP]
	MOV	EDX,DWORD [24+EBP]
	ADD	EAX,ESI
	ADD	EDX,EBX
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDX
	MOV	ECX,DWORD [8+EBP]
	MOV	EDX,DWORD [-20+EBP]
	INC	EBX
	MOV	DL,BYTE [EDX]
	MOV	BYTE [EAX+ECX*1],DL
	INC	DWORD [-20+EBP]
	CMP	EBX,DWORD [16+EBP]
	JL	L85
L90:
	INC	ESI
	ADD	EDI,DWORD [36+EBP]
	CMP	ESI,DWORD [20+EBP]
	JL	L86
L88:
	ADD	ESP,12
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET