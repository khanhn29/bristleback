
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
	.DEF _g_count_adc_0=R6
	.DEF _g_count_adc_0_msb=R7
	.DEF _g_value_adc_0=R8
	.DEF _g_value_adc_0_msb=R9
	.DEF _g_count_adc_1=R10
	.DEF _g_count_adc_1_msb=R11
	.DEF _g_value_adc_1=R12
	.DEF _g_value_adc_1_msb=R13
	.DEF _g_gas_alarm_mode=R4

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
	JMP  _timer0_ovf_isr
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
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0x72,0x65,0x61,0x64,0x79,0x0
_0x20003:
	.DB  0x64
_0x20004:
	.DB  0x1
_0x20005:
	.DB  0x1
_0x20000:
	.DB  0x65,0x72,0x72,0x2C,0x25,0x64,0x3B,0x0
	.DB  0x61,0x64,0x63,0x2C,0x25,0x64,0x3B,0x0
	.DB  0x2C,0x0,0x43,0x4F,0x4E,0x4E,0x45,0x43
	.DB  0x54,0x0,0x4F,0x46,0x46,0x0,0x74,0x68
	.DB  0x72,0x65,0x73,0x68,0x6F,0x6C,0x64,0x0
	.DB  0x67,0x61,0x73,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x06
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x01
	.DW  _g_temperature_not_ready_value_G001
	.DW  _0x20003*2

	.DW  0x01
	.DW  _g_led_control
	.DW  _0x20004*2

	.DW  0x01
	.DW  _g_alarm_control
	.DW  _0x20005*2

	.DW  0x08
	.DW  _0x20081
	.DW  _0x20000*2+18

	.DW  0x04
	.DW  _0x20081+8
	.DW  _0x20000*2+26

	.DW  0x0A
	.DW  _0x20081+12
	.DW  _0x20000*2+30

	.DW  0x04
	.DW  _0x20081+22
	.DW  _0x20000*2+40

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
;#include <delay.h>
;#include <string.h>
;
;// Declare your global variables here
;enum alert_mode_e    g_alert_led_mode = no_fault;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0025 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026 // Place your code here
; 0000 0027    //Get status led then control led accordingly
; 0000 0028    get_status_led();
	RCALL _get_status_led
; 0000 0029    perform_status_led();
	RCALL _perform_status_led
; 0000 002A    //Run connect mode
; 0000 002B    run_connect_mode();
	RCALL _run_connect_mode
; 0000 002C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0033 {
_read_adc:
; .FSTART _read_adc
; 0000 0034 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0035 // Delay needed for the stabilization of the ADC input voltage
; 0000 0036 delay_us(10);
	__DELAY_USB 27
; 0000 0037 // Start the AD conversion
; 0000 0038 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0039 // Wait for the AD conversion to complete
; 0000 003A while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 003B ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 003C return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20A0003
; 0000 003D }
; .FEND
;
;void main(void)
; 0000 0040 {
_main:
; .FSTART _main
; 0000 0041 // Declare your local variables here
; 0000 0042 char recv_buf[MAX_RECIEVE_BUF];
; 0000 0043 // Input/Output Ports initialization
; 0000 0044 // Port A initialization
; 0000 0045 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0046 DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,50
;	recv_buf -> Y+0
	LDI  R30,LOW(128)
	OUT  0x1A,R30
; 0000 0047 // State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0048 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0049 
; 0000 004A // Port B initialization
; 0000 004B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 004C DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 004D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 004E PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 004F 
; 0000 0050 // Port C initialization
; 0000 0051 // Function: Bit7=Out Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 0052 DDRC=(1<<DDC7) | (0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(171)
	OUT  0x14,R30
; 0000 0053 // State: Bit7=0 Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=0
; 0000 0054 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0055 
; 0000 0056 // Port D initialization
; 0000 0057 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0058 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0059 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 005A PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 005B 
; 0000 005C // Port E initialization
; 0000 005D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005E DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 005F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0060 PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 0061 
; 0000 0062 // Port F initialization
; 0000 0063 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0064 DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 0065 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0066 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 0067 
; 0000 0068 // Port G initialization
; 0000 0069 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 006A DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 006B // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 006C PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 006D 
; 0000 006E // Timer/Counter 0 initialization
; 0000 006F // Clock source: System Clock
; 0000 0070 // Clock value: 31.250 kHz
; 0000 0071 // Mode: Normal top=0xFF
; 0000 0072 // OC0 output: Disconnected
; 0000 0073 // Timer Period: 8.192 ms
; 0000 0074 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0075 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(6)
	OUT  0x33,R30
; 0000 0076 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0077 OCR0=0x00;
	OUT  0x31,R30
; 0000 0078 
; 0000 0079 // Timer/Counter 1 initialization
; 0000 007A // Clock source: System Clock
; 0000 007B // Clock value: Timer1 Stopped
; 0000 007C // Mode: Normal top=0xFFFF
; 0000 007D // OC1A output: Disconnected
; 0000 007E // OC1B output: Disconnected
; 0000 007F // OC1C output: Disconnected
; 0000 0080 // Noise Canceler: Off
; 0000 0081 // Input Capture on Falling Edge
; 0000 0082 // Timer1 Overflow Interrupt: Off
; 0000 0083 // Input Capture Interrupt: Off
; 0000 0084 // Compare A Match Interrupt: Off
; 0000 0085 // Compare B Match Interrupt: Off
; 0000 0086 // Compare C Match Interrupt: Off
; 0000 0087 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0088 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0089 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 008A TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008B ICR1H=0x00;
	OUT  0x27,R30
; 0000 008C ICR1L=0x00;
	OUT  0x26,R30
; 0000 008D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 008F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0090 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0091 OCR1CH=0x00;
	STS  121,R30
; 0000 0092 OCR1CL=0x00;
	STS  120,R30
; 0000 0093 
; 0000 0094 // Timer/Counter 2 initialization
; 0000 0095 // Clock source: System Clock
; 0000 0096 // Clock value: Timer2 Stopped
; 0000 0097 // Mode: Normal top=0xFF
; 0000 0098 // OC2 output: Disconnected
; 0000 0099 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 009A TCNT2=0x00;
	OUT  0x24,R30
; 0000 009B OCR2=0x00;
	OUT  0x23,R30
; 0000 009C 
; 0000 009D // Timer/Counter 3 initialization
; 0000 009E // Clock source: System Clock
; 0000 009F // Clock value: Timer3 Stopped
; 0000 00A0 // Mode: Normal top=0xFFFF
; 0000 00A1 // OC3A output: Disconnected
; 0000 00A2 // OC3B output: Disconnected
; 0000 00A3 // OC3C output: Disconnected
; 0000 00A4 // Noise Canceler: Off
; 0000 00A5 // Input Capture on Falling Edge
; 0000 00A6 // Timer3 Overflow Interrupt: Off
; 0000 00A7 // Input Capture Interrupt: Off
; 0000 00A8 // Compare A Match Interrupt: Off
; 0000 00A9 // Compare B Match Interrupt: Off
; 0000 00AA // Compare C Match Interrupt: Off
; 0000 00AB TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 00AC TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 00AD TCNT3H=0x00;
	STS  137,R30
; 0000 00AE TCNT3L=0x00;
	STS  136,R30
; 0000 00AF ICR3H=0x00;
	STS  129,R30
; 0000 00B0 ICR3L=0x00;
	STS  128,R30
; 0000 00B1 OCR3AH=0x00;
	STS  135,R30
; 0000 00B2 OCR3AL=0x00;
	STS  134,R30
; 0000 00B3 OCR3BH=0x00;
	STS  133,R30
; 0000 00B4 OCR3BL=0x00;
	STS  132,R30
; 0000 00B5 OCR3CH=0x00;
	STS  131,R30
; 0000 00B6 OCR3CL=0x00;
	STS  130,R30
; 0000 00B7 
; 0000 00B8 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B9 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 00BA ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 00BB 
; 0000 00BC // External Interrupt(s) initialization
; 0000 00BD // INT0: Off
; 0000 00BE // INT1: Off
; 0000 00BF // INT2: Off
; 0000 00C0 // INT3: Off
; 0000 00C1 // INT4: Off
; 0000 00C2 // INT5: Off
; 0000 00C3 // INT6: Off
; 0000 00C4 // INT7: Off
; 0000 00C5 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 00C6 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 00C7 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 00C8 
; 0000 00C9 // USART0 initialization
; 0000 00CA // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00CB // USART0 Receiver: On
; 0000 00CC // USART0 Transmitter: On
; 0000 00CD // USART0 Mode: Asynchronous
; 0000 00CE // USART0 Baud Rate: 9600
; 0000 00CF UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 00D0 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00D1 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 00D2 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 00D3 UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00D4 
; 0000 00D5 // USART1 initialization
; 0000 00D6 // USART1 disabled
; 0000 00D7 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 00D8 
; 0000 00D9 // Analog Comparator initialization
; 0000 00DA // Analog Comparator: Off
; 0000 00DB // The Analog Comparator's positive input is
; 0000 00DC // connected to the AIN0 pin
; 0000 00DD // The Analog Comparator's negative input is
; 0000 00DE // connected to the AIN1 pin
; 0000 00DF ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E0 
; 0000 00E1 // ADC initialization
; 0000 00E2 // ADC Clock frequency: 1000.000 kHz
; 0000 00E3 // ADC Voltage Reference: AREF pin
; 0000 00E4 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00E5 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00E6 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00E7 
; 0000 00E8 // SPI initialization
; 0000 00E9 // SPI disabled
; 0000 00EA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00EB 
; 0000 00EC // TWI initialization
; 0000 00ED // TWI disabled
; 0000 00EE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 00EF 
; 0000 00F0 // Global enable interrupts
; 0000 00F1 #asm("sei")
	sei
; 0000 00F2    send_string("ready");
	__POINTW2MN _0x6,0
	RCALL _send_string
; 0000 00F3 
; 0000 00F4    QUAT = RUN_5V;
	CBI  0x15,0
; 0000 00F5    CONTROL_5V_12V = RUN_5V;
	CBI  0x15,1
; 0000 00F6    SENSOR_1 = STATUS_ON;
	SBI  0x15,3
; 0000 00F7    LED_GREEN = STATUS_ON;
	SBI  0x15,5
; 0000 00F8    LED_RED = STATUS_ON;
	SBI  0x15,7
; 0000 00F9    delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 00FA    SENSOR_1 = STATUS_OFF;
	CBI  0x15,3
; 0000 00FB    LED_GREEN = STATUS_OFF;
	CBI  0x15,5
; 0000 00FC    LED_RED = STATUS_OFF;
	CBI  0x15,7
; 0000 00FD    perform_status_led();
	RCALL _perform_status_led
; 0000 00FE while (1)
_0x17:
; 0000 00FF       {
; 0000 0100           // Nhan lenh
; 0000 0101           recieve_string(recv_buf);
	MOVW R26,R28
	RCALL _recieve_string
; 0000 0102           // Gui lai lenh qua uart
; 0000 0103           send_string(recv_buf);
	MOVW R26,R28
	RCALL _send_string
; 0000 0104           // Xu ly lenh
; 0000 0105           execute_command(recv_buf);
	MOVW R26,R28
	RCALL _execute_command
; 0000 0106           memset(recv_buf, 0, sizeof(recv_buf));
	MOVW R30,R28
	CALL SUBOPT_0x0
; 0000 0107       }
	RJMP _0x17
; 0000 0108 }
_0x1A:
	RJMP _0x1A
; .FEND

	.DSEG
_0x6:
	.BYTE 0x6
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
;unsigned int      g_led_control = 1;
;unsigned int      g_alarm_control = 1;
;int      g_connect_mode;
;char     g_uart_send_buf[MAX_RECIEVE_BUF];
;extern enum alert_mode_e    g_alert_led_mode;
;enum gas_alarm_mode_e g_gas_alarm_mode;
;
;void get_status_led()
; 0001 0018 {

	.CSEG
_get_status_led:
; .FSTART _get_status_led
; 0001 0019    g_count_adc_1++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0001 001A    if(g_count_adc_1 > 100)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x20006
; 0001 001B    {
; 0001 001C       g_count_adc_1 = 0;
	CLR  R10
	CLR  R11
; 0001 001D       g_value_adc_1 = read_adc(1) * 500 / 1023;
	LDI  R26,LOW(1)
	RCALL _read_adc
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CALL __DIVW21U
	MOVW R12,R30
; 0001 001E    }
; 0001 001F 
; 0001 0020    if(DOOR == IS_OPEN || INLET == IS_REMOVED)
_0x20006:
	SBIC 0x19,1
	RJMP _0x20008
	SBIS 0x19,3
	RJMP _0x20007
_0x20008:
; 0001 0021    {
; 0001 0022       g_alert_led_mode = door_open_or_inlet_removed;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0001 0023       turnoff();
	RCALL _turnoff
; 0001 0024    }
; 0001 0025    else if(NOZZLE == IS_BLOCKED)
	RJMP _0x2000A
_0x20007:
	SBIC 0x19,5
	RJMP _0x2000B
; 0001 0026    {
; 0001 0027       g_alert_led_mode = nozzle_blocked;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0001 0028       turnoff();
	RCALL _turnoff
; 0001 0029    }
; 0001 002A    else if(g_value_adc_1 >= g_temperature_not_ready_value)
	RJMP _0x2000C
_0x2000B:
	LDS  R30,_g_temperature_not_ready_value_G001
	LDS  R31,_g_temperature_not_ready_value_G001+1
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x2000D
; 0001 002B    {
; 0001 002C       g_alert_led_mode = in_temperature_not_ready_mode;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0001 002D       turnoff();
	RCALL _turnoff
; 0001 002E    }
; 0001 002F    else
	RJMP _0x2000E
_0x2000D:
; 0001 0030    {
; 0001 0031       g_alert_led_mode = no_fault;
	CLR  R5
; 0001 0032    }
_0x2000E:
_0x2000C:
_0x2000A:
; 0001 0033 }
	RET
; .FEND
;
;
;void send_string(unsigned char *u)
; 0001 0037 {
_send_string:
; .FSTART _send_string
; 0001 0038    unsigned char n,i;
; 0001 0039    n = strlen(u);
	CALL SUBOPT_0x1
;	*u -> Y+2
;	n -> R17
;	i -> R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strlen
	MOV  R17,R30
; 0001 003A    for(i = 0; i < n; i++)
	LDI  R16,LOW(0)
_0x20010:
	CP   R16,R17
	BRSH _0x20011
; 0001 003B    {
; 0001 003C       putchar(u[i]);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R26,X
	CALL _putchar
; 0001 003D    }
	SUBI R16,-1
	RJMP _0x20010
_0x20011:
; 0001 003E    putchar('\r');
	LDI  R26,LOW(13)
	CALL _putchar
; 0001 003F    putchar('\n');
	LDI  R26,LOW(10)
	CALL _putchar
; 0001 0040 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0007
; .FEND
;
;
;
;void perform_status_led()
; 0001 0045 {
_perform_status_led:
; .FSTART _perform_status_led
; 0001 0046    static enum alert_mode_e prev_status = no_fault;
; 0001 0047    g_led_control++;
	LDI  R26,LOW(_g_led_control)
	LDI  R27,HIGH(_g_led_control)
	CALL SUBOPT_0x2
; 0001 0048    if(g_led_control >= 10000)
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLO _0x20012
; 0001 0049       g_led_control = 0;
	LDI  R30,LOW(0)
	STS  _g_led_control,R30
	STS  _g_led_control+1,R30
; 0001 004A 
; 0001 004B    switch(g_alert_led_mode)
_0x20012:
	MOV  R30,R5
	LDI  R31,0
; 0001 004C    {
; 0001 004D       case no_fault:
	SBIW R30,0
	BRNE _0x20016
; 0001 004E       {
; 0001 004F          LED_GREEN = STATUS_ON;
	SBI  0x15,5
; 0001 0050          LED_RED = STATUS_OFF;
	CBI  0x15,7
; 0001 0051          break;
	RJMP _0x20015
; 0001 0052       }
; 0001 0053       case nozzle_blocked:
_0x20016:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2001B
; 0001 0054       {
; 0001 0055          if(g_led_control % DELAY_DIV_NUM == 0)
	CALL SUBOPT_0x4
	BRNE _0x2001C
; 0001 0056          {
; 0001 0057             LED_GREEN = !LED_GREEN;
	SBIS 0x15,5
	RJMP _0x2001D
	CBI  0x15,5
	RJMP _0x2001E
_0x2001D:
	SBI  0x15,5
_0x2001E:
; 0001 0058             LED_RED = LED_GREEN;
	SBIC 0x15,5
	RJMP _0x2001F
	CBI  0x15,7
	RJMP _0x20020
_0x2001F:
	SBI  0x15,7
_0x20020:
; 0001 0059          }
; 0001 005A          break;
_0x2001C:
	RJMP _0x20015
; 0001 005B       }
; 0001 005C       case in_maintenance_mode:
_0x2001B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20021
; 0001 005D       {
; 0001 005E          if(g_led_control % DELAY_DIV_NUM == 0)
	CALL SUBOPT_0x4
	BRNE _0x20022
; 0001 005F          {
; 0001 0060             LED_GREEN = !LED_GREEN;
	SBIS 0x15,5
	RJMP _0x20023
	CBI  0x15,5
	RJMP _0x20024
_0x20023:
	SBI  0x15,5
_0x20024:
; 0001 0061             LED_RED = !LED_GREEN;
	SBIS 0x15,5
	RJMP _0x20025
	CBI  0x15,7
	RJMP _0x20026
_0x20025:
	SBI  0x15,7
_0x20026:
; 0001 0062          }
; 0001 0063          break;
_0x20022:
	RJMP _0x20015
; 0001 0064       }
; 0001 0065       case in_temperature_not_ready_mode:
_0x20021:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20027
; 0001 0066       {
; 0001 0067          if(g_led_control % DELAY_DIV_NUM == 0)
	CALL SUBOPT_0x4
	BRNE _0x20028
; 0001 0068          {
; 0001 0069             LED_GREEN = !LED_GREEN;
	SBIS 0x15,5
	RJMP _0x20029
	CBI  0x15,5
	RJMP _0x2002A
_0x20029:
	SBI  0x15,5
_0x2002A:
; 0001 006A          }
; 0001 006B          LED_RED = STATUS_OFF;
_0x20028:
	CBI  0x15,7
; 0001 006C          break;
	RJMP _0x20015
; 0001 006D       }
; 0001 006E       case door_open_or_inlet_removed:
_0x20027:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2002D
; 0001 006F       {
; 0001 0070          if(g_led_control % DELAY_DIV_NUM == 0)
	CALL SUBOPT_0x4
	BRNE _0x2002E
; 0001 0071          {
; 0001 0072             LED_RED = !LED_RED;
	SBIS 0x15,7
	RJMP _0x2002F
	CBI  0x15,7
	RJMP _0x20030
_0x2002F:
	SBI  0x15,7
_0x20030:
; 0001 0073          }
; 0001 0074          LED_GREEN = STATUS_OFF;
_0x2002E:
	CBI  0x15,5
; 0001 0075          break;
	RJMP _0x20015
; 0001 0076       }
; 0001 0077       case serial_link_to_siu_fault:
_0x2002D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20033
; 0001 0078       {
; 0001 0079          if(g_led_control % DELAY_DIV_NUM == 0)
	CALL SUBOPT_0x4
	BRNE _0x20034
; 0001 007A          {
; 0001 007B             LED_RED = !LED_RED;
	SBIS 0x15,7
	RJMP _0x20035
	CBI  0x15,7
	RJMP _0x20036
_0x20035:
	SBI  0x15,7
_0x20036:
; 0001 007C          }
; 0001 007D          LED_GREEN = STATUS_ON;
_0x20034:
	SBI  0x15,5
; 0001 007E          break;
	RJMP _0x20015
; 0001 007F       }
; 0001 0080       case other_fault:
_0x20033:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20039
; 0001 0081       {
; 0001 0082          LED_RED = STATUS_ON;
	SBI  0x15,7
; 0001 0083          LED_GREEN = STATUS_OFF;
	CBI  0x15,5
; 0001 0084          break;
	RJMP _0x20015
; 0001 0085       }
; 0001 0086       case led_check:
_0x20039:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20043
; 0001 0087       {
; 0001 0088          LED_RED = STATUS_ON;
	SBI  0x15,7
; 0001 0089          LED_GREEN = STATUS_ON;
	SBI  0x15,5
; 0001 008A          break;
; 0001 008B       }
; 0001 008C       default:
_0x20043:
; 0001 008D          break;
; 0001 008E    }
_0x20015:
; 0001 008F    if(g_alert_led_mode != no_fault && g_led_control % DELAY_SEND_ERR_DIV_NUM == 0)
	TST  R5
	BREQ _0x20045
	CALL SUBOPT_0x3
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	SBIW R30,0
	BREQ _0x20046
_0x20045:
	RJMP _0x20044
_0x20046:
; 0001 0090    {
; 0001 0091       memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
	CALL SUBOPT_0x5
; 0001 0092       sprintf(g_uart_send_buf, "err,%d;", g_alert_led_mode);
	CALL SUBOPT_0x6
; 0001 0093       send_string(g_uart_send_buf);
; 0001 0094       CONTROL_5V_12V = RUN_5V;
	CBI  0x15,1
; 0001 0095       prev_status = g_alert_led_mode;
	RJMP _0x2008A
; 0001 0096    }
; 0001 0097    else if(g_alert_led_mode == no_fault && prev_status != no_fault)
_0x20044:
	TST  R5
	BRNE _0x2004B
	LDS  R26,_prev_status_S0010002000
	CPI  R26,LOW(0x0)
	BRNE _0x2004C
_0x2004B:
	RJMP _0x2004A
_0x2004C:
; 0001 0098    {
; 0001 0099       memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
	CALL SUBOPT_0x5
; 0001 009A       sprintf(g_uart_send_buf, "err,%d;", g_alert_led_mode);
	CALL SUBOPT_0x6
; 0001 009B       send_string(g_uart_send_buf);
; 0001 009C       prev_status = g_alert_led_mode;
_0x2008A:
	STS  _prev_status_S0010002000,R5
; 0001 009D    }
; 0001 009E 
; 0001 009F    g_alarm_control++;
_0x2004A:
	LDI  R26,LOW(_g_alarm_control)
	LDI  R27,HIGH(_g_alarm_control)
	CALL SUBOPT_0x2
; 0001 00A0    if(g_alarm_control >= 10000)
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLO _0x2004D
; 0001 00A1       g_alarm_control = 0;
	LDI  R30,LOW(0)
	STS  _g_alarm_control,R30
	STS  _g_alarm_control+1,R30
; 0001 00A2 
; 0001 00A3    switch (g_gas_alarm_mode)
_0x2004D:
	MOV  R30,R4
	LDI  R31,0
; 0001 00A4    {
; 0001 00A5       case error_orange:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20051
; 0001 00A6       {
; 0001 00A7          if(g_alarm_control % (DELAY_DIV_NUM_ALARM * 2) == 0)
	CALL SUBOPT_0x7
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __MODW21U
	SBIW R30,0
	BRNE _0x20052
; 0001 00A8          {
; 0001 00A9             ALARM = !ALARM;
	SBIS 0x1B,7
	RJMP _0x20053
	CBI  0x1B,7
	RJMP _0x20054
_0x20053:
	SBI  0x1B,7
_0x20054:
; 0001 00AA          }
; 0001 00AB          break;
_0x20052:
	RJMP _0x20050
; 0001 00AC       }
; 0001 00AD       case error_red:
_0x20051:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20059
; 0001 00AE       {
; 0001 00AF          if(g_alarm_control % (DELAY_DIV_NUM_ALARM * 1) == 0)
	CALL SUBOPT_0x7
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21U
	SBIW R30,0
	BRNE _0x20056
; 0001 00B0          {
; 0001 00B1             ALARM = !ALARM;
	SBIS 0x1B,7
	RJMP _0x20057
	CBI  0x1B,7
	RJMP _0x20058
_0x20057:
	SBI  0x1B,7
_0x20058:
; 0001 00B2          }
; 0001 00B3          break;
_0x20056:
	RJMP _0x20050
; 0001 00B4       }
; 0001 00B5       default:
_0x20059:
; 0001 00B6       {
; 0001 00B7          ALARM = STATUS_OFF;
	CBI  0x1B,7
; 0001 00B8       }
; 0001 00B9    }
_0x20050:
; 0001 00BA }
	RET
; .FEND
;
;void run_connect_mode()
; 0001 00BD {
_run_connect_mode:
; .FSTART _run_connect_mode
; 0001 00BE    g_count_adc_0++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0001 00BF    if(g_count_adc_0 >= TIMEOUT_ON_MODE && g_connect_mode == ON_MODE)
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x2005D
	LDS  R26,_g_connect_mode
	LDS  R27,_g_connect_mode+1
	SBIW R26,1
	BREQ _0x2005E
_0x2005D:
	RJMP _0x2005C
_0x2005E:
; 0001 00C0    {
; 0001 00C1       // Read adc and sent via uart
; 0001 00C2       g_count_adc_0 = 0;
	CLR  R6
	CLR  R7
; 0001 00C3       g_value_adc_0 = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R8,R30
; 0001 00C4       memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
	CALL SUBOPT_0x5
; 0001 00C5       sprintf(g_uart_send_buf, "adc,%d;", g_value_adc_0);
	LDI  R30,LOW(_g_uart_send_buf)
	LDI  R31,HIGH(_g_uart_send_buf)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0001 00C6       send_string(g_uart_send_buf);
	LDI  R26,LOW(_g_uart_send_buf)
	LDI  R27,HIGH(_g_uart_send_buf)
	RCALL _send_string
; 0001 00C7    }else if(g_count_adc_0 >= TIMEOUT_STARTING_MODE && g_connect_mode == STARTING_MODE){
	RJMP _0x2005F
_0x2005C:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x20061
	LDS  R26,_g_connect_mode
	LDS  R27,_g_connect_mode+1
	SBIW R26,2
	BREQ _0x20062
_0x20061:
	RJMP _0x20060
_0x20062:
; 0001 00C8       // Sau khi nhan duoc lenh CONNECT, chay TIMEOUT_STARTING_MODE lan timer, sau do thay doi ve trang thai on mode
; 0001 00C9       QUAT = ON_5V;
	SBI  0x15,0
; 0001 00CA       CONTROL_5V_12V = RUN_5V;
	CBI  0x15,1
; 0001 00CB       SENSOR_1 = STATUS_ON;
	SBI  0x15,3
; 0001 00CC       g_count_adc_0 = 0;
	CLR  R6
	CLR  R7
; 0001 00CD       g_connect_mode = ON_MODE;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _g_connect_mode,R30
	STS  _g_connect_mode+1,R31
; 0001 00CE    }else if(g_count_adc_0 >= TIMEOUT_STARTING_MODE){
	RJMP _0x20069
_0x20060:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x2006A
; 0001 00CF       g_count_adc_0 = 0;
	CLR  R6
	CLR  R7
; 0001 00D0    }
; 0001 00D1 }
_0x2006A:
_0x20069:
_0x2005F:
	RET
; .FEND
;
;void recieve_string(char* buf)
; 0001 00D4 {
_recieve_string:
; .FSTART _recieve_string
; 0001 00D5    int i = 0;
; 0001 00D6    char u = getchar();
; 0001 00D7    while(1){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*buf -> Y+4
;	i -> R16,R17
;	u -> R19
	__GETWRN 16,17,0
	CALL _getchar
	MOV  R19,R30
_0x2006B:
; 0001 00D8       if(u != ';' && i < MAX_RECIEVE_BUF){
	CPI  R19,59
	BREQ _0x2006F
	__CPWRN 16,17,50
	BRLT _0x20070
_0x2006F:
	RJMP _0x2006E
_0x20070:
; 0001 00D9          buf[i] = u;
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R19
; 0001 00DA          i++;
	__ADDWRN 16,17,1
; 0001 00DB          u = getchar();
	CALL _getchar
	MOV  R19,R30
; 0001 00DC       }else{
	RJMP _0x20071
_0x2006E:
; 0001 00DD          break;
	RJMP _0x2006D
; 0001 00DE       }
_0x20071:
; 0001 00DF    }
	RJMP _0x2006B
_0x2006D:
; 0001 00E0    i++;
	__ADDWRN 16,17,1
; 0001 00E1    buf[i] = '\0';
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 00E2 }
	CALL __LOADLOCR4
	JMP  _0x20A0005
; .FEND
;
;void connect_avr()
; 0001 00E5 {
_connect_avr:
; .FSTART _connect_avr
; 0001 00E6    // Bat ADC
; 0001 00E7    // ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
; 0001 00E8    g_count_adc_0 = 0;
	CLR  R6
	CLR  R7
; 0001 00E9    QUAT = OFF_5V;
	CBI  0x15,0
; 0001 00EA    CONTROL_5V_12V = RUN_12V;
	SBI  0x15,1
; 0001 00EB    g_connect_mode = STARTING_MODE;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _g_connect_mode,R30
	STS  _g_connect_mode+1,R31
; 0001 00EC }
	RET
; .FEND
;
;void turnoff()
; 0001 00EF {
_turnoff:
; .FSTART _turnoff
; 0001 00F0    // Tat adc
; 0001 00F1    // ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
; 0001 00F2    g_count_adc_0 = 0;
	CLR  R6
	CLR  R7
; 0001 00F3    CONTROL_5V_12V = RUN_5V;
	CBI  0x15,1
; 0001 00F4    QUAT = STATUS_OFF;
	CBI  0x15,0
; 0001 00F5    SENSOR_1 = STATUS_OFF;
	CBI  0x15,3
; 0001 00F6    g_connect_mode = OFF_MODE;
	LDI  R30,LOW(0)
	STS  _g_connect_mode,R30
	STS  _g_connect_mode+1,R30
; 0001 00F7 }
	RET
; .FEND
;
;
;int strcasecmp(const char *s1, const char *s2) {
; 0001 00FA int strcasecmp(const char *s1, const char *s2) {
_strcasecmp:
; .FSTART _strcasecmp
; 0001 00FB     const unsigned char *us1 = (const unsigned char *)s1,
; 0001 00FC                         *us2 = (const unsigned char *)s2;
; 0001 00FD 
; 0001 00FE     while (tolower(*us1) == tolower(*us2++))
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*s1 -> Y+6
;	*s2 -> Y+4
;	*us1 -> R16,R17
;	*us2 -> R18,R19
	__GETWRS 16,17,6
	__GETWRS 18,19,4
_0x2007C:
	MOVW R26,R16
	LD   R26,X
	CALL _tolower
	PUSH R30
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R26,X
	CALL _tolower
	POP  R26
	CP   R30,R26
	BRNE _0x2007E
; 0001 00FF         if (*us1++ == '\0')
	MOVW R26,R16
	__ADDWRN 16,17,1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2007F
; 0001 0100             return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0008
; 0001 0101     return (tolower(*us1) - tolower(*--us2));
_0x2007F:
	RJMP _0x2007C
_0x2007E:
	MOVW R26,R16
	LD   R26,X
	CALL _tolower
	LDI  R31,0
	PUSH R31
	PUSH R30
	MOVW R30,R18
	SBIW R30,1
	MOVW R18,R30
	LD   R26,Z
	CALL _tolower
	LDI  R31,0
	POP  R26
	POP  R27
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
_0x20A0008:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; 0001 0102 }
; .FEND
;
;void execute_command(char* buf)
; 0001 0105 {
_execute_command:
; .FSTART _execute_command
; 0001 0106    char* temp_cmd;
; 0001 0107    temp_cmd = strtok(buf, ",");
	CALL SUBOPT_0x1
;	*buf -> Y+2
;	*temp_cmd -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x8
; 0001 0108    if(!strcasecmp(temp_cmd,"CONNECT"))
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x20081,0
	RCALL _strcasecmp
	SBIW R30,0
	BRNE _0x20080
; 0001 0109    {
; 0001 010A       // Bat quat to trong 1 phut, sau do bat sensor
; 0001 010B       connect_avr();
	RCALL _connect_avr
; 0001 010C    }
; 0001 010D    else if(!strcasecmp(temp_cmd,"OFF"))
	RJMP _0x20082
_0x20080:
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x20081,8
	RCALL _strcasecmp
	SBIW R30,0
	BRNE _0x20083
; 0001 010E    {
; 0001 010F       // Tat quat nho, dung lay du lieu
; 0001 0110       turnoff();
	RCALL _turnoff
; 0001 0111    }
; 0001 0112    else if(!strcasecmp(temp_cmd,"threshold"))
	RJMP _0x20084
_0x20083:
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x20081,12
	RCALL _strcasecmp
	SBIW R30,0
	BRNE _0x20085
; 0001 0113    {
; 0001 0114       g_led_control = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _g_led_control,R30
	STS  _g_led_control+1,R31
; 0001 0115       temp_cmd = strtok(NULL, ",");
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x8
; 0001 0116       if(temp_cmd != NULL)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x20086
; 0001 0117       {
; 0001 0118          g_temperature_not_ready_value = atoi(temp_cmd);
	MOVW R26,R16
	CALL _atoi
	STS  _g_temperature_not_ready_value_G001,R30
	STS  _g_temperature_not_ready_value_G001+1,R31
; 0001 0119          //memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
; 0001 011A          //sprintf(g_uart_send_buf, "thres,%d;", g_temperature_not_ready_value);
; 0001 011B          //send_string(g_uart_send_buf);
; 0001 011C       }
; 0001 011D    }
_0x20086:
; 0001 011E    else if(!strcasecmp(temp_cmd,"gas"))
	RJMP _0x20087
_0x20085:
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x20081,22
	RCALL _strcasecmp
	SBIW R30,0
	BRNE _0x20088
; 0001 011F    {
; 0001 0120       g_alarm_control = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _g_alarm_control,R30
	STS  _g_alarm_control+1,R31
; 0001 0121       temp_cmd = strtok(NULL, ",");
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x8
; 0001 0122       if(temp_cmd != NULL)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x20089
; 0001 0123       {
; 0001 0124          g_gas_alarm_mode = (enum gas_alarm_mode_e)atoi(temp_cmd);
	MOVW R26,R16
	CALL _atoi
	MOV  R4,R30
; 0001 0125       }
; 0001 0126    }
_0x20089:
; 0001 0127 }
_0x20088:
_0x20087:
_0x20084:
_0x20082:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0007
; .FEND

	.DSEG
_0x20081:
	.BYTE 0x1A

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	JMP  _0x20A0002
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strpbrkf:
; .FSTART _strpbrkf
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
strpbrkf0:
    ld   r22,x
    tst  r22
    breq strpbrkf2
    ldd  r31,y+1
    ld   r30,y
strpbrkf1:
	lpm
    tst  r0
    breq strpbrkf3
    adiw r30,1
    cp   r22,r0
    brne strpbrkf1
    movw r30,r26
    rjmp strpbrkf4
strpbrkf3:
    adiw r26,1
    rjmp strpbrkf0
strpbrkf2:
    clr  r30
    clr  r31
strpbrkf4:
	JMP  _0x20A0006
; .FEND
_strspnf:
; .FSTART _strspnf
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
    clr  r24
    clr  r25
strspnf0:
    ld   r22,x+
    tst  r22
    breq strspnf2
    ldd  r31,y+1
    ld   r30,y
strspnf1:
	lpm  r0,z+
    tst  r0
    breq strspnf2
    cp   r22,r0
    brne strspnf1
    adiw r24,1
    rjmp strspnf0
strspnf2:
    movw r30,r24
_0x20A0006:
_0x20A0007:
	ADIW R28,4
	RET
; .FEND
_strtok:
; .FSTART _strtok
	CALL SUBOPT_0x1
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x2000003
	LDS  R30,_p_S1000026000
	LDS  R31,_p_S1000026000+1
	SBIW R30,0
	BRNE _0x2000004
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0004
_0x2000004:
	LDS  R30,_p_S1000026000
	LDS  R31,_p_S1000026000+1
	STD  Y+4,R30
	STD  Y+4+1,R31
_0x2000003:
	CALL SUBOPT_0x9
	CALL _strspnf
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2000005
	LDI  R30,LOW(0)
	STS  _p_S1000026000,R30
	STS  _p_S1000026000+1,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0004
_0x2000005:
	CALL SUBOPT_0x9
	CALL _strpbrkf
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000006
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2000006:
	__PUTWMRN _p_S1000026000,0,16,17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
_0x20A0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0005:
	ADIW R28,6
	RET
; .FEND
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
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20A0003:
	ADIW R28,1
	RET
; .FEND
_put_buff_G101:
; .FSTART _put_buff_G101
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x2
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0002:
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0xA
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0xA
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0xB
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xC
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0xA
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xC
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xF
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xF
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_tolower:
; .FSTART _tolower
	ST   -Y,R26
    ld   r30,y+
    cpi  r30,'A'
    brlo tolower1
    cpi  r30,'Z'+1
    brcc tolower1
    subi r30,-32
tolower1:
    ret
; .FEND

	.CSEG

	.DSEG
_g_temperature_not_ready_value_G001:
	.BYTE 0x2
_g_led_control:
	.BYTE 0x2
_g_alarm_control:
	.BYTE 0x2
_g_connect_mode:
	.BYTE 0x2
_g_uart_send_buf:
	.BYTE 0x32
_prev_status_S0010002000:
	.BYTE 0x1
_p_S1000026000:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDS  R26,_g_led_control
	LDS  R27,_g_led_control+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x3
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __MODW21U
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_g_uart_send_buf)
	LDI  R31,HIGH(_g_uart_send_buf)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(_g_uart_send_buf)
	LDI  R31,HIGH(_g_uart_send_buf)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20000,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_g_uart_send_buf)
	LDI  R27,HIGH(_g_uart_send_buf)
	JMP  _send_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDS  R26,_g_alarm_control
	LDS  R27,_g_alarm_control+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x20000,16
	CALL _strtok
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
