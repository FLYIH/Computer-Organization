# 112550194
.data
    input_msg1: .asciiz "Enter five positive integers: "
    newline:    .asciiz "\n"
    space:      .asciiz " "
    numbers:    .align 2
    .word 0, 0, 0, 0, 0
    max_val:    .word 0
    min_val:    .word 0

.text
.globl main
# i am not sure if i need to makesure the input can be seperated by space
main:
    li $v0, 4
    la $a0, input_msg1
    syscall

    la $t0, numbers  
    li $t1, 5        

read_loop:
    li $v0, 5        # read integer
    syscall
    sw $v0, 0($t0)   # store in array
    addi $t0, $t0, 4 
    add $t1, $t1, -1 # minius counter
    bnez $t1, read_loop

    la $a0, numbers  
    li $a1, 5        
    la $a2, max_val  
    la $a3, min_val  
    jal findMaxMin   

    li $v0, 1
    lw $a0, max_val
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $v0, 1
    lw $a0, min_val
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

findMaxMin:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)  
    sw $s1, 4($sp)  
    sw $s2, 0($sp)  

    move $s0, $a0  
    move $s1, $a1  
    move $s2, $zero

    lw $t0, 0($s0)  
    sw $t0, 0($a2)  
    sw $t0, 0($a3)  
    addi $s2, $s2, 1 

loop:
    bge $s2, $s1, end_findMaxMin 

    mul $t1, $s2, 4 
    add $t2, $s0, $t1
    lw  $t3, 0($t2) 

    lw  $t4, 0($a2) 
    ble $t3, $t4, check_min 
    sw  $t3, 0($a2) 

check_min:
    lw  $t5, 0($a3) 
    bge $t3, $t5, next_iteration
    sw  $t3, 0($a3)

next_iteration:
    addi $s2, $s2, 1  
    j loop            

end_findMaxMin:
    lw $ra, 12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16

    jr $ra  