.syntax unified
.cpu cortex-m3
.thumb


.global Reset_Handler
.global _estack


.extern main
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss
.extern _etext


.section .isr_vector, "a", %progbits
.type g_pfnVectors, %object

g_pfnVectors:
    .word _estack            /* Initial Stack Pointer */
    .word Reset_Handler      /* Reset Handler */
    .word 0                  /* NMI */
    .word 0                  /* HardFault */
    .word 0                  /* MemManage */
    .word 0                  /* BusFault */
    .word 0                  /* UsageFault */
    .word 0,0,0,0            /* Reserved */
    .word 0                  /* SVCall */
    .word 0                  /* Debug Monitor */
    .word 0                  /* Reserved */
    .word 0                  /* PendSV */
    .word 0                  /* SysTick */

.size g_pfnVectors, .-g_pfnVectors

.section .text.Reset_Handler
.type Reset_Handler, %function

Reset_Handler:

    /* Copy .data from Flash to RAM */
    ldr r0, =_sdata
    ldr r1, =_edata
    ldr r2, =_etext

copy_data:
    cmp r0, r1
    ittt lt
    ldrlt r3, [r2], #4
    strlt r3, [r0], #4
    blt copy_data

    /* Zero .bss */
    ldr r0, =_sbss
    ldr r1, =_ebss

zero_bss:
    cmp r0, r1
    it lt
    movlt r2, #0
    strlt r2, [r0], #4
    blt zero_bss

    /* Call main */
    bl main

    /* If main returns, loop forever */
infinite_loop:
    b infinite_loop

.size Reset_Handler, .-Reset_Handler