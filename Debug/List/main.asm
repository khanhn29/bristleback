
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _g_alert_led_mode=R5
	.DEF _rx_wr_index0=R4
	.DEF _rx_rd_index0=R7
	.DEF _rx_counter0=R6
	.DEF _tx_wr_index0=R9
	.DEF _tx_rd_index0=R8
	.DEF _tx_counter0=R11
	.DEF _g_count_adc_0=R12
	.DEF _g_count_adc_0_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x20003:
	.DB  0x64
_0x20000:
	.DB  0x65,0x72,0x72,0x2C,0x25,0x64,0x3B,0x0
	.DB  0x61,0x64,0x63,0x2C,0x25,0x64,0x3B,0x0
	.DB  0x2C,0x0,0x43,0x4F,0x4E,0x4E,0x45,0x43
	.DB  0x54,0x0,0x4F,0x46,0x46,0x0,0x74,0x68
	.DB  0x72,0x65,0x73,0x68,0x6F,0x6C,0x64,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _g_temperature_not_ready_value_G001
	.DW  _0x20003*2

	.DW  0x08
	.DW  _0x20072
	.DW  _0x20000*2+18

	.DW  0x04
	.DW  _0x20072+8
	.DW  _0x20000*2+26

	.DW  0x0A
	.DW  _0x20072+12
	.DW  _0x20000*2+30

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 9/28/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "main.h"
;#include <string.h>
;#include <delay.h>
;
;// Declare your global variables here
;enum alert_mode_e    g_alert_led_mode;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 003B {

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003C char status,data;
; 0000 003D status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 003E data=UDR0;
	IN   R16,12
; 0000 003F if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0040    {
; 0000 0041    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0042 #if RX_BUFFER_SIZE0 == 256
; 0000 0043    // special case for receiver buffer size=256
; 0000 0044    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0045 #else
; 0000 0046    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
; 0000 0047    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R6
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x5
; 0000 0048       {
; 0000 0049       rx_counter0=0;
	CLR  R6
; 0000 004A       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 004B       }
; 0000 004C #endif
; 0000 004D    }
_0x5:
; 0000 004E }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x1B
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0055 {
; 0000 0056 char data;
; 0000 0057 while (rx_counter0==0);
;	data -> R17
; 0000 0058 data=rx_buffer0[rx_rd_index0++];
; 0000 0059 #if RX_BUFFER_SIZE0 != 256
; 0000 005A if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 005B #endif
; 0000 005C #asm("cli")
; 0000 005D --rx_counter0;
; 0000 005E #asm("sei")
; 0000 005F return data;
; 0000 0060 }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0=0,tx_rd_index0=0;
;#else
;unsigned int tx_wr_index0=0,tx_rd_index0=0;
;#endif
;
;#if TX_BUFFER_SIZE0 < 256
;unsigned char tx_counter0=0;
;#else
;unsigned int tx_counter0=0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0076 {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077 if (tx_counter0)
	TST  R11
	BREQ _0xA
; 0000 0078    {
; 0000 0079    --tx_counter0;
	DEC  R11
; 0000 007A    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 007B #if TX_BUFFER_SIZE0 != 256
; 0000 007C    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0xB
	CLR  R8
; 0000 007D #endif
; 0000 007E    }
_0xB:
; 0000 007F }
_0xA:
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0086 {
; 0000 0087 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
; 0000 0088 #asm("cli")
; 0000 0089 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
; 0000 008A    {
; 0000 008B    tx_buffer0[tx_wr_index0++]=c;
; 0000 008C #if TX_BUFFER_SIZE0 != 256
; 0000 008D    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0000 008E #endif
; 0000 008F    ++tx_counter0;
; 0000 0090    }
; 0000 0091 else
; 0000 0092    UDR0=c;
; 0000 0093 #asm("sei")
; 0000 0094 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00A0 {
; 0000 00A1 ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 00A2 // Delay needed for the stabilization of the ADC input voltage
; 0000 00A3 delay_us(10);
; 0000 00A4 // Start the AD conversion
; 0000 00A5 ADCSRA|=(1<<ADSC);
; 0000 00A6 // Wait for the AD conversion to complete
; 0000 00A7 while ((ADCSRA & (1<<ADIF))==0);
; 0000 00A8 ADCSRA|=(1<<ADIF);
; 0000 00A9 return ADCW;
; 0000 00AA }
;
;void main(void)
; 0000 00AD {
_main:
; .FSTART _main
; 0000 00AE // Declare your local variables here
; 0000 00AF 
; 0000 00B0 // Input/Output Ports initialization
; 0000 00B1 // Port A initialization
; 0000 00B2 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B3 DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(128)
	OUT  0x1A,R30
; 0000 00B4 // State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B5 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00B6 
; 0000 00B7 // Port B initialization
; 0000 00B8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B9 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 00BA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00BB PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 00BC 
; 0000 00BD // Port C initialization
; 0000 00BE // Function: Bit7=Out Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 00BF DDRC=(1<<DDC7) | (0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(171)
	OUT  0x14,R30
; 0000 00C0 // State: Bit7=0 Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=0
; 0000 00C1 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00C2 
; 0000 00C3 // Port D initialization
; 0000 00C4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C5 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00C6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C7 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00C8 
; 0000 00C9 // Port E initialization
; 0000 00CA // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CB DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 00CC // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CD PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 00CE 
; 0000 00CF // Port F initialization
; 0000 00D0 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D1 DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 00D2 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D3 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 00D4 
; 0000 00D5 // Port G initialization
; 0000 00D6 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D7 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 00D8 // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D9 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 00DA 
; 0000 00DB // Timer/Counter 0 initialization
; 0000 00DC // Clock source: System Clock
; 0000 00DD // Clock value: Timer 0 Stopped
; 0000 00DE // Mode: Normal top=0xFF
; 0000 00DF // OC0 output: Disconnected
; 0000 00E0 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 00E1 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00E2 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00E3 OCR0=0x00;
	OUT  0x31,R30
; 0000 00E4 
; 0000 00E5 // Timer/Counter 1 initialization
; 0000 00E6 // Clock source: System Clock
; 0000 00E7 // Clock value: Timer1 Stopped
; 0000 00E8 // Mode: Normal top=0xFFFF
; 0000 00E9 // OC1A output: Disconnected
; 0000 00EA // OC1B output: Disconnected
; 0000 00EB // OC1C output: Disconnected
; 0000 00EC // Noise Canceler: Off
; 0000 00ED // Input Capture on Falling Edge
; 0000 00EE // Timer1 Overflow Interrupt: Off
; 0000 00EF // Input Capture Interrupt: Off
; 0000 00F0 // Compare A Match Interrupt: Off
; 0000 00F1 // Compare B Match Interrupt: Off
; 0000 00F2 // Compare C Match Interrupt: Off
; 0000 00F3 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00F4 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00F5 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00F6 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F7 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F8 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F9 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00FA OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00FB OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00FC OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00FD OCR1CH=0x00;
	STS  121,R30
; 0000 00FE OCR1CL=0x00;
	STS  120,R30
; 0000 00FF 
; 0000 0100 // Timer/Counter 2 initialization
; 0000 0101 // Clock source: System Clock
; 0000 0102 // Clock value: Timer2 Stopped
; 0000 0103 // Mode: Normal top=0xFF
; 0000 0104 // OC2 output: Disconnected
; 0000 0105 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0106 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0107 OCR2=0x00;
	OUT  0x23,R30
; 0000 0108 
; 0000 0109 // Timer/Counter 3 initialization
; 0000 010A // Clock source: System Clock
; 0000 010B // Clock value: Timer3 Stopped
; 0000 010C // Mode: Normal top=0xFFFF
; 0000 010D // OC3A output: Disconnected
; 0000 010E // OC3B output: Disconnected
; 0000 010F // OC3C output: Disconnected
; 0000 0110 // Noise Canceler: Off
; 0000 0111 // Input Capture on Falling Edge
; 0000 0112 // Timer3 Overflow Interrupt: Off
; 0000 0113 // Input Capture Interrupt: Off
; 0000 0114 // Compare A Match Interrupt: Off
; 0000 0115 // Compare B Match Interrupt: Off
; 0000 0116 // Compare C Match Interrupt: Off
; 0000 0117 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 0118 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 0119 TCNT3H=0x00;
	STS  137,R30
; 0000 011A TCNT3L=0x00;
	STS  136,R30
; 0000 011B ICR3H=0x00;
	STS  129,R30
; 0000 011C ICR3L=0x00;
	STS  128,R30
; 0000 011D OCR3AH=0x00;
	STS  135,R30
; 0000 011E OCR3AL=0x00;
	STS  134,R30
; 0000 011F OCR3BH=0x00;
	STS  133,R30
; 0000 0120 OCR3BL=0x00;
	STS  132,R30
; 0000 0121 OCR3CH=0x00;
	STS  131,R30
; 0000 0122 OCR3CL=0x00;
	STS  130,R30
; 0000 0123 
; 0000 0124 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0125 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 0126 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 0127 
; 0000 0128 // External Interrupt(s) initialization
; 0000 0129 // INT0: Off
; 0000 012A // INT1: Off
; 0000 012B // INT2: Off
; 0000 012C // INT3: Off
; 0000 012D // INT4: Off
; 0000 012E // INT5: Off
; 0000 012F // INT6: Off
; 0000 0130 // INT7: Off
; 0000 0131 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 0132 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 0133 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 0134 
; 0000 0135 // USART0 initialization
; 0000 0136 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0137 // USART0 Receiver: On
; 0000 0138 // USART0 Transmitter: On
; 0000 0139 // USART0 Mode: Asynchronous
; 0000 013A // USART0 Baud Rate: 9600
; 0000 013B UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 013C UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 013D UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 013E UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 013F UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0140 
; 0000 0141 // USART1 initialization
; 0000 0142 // USART1 disabled
; 0000 0143 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0144 
; 0000 0145 // Analog Comparator initialization
; 0000 0146 // Analog Comparator: Off
; 0000 0147 // The Analog Comparator's positive input is
; 0000 0148 // connected to the AIN0 pin
; 0000 0149 // The Analog Comparator's negative input is
; 0000 014A // connected to the AIN1 pin
; 0000 014B ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 014C 
; 0000 014D // ADC initialization
; 0000 014E // ADC Clock frequency: 1000.000 kHz
; 0000 014F // ADC Voltage Reference: AREF pin
; 0000 0150 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0151 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0152 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0153 
; 0000 0154 // SPI initialization
; 0000 0155 // SPI disabled
; 0000 0156 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0157 
; 0000 0158 // TWI initialization
; 0000 0159 // TWI disabled
; 0000 015A TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 015B 
; 0000 015C // Global enable interrupts
; 0000 015D #asm("sei")
	sei
; 0000 015E 
; 0000 015F while (1)
_0x17:
; 0000 0160       {
; 0000 0161       // Place your code here
; 0000 0162 
; 0000 0163       }
	RJMP _0x17
; 0000 0164 }
_0x1A:
	RJMP _0x1A
; .FEND
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#include <ctype.h>
;#include "main.h"
;
;unsigned int      g_count_adc_0;
;int               g_value_adc_0;
;
;unsigned int      g_count_adc_1;
;int               g_value_adc_1;
;static int        g_temperature_not_ready_value = 100;

	.DSEG
;
;unsigned int      g_led_control;
;int      g_connect_mode;
;char     g_uart_send_buf[MAX_RECIEVE_BUF];
;extern enum alert_mode_e    g_alert_led_mode;
;
;void get_status_led()
; 0001 0016 {

	.CSEG
; 0001 0017    g_count_adc_1++;
; 0001 0018    if(g_count_adc_1 > 100)
; 0001 0019    {
; 0001 001A       g_count_adc_1 = 0;
; 0001 001B       g_value_adc_1 = read_adc(1) * 500 / 1023;
; 0001 001C    }
; 0001 001D 
; 0001 001E    if(DOOR == IS_OPEN || INLET == IS_REMOVED)
; 0001 001F    {
; 0001 0020       g_alert_led_mode = door_open_or_inlet_removed;
; 0001 0021       turnoff();
; 0001 0022    }
; 0001 0023    else if(NOZZLE == IS_BLOCKED)
; 0001 0024    {
; 0001 0025       g_alert_led_mode = nozzle_blocked;
; 0001 0026       turnoff();
; 0001 0027    }
; 0001 0028    else if(g_value_adc_1 >= g_temperature_not_ready_value)
; 0001 0029    {
; 0001 002A       g_alert_led_mode = in_temperature_not_ready_mode;
; 0001 002B       turnoff();
; 0001 002C    }
; 0001 002D    else
; 0001 002E    {
; 0001 002F       g_alert_led_mode = no_fault;
; 0001 0030    }
; 0001 0031 }
;
;
;void send_string(unsigned char *u)
; 0001 0035 {
; 0001 0036    unsigned char n,i;
; 0001 0037    n = strlen(u);
;	*u -> Y+2
;	n -> R17
;	i -> R16
; 0001 0038    for(i = 0; i < n; i++)
; 0001 0039    {
; 0001 003A       putchar(u[i]);
; 0001 003B    }
; 0001 003C    putchar('\r');
; 0001 003D    putchar('\n');
; 0001 003E }
;
;
;
;void perform_status_led()
; 0001 0043 {
; 0001 0044    static enum alert_mode_e prev_status = no_fault;
; 0001 0045    g_led_control++;
; 0001 0046    if(g_led_control >= 10000)
; 0001 0047       g_led_control = 0;
; 0001 0048 
; 0001 0049    switch(g_alert_led_mode)
; 0001 004A    {
; 0001 004B       case no_fault:
; 0001 004C       {
; 0001 004D          LED_GREEN = STATUS_ON;
; 0001 004E          LED_RED = STATUS_OFF;
; 0001 004F          break;
; 0001 0050       }
; 0001 0051       case nozzle_blocked:
; 0001 0052       {
; 0001 0053          if(g_led_control % DELAY_DIV_NUM == 0)
; 0001 0054          {
; 0001 0055             LED_GREEN = !LED_GREEN;
; 0001 0056             LED_RED = LED_GREEN;
; 0001 0057          }
; 0001 0058          break;
; 0001 0059       }
; 0001 005A       case in_maintenance_mode:
; 0001 005B       {
; 0001 005C          if(g_led_control % DELAY_DIV_NUM == 0)
; 0001 005D          {
; 0001 005E             LED_GREEN = !LED_GREEN;
; 0001 005F             LED_RED = !LED_GREEN;
; 0001 0060          }
; 0001 0061          break;
; 0001 0062       }
; 0001 0063       case in_temperature_not_ready_mode:
; 0001 0064       {
; 0001 0065          if(g_led_control % DELAY_DIV_NUM == 0)
; 0001 0066          {
; 0001 0067             LED_GREEN = !LED_GREEN;
; 0001 0068          }
; 0001 0069          LED_RED = STATUS_OFF;
; 0001 006A          break;
; 0001 006B       }
; 0001 006C       case door_open_or_inlet_removed:
; 0001 006D       {
; 0001 006E          if(g_led_control % DELAY_DIV_NUM == 0)
; 0001 006F          {
; 0001 0070             LED_RED = !LED_RED;
; 0001 0071          }
; 0001 0072          LED_GREEN = STATUS_OFF;
; 0001 0073          break;
; 0001 0074       }
; 0001 0075       case serial_link_to_siu_fault:
; 0001 0076       {
; 0001 0077          if(g_led_control % DELAY_DIV_NUM == 0)
; 0001 0078          {
; 0001 0079             LED_RED = !LED_RED;
; 0001 007A          }
; 0001 007B          LED_GREEN = STATUS_ON;
; 0001 007C          break;
; 0001 007D       }
; 0001 007E       case other_fault:
; 0001 007F       {
; 0001 0080          LED_RED = STATUS_ON;
; 0001 0081          LED_GREEN = STATUS_OFF;
; 0001 0082          break;
; 0001 0083       }
; 0001 0084       case led_check:
; 0001 0085       {
; 0001 0086          LED_RED = STATUS_ON;
; 0001 0087          LED_GREEN = STATUS_ON;
; 0001 0088          break;
; 0001 0089       }
; 0001 008A       default:
; 0001 008B          break;
; 0001 008C    }
; 0001 008D    if(g_alert_led_mode != no_fault && g_led_control % DELAY_SEND_ERR_DIV_NUM == 0)
; 0001 008E    {
; 0001 008F       memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
; 0001 0090       sprintf(g_uart_send_buf, "err,%d;", g_alert_led_mode);
; 0001 0091       send_string(g_uart_send_buf);
; 0001 0092       CONTROL_5V_12V = RUN_5V;
; 0001 0093       prev_status = g_alert_led_mode;
; 0001 0094    }
; 0001 0095    else if(g_alert_led_mode == no_fault && prev_status != no_fault)
; 0001 0096    {
; 0001 0097       memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
; 0001 0098       sprintf(g_uart_send_buf, "err,%d;", g_alert_led_mode);
; 0001 0099       send_string(g_uart_send_buf);
; 0001 009A       prev_status = g_alert_led_mode;
; 0001 009B    }
; 0001 009C    ALARM = LED_RED;
; 0001 009D }
;
;void run_connect_mode()
; 0001 00A0 {
; 0001 00A1    g_count_adc_0++;
; 0001 00A2    if(g_count_adc_0 >= TIMEOUT_ON_MODE && g_connect_mode == ON_MODE)
; 0001 00A3    {
; 0001 00A4       // Read adc and sent via uart
; 0001 00A5       g_count_adc_0 = 0;
; 0001 00A6       g_value_adc_0 = read_adc(0);
; 0001 00A7       memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
; 0001 00A8       sprintf(g_uart_send_buf, "adc,%d;", g_value_adc_0);
; 0001 00A9       send_string(g_uart_send_buf);
; 0001 00AA    }else if(g_count_adc_0 >= TIMEOUT_STARTING_MODE && g_connect_mode == STARTING_MODE){
; 0001 00AB       // Sau khi nhan duoc lenh CONNECT, chay TIMEOUT_STARTING_MODE lan timer, sau do thay doi ve trang thai on mode
; 0001 00AC       QUAT = ON_5V;
; 0001 00AD       CONTROL_5V_12V = RUN_5V;
; 0001 00AE       SENSOR_1 = STATUS_ON;
; 0001 00AF       g_count_adc_0 = 0;
; 0001 00B0       g_connect_mode = ON_MODE;
; 0001 00B1    }else if(g_count_adc_0 >= TIMEOUT_STARTING_MODE){
; 0001 00B2       g_count_adc_0 = 0;
; 0001 00B3    }
; 0001 00B4 }
;
;void recieve_string(char* buf)
; 0001 00B7 {
; 0001 00B8    int i = 0;
; 0001 00B9    char u = getchar();
; 0001 00BA    while(1){
;	*buf -> Y+4
;	i -> R16,R17
;	u -> R19
; 0001 00BB       if(u != ';' && i < MAX_RECIEVE_BUF){
; 0001 00BC          buf[i] = u;
; 0001 00BD          i++;
; 0001 00BE          u = getchar();
; 0001 00BF       }else{
; 0001 00C0          break;
; 0001 00C1       }
; 0001 00C2    }
; 0001 00C3    i++;
; 0001 00C4    buf[i] = '\0';
; 0001 00C5 }
;
;void connect_avr()
; 0001 00C8 {
; 0001 00C9    // Bat ADC
; 0001 00CA    // ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
; 0001 00CB    g_count_adc_0 = 0;
; 0001 00CC    QUAT = OFF_5V;
; 0001 00CD    CONTROL_5V_12V = RUN_12V;
; 0001 00CE    g_connect_mode = STARTING_MODE;
; 0001 00CF }
;
;void turnoff()
; 0001 00D2 {
; 0001 00D3    // Tat adc
; 0001 00D4    // ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
; 0001 00D5    g_count_adc_0 = 0;
; 0001 00D6    CONTROL_5V_12V = RUN_5V;
; 0001 00D7    QUAT = STATUS_OFF;
; 0001 00D8    SENSOR_1 = STATUS_OFF;
; 0001 00D9    g_connect_mode = OFF_MODE;
; 0001 00DA }
;
;
;int strcasecmp(const char *s1, const char *s2) {
; 0001 00DD int strcasecmp(const char *s1, const char *s2) {
; 0001 00DE     const unsigned char *us1 = (const unsigned char *)s1,
; 0001 00DF                         *us2 = (const unsigned char *)s2;
; 0001 00E0 
; 0001 00E1     while (tolower(*us1) == tolower(*us2++))
;	*s1 -> Y+6
;	*s2 -> Y+4
;	*us1 -> R16,R17
;	*us2 -> R18,R19
; 0001 00E2         if (*us1++ == '\0')
; 0001 00E3             return (0);
; 0001 00E4     return (tolower(*us1) - tolower(*--us2));
; 0001 00E5 }
;
;void execute_command(char* buf)
; 0001 00E8 {
; 0001 00E9    char* temp_cmd;
; 0001 00EA    temp_cmd = strtok(buf, ",");
;	*buf -> Y+2
;	*temp_cmd -> R16,R17
; 0001 00EB    if(!strcasecmp(temp_cmd,"CONNECT"))
; 0001 00EC    {
; 0001 00ED       // Bat quat to trong 1 phut, sau do bat sensor
; 0001 00EE       connect_avr();
; 0001 00EF    }
; 0001 00F0    else if(!strcasecmp(temp_cmd,"OFF"))
; 0001 00F1    {
; 0001 00F2       // Tat quat nho, dung lay du lieu
; 0001 00F3       turnoff();
; 0001 00F4    }
; 0001 00F5    else if(!strcasecmp(temp_cmd,"threshold"))
; 0001 00F6    {
; 0001 00F7       g_led_control = 1;
; 0001 00F8       temp_cmd = strtok(NULL, ",");
; 0001 00F9       if(temp_cmd != NULL)
; 0001 00FA       {
; 0001 00FB          g_temperature_not_ready_value = atoi(temp_cmd);
; 0001 00FC          memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
; 0001 00FD          //sprintf(g_uart_send_buf, "thres,%d;", g_temperature_not_ready_value);
; 0001 00FE          send_string(g_uart_send_buf);
; 0001 00FF       }
; 0001 0100    }
; 0001 0101 }

	.DSEG
_0x20072:
	.BYTE 0x16

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
_g_value_adc_0:
	.BYTE 0x2
_g_count_adc_1:
	.BYTE 0x2
_g_value_adc_1:
	.BYTE 0x2
_g_temperature_not_ready_value_G001:
	.BYTE 0x2
_g_led_control:
	.BYTE 0x2
_g_connect_mode:
	.BYTE 0x2
_g_uart_send_buf:
	.BYTE 0x32
__seed_G102:
	.BYTE 0x4

	.CSEG

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
