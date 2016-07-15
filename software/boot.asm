

	.section .text
	.globl	start 
start:
      	/* Enable interrupt request */  
        MRS     r1, CPSR
        BIC     r1, r1, #0x80
        MSR     CPSR_c, r1
       

        @ jump to main
        .extern main
        bl      main    
	
loop:   b       loop
