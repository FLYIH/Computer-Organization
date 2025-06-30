# 112550194
.data
    input_msg1: .asciiz "Please enter the first number: "
    input_msg2: .asciiz "Please enter the second number: "
    space:      .asciiz " "
    newline:    .asciiz "\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, input_msg1
    syscall

    li $v0, 5
    syscall
    move $s3, $v0

  
    li $v0, 4
    la $a0, input_msg2
    syscall

    li $v0, 5
    syscall
    move $s4, $v0
    
    move $a0, $s3
    move $a1, $s4
    jal gcd
    move $s2, $v0

    
    beq $s2, $zero, set_lcm_zero

    mult $s3, $s4   
    mflo $t2        
    
    div $t2, $s2    
    mflo $t3        
    j print_result

set_lcm_zero:
    li $t3, 0

print_result:
    li $v0, 1
    move $a0, $s2
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

gcd:
    beq   $a1, $zero, gcd_end
    div   $a0, $a1
    mfhi  $t0
    move  $a0, $a1
    move  $a1, $t0

    addi  $sp, $sp, -4
    sw    $ra, 0($sp)

    jal   gcd

    lw    $ra, 0($sp)
    addi  $sp, $sp, 4

    jr    $ra

gcd_end:
    move  $v0, $a0
    jr    $ra
