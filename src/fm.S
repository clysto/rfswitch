#include <msp430.h>

#define R_ZERO        R10
#define R_CURR_BYTE   R11
#define R_PULSE_CNT   R12
#define R_DATA_PTR    R13
#define R_BYTE_CNT    R14
#define R_LOOP_CNT    R15
; 发射天线连接到 P1.3
#define TX_PIN        BIT7
#define TX_OUT        P1OUT


; 生成 num 个 NOP 指令
.macro NOPN num
.rept \num
NOP
.endr
.endm

.global TX_FM

;==============================================================================
;
;   725khz 频移
;
;==============================================================================

TX_FM:
    MOV.B       #0x00,          R_ZERO
    MOV.B       R_ZERO,         R_CURR_BYTE
    MOV.B       #64,            R_BYTE_CNT
    MOV.B       #30,            R_PULSE_CNT
    MOV         #BITSTREAM,     R_DATA_PTR

    ; 循环发送字节 (MSB对齐)
SEND_BYTE:
    MOV.B       @R_DATA_PTR+,   R_CURR_BYTE

;==============================================================================
;   发送 BIT0
;==============================================================================
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B0_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B0_LOOP

;==============================================================================
;   发送 BIT1
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B1_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B1_LOOP

;==============================================================================
;   发送 BIT2
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B2_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B2_LOOP

;==============================================================================
;   发送 BIT3
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B3_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B3_LOOP

;==============================================================================
;   发送 BIT4
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B4_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT

    JNZ         B4_LOOP

;==============================================================================
;   发送 BIT5
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B5_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B5_LOOP

;==============================================================================
;   发送 BIT6
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B6_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B6_LOOP

;==============================================================================
;   发送 BIT7
;==============================================================================
    RLA.B       R_CURR_BYTE
    MOV.B       R_PULSE_CNT,    R_LOOP_CNT
B7_LOOP:
    MOV.B       R_CURR_BYTE,    &TX_OUT
    NOPN        7
    MOV.B       R_ZERO,         &TX_OUT
    NOPN        3
    DEC.B       R_LOOP_CNT
    JNZ         B7_LOOP

B7_T:
    DEC.B       R_BYTE_CNT
    ; 如果没有发送完成继续发送下一个字节
    JNZ         SEND_BYTE
    MOV.B       R_ZERO,         &TX_OUT

    RET

.end
