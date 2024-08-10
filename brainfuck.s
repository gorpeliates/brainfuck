.global brainfuck

scanf_input: .skip 8
char_format: .asciz "%c"
format_str: .asciz "We should be executing the following code:\n%s"
scanformat: .asciz "%c"
tape: .skip 30000

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

# r13 : brainfuck cell tape pointer
# r12: code pointer

brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	pushq %r12
	pushq %r13

	movq %rdi, %r12 #r12 has the start of string == code pointer
	movq %rdi, %rsi

	movq $format_str, %rdi
	
	movq $0, %rax
	call printf

	movq $tape, %r13
	jmp interpret
	

end:

	popq %r13
	popq %r12
	
	movq %rbp, %rsp
	popq %rbp
	
	movq $0, %rdi
	call exit

nextcommand:

	inc %r12

interpret:


	cmpq $0, %r12
	je end

	cmpb $'>' , %r12b
    je inc_dp
    cmpb $'<' , %r12b
    je dec_dp
    cmpb $'+' , %r12b
    je inc_val
    cmpb $'-' , %r12b
    je dec_val
    cmpb $'.' , %r12b
    je output 
    cmpb $',' , %r12b
    je input 
    cmpb $'[' , %r12b
    je loop_start
    cmpb $']' , %r12b
    je loop_end
	jmp nextcommand


inc_dp:

	incq %r13
	jmp nextcommand
	

dec_dp:
    decq %r13
	jmp nextcommand

inc_val:
	incq (%r13)
	jmp nextcommand

dec_val:
	decq (%r13)
	jmp nextcommand

output:

	movq $0,%rax
	movq (%r13),%rsi
	movq $char_format, %rdi
	call printf
	jmp nextcommand

input:

	movq $0, %rax
	movq $char_format, %rdi
	#leaq $scanf_input, %rsi 
	#call scanf
	movq $scanf_input, (%r13)
	jmp nextcommand

loop_start:

	pushq %r12
	jmp nextcommand


loop_end:
 
	cmpq $0, %r13
	je popr12
	sub $8, %rbp
	jmp next

popr12:
	popq %r12
	jmp nextcommand